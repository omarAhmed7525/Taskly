import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/projects_bloc.dart';
import '../bloc/projects_event.dart';
import '../bloc/projects_state.dart';
import '../widgets/project_form.dart';

class CreateProjectPage extends StatelessWidget {
  const CreateProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUserId = context.read<AuthBloc>().state.user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createProject),
      ),
      body: BlocConsumer<ProjectsBloc, ProjectsState>(
        listener: (context, state) {
          if (state.actionSuccessMessage != null && !state.isSubmitting) {
            context.pop();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsetsDirectional.all(24),
            child: ProjectForm(
              isLoading: state.isSubmitting,
              onSubmit: ({
                required String name,
                required String description,
                required status,
                DateTime? deadline,
              }) {
                context.read<ProjectsBloc>().add(
                      ProjectCreateSubmitted(
                        name: name,
                        description: description,
                        ownerId: currentUserId,
                        deadline: deadline,
                      ),
                    );
              },
            ),
          );
        },
      ),
    );
  }
}
