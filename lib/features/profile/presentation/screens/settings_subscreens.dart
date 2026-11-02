import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/rafiq_emergency_bar.dart';
import '../../../../core/widgets/rafiq_sky_header.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../emergency/presentation/screens/emergency_screen.dart';

/// 1. Edit Profile Screen (`تعديل بياناتي` `#47:3`).
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthCubit>().state;
    _nameController = TextEditingController(text: auth.userName ?? 'عادل أحمد');
    _phoneController = TextEditingController(text: auth.userPhone);
    _addressController = TextEditingController(text: auth.homeAddress);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
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
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          RafiqSkyHeader(
            title: 'تعديل بياناتي',
            subtitle: 'حدّث اسمك ورقم هاتفك وعنوان المنزل',
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
                        Center(
                          child: CircleAvatar(
                            radius: 36,
                            backgroundColor: primaryColor,
                            child: const Text(
                              'ع',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'الاسم الكامل',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'رقم الهاتف',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'عنوان المنزل (للطوارئ والعودة للبيت)',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.home_outlined),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<AuthCubit>().updateProfile(
                                    name: _nameController.text,
                                    phone: _phoneController.text,
                                    homeAddress: _addressController.text,
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('✓ تم حفظ بياناتك بنجاح'),
                                ),
                              );
                              Navigator.of(context).maybePop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'حفظ التعديلات ✓',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
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

/// 2. Appearance Screen (`المظهر` `#75:12` Day & `#75:208` Night).
class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

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

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          RafiqSkyHeader(
            title: 'المظهر',
            subtitle: 'اختر مظهر النهار أو الليل أو التبديل التلقائي',
            onBack: () => Navigator.of(context).maybePop(),
            backLabel: 'رجوع',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _RadioChoiceCard(
                    title: 'تلقائي حسب الوقت',
                    badgeText: 'موصى به',
                    subtitle: 'مظهر نهاري مشرق صباحًا، وليلي هادئ مساءً.',
                    icon: Icons.wb_twilight_rounded,
                    isSelected: settings.appearanceMode == 'auto',
                    isDark: isDark,
                    onTap: () => notifier.setAppearanceMode('auto'),
                  ),
                  const SizedBox(height: 12),
                  _RadioChoiceCard(
                    title: 'دائمًا فاتح',
                    subtitle: 'مظهر نهاري واضح وساطع طوال اليوم (☀).',
                    icon: Icons.wb_sunny_rounded,
                    isSelected: settings.appearanceMode == 'light',
                    isDark: isDark,
                    onTap: () => notifier.setAppearanceMode('light'),
                  ),
                  const SizedBox(height: 12),
                  _RadioChoiceCard(
                    title: 'دائمًا داكن',
                    subtitle: 'مظهر ليلي مريح للعينين في الإضاءة الخافتة (☾).',
                    icon: Icons.nightlight_round,
                    isSelected: settings.appearanceMode == 'dark',
                    isDark: isDark,
                    onTap: () => notifier.setAppearanceMode('dark'),
                  ),
                  const SizedBox(height: 16),

                  // Live Preview Card (`معاينة المظهر الحالي`)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDark
                              ? 'معاينة · وضع الليل الهادئ ☾'
                              : 'معاينة · وضع النهار المشرق ☀',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '«صباح الخير يا عادل! موعد حبة الضغط الساعة ٢:٠٠ م.»',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  RafiqEmergencyButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EmergencyScreen(),
                        ),
                      );
                    },
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

