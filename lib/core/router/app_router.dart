import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/projects/domain/entities/project.dart';
import '../../features/projects/presentation/pages/create_project_page.dart';
import '../../features/projects/presentation/pages/edit_project_page.dart';
import '../../features/projects/presentation/pages/project_details_page.dart';
import '../../features/projects/presentation/pages/project_members_page.dart';
import '../../features/projects/presentation/pages/projects_page.dart';

class AppRouter {
  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: '/projects',
      refreshListenable: _GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final status = authState.status;

        // While initializing, don't redirect yet
        if (status == AuthStatus.initial) {
          return null;
        }

        final isAuthenticated = status == AuthStatus.authenticated;
        final location = state.uri.path;

        final isAuthRoute = location == '/login' ||
            location == '/register' ||
            location == '/forgot-password';

        // Unauthenticated users trying to access protected routes -> redirect to /login
        if (!isAuthenticated && !isAuthRoute) {
          return '/login';
        }

        // Authenticated users trying to access auth pages -> redirect to /projects
        if (isAuthenticated && isAuthRoute) {
          return '/projects';
        }

        return null;
      },
      routes: [
        // Auth routes
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordPage(),
        ),

        // Projects routes
        GoRoute(
          path: '/projects',
          builder: (context, state) => const ProjectsPage(),
          routes: [
            GoRoute(
              path: ':projectId',
              builder: (context, state) {
                final project = state.extra as Project?;
                final projectId = state.pathParameters['projectId']!;
                return ProjectDetailsPage(
                  project: project ??
                      Project(
                        id: projectId,
                        ownerId: '',
                        name: 'Project ',
                        description: '',
                      ),
                );
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    final project = state.extra as Project;
                    return EditProjectPage(project: project);
                  },
                ),
                GoRoute(
                  path: 'members',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>? ?? {};
                    return ProjectMembersPage(
                      projectId: extra['projectId'] as String? ??
                          state.pathParameters['projectId']!,
                      isOwner: extra['isOwner'] as bool? ?? false,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/create-project',
          builder: (context, state) => const CreateProjectPage(),
        ),

        // Notifications route
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsPage(),
        ),
      ],
    );
  }
}

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
