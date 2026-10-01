import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/projects_bloc.dart';
import '../bloc/projects_event.dart';
import '../bloc/projects_state.dart';
import '../widgets/project_card.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState.user != null) {
      context.read<ProjectsBloc>().add(
            ProjectsSubscriptionRequested(userId: authState.user!.uid),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.projects),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-project'),
        icon: const Icon(Icons.add),
        label: Text(l10n.createProject),
      ),
      body: BlocConsumer<ProjectsBloc, ProjectsState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
          if (state.actionSuccessMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.actionSuccessMessage!),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ProjectsStatus.loading && state.projects.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProjectsStatus.failure && state.projects.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? l10n.somethingWentWrong),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final uid = context.read<AuthBloc>().state.user?.uid;
                      if (uid != null) {
                        context
                            .read<ProjectsBloc>()
                            .add(ProjectsSubscriptionRequested(userId: uid));
                      }
                    },
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          if (state.projects.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open_outlined,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noProjects,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsetsDirectional.all(16),
            itemCount: state.projects.length,
            itemBuilder: (context, index) {
              final project = state.projects[index];
              return ProjectCard(
                project: project,
                onTap: () => context.push('/projects/', extra: project),
              );
            },
          );
        },
      ),
    );
  }
}
