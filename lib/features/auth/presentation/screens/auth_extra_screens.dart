import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/rafiq_sky_header.dart';
import '../../providers/auth_provider.dart';
import 'onboarding_screen.dart';

/// 1. Continue with Google Screen (`المتابعة باستخدام Google` `#93:4696`).
class GoogleConsentScreen extends StatelessWidget {
  const GoogleConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColorsDark.background : AppColors.background;
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          RafiqSkyHeader(
            title: 'المتابعة باستخدام Google',
            subtitle: 'نستخدم حساب Google لتسجيل دخولك بسرعة وأمان',
            onBack: () => Navigator.of(context).maybePop(),
            backLabel: 'رجوع',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColorsDark.primaryContainer
                                    : AppColors.rafiqPrimaryTint,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'G',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ما الذي تتم مشاركته مع رفيق؟',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w800,
                                      color: textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'بيانات أساسية فقط لإنشاء ملفك الشخصي',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _SharedInfoRow(
                          label: 'الاسم الكامل (مثال: عادل أحمد)',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),
                        _SharedInfoRow(
                          label: 'البريد الإلكتروني المرتبط بحسابك',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),
                        _SharedInfoRow(
                          label: 'صورة الملف الشخصي الأساسية',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColorsDark.successLight
                                : AppColors.successLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? AppColorsDark.successBorder
                                  : AppColors.successBorder,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.success,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'كلمة مرور Google تبقى خاصة ولا يطّلع عليها تطبيق رفيق أبدًا.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await context.read<AuthCubit>()
                                  .loginWithGoogle();
                              if (!context.mounted) return;
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const PermissionsPrivacyScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            icon: const Icon(Icons.check_circle_outline_rounded),
                            label: const Text(
                              'المتابعة إلى Google',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: textPrimary,
                              side: BorderSide(color: borderColor, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'إلغاء',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SharedInfoRow extends StatelessWidget {
  const _SharedInfoRow({required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: AppColors.success,
          size: 22,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// 2. Password Recovery Screen (`استعادة كلمة المرور` `#93:4609`).
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController(
    text: 'adel.ahmed@rafiq.app',
  );
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColorsDark.background : AppColors.background;
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          RafiqSkyHeader(
            title: 'استعادة كلمة المرور',
            subtitle: 'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة التعيين',
            onBack: () => Navigator.of(context).maybePop(),
            backLabel: 'رجوع',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'البريد الإلكتروني',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'adel.ahmed@rafiq.app',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        if (_sent) ...[
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColorsDark.successLight
                                  : AppColors.successLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? AppColorsDark.successBorder
                                    : AppColors.successBorder,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.mark_email_read_rounded,
                                  color: AppColors.success,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'تم إرسال رابط استعادة كلمة المرور إلى بريدك الإلكتروني بنجاح.',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: () async {
                              final ok = await context.read<AuthCubit>()
                                  .sendPasswordReset(_emailController.text);
                              if (ok && mounted) {
                                setState(() => _sent = true);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'إرسال رابط الاستعادة',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: textPrimary,
                              side: BorderSide(color: borderColor, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'العودة لتسجيل الدخول',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor, width: 1.4),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: primaryColor,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'افتح الرابط بنفسك',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                'لا تشارك رابط استعادة كلمة المرور مع أي شخص حفاظًا على أمان حسابك.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 3. Permissions & Privacy Screen (`الأذونات والخصوصية` `#93:4429` Day / `#93:4753` Night).
class PermissionsPrivacyScreen extends StatelessWidget {
  const PermissionsPrivacyScreen({super.key});

  void _proceedToMeetAssistant(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsCubit>().state;
    final notifier = context.read<AppSettingsCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColorsDark.background : AppColors.background;
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          RafiqSkyHeader(
            title: 'الأذونات والخصوصية',
            subtitle: 'أنت تختار ما تسمح به، ويمكنك تغييره في أي وقت',
            onBack: () => Navigator.of(context).maybePop(),
            backLabel: 'رجوع',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إعدادات اختيارية لراحتك',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Permission 1: Notifications
                        _PermissionCardItem(
                          title: 'الإشعارات للتذكير',
                          badgeText: 'اختياري',
                          description:
                              'تنبيهات لطيفة بمواعيد الأدوية والزيارات الطبية.',
                          value: settings.notificationsEnabled,
                          isDark: isDark,
                          onChanged: notifier.setNotificationsEnabled,
                        ),
                        const SizedBox(height: 12),
                        // Permission 2: Location while using
                        _PermissionCardItem(
                          title: 'الموقع أثناء الاستخدام فقط',
                          badgeText: 'اختياري',
                          description:
                              'لمعرفة المستشفيات القريبة ومساعدتك في العودة للمنزل عند الطلب.',
                          value: settings.locationWhileUsingEnabled,
                          isDark: isDark,
                          onChanged: notifier.setLocationWhileUsingEnabled,
                        ),
                        const SizedBox(height: 12),
                        // Consent 3: Trusted person sharing
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColorsDark.surfaceVariant
                                : const Color(0xFFF8FAFF),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'المشاركة مع شخص موثوق',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'لا تتم مشاركة أي بيانات صحية مع العائلة إلا بموافقتك الصريحة.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: settings.trustedPersonSharingConsent,
                                activeColor: primaryColor,
                                onChanged: (val) => notifier
                                    .setTrustedPersonSharingConsent(val ?? false),
                                title: Text(
                                  'أريد اختيار شخص وما أشاركه معه',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: () => _proceedToMeetAssistant(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'المتابعة',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () => _proceedToMeetAssistant(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: textPrimary,
                              side: BorderSide(color: borderColor, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'تخطّي الآن',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Next Step Preview Card (`التالي: تعرّف على مساعدك`)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.record_voice_over_rounded,
                          color: primaryColor,
                          size: 26,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'التالي: تعرّف على مساعدك',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                'اختر نبرة الصوت المريحة لك (دافئ ولطيف، واضح ومباشر، أو عائلي).',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionCardItem extends StatelessWidget {
  const _PermissionCardItem({
    required this.title,
    required this.badgeText,
    required this.description,
    required this.value,
    required this.isDark,
    required this.onChanged,
  });

  final String title;
  final String badgeText;
  final String description;
  final bool value;
  final bool isDark;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surfaceVariant : const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: primaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
