import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/demo_snackbar.dart';
import '../../../doctors/data/models/appointment_model.dart';
import '../../../doctors/data/models/doctor_model.dart';
import '../../../doctors/providers/appointments_provider.dart';
import '../../providers/voice_assistant_provider.dart';

class VoiceAssistantScreen extends ConsumerStatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  ConsumerState<VoiceAssistantScreen> createState() =>
      _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends ConsumerState<VoiceAssistantScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final stateData = ref.watch(voiceAssistantProvider);
    final notifier = ref.read(voiceAssistantProvider.notifier);

    ref.listen(voiceAssistantProvider, (previous, next) {
      if (previous?.history.length != next.history.length) {
        _scrollToBottom();
      }
    });

    final isListening = stateData.state == VoiceAssistantState.listening;
    final isSpeaking = stateData.state == VoiceAssistantState.speaking;
    final isProcessing = stateData.state == VoiceAssistantState.processing;

    return Column(
      children: [
        // ─── Header ───
        Container(
          padding: const EdgeInsets.fromLTRB(8, 6, 16, 10),
          decoration: BoxDecoration(
            color: isDark ? AppColorsDark.surface : AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 28),
                tooltip: 'Back',
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.smart_toy_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Voice Companion',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isListening || isSpeaking
                                ? AppColors.warning
                                : AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _statusLabel(stateData.state),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColorsDark.textMuted : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ─── Conversation History ───
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            itemCount: stateData.history.length,
            itemBuilder: (context, index) {
              final item = stateData.history[index];
              if (item.kind == ChatBubbleKind.doctors) {
                return Column(
                  children: item.doctors
                      .map((doctor) => _VoiceDoctorCard(doctor: doctor))
                      .toList(),
                );
              }
              final isUser = item.kind == ChatBubbleKind.user;
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.82,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: isUser
                          ? const LinearGradient(
                              colors: [Color(0xFF4C6EF5), Color(0xFF3B5BDB)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isUser
                          ? null
                          : (isDark
                              ? AppColorsDark.primaryContainer
                              : AppColors.primaryContainer),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(22),
                        topRight: const Radius.circular(22),
                        bottomLeft: Radius.circular(isUser ? 22 : 6),
                        bottomRight: Radius.circular(isUser ? 6 : 22),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isUser
                              ? AppColors.primary.withValues(alpha: 0.25)
                              : Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isUser) ...[
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.smart_toy_rounded,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Flexible(
                          child: Text(
                            item.text,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isUser
                                  ? AppColors.textLight
                                  : (isDark
                                      ? AppColorsDark.textPrimary
                                      : AppColors.textPrimary),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // ─── Voice Action Control Orb ───
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: isDark ? AppColorsDark.surface : AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
                blurRadius: 20,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Quick Prompt Suggestion Pill Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _VoicePromptChip(
                      label: '💊 Take medications',
                      onTap: () {
                        notifier.startListening();
                        notifier.stopListeningAndProcess('Did I take my medications today?');
                      },
                    ),
                    const SizedBox(width: 8),
                    _VoicePromptChip(
                      label: '🩺 Find a doctor nearby',
                      onTap: () {
                        notifier.startListening();
                        notifier.stopListeningAndProcess('Find me a doctor nearby');
                      },
                    ),
                    const SizedBox(width: 8),
                    _VoicePromptChip(
                      label: '📞 Call Daughter',
                      onTap: () {
                        notifier.startListening();
                        notifier.stopListeningAndProcess('Call my daughter Sarah');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Animated Pulsing Mic Button
              Semantics(
                label: 'Main microphone. Tap to speak.',
                button: true,
                child: GestureDetector(
                  onTap: () {
                    if (stateData.state == VoiceAssistantState.idle) {
                      notifier.startListening();
                    } else if (stateData.state == VoiceAssistantState.listening) {
                      notifier.stopListeningAndProcess(
                        'Find me a doctor nearby',
                      );
                    }
                  },
                  child: AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      final pulseScale = isListening ? (1.0 + _waveController.value * 0.12) : 1.0;
                      return Transform.scale(
                        scale: pulseScale,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: isListening
                              ? [const Color(0xFFFF6B6B), const Color(0xFFE53E3E)]
                              : (isSpeaking
                                  ? [const Color(0xFF38A169), const Color(0xFF2F855A)]
                                  : [const Color(0xFF4C6EF5), const Color(0xFF3B5BDB)]),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isListening
                                    ? AppColors.emergency
                                    : (isSpeaking ? AppColors.success : AppColors.primary))
                                .withValues(alpha: 0.4),
                            blurRadius: 24,
                            spreadRadius: 4,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        isListening
                            ? Icons.mic_rounded
                            : (isProcessing
                                ? Icons.sync_rounded
                                : Icons.mic_none_rounded),
                        size: 44,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                _statusLabel(stateData.state),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isListening
                      ? AppColors.emergency
                      : (isDark ? AppColorsDark.textPrimary : AppColors.textPrimary),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ],
    );
  }

  String _statusLabel(VoiceAssistantState state) {
    return switch (state) {
      VoiceAssistantState.idle => 'Tap to speak',
      VoiceAssistantState.listening => 'Listening...',
      VoiceAssistantState.processing => 'Processing...',
      VoiceAssistantState.speaking => 'Speaking...',
    };
  }
}

class _VoicePromptChip extends StatelessWidget {
  const _VoicePromptChip({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ActionChip(
      onPressed: onTap,
      backgroundColor: isDark ? AppColorsDark.surface : AppColors.primaryContainer,
      elevation: 0,
      side: BorderSide(
        color: AppColors.primary.withValues(alpha: 0.2),
      ),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _VoiceDoctorCard extends ConsumerWidget {
  const _VoiceDoctorCard({required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        doctor.type,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            '${doctor.distanceKm} km • ${doctor.estimatedMinutes} min away',
                            style: TextStyle(
                              color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                      SizedBox(width: 2),
                      Text(
                        '4.9',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  ref.read(appointmentsProvider.notifier).addAppointment(
                        AppointmentModel(
                          appointmentId:
                              'app_${DateTime.now().millisecondsSinceEpoch}',
                          doctorId: doctor.providerId,
                          doctorName: doctor.name,
                          doctorType: doctor.type,
                          dateTime: DateTime.now().add(const Duration(days: 3)),
                          status: 'Upcoming',
                        ),
                      );
                  showDemoSnackBar(
                    context,
                    'Appointment booked with ${doctor.name} (demo)',
                  );
                },
                icon: const Icon(Icons.calendar_month_rounded, size: 20),
                label: const Text(
                  'Book Appointment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

