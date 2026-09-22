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

class _VoiceAssistantScreenState extends ConsumerState<VoiceAssistantScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
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
    final stateData = ref.watch(voiceAssistantProvider);
    final notifier = ref.read(voiceAssistantProvider.notifier);

    ref.listen(voiceAssistantProvider, (previous, next) {
      if (previous?.history.length != next.history.length) {
        _scrollToBottom();
      }
    });

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                    maxWidth: MediaQuery.sizeOf(context).width * 0.8,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.primary
                          : AppColors.primaryContainer,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isUser ? 20 : 6),
                        bottomRight: Radius.circular(isUser ? 6 : 20),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isUser) ...[
                          const Icon(
                            Icons.smart_toy_outlined,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            item.text,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isUser
                                  ? AppColors.textLight
                                  : AppColors.textPrimary,
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
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
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
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: stateData.state == VoiceAssistantState.listening
                          ? AppColors.emergency
                          : AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      stateData.state == VoiceAssistantState.listening
                          ? Icons.mic
                          : Icons.mic_none,
                      size: 40,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _statusLabel(stateData.state),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
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

class _VoiceDoctorCard extends ConsumerWidget {
  const _VoiceDoctorCard({required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryContainer,
                  child: Icon(Icons.person, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        doctor.type,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      Text(
                        '${doctor.distanceKm} km • ${doctor.estimatedMinutes} min',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textMuted),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
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
                child: const Text('Book Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
