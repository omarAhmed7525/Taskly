import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_state_changes.dart';
import '../../features/auth/domain/usecases/forgot_password.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/domain/usecases/register.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/projects/data/datasources/projects_remote_datasource.dart';
import '../../features/projects/data/repositories/projects_repository_impl.dart';
import '../../features/projects/domain/repositories/projects_repository.dart';
import '../../features/projects/domain/usecases/add_project_member.dart';
import '../../features/projects/domain/usecases/create_project.dart';
import '../../features/projects/domain/usecases/delete_project.dart';
import '../../features/projects/domain/usecases/get_project.dart';
import '../../features/projects/domain/usecases/get_project_members.dart';
import '../../features/projects/domain/usecases/get_projects.dart';
import '../../features/projects/domain/usecases/remove_project_member.dart';
import '../../features/projects/domain/usecases/update_member_role.dart';
import '../../features/projects/domain/usecases/update_project.dart';
import '../../features/projects/presentation/bloc/projects_bloc.dart';

import '../../features/notifications/data/datasources/notification_remote_datasource.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/domain/usecases/get_notifications.dart';
import '../../features/notifications/domain/usecases/initialize_notifications.dart';
import '../../features/notifications/domain/usecases/mark_notification_read.dart';
import '../../features/notifications/domain/usecases/remove_fcm_token.dart';
import '../../features/notifications/domain/usecases/save_fcm_token.dart';
import '../../features/notifications/presentation/bloc/notification_bloc.dart';

import 'notification_service.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ----------------------------------------------------
  // External / Firebase Singletons
  // ----------------------------------------------------
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);

  // ----------------------------------------------------
  // Core Services
  // ----------------------------------------------------
  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(messaging: sl(), firestore: sl()),
  );

  // ----------------------------------------------------
  // Auth Feature
  // ----------------------------------------------------
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => AuthStateChangesUseCase(sl()));

  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      forgotPasswordUseCase: sl(),
      getCurrentUserUseCase: sl(),
      authStateChangesUseCase: sl(),
    ),
  );

  // ----------------------------------------------------
  // Projects Feature
  // ----------------------------------------------------
  sl.registerLazySingleton<ProjectsRemoteDataSource>(
    () => ProjectsRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<ProjectsRepository>(
    () => ProjectsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => CreateProjectUseCase(sl()));
  sl.registerLazySingleton(() => GetProjectsUseCase(sl()));
  sl.registerLazySingleton(() => GetProjectUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProjectUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProjectUseCase(sl()));
  sl.registerLazySingleton(() => GetProjectMembersUseCase(sl()));
  sl.registerLazySingleton(() => AddProjectMemberUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMemberRoleUseCase(sl()));
  sl.registerLazySingleton(() => RemoveProjectMemberUseCase(sl()));

  sl.registerFactory(
    () => ProjectsBloc(
      getProjectsUseCase: sl(),
      createProjectUseCase: sl(),
      updateProjectUseCase: sl(),
      deleteProjectUseCase: sl(),
    ),
  );

  // ----------------------------------------------------
  // Notifications Feature
  // ----------------------------------------------------
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(
      notificationService: sl(),
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => InitializeNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => SaveFcmTokenUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFcmTokenUseCase(sl()));
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationReadUseCase(sl()));

  sl.registerFactory(
    () => NotificationBloc(
      initializeNotificationsUseCase: sl(),
      saveFcmTokenUseCase: sl(),
      getNotificationsUseCase: sl(),
      markNotificationReadUseCase: sl(),
    ),
  );
}
