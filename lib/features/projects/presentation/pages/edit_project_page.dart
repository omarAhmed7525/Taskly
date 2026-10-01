import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/project.dart';
import '../bloc/projects_bloc.dart';
import '../bloc/projects_event.dart';
import '../bloc/projects_state.dart';
import '../widgets/project_form.dart';

class EditProjectPage extends StatelessWidget {
  final Project project;

  const EditProjectPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProject),
      ),
      body: BlocConsumer<ProjectsBloc, ProjectsState>(
        listener: (context, state) {
          if (state.actionSuccessMessage == 'Project updated successfully') {
            context.pop();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsetsDirectional.all(24),
            child: ProjectForm(
              initialName: project.name,
              initialDescription: project.description,
              initialStatus: project.status,
              initialDeadline: project.deadline,
              isEditing: true,
              isLoading: state.isSubmitting,
              onSubmit: ({
                required String name,
                required String description,
                required ProjectStatus status,
                DateTime? deadline,
              }) {
                context.read<ProjectsBloc>().add(
                      ProjectUpdateSubmitted(
                        projectId: project.id,
                        name: name,
                        description: description,
                        status: status,
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
