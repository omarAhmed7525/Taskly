import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/localization/app_localizations.dart';
import 'package:flutter/widgets.dart';

void main() {
  group('AppLocalizations Tests', () {
    test('English translations are properly resolved', () {
      final l10n = AppLocalizations(const Locale('en'));
      expect(l10n.appName, 'Taskly');
      expect(l10n.login, 'Login');
      expect(l10n.projects, 'Projects');
      expect(l10n.notifications, 'Notifications');
      expect(l10n.createProject, 'Create Project');
    });

    test('Arabic translations are properly resolved', () {
      final l10n = AppLocalizations(const Locale('ar'));
      expect(l10n.appName, 'تاسكلي');
      expect(l10n.login, 'تسجيل الدخول');
      expect(l10n.projects, 'المشاريع');
      expect(l10n.notifications, 'الإشعارات');
      expect(l10n.createProject, 'إنشاء مشروع');
    });
  });
}