/// 3. Font & Contrast Screen (`الخط والتباين` `#47:128` Day & `#47:188` Night).
class FontContrastScreen extends StatelessWidget {
  const FontContrastScreen({super.key});

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
            title: 'الخط والتباين',
            subtitle: 'اضبط حجم النص ووضوح الألوان لراحة عينيك',
            onBack: () => Navigator.of(context).maybePop(),
            backLabel: 'رجوع',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Font Size Card (`حجم الخط`)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'حجم الخط',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _SegmentedOptionPill(
                                label: 'كبير جداً',
                                isSelected: settings.fontScale >= 1.25,
                                isDark: isDark,
                                onTap: () => notifier.setFontScale(1.30),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _SegmentedOptionPill(
                                label: 'كبير',
                                isSelected: settings.fontScale >= 1.10 &&
                                    settings.fontScale < 1.25,
                                isDark: isDark,
                                onTap: () => notifier.setFontScale(1.15),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _SegmentedOptionPill(
                                label: 'عادي',
                                isSelected: settings.fontScale < 1.10,
                                isDark: isDark,
                                onTap: () => notifier.setFontScale(1.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Contrast Card (`التباين`)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'التباين',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _SegmentedOptionPill(
                                label: 'عالٍ (أكثر وضوحًا)',
                                isSelected: settings.highContrast,
                                isDark: isDark,
                                onTap: () => notifier.setHighContrast(true),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _SegmentedOptionPill(
                                label: 'عادي',
                                isSelected: !settings.highContrast,
                                isDark: isDark,
                                onTap: () => notifier.setHighContrast(false),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Arabic Preview Card (`معاينة · خط كبير وتباين عادي` `#47:175`)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: settings.highContrast
                            ? primaryColor
                            : borderColor,
                        width: settings.highContrast ? 2.4 : 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'معاينة القراءة المباشرة',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'الدواء القادم: حبة الضغط الساعة ٢:٠٠ م بعد الغداء.',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'اضغط على الزر الأخضر عند تناول الدواء ليطمئنّ أهلك.',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  RafiqEmergencyButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EmergencyScreen(),
                        ),
                      );
                    },
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

/// 4. Voice & Speech Screen (`الصوت والكلام` `#47:327`).
class VoiceSpeechScreen extends StatelessWidget {
  const VoiceSpeechScreen({super.key});

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
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          RafiqSkyHeader(
            title: 'الصوت والكلام',
            subtitle: 'اختر أسلوب صوت المساعد وسرعة التحدث',
            onBack: () => Navigator.of(context).maybePop(),
            backLabel: 'رجوع',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'أسلوب الصوت',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _RadioChoiceCard(
                    title: 'دافئ ولطيف',
                    badgeText: 'موصى به',
                    subtitle: 'هادئ وودود ومطمئن.',
                    icon: Icons.favorite_rounded,
                    isSelected: settings.voicePersona == 'warm',
                    isDark: isDark,
                    onTap: () => notifier.setVoicePersona('warm'),
                  ),
                  const SizedBox(height: 10),
                  _RadioChoiceCard(
                    title: 'واضح ومباشر',
                    subtitle: 'واضح ومختصر وسهل المتابعة.',
                    icon: Icons.graphic_eq_rounded,
                    isSelected: settings.voicePersona == 'clear',
                    isDark: isDark,
                    onTap: () => notifier.setVoicePersona('clear'),
                  ),
                  const SizedBox(height: 10),
                  _RadioChoiceCard(
                    title: 'أسلوب فرد من العائلة',
                    subtitle: 'قريب ودافئ كأنه من العائلة.',
                    icon: Icons.people_alt_rounded,
                    isSelected: settings.voicePersona == 'family',
                    isDark: isDark,
                    onTap: () => notifier.setVoicePersona('family'),
                  ),
                  const SizedBox(height: 16),

                  // Speech Speed (`سرعة الكلام`)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'سرعة الكلام',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _SegmentedOptionPill(
                                label: 'بطيء',
                                isSelected: settings.speechSpeed == 'slow',
                                isDark: isDark,
                                onTap: () => notifier.setSpeechSpeed('slow'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _SegmentedOptionPill(
                                label: 'عادي',
                                isSelected: settings.speechSpeed == 'normal',
                                isDark: isDark,
                                onTap: () => notifier.setSpeechSpeed('normal'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _SegmentedOptionPill(
                                label: 'سريع',
                                isSelected: settings.speechSpeed == 'fast',
                                isDark: isDark,
                                onTap: () => notifier.setSpeechSpeed('fast'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '🔊 عينة صوت (${settings.voicePersonaLabelAr} • سرعة ${settings.speechSpeedLabelAr}): «صباح الخير يا عادل!»',
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryColor,
                              side: BorderSide(color: primaryColor, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(Icons.volume_up_rounded),
                            label: const Text(
                              'استمع لعينة',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  RafiqEmergencyButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EmergencyScreen(),
                        ),
                      );
                    },
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

/// 5. Medicine Alerts Screen (`تنبيهات الدواء` `#47:891`).
class MedicineAlertsScreen extends StatelessWidget {
  const MedicineAlertsScreen({super.key});

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
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          RafiqSkyHeader(
            title: 'تنبيهات الدواء',
            subtitle: 'تحكّم في صوت التنبيه والاهتزاز والنطق الصوتي',
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
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مستوى صوت التنبيه',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _SegmentedOptionPill(
                                label: 'عالٍ',
                                isSelected: settings.pillAlertVolume == 'high',
                                isDark: isDark,
                                onTap: () =>
                                    notifier.setPillAlertVolume('high'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _SegmentedOptionPill(
                                label: 'متوسط',
                                isSelected:
                                    settings.pillAlertVolume == 'medium',
                                isDark: isDark,
                                onTap: () =>
                                    notifier.setPillAlertVolume('medium'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _SegmentedOptionPill(
                                label: 'منخفض',
                                isSelected: settings.pillAlertVolume == 'low',
                                isDark: isDark,
                                onTap: () => notifier.setPillAlertVolume('low'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          value: settings.pillVibration,
                          activeThumbColor: Colors.white,
                          activeTrackColor: primaryColor,
                          onChanged: notifier.setPillVibration,
                          title: Text(
                            'الاهتزاز عند التنبيه',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                        ),
                        Divider(color: borderColor),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          value: settings.pillSpokenReminder,
                          activeThumbColor: Colors.white,
                          activeTrackColor: primaryColor,
                          onChanged: notifier.setPillSpokenReminder,
                          title: Text(
                            'التذكير المنطوق باسم الدواء',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                          subtitle: const Text(
                            'ينطق المساعد اسم الدواء بصوت واضح في موعده',
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    '🔔 اختبار التنبيه: «حان الآن موعد حبة الضغط (٢:٠٠ م)»',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(Icons.notifications_active_rounded),
                            label: const Text(
                              'اختبار التنبيه',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  RafiqEmergencyButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EmergencyScreen(),
                        ),
                      );
                    },
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

class _RadioChoiceCard extends StatelessWidget {
  const _RadioChoiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
    this.badgeText,
  });

  final String title;
  final String? badgeText;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;
    final surfaceColor = isSelected
        ? (isDark
            ? AppColorsDark.primaryContainer
            : AppColors.rafiqPrimaryTint)
        : (isDark ? AppColorsDark.surface : AppColors.surface);
    final borderColor = isSelected
        ? primaryColor
        : (isDark ? AppColorsDark.cardBorder : AppColors.cardBorder);
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$title - $subtitle',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 2.2 : 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor
                        : primaryColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
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
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: textPrimary,
                              ),
                            ),
                          ),
                          if (badgeText != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                badgeText!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: isSelected ? primaryColor : textSecondary,
                  size: 26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SegmentedOptionPill extends StatelessWidget {
  const _SegmentedOptionPill({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 50),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? primaryColor : borderColor,
                width: 1.5,
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
