import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../widgets/notification_tile.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    final uid = context.read<AuthBloc>().state.user?.uid;
    if (uid != null) {
      context.read<NotificationBloc>().add(
            NotificationSubscribeRequested(userId: uid),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state.status == NotificationStatus.loading && state.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == NotificationStatus.failure && state.notifications.isEmpty) {
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
                        context.read<NotificationBloc>().add(
                              NotificationSubscribeRequested(userId: uid),
                            );
                      }
                    },
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          if (state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noNotifications,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsetsDirectional.all(16),
            itemCount: state.notifications.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final notification = state.notifications[index];
              return NotificationTile(
                notification: notification,
                onTap: () {
                  if (!notification.isRead) {
                    context.read<NotificationBloc>().add(
                          NotificationMarkReadRequested(notificationId: notification.id),
                        );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
