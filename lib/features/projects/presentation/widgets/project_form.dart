import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/project.dart';

class ProjectForm extends StatefulWidget {
  final String? initialName;
  final String? initialDescription;
  final ProjectStatus initialStatus;
  final DateTime? initialDeadline;
  final bool isEditing;
  final bool isLoading;
  final void Function({
    required String name,
    required String description,
    required ProjectStatus status,
    DateTime? deadline,
  }) onSubmit;

  const ProjectForm({
    super.key,
    this.initialName,
    this.initialDescription,
    this.initialStatus = ProjectStatus.active,
    this.initialDeadline,
    this.isEditing = false,
    this.isLoading = false,
    required this.onSubmit,
  });

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late ProjectStatus _status;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _status = widget.initialStatus;
    _deadline = widget.initialDeadline;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        status: _status,
        deadline: _deadline,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.projectName,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.fieldRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: l10n.projectDescription,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          if (widget.isEditing) ...[
            const SizedBox(height: 16),
            DropdownButtonFormField<ProjectStatus>(
              initialValue: _status,
              decoration: InputDecoration(
                labelText: l10n.status,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: ProjectStatus.values.map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Text(s.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _status = val);
              },
            ),
          ],
          const SizedBox(height: 16),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outline.withAlpha(80)),
            ),
            leading: const Icon(Icons.calendar_today_outlined),
            title: Text(l10n.deadline),
            subtitle: Text(
              _deadline != null
                  ? DateFormat.yMMMd().format(_deadline!)
                  : l10n.selectDeadline,
            ),
            trailing: _deadline != null
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _deadline = null),
                  )
                : null,
            onTap: _pickDeadline,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: FilledButton(
              onPressed: widget.isLoading ? null : _submit,
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.isEditing ? l10n.update : l10n.save),
            ),
          ),
        ],
      ),
    );
  }
}
