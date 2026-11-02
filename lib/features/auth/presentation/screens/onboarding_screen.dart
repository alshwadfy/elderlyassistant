import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/rafiq_sky_header.dart';
import '../../../home/presentation/screens/home_shell_screen.dart';

/// Meet Your Assistant Screen (`تعرّف على مساعدك` `#2:3` Day & `#7:4697` Night).
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isPlayingSample = true;

  String _sampleQuoteFor(String persona) {
    return switch (persona) {
      'clear' => '«صباح الخير يا عادل. موعد حبة الضغط الساعة ٢:٠٠ م.»',
      'family' => '«صباح النور يا عم عادل! طمئنّي عليك اليوم، أخذت دواءك؟»',
      _ => '«صباح الخير يا عادل!»',
    };
  }

  String _ctaTextFor(String persona) {
    return switch (persona) {
      'clear' => 'تابع بالأسلوب الواضح والمباشر',
      'family' => 'تابع بأسلوب فرد من العائلة',
      _ => 'تابع بالأسلوب الدافئ واللطيف',
    };
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsCubit>().state;
    final notifier = context.read<AppSettingsCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColorsDark.background : AppColors.background;
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;
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
            title: 'تعرّف على مساعدك',
            subtitle: 'اختر صوتًا مريحًا لك.',
            onBack: () => Navigator.of(context).maybePop(),
            backLabel: 'رجوع',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Voice Option 1: `دافئ ولطيف` (`موصى به`)
                  _VoicePersonaCard(
                    title: 'دافئ ولطيف',
                    badgeText: 'موصى به',
                    description: 'هادئ وودود ومطمئن.',
                    icon: Icons.favorite_rounded,
                    isSelected: settings.voicePersona == 'warm',
                    isDark: isDark,
                    onSelect: () {
                      notifier.setVoicePersona('warm');
                      setState(() => _isPlayingSample = true);
                    },
                    onPlaySample: () {
                      notifier.setVoicePersona('warm');
                      setState(() => _isPlayingSample = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            '🔊 يعمل الآن (دافئ ولطيف): «صباح الخير يا عادل!»',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Voice Option 2: `واضح ومباشر`
                  _VoicePersonaCard(
                    title: 'واضح ومباشر',
                    description: 'واضح ومختصر وسهل المتابعة.',
                    icon: Icons.graphic_eq_rounded,
                    isSelected: settings.voicePersona == 'clear',
                    isDark: isDark,
                    onSelect: () {
                      notifier.setVoicePersona('clear');
                      setState(() => _isPlayingSample = true);
                    },
                    onPlaySample: () {
                      notifier.setVoicePersona('clear');
                      setState(() => _isPlayingSample = true);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Voice Option 3: `أسلوب فرد من العائلة`
                  _VoicePersonaCard(
                    title: 'أسلوب فرد من العائلة',
                    description: 'قريب ودافئ كأنه من العائلة.',
                    icon: Icons.people_alt_rounded,
                    isSelected: settings.voicePersona == 'family',
                    isDark: isDark,
                    onSelect: () {
                      notifier.setVoicePersona('family');
                      setState(() => _isPlayingSample = true);
                    },
                    onPlaySample: () {
                      notifier.setVoicePersona('family');
                      setState(() => _isPlayingSample = true);
                    },
                  ),
                  const SizedBox(height: 14),

                  // Active Voice Sample Bar (`يعمل الآن: دافئ ولطيف` `#2:78`)
                  if (_isPlayingSample)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.45),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.14),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.volume_up_rounded,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'يعمل الآن: ${settings.voicePersonaLabelAr}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _sampleQuoteFor(settings.voicePersona),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 18),

                  // Primary CTA (`تابع بالأسلوب الدافئ واللطيف` `#2:93`)
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const HomeShellScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        _ctaTextFor(settings.voicePersona),
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'يمكنك تغيير أسلوب الصوت وسرعته في أي وقت من الإعدادات.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
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

class _VoicePersonaCard extends StatelessWidget {
  const _VoicePersonaCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onSelect,
    required this.onPlaySample,
    this.badgeText,
  });

  final String title;
  final String? badgeText;
  final String description;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onSelect;
  final VoidCallback onPlaySample;

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
        ? (isDark ? AppColorsDark.rafiqAccentBlue : AppColors.rafiqPrimary)
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
      label: '$title - $description',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onSelect,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 2.2 : 1.4,
              ),
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
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                              if (badgeText != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    badgeText!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? primaryColor : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? primaryColor : borderColor,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              size: 18,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ],
                ),
                if (isSelected) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: OutlinedButton.icon(
                      onPressed: onPlaySample,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: BorderSide(color: primaryColor, width: 1.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded, size: 22),
                      label: const Text(
                        'استمع لعيّنة',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
