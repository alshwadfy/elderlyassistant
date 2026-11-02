import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/rafiq_sky_header.dart';
import '../../providers/emergency_provider.dart';
import '../../providers/family_provider.dart';

/// Emergency Help (`مساعدة الطوارئ` `#2:562`) & Help Is Coming (`المساعدة في الطريق` `#2:597`)
/// matching Sequence Diagram 3 (15-second cancelable countdown + sequential family escalation).
///
/// The 1-second timer and race-condition-free cancellation are encapsulated inside [EmergencyBloc].
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<EmergencyBloc>().add(const EmergencySessionStarted());
      }
    });
  }

  String _toArabicDigits(int value) {
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var out = value.toString();
    for (var i = 0; i < western.length; i++) {
      out = out.replaceAll(western[i], eastern[i]);
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final emg = context.watch<EmergencyBloc>().state;
    final bloc = context.read<EmergencyBloc>();
    final contacts = context.watch<FamilyCubit>().state;
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

    final secsAr = _toArabicDigits(emg.countdownSeconds);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          RafiqSkyHeader(
            isEmergency: true,
            title: emg.isDispatched ? 'المساعدة في الطريق' : 'مساعدة الطوارئ',
            subtitle: emg.isDispatched
                ? 'ابقَ مكانك · موقعك مُشارَك مع عائلتك'
                : 'مساعدة فورية · تنبيه العائلة',
            onBack: () {
              bloc.add(const EmergencyCancelled());
              Navigator.of(context).maybePop();
            },
            backLabel: 'رجوع',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: !emg.isDispatched
                  ? _buildCountdownView(
                      context: context,
                      emg: emg,
                      bloc: bloc,
                      secsAr: secsAr,
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      primaryColor: primaryColor,
                    )
                  : _buildHelpIsComingView(
                      context: context,
                      emg: emg,
                      bloc: bloc,
                      contacts: contacts,
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      primaryColor: primaryColor,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// Phase 1: `مساعدة الطوارئ` (`#2:562`)
  Widget _buildCountdownView({
    required BuildContext context,
    required EmergencyState emg,
    required EmergencyBloc bloc,
    required String secsAr,
    required bool isDark,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color primaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 15-Second Countdown Card (`الاتصال خلال ١٥ ثانية…` `#2:571`)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? AppColorsDark.emergencyContainer
                : AppColors.emergencyContainer,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.emergencyRed,
              width: 2.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.emergencyRed,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$secsArث',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الاتصال خلال $secsAr ثانية…',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'سيتم الاتصال بعائلتك بالترتيب وإرسال موقعك تلقائيًا.',
                      style: TextStyle(
                        fontSize: 15,
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
        const SizedBox(height: 14),

        // Shared Location Card (`تمت مشاركة موقعك` `#2:579`)
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تمت مشاركة موقعك',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      emg.sharedAddress,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
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

        // Primary Red CTA: `اتصل بالطوارئ (١٢٣)` (`#2:586`)
        SizedBox(
          height: 60,
          child: ElevatedButton.icon(
            onPressed: () {
              bloc.add(const EmergencyDispatchedImmediately());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emergencyRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.emergency_rounded, size: 24),
            label: const Text(
              'اتصل بالطوارئ (١٢٣)',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Secondary Call Family CTA: `اتصل بالعائلة (ليلى – الابنة)` (`#2:591`)
        SizedBox(
          height: 58,
          child: ElevatedButton.icon(
            onPressed: () {
              bloc.add(const EmergencyDispatchedImmediately());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.phone_in_talk_rounded, size: 22),
            label: const Text(
              'اتصل بالعائلة (ليلى – الابنة)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Cancel CTA: `أنا بخير الآن. إلغاء` (`#2:594`)
        SizedBox(
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              bloc.add(const EmergencyCancelled());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إلغاء تنبيه الطوارئ. الحمد لله على سلامتك.'),
                ),
              );
              Navigator.of(context).maybePop();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: textPrimary,
              backgroundColor: surfaceColor,
              side: BorderSide(color: borderColor, width: 1.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'أنا بخير الآن. إلغاء',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }

  /// Phase 2: `المساعدة في الطريق` (`#2:597`) — Sequential Family Priority Escalation
  Widget _buildHelpIsComingView({
    required BuildContext context,
    required EmergencyState emg,
    required EmergencyBloc bloc,
    required List contacts,
    required bool isDark,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color primaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sequential Priority Escalation Card (`نتصل بعائلتك بالترتيب` `#2:607`)
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor, width: 1.6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'نتصل بعائلتك بالترتيب',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => bloc.add(
                      EmergencyContactEscalated(contacts.length),
                    ),
                    icon: const Icon(Icons.skip_next_rounded, size: 18),
                    label: const Text('التالي'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              for (var i = 0; i < contacts.length; i++) ...[
                _EscalationContactRow(
                  priorityArabic: _toArabicDigits(i + 1),
                  name: contacts[i].name,
                  relation: contacts[i].relation,
                  statusText: emg.statusLabelAr(i),
                  status: emg.statusForIndex(i),
                  isDark: isDark,
                  onTap: () => bloc.add(
                    EmergencyContactConnected(
                      contactName: contacts[i].name,
                      index: i,
                    ),
                  ),
                ),
                if (i < contacts.length - 1) const SizedBox(height: 10),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Shared Location Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.my_location_rounded,
                color: AppColors.success,
                size: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'موقعك المباشر مُشارَك مع عائلتك',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.success,
                      ),
                    ),
                    Text(
                      emg.sharedAddress,
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

        // Cancel CTA (`أنا بخير الآن · إلغاء` `#2:635`)
        SizedBox(
          height: 58,
          child: OutlinedButton(
            onPressed: () {
              bloc.add(const EmergencyCancelled());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إلغاء التنبيه وإبلاغ عائلتك أنك بخير الآن.'),
                ),
              );
              Navigator.of(context).maybePop();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: textPrimary,
              backgroundColor: surfaceColor,
              side: BorderSide(color: borderColor, width: 1.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'أنا بخير الآن · إلغاء',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

class _EscalationContactRow extends StatelessWidget {
  const _EscalationContactRow({
    required this.priorityArabic,
    required this.name,
    required this.relation,
    required this.statusText,
    required this.status,
    required this.isDark,
    required this.onTap,
  });

  final String priorityArabic;
  final String name;
  final String relation;
  final String statusText;
  final ContactCallStatus status;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isCalling = status == ContactCallStatus.calling;
    final isConnected = status == ContactCallStatus.connected;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;

    final Color cardBg;
    final Color cardBorder;
    final Color chipBg;
    final Color chipFg;

    if (isConnected) {
      cardBg = isDark ? AppColorsDark.successLight : AppColors.successLight;
      cardBorder = AppColors.success;
      chipBg = AppColors.success;
      chipFg = Colors.white;
    } else if (isCalling) {
      cardBg = isDark
          ? AppColorsDark.primaryContainer
          : AppColors.rafiqPrimaryTint;
      cardBorder = primaryColor;
      chipBg = primaryColor;
      chipFg = Colors.white;
    } else {
      cardBg = isDark ? AppColorsDark.surfaceVariant : const Color(0xFFF8FAFF);
      cardBorder = borderColor;
      chipBg = isDark ? AppColorsDark.surface : Colors.white;
      chipFg = textSecondary;
    }

    return Semantics(
      button: true,
      label: 'الأولوية $priorityArabic $name $relation - $statusText',
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: cardBorder,
              width: (isCalling || isConnected) ? 2.0 : 1.4,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: (isCalling || isConnected) ? chipBg : borderColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  priorityArabic,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: (isCalling || isConnected)
                        ? Colors.white
                        : textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      relation,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: cardBorder),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: chipFg,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
