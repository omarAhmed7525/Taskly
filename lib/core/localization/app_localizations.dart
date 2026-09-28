import 'package:flutter/widgets.dart';

/// Localization keys and translations for Arabic and English.
/// Architecture designed to be shared and extended across Taskly features.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // General
      'appName': 'Taskly',
      'loading': 'Loading...',
      'retry': 'Retry',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'update': 'Update',
      'confirm': 'Confirm',
      'error': 'Error',
      'success': 'Success',
      'somethingWentWrong': 'Something went wrong. Please try again.',
      'networkError': 'No internet connection. Please verify your network.',

      // Auth
      'login': 'Login',
      'register': 'Register',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'name': 'Full Name',
      'forgotPassword': 'Forgot Password?',
      'forgotPasswordTitle': 'Reset Password',
      'forgotPasswordInstruction': 'Enter your registered email to receive a password reset link.',
      'sendResetLink': 'Send Reset Link',
      'resetLinkSent': 'Password reset link sent to your email.',
      'dontHaveAccount': 'Don\'t have an account? Register',
      'alreadyHaveAccount': 'Already have an account? Login',
      'loginSuccess': 'Logged in successfully',
      'registerSuccess': 'Account registered successfully',

      // Validation
      'fieldRequired': 'This field is required',
      'invalidEmail': 'Please enter a valid email address',
      'passwordTooShort': 'Password must be at least 6 characters',
      'passwordsDoNotMatch': 'Passwords do not match',
      'nameTooShort': 'Name must be at least 2 characters',

      // Projects
      'projects': 'Projects',
      'createProject': 'Create Project',
      'editProject': 'Edit Project',
      'projectName': 'Project Name',
      'projectDescription': 'Description',
      'deadline': 'Deadline',
      'selectDeadline': 'Select Deadline',
      'noDeadline': 'No deadline set',
      'status': 'Status',
      'active': 'Active',
      'completed': 'Completed',
      'archived': 'Archived',
      'noProjects': 'No projects found. Create your first project!',
      'projectCreated': 'Project created successfully',
      'projectUpdated': 'Project updated successfully',
      'projectDeleted': 'Project deleted successfully',
      'deleteProjectConfirmation': 'Are you sure you want to delete this project?',
      'members': 'Members',
      'addMember': 'Add Member',
      'memberRole': 'Role',
      'memberUserId': 'Member User ID',
      'owner': 'Owner',
      'manager': 'Manager',
      'member': 'Member',
      'viewer': 'Viewer',
      'removeMember': 'Remove Member',
      'removeMemberConfirmation': 'Are you sure you want to remove this member?',

      // Notifications
      'notifications': 'Notifications',
      'noNotifications': 'You have no notifications',
      'markAsRead': 'Mark as read',
      'notificationRead': 'Notification read',
    },
    'ar': {
      // General
      'appName': 'تاسكلي',
      'loading': 'جاري التحميل...',
      'retry': 'إعادة المحاولة',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'update': 'تحديث',
      'confirm': 'تأكيد',
      'error': 'خطأ',
      'success': 'تم بنجاح',
      'somethingWentWrong': 'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
      'networkError': 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.',

      // Auth
      'login': 'تسجيل الدخول',
      'register': 'إنشاء حساب جديد',
      'logout': 'تسجيل الخروج',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirmPassword': 'تأكيد كلمة المرور',
      'name': 'الاسم بالكامل',
      'forgotPassword': 'هل نسيت كلمة المرور؟',
      'forgotPasswordTitle': 'إعادة تعيين كلمة المرور',
      'forgotPasswordInstruction': 'أدخل بريدك الإلكتروني المسجل لتلقي رابط إعادة التعيين.',
      'sendResetLink': 'إرسال رابط إعادة التعيين',
      'resetLinkSent': 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.',
      'dontHaveAccount': 'ليس لديك حساب؟ تسجيل جديد',
      'alreadyHaveAccount': 'لديك حساب بالفعل؟ تسجيل الدخول',
      'loginSuccess': 'تم تسجيل الدخول بنجاح',
      'registerSuccess': 'تم إنشاء الحساب بنجاح',

      // Validation
      'fieldRequired': 'هذا الحقل مطلوب',
      'invalidEmail': 'يرجى إدخال بريد إلكتروني صالح',
      'passwordTooShort': 'كلمة المرور يجب أن لا تقل عن 6 أحرف',
      'passwordsDoNotMatch': 'كلمتا المرور غير متطابقتين',
      'nameTooShort': 'الاسم يجب أن لا يقل عن حرفين',

      // Projects
      'projects': 'المشاريع',
      'createProject': 'إنشاء مشروع',
      'editProject': 'تعديل المشروع',
      'projectName': 'اسم المشروع',
      'projectDescription': 'الوصف',
      'deadline': 'الموعد النهائي',
      'selectDeadline': 'تحديد الموعد النهائي',
      'noDeadline': 'لم يتم تحديد موعد',
      'status': 'الحالة',
      'active': 'نشط',
      'completed': 'مكتمل',
      'archived': 'مؤرشف',
      'noProjects': 'لا توجد مشاريع حالياً. ابدأ بإنشاء أول مشروع!',
      'projectCreated': 'تم إنشاء المشروع بنجاح',
      'projectUpdated': 'تم تحديث المشروع بنجاح',
      'projectDeleted': 'تم حذف المشروع بنجاح',
      'deleteProjectConfirmation': 'هل أنت متأكد من رغبتك في حذف هذا المشروع؟',
      'members': 'الأعضاء',
      'addMember': 'إضافة عضو',
      'memberRole': 'الدور',
      'memberUserId': 'معرف المستخدم للعضو',
      'owner': 'مالك',
      'manager': 'مدير',
      'member': 'عضو',
      'viewer': 'مشاهد',
      'removeMember': 'إزالة العضو',
      'removeMemberConfirmation': 'هل أنت متأكد من إزالة هذا العضو؟',

      // Notifications
      'notifications': 'الإشعارات',
      'noNotifications': 'لا توجد إشعارات لديك',
      'markAsRead': 'تحديد كمقروء',
      'notificationRead': 'تم قراءة الإشعار',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Common helpers
  String get appName => translate('appName');
  String get loading => translate('loading');
  String get retry => translate('retry');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get update => translate('update');
  String get confirm => translate('confirm');
  String get error => translate('error');
  String get success => translate('success');
  String get somethingWentWrong => translate('somethingWentWrong');
  String get networkError => translate('networkError');

  // Auth
  String get login => translate('login');
  String get register => translate('register');
  String get logout => translate('logout');
  String get email => translate('email');
  String get password => translate('password');
  String get confirmPassword => translate('confirmPassword');
  String get name => translate('name');
  String get forgotPassword => translate('forgotPassword');
  String get forgotPasswordTitle => translate('forgotPasswordTitle');
  String get forgotPasswordInstruction => translate('forgotPasswordInstruction');
  String get sendResetLink => translate('sendResetLink');
  String get resetLinkSent => translate('resetLinkSent');
  String get dontHaveAccount => translate('dontHaveAccount');
  String get alreadyHaveAccount => translate('alreadyHaveAccount');
  String get loginSuccess => translate('loginSuccess');
  String get registerSuccess => translate('registerSuccess');

  // Validation
  String get fieldRequired => translate('fieldRequired');
  String get invalidEmail => translate('invalidEmail');
  String get passwordTooShort => translate('passwordTooShort');
  String get passwordsDoNotMatch => translate('passwordsDoNotMatch');
  String get nameTooShort => translate('nameTooShort');

  // Projects
  String get projects => translate('projects');
  String get createProject => translate('createProject');
  String get editProject => translate('editProject');
  String get projectName => translate('projectName');
  String get projectDescription => translate('projectDescription');
  String get deadline => translate('deadline');
  String get selectDeadline => translate('selectDeadline');
  String get noDeadline => translate('noDeadline');
  String get status => translate('status');
  String get active => translate('active');
  String get completed => translate('completed');
  String get archived => translate('archived');
  String get noProjects => translate('noProjects');
  String get projectCreated => translate('projectCreated');
  String get projectUpdated => translate('projectUpdated');
  String get projectDeleted => translate('projectDeleted');
  String get deleteProjectConfirmation => translate('deleteProjectConfirmation');
  String get members => translate('members');
  String get addMember => translate('addMember');
  String get memberRole => translate('memberRole');
  String get memberUserId => translate('memberUserId');
  String get owner => translate('owner');
  String get manager => translate('manager');
  String get member => translate('member');
  String get viewer => translate('viewer');
  String get removeMember => translate('removeMember');
  String get removeMemberConfirmation => translate('removeMemberConfirmation');

  // Notifications
  String get notifications => translate('notifications');
  String get noNotifications => translate('noNotifications');
  String get markAsRead => translate('markAsRead');
  String get notificationRead => translate('notificationRead');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
