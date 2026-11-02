import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/rafiq_emergency_bar.dart';
import '../../../../core/widgets/rafiq_sky_header.dart';
import '../../../doctors/data/models/doctor_model.dart';
import '../../../emergency/presentation/screens/emergency_screen.dart';
import '../../providers/voice_assistant_provider.dart';

/// Ask Your Assistant (`اسأل مساعدك`) matching Figma `#2:186` (Day) & `#7:4870` (Night)
/// and Sequence Diagrams 1 & 2, powered by event-driven [VoiceAssistantBloc].
class VoiceAssistantScreen extends StatelessWidget {
  const VoiceAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vaState = context.watch<VoiceAssistantBloc>().state;
    final bloc = context.read<VoiceAssistantBloc>();
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

    final isBusy = vaState.state == VoiceAssistantState.processing ||
        vaState.state == VoiceAssistantState.listening;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          RafiqSkyHeader(
            title: 'اسأل مساعدك',
            subtitle: 'اليوم · ١٠:٣٠ ص',
            onBack: () => Navigator.of(context).maybePop(),
            backLabel: 'الرئيسية',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              children: [
                for (final bubble in vaState.history) ...[
                  _buildBubble(
                    context: context,
                    bubble: bubble,
                    isDark: isDark,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    primaryColor: primaryColor,
                  ),
                  const SizedBox(height: 12),
                ],

                // Thinking / Listening Indicator (`المساعد يفكّر…` `#2:222`)
                if (isBusy)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          vaState.state == VoiceAssistantState.listening
                              ? 'جارٍ الاستماع إليك…'
                              : 'المساعد يفكّر…',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 10),

                // Suggestion Chips (`يمكنك أن تقول:` `#2:229`)
                Text(
                  'يمكنك أن تقول:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _SuggestionChip(
                      label: '«أين أقرب مستشفى؟»',
                      isDark: isDark,
                      onTap: () => bloc.add(
                        const VoiceCommandSubmitted('أين أقرب مستشفى؟'),
                      ),
                    ),
                    _SuggestionChip(
                      label: '«اتصل بابنتي»',
                      isDark: isDark,
                      onTap: () => bloc.add(
                        const VoiceCommandSubmitted('اتصل بابنتي ليلى'),
                      ),
                    ),
                    _SuggestionChip(
                      label: '«أخذت حبة الضغط الآن»',
                      isDark: isDark,
                      onTap: () => bloc.add(
                        const VoiceCommandSubmitted(
                          'نعم، أخذت حبة الضغط الآن مع الفطور.',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Action Bar (`اضغط على الميكروفون للتحدث` + `تحدّث` + `أحتاج مساعدة` `#2:243`)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: surfaceColor,
              border: Border(top: BorderSide(color: borderColor, width: 1.4)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColorsDark.surfaceVariant
                          : const Color(0xFFF5F8FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            vaState.state == VoiceAssistantState.listening
                                ? 'جارٍ الاستماع… اضغط للإرسال'
                                : 'اضغط على الميكروفون للتحدث',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Semantics(
                          button: true,
                          label: 'تحدّث مع المساعد الصوتي',
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (vaState.state ==
                                  VoiceAssistantState.listening) {
                                bloc.add(
                                  const VoiceCommandSubmitted(
                                    'أين أقرب مستشفى للقلب؟',
                                  ),
                                );
                              } else {
                                bloc.add(const VoiceListeningStarted());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(118, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: Icon(
                              vaState.state == VoiceAssistantState.listening
                                  ? Icons.stop_circle_outlined
                                  : Icons.mic_rounded,
                              size: 22,
                            ),
                            label: Text(
                              vaState.state == VoiceAssistantState.listening
                                  ? 'إرسال'
                                  : 'تحدّث',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
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

  Widget _buildBubble({
    required BuildContext context,
    required ChatBubble bubble,
    required bool isDark,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color primaryColor,
  }) {
    switch (bubble.kind) {
      case ChatBubbleKind.assistant:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppLogo(size: 36, height: 44),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Text(
                  bubble.text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        );

      case ChatBubbleKind.user:
        return Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 310),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              bubble.text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.35,
              ),
            ),
          ),
        );

      case ChatBubbleKind.doseLogged:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColorsDark.successLight : AppColors.successLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? AppColorsDark.successBorder
                  : AppColors.successBorder,
              width: 1.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  bubble.badgeTitle ?? '✓ سُجّلت الجرعة',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                bubble.text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        );

      case ChatBubbleKind.familyCall:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? AppColorsDark.primaryContainer
                : AppColors.rafiqPrimaryTint,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primaryColor, width: 1.6),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: primaryColor,
                child: const Icon(
                  Icons.phone_in_talk_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bubble.badgeTitle ?? 'اتصال بالعائلة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      bubble.text,
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
        );

      case ChatBubbleKind.doctors:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final hosp in bubble.doctors) ...[
              _VoiceHospitalMiniCard(
                hospital: hosp,
                isDark: isDark,
              ),
              const SizedBox(height: 8),
            ],
          ],
        );
    }
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final primaryColor = isDark
        ? AppColorsDark.rafiqAccentBlue
        : AppColors.rafiqPrimary;

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VoiceHospitalMiniCard extends StatelessWidget {
  const _VoiceHospitalMiniCard({
    required this.hospital,
    required this.isDark,
  });

  final DoctorModel hospital;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;
    final primaryColor = isDark
        ? AppColorsDark.rafiqAccentBlue
        : AppColors.rafiqPrimary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.4),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.local_hospital_rounded, color: primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hospital.name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                Text(
                  hospital.distanceLabelAr.isNotEmpty
                      ? hospital.distanceLabelAr
                      : '${hospital.distanceKm} كم • ${hospital.estimatedMinutes} دقائق',
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
    );
  }
}
