import 'package:flutter/material.dart';

/// Localization support for English (en) and Arabic (ar).
/// Access via `AppLocalizations.of(context).someKey`.
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  // ───── String Maps ─────
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': _en,
    'ar': _ar,
  };

  String get _languageCode => locale.languageCode;

  String _t(String key) =>
      _localizedValues[_languageCode]?[key] ??
      _localizedValues['en']![key] ??
      key;

  // ─── App-wide ───
  String get appTitle => _t('appTitle');
  String get hello => _t('hello');

  // ─── Bottom Nav ───
  String get navHome => _t('navHome');
  String get navSchedule => _t('navSchedule');
  String get navReminders => _t('navReminders');
  String get navMore => _t('navMore');

  // ─── Home ───
  String get goodMorning => _t('goodMorning');
  String get howCanIHelp => _t('howCanIHelp');
  String get tapToSpeak => _t('tapToSpeak');
  String get orSayHey => _t('orSayHey');
  String get findDoctor => _t('findDoctor');
  String get findDoctorSubtitle => _t('findDoctorSubtitle');
  String get medicationReminders => _t('medicationReminders');
  String get neverMissMed => _t('neverMissMed');
  String get contactFamily => _t('contactFamily');
  String get quicklyReachFamily => _t('quicklyReachFamily');
  String get emergencyHelp => _t('emergencyHelp');
  String get getImmediateAssistance => _t('getImmediateAssistance');

  // ─── Login / Auth ───
  String get getStarted => _t('getStarted');
  String get login => _t('login');
  String get welcomeBack => _t('welcomeBack');
  String get signInBelow => _t('signInBelow');
  String get emailAddress => _t('emailAddress');
  String get password => _t('password');
  String get showPassword => _t('showPassword');
  String get hidePassword => _t('hidePassword');
  String get forgotPassword => _t('forgotPassword');
  String get logInSafely => _t('logInSafely');
  String get signingIn => _t('signingIn');
  String get newHere => _t('newHere');
  String get createFreeAccount => _t('createFreeAccount');
  String get createAccount => _t('createAccount');
  String get joinCommunity => _t('joinCommunity');
  String get fullName => _t('fullName');
  String get phoneOrEmergency => _t('phoneOrEmergency');
  String get createPassword => _t('createPassword');
  String get agreePrivacy => _t('agreePrivacy');
  String get pleaseAcceptPrivacy => _t('pleaseAcceptPrivacy');
  String get sendingCode => _t('sendingCode');
  String get continueVerification => _t('continueVerification');
  String get alreadyHaveAccount => _t('alreadyHaveAccount');
  String get verifyCode => _t('verifyCode');
  String get codeSent => _t('codeSent');
  String get verifying => _t('verifying');
  String get verifyAndContinue => _t('verifyAndContinue');
  String get resendCode => _t('resendCode');
  String get yourVoiceOurSupport => _t('yourVoiceOurSupport');

  // ─── Onboarding ───
  String get meetAssistant => _t('meetAssistant');
  String get chooseVoice => _t('chooseVoice');
  String get warmGentle => _t('warmGentle');
  String get warmGentleDesc => _t('warmGentleDesc');
  String get clearDirect => _t('clearDirect');
  String get clearDirectDesc => _t('clearDirectDesc');
  String get familyMode => _t('familyMode');
  String get familyModeDesc => _t('familyModeDesc');
  String get playVoiceSample => _t('playVoiceSample');
  String get whatCallYou => _t('whatCallYou');
  String get completeSetup => _t('completeSetup');

  // ─── Profile & Settings ───
  String get profileSettings => _t('profileSettings');
  String get edit => _t('edit');
  String get voiceSettings => _t('voiceSettings');
  String get voiceSettingsSub => _t('voiceSettingsSub');
  String get notifications => _t('notifications');
  String get notificationsSub => _t('notificationsSub');
  String get privacySecurity => _t('privacySecurity');
  String get privacySub => _t('privacySub');
  String get about => _t('about');
  String get aboutSub => _t('aboutSub');
  String get language => _t('language');
  String get darkMode => _t('darkMode');
  String get lightMode => _t('lightMode');
  String get appearance => _t('appearance');
  String get english => _t('english');
  String get arabic => _t('arabic');

  // ─── Emergency ───
  String get emergencyHelpTitle => _t('emergencyHelpTitle');
  String get helpOnWay => _t('helpOnWay');
  String get alertDispatched => _t('alertDispatched');
  String get needAssistance => _t('needAssistance');
  String get stayCalm => _t('stayCalm');
  String get cancelEmergencyAlert => _t('cancelEmergencyAlert');
  String get callEmergency => _t('callEmergency');
  String get emergencyAlertCancelled => _t('emergencyAlertCancelled');

  // ─── Family Circle ───
  String get familyCircle => _t('familyCircle');
  String get contacts => _t('contacts');
  String get requests => _t('requests');
  String get recent => _t('recent');
  String get noRecentCalls => _t('noRecentCalls');
  String get noPendingRequests => _t('noPendingRequests');
  String get approve => _t('approve');
  String get decline => _t('decline');
  String get approved => _t('approved');
  String get declined => _t('declined');

  // ─── Doctors ───
  String get findDoctorTitle => _t('findDoctorTitle');
  String get searchDoctorSubtitle => _t('searchDoctorSubtitle');
  String get searchHint => _t('searchHint');
  String get all => _t('all');
  String get general => _t('general');
  String get cardiology => _t('cardiology');
  String get dermatology => _t('dermatology');
  String get noMatch => _t('noMatch');
  String get book => _t('book');
  String get bookAppointment => _t('bookAppointment');

  // ─── Appointments ───
  String get myAppointments => _t('myAppointments');
  String get manageAppointments => _t('manageAppointments');
  String get upcoming => _t('upcoming');
  String get past => _t('past');
  String get noAppointments => _t('noAppointments');
  String get addNewAppointment => _t('addNewAppointment');
  String get cancelAppointment => _t('cancelAppointment');
  String get keepAppointment => _t('keepAppointment');
  String get cancelled => _t('cancelled');

  // ─── Reminders ───
  String get reminderTitle => _t('reminderTitle');
  String get addNewReminder => _t('addNewReminder');
  String get editReminder => _t('editReminder');
  String get deleteReminder => _t('deleteReminder');
  String get reminderTitleLabel => _t('reminderTitleLabel');
  String get instructionsPattern => _t('instructionsPattern');
  String get save => _t('save');
  String get cancel => _t('cancel');
  String get delete => _t('delete');
  String get completed => _t('completed');
  String get skipped => _t('skipped');
  String get missed => _t('missed');
  String get pending => _t('pending');
  String get markCompleted => _t('markCompleted');
  String get markPending => _t('markPending');
  String get todayReminders => _t('todayReminders');

  // ─── Voice Assistant ───
  String get listening => _t('listening');
  String get processing => _t('processing');
  String get speaking => _t('speaking');

  // ─── Connection Banner ───
  String get reconnecting => _t('reconnecting');
  String get liveUnavailable => _t('liveUnavailable');
  String get retry => _t('retry');

  // ─── Error View ───
  String get somethingWentWrong => _t('somethingWentWrong');

  // ─── Misc ───
  String get km => _t('km');
  String get min => _t('min');

  // ─── Helpers for parameterized strings ───
  String remindersScheduled(int count) =>
      _languageCode == 'ar'
          ? '$count تذكيرات مجدولة لليوم'
          : '$count reminders scheduled for today';

  String alertSentAt(String time) =>
      _languageCode == 'ar'
          ? 'تم إرسال التنبيه في $time. تم إخطار عائلتك ومقدمي الرعاية.'
          : 'Alert sent at $time. Your family and caregivers have been notified.';

  String confirmDelete(String title) =>
      _languageCode == 'ar'
          ? 'هل أنت متأكد من حذف "$title"؟'
          : 'Are you sure you want to delete "$title"?';

  String confirmCancel(String name) =>
      _languageCode == 'ar'
          ? 'هل أنت متأكد من إلغاء موعدك مع $name؟'
          : 'Are you sure you want to cancel your appointment with $name?';

  String goodMorningName(String name) =>
      _languageCode == 'ar' ? 'صباح الخير، $name' : 'Good morning, $name';

  String selectDateFor(String name) =>
      _languageCode == 'ar'
          ? 'اختر تاريخ الموعد لـ $name'
          : 'Select Appointment Date for $name';

  String get selectTime =>
      _languageCode == 'ar' ? 'اختر وقت الموعد' : 'Select Appointment Time';

  // ───── English Strings ─────
  static const Map<String, String> _en = {
    'appTitle': 'AI Elderly Assistant',
    'hello': 'Hello,',

    // Nav
    'navHome': 'Home',
    'navSchedule': 'Schedule',
    'navReminders': 'Reminders',
    'navMore': 'More',

    // Home
    'goodMorning': 'Good morning',
    'howCanIHelp': 'How can I help you today?',
    'tapToSpeak': 'Tap to speak',
    'orSayHey': 'Or say "Hey Assistant"',
    'findDoctor': 'Find a Doctor',
    'findDoctorSubtitle': 'Search nearby doctors and book appointments',
    'medicationReminders': 'Medication Reminders',
    'neverMissMed': 'Never miss your medication',
    'contactFamily': 'Contact Family',
    'quicklyReachFamily': 'Quickly reach your family members',
    'emergencyHelp': 'Emergency Help',
    'getImmediateAssistance': 'Get immediate assistance',

    // Auth
    'getStarted': 'Get Started',
    'login': 'Login',
    'welcomeBack': 'Welcome Back',
    'signInBelow': 'Sign in below to start speaking with your assistant.',
    'emailAddress': 'Email Address',
    'password': 'Password',
    'showPassword': 'Show password',
    'hidePassword': 'Hide password',
    'forgotPassword': 'Forgot Password?',
    'logInSafely': 'Log In Safely',
    'signingIn': 'Signing in...',
    'newHere': 'New here? ',
    'createFreeAccount': 'Create a free account',
    'createAccount': 'Create Account',
    'joinCommunity':
        'Join our caring community. We are here to support you every step of the way.',
    'fullName': 'Full Name',
    'phoneOrEmergency': 'Phone or Emergency Contact',
    'createPassword': 'Create Password',
    'agreePrivacy':
        'I agree to the Privacy Policy. Personal information is protected with secure safeguards.',
    'pleaseAcceptPrivacy': 'Please accept the privacy policy',
    'sendingCode': 'Sending code...',
    'continueVerification': 'Continue to Verification',
    'alreadyHaveAccount': 'Already have an account? Login',
    'verifyCode': 'Verify Your Code',
    'codeSent':
        'We sent a simple 4-digit security code to your phone. Demo code: 1234',
    'verifying': 'Verifying...',
    'verifyAndContinue': 'Verify & Continue',
    'resendCode': 'Resend Code',
    'yourVoiceOurSupport':
        'Your voice. Our support.\nSimple help for a safer, healthier and more connected life.',

    // Onboarding
    'meetAssistant': 'Meet Your Assistant',
    'chooseVoice':
        'Choose how you\'d like your companion to speak with you. You can change this at any time.',
    'warmGentle': 'Warm & Gentle',
    'warmGentleDesc':
        'Soothing tone, slower pace, and friendly heartfelt check-ins.',
    'clearDirect': 'Clear & Direct',
    'clearDirectDesc':
        'Crisp volume, concise updates, and clear medication prompts.',
    'familyMode': 'Family Member Mode',
    'familyModeDesc':
        'Warm conversational tone with thoughtful daily stories and recap.',
    'playVoiceSample': 'Play Voice Sample',
    'whatCallYou': 'What should I call you?',
    'completeSetup': 'Complete Setup & Go Home',

    // Profile
    'profileSettings': 'Profile & Settings',
    'edit': 'Edit',
    'voiceSettings': 'Voice Settings',
    'voiceSettingsSub': 'Language, voice, speed',
    'notifications': 'Notifications',
    'notificationsSub': 'Reminders, alerts',
    'privacySecurity': 'Privacy & Security',
    'privacySub': 'Data and permissions',
    'about': 'About',
    'aboutSub': 'App version, support',
    'language': 'Language',
    'darkMode': 'Dark Mode',
    'lightMode': 'Light Mode',
    'appearance': 'Appearance',
    'english': 'English',
    'arabic': 'العربية',

    // Emergency
    'emergencyHelpTitle': 'Emergency Help',
    'helpOnWay': 'Help is on the way!',
    'alertDispatched': 'Alert Dispatched',
    'needAssistance':
        'Need immediate assistance?\nYou will be connected with your family or emergency services.',
    'stayCalm':
        'Stay calm. Your caregivers have received your location and contact request.',
    'cancelEmergencyAlert': 'Cancel Emergency Alert',
    'callEmergency': 'Call Emergency',
    'emergencyAlertCancelled': 'Emergency alert cancelled',
    'back': 'Back',

    // Family
    'familyCircle': 'Family Circle',
    'contacts': 'Contacts',
    'requests': 'Requests',
    'recent': 'Recent',
    'noRecentCalls': 'No recent calls',
    'noPendingRequests': 'No pending caregiver access requests',
    'approve': 'Approve',
    'decline': 'Decline',
    'approved': 'Approved',
    'declined': 'Declined',

    // Doctors
    'findDoctorTitle': 'Find a Doctor',
    'searchDoctorSubtitle':
        'Search for nearby doctors and book an appointment',
    'searchHint': 'Search by speciality (e.g. cardiologist)',
    'all': 'All',
    'general': 'General',
    'cardiology': 'Cardiology',
    'dermatology': 'Dermatology',
    'noMatch': 'No doctors match this search.',
    'book': 'Book',
    'bookAppointment': 'Book Appointment',

    // Appointments
    'myAppointments': 'My Appointments',
    'manageAppointments': 'View and manage your upcoming appointments.',
    'upcoming': 'Upcoming',
    'past': 'Past',
    'noAppointments': 'No appointments here yet.',
    'addNewAppointment': 'Add New Appointment',
    'cancelAppointment': 'Cancel Appointment',
    'keepAppointment': 'Keep Appointment',
    'cancelled': 'Cancelled',

    // Reminders
    'reminderTitle': 'Medication Reminders',
    'addNewReminder': 'Add New Reminder',
    'editReminder': 'Edit Reminder',
    'deleteReminder': 'Delete Reminder',
    'reminderTitleLabel': 'Reminder Title',
    'instructionsPattern': 'Instructions / Repeat Pattern',
    'save': 'Save',
    'cancel': 'Cancel',
    'delete': 'Delete',
    'completed': 'Completed',
    'skipped': 'Skipped',
    'missed': 'Missed',
    'pending': 'Pending',
    'markCompleted': 'Mark as completed',
    'markPending': 'Mark as pending',
    'todayReminders': 'Today, 23 September\nHere are your upcoming medications:',

    // Voice
    'listening': 'Listening...',
    'processing': 'Processing...',
    'speaking': 'Speaking...',

    // Connection
    'reconnecting': 'Reconnecting to live updates…',
    'liveUnavailable': 'Live updates unavailable. Tap Retry.',
    'retry': 'Retry',

    // Error
    'somethingWentWrong': 'Something went wrong',

    // Misc
    'km': 'km',
    'min': 'min',
  };

  // ───── Arabic Strings ─────
  static const Map<String, String> _ar = {
    'appTitle': 'مساعد كبار السن الذكي',
    'hello': 'مرحباً،',

    // Nav
    'navHome': 'الرئيسية',
    'navSchedule': 'المواعيد',
    'navReminders': 'التذكيرات',
    'navMore': 'المزيد',

    // Home
    'goodMorning': 'صباح الخير',
    'howCanIHelp': 'كيف يمكنني مساعدتك اليوم؟',
    'tapToSpeak': 'اضغط للتحدث',
    'orSayHey': 'أو قل "يا مساعد"',
    'findDoctor': 'ابحث عن طبيب',
    'findDoctorSubtitle': 'ابحث عن أطباء قريبين واحجز مواعيد',
    'medicationReminders': 'تذكيرات الأدوية',
    'neverMissMed': 'لا تفوّت دواءك أبداً',
    'contactFamily': 'تواصل مع العائلة',
    'quicklyReachFamily': 'تواصل بسرعة مع أفراد عائلتك',
    'emergencyHelp': 'مساعدة طوارئ',
    'getImmediateAssistance': 'احصل على مساعدة فورية',

    // Auth
    'getStarted': 'ابدأ الآن',
    'login': 'تسجيل الدخول',
    'welcomeBack': 'مرحباً بعودتك',
    'signInBelow': 'سجّل دخولك للتحدث مع مساعدك.',
    'emailAddress': 'البريد الإلكتروني',
    'password': 'كلمة المرور',
    'showPassword': 'إظهار كلمة المرور',
    'hidePassword': 'إخفاء كلمة المرور',
    'forgotPassword': 'نسيت كلمة المرور؟',
    'logInSafely': 'تسجيل دخول آمن',
    'signingIn': 'جارٍ تسجيل الدخول...',
    'newHere': 'جديد هنا؟ ',
    'createFreeAccount': 'أنشئ حساباً مجانياً',
    'createAccount': 'إنشاء حساب',
    'joinCommunity': 'انضم لمجتمعنا الداعم. نحن هنا لدعمك في كل خطوة.',
    'fullName': 'الاسم الكامل',
    'phoneOrEmergency': 'الهاتف أو جهة اتصال الطوارئ',
    'createPassword': 'أنشئ كلمة مرور',
    'agreePrivacy':
        'أوافق على سياسة الخصوصية. المعلومات الشخصية محمية بإجراءات أمنية.',
    'pleaseAcceptPrivacy': 'يرجى الموافقة على سياسة الخصوصية',
    'sendingCode': 'جارٍ إرسال الرمز...',
    'continueVerification': 'المتابعة للتحقق',
    'alreadyHaveAccount': 'لديك حساب بالفعل؟ سجّل دخولك',
    'verifyCode': 'تحقق من الرمز',
    'codeSent':
        'أرسلنا رمز أمان بسيط مكون من 4 أرقام لهاتفك. رمز التجربة: 1234',
    'verifying': 'جارٍ التحقق...',
    'verifyAndContinue': 'تحقق ومتابعة',
    'resendCode': 'إعادة إرسال الرمز',
    'yourVoiceOurSupport':
        'صوتك. دعمنا.\nمساعدة بسيطة لحياة أكثر أماناً وصحة وتواصلاً.',

    // Onboarding
    'meetAssistant': 'تعرّف على مساعدك',
    'chooseVoice': 'اختر كيف تريد أن يتحدث مساعدك معك. يمكنك التغيير في أي وقت.',
    'warmGentle': 'دافئ ولطيف',
    'warmGentleDesc': 'نبرة مهدئة، إيقاع أبطأ، وتفقد ودي صادق.',
    'clearDirect': 'واضح ومباشر',
    'clearDirectDesc': 'صوت واضح، تحديثات مختصرة، وتنبيهات أدوية واضحة.',
    'familyMode': 'وضع فرد العائلة',
    'familyModeDesc': 'نبرة محادثة دافئة مع قصص يومية مدروسة وملخص.',
    'playVoiceSample': 'تشغيل عينة صوتية',
    'whatCallYou': 'ماذا تحب أن أناديك؟',
    'completeSetup': 'إكمال الإعداد والانتقال للرئيسية',

    // Profile
    'profileSettings': 'الملف الشخصي والإعدادات',
    'edit': 'تعديل',
    'voiceSettings': 'إعدادات الصوت',
    'voiceSettingsSub': 'اللغة، الصوت، السرعة',
    'notifications': 'الإشعارات',
    'notificationsSub': 'التذكيرات، التنبيهات',
    'privacySecurity': 'الخصوصية والأمان',
    'privacySub': 'البيانات والصلاحيات',
    'about': 'حول التطبيق',
    'aboutSub': 'إصدار التطبيق، الدعم',
    'language': 'اللغة',
    'darkMode': 'الوضع الداكن',
    'lightMode': 'الوضع الفاتح',
    'appearance': 'المظهر',
    'english': 'English',
    'arabic': 'العربية',

    // Emergency
    'emergencyHelpTitle': 'مساعدة الطوارئ',
    'helpOnWay': 'المساعدة في الطريق!',
    'alertDispatched': 'تم إرسال التنبيه',
    'needAssistance':
        'تحتاج مساعدة فورية؟\nسيتم توصيلك بعائلتك أو خدمات الطوارئ.',
    'stayCalm': 'ابقَ هادئاً. تلقّى مقدمو الرعاية موقعك وطلب التواصل.',
    'cancelEmergencyAlert': 'إلغاء تنبيه الطوارئ',
    'callEmergency': 'اتصل بالطوارئ',
    'emergencyAlertCancelled': 'تم إلغاء تنبيه الطوارئ',
    'back': 'رجوع',

    // Family
    'familyCircle': 'دائرة العائلة',
    'contacts': 'جهات الاتصال',
    'requests': 'الطلبات',
    'recent': 'الأخيرة',
    'noRecentCalls': 'لا توجد مكالمات حديثة',
    'noPendingRequests': 'لا توجد طلبات وصول معلقة لمقدمي الرعاية',
    'approve': 'قبول',
    'decline': 'رفض',
    'approved': 'تمت الموافقة',
    'declined': 'تم الرفض',

    // Doctors
    'findDoctorTitle': 'ابحث عن طبيب',
    'searchDoctorSubtitle': 'ابحث عن أطباء قريبين واحجز موعداً',
    'searchHint': 'ابحث بالتخصص (مثلاً: قلب)',
    'all': 'الكل',
    'general': 'عام',
    'cardiology': 'قلب',
    'dermatology': 'جلدية',
    'noMatch': 'لا يوجد أطباء مطابقون لهذا البحث.',
    'book': 'احجز',
    'bookAppointment': 'حجز موعد',

    // Appointments
    'myAppointments': 'مواعيدي',
    'manageAppointments': 'عرض وإدارة مواعيدك القادمة.',
    'upcoming': 'القادمة',
    'past': 'السابقة',
    'noAppointments': 'لا توجد مواعيد حتى الآن.',
    'addNewAppointment': 'إضافة موعد جديد',
    'cancelAppointment': 'إلغاء الموعد',
    'keepAppointment': 'الاحتفاظ بالموعد',
    'cancelled': 'ملغي',

    // Reminders
    'reminderTitle': 'تذكيرات الأدوية',
    'addNewReminder': 'إضافة تذكير جديد',
    'editReminder': 'تعديل التذكير',
    'deleteReminder': 'حذف التذكير',
    'reminderTitleLabel': 'عنوان التذكير',
    'instructionsPattern': 'التعليمات / نمط التكرار',
    'save': 'حفظ',
    'cancel': 'إلغاء',
    'delete': 'حذف',
    'completed': 'مكتمل',
    'skipped': 'تم تخطيه',
    'missed': 'فائت',
    'pending': 'قيد الانتظار',
    'markCompleted': 'وضع علامة مكتمل',
    'markPending': 'وضع علامة قيد الانتظار',
    'todayReminders': 'اليوم، 23 سبتمبر\nإليك أدويتك القادمة:',

    // Voice
    'listening': 'جارٍ الاستماع...',
    'processing': 'جارٍ المعالجة...',
    'speaking': 'جارٍ التحدث...',

    // Connection
    'reconnecting': 'جارٍ إعادة الاتصال بالتحديثات الحية…',
    'liveUnavailable': 'التحديثات الحية غير متاحة. اضغط إعادة المحاولة.',
    'retry': 'إعادة المحاولة',

    // Error
    'somethingWentWrong': 'حدث خطأ ما',

    // Misc
    'km': 'كم',
    'min': 'دقيقة',
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
