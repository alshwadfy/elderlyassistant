import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/accessible_button.dart';
import '../../providers/voice_assistant_provider.dart';

class VoiceAssistantScreen extends ConsumerStatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  ConsumerState<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends ConsumerState<VoiceAssistantScreen> {
  final ScrollController _scrollController = ScrollController();

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

    // Auto-scroll when history changes
    ref.listen(voiceAssistantProvider, (previous, next) {
      if (previous?.history.length != next.history.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'المساعد الصوتي / Voice Conversation',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status bar banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: stateData.state == VoiceAssistantState.listening
                  ? AppColors.emergencyContainer
                  : AppColors.primaryContainer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStateIndicatorIcon(stateData.state),
                  const SizedBox(width: 12),
                  Text(
                    _getStateText(stateData.state),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Conversation History (Chat Bubbles)
            Expanded(
              child: stateData.history.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.record_voice_over,
                            size: 72,
                            color: AppColors.primary.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'اضغط على زر الميكروفون وابدأ الحديث 🗣️\nTap the microphone and start speaking',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: stateData.history.length,
                      itemBuilder: (context, index) {
                        final item = stateData.history[index];
                        return Column(
                          children: [
                            // User Spoken Bubble (Right aligned)
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                maxConstraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                                ),
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  item.userSpeech,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: AppColors.textLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            // AI Assistant Response Bubble (Left aligned)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                maxConstraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                                ),
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryContainer,
                                  border: Border.all(color: AppColors.secondary, width: 1.5),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.smart_toy_outlined, color: AppColors.secondary, size: 22),
                                        SizedBox(width: 8),
                                        Text(
                                          'المساعد الصوتي / Assistant',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.responseText,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),

            // Quick Voice Suggestion Chips
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildVoiceChip(
                      label: '💊 تذكير بالدواء',
                      onTap: () => notifier.stopListeningAndProcess('ذكرني بموعد دواء الضغط الساعة 8 مساء'),
                    ),
                    const SizedBox(width: 8),
                    _buildVoiceChip(
                      label: '🩺 حجز طبيب',
                      onTap: () => notifier.stopListeningAndProcess('أريد حجز موعد مع طبيب القلب'),
                    ),
                    const SizedBox(width: 8),
                    _buildVoiceChip(
                      label: '🚨 طلب مساعدة',
                      onTap: () => notifier.stopListeningAndProcess('أتصل بالطوارئ أنا لا أشعر بخير'),
                    ),
                  ],
                ),
              ),
            ),

            // Microphone Big Control Bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    label: 'الميكروفون الرئيسي - اضغط للتحدث / Main Microphone',
                    button: true,
                    child: GestureDetector(
                      onTap: () {
                        if (stateData.state == VoiceAssistantState.idle) {
                          notifier.startListening();
                        } else if (stateData.state == VoiceAssistantState.listening) {
                          notifier.stopListeningAndProcess('ذكرني بالدواء الساعة 8 مساء');
                        }
                      },
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: stateData.state == VoiceAssistantState.listening
                              ? AppColors.emergency
                              : AppColors.primary,
                          boxShadow: [
                            BoxShadow(
                              color: (stateData.state == VoiceAssistantState.listening
                                      ? AppColors.emergency
                                      : AppColors.primary)
                                  .withValues(alpha: 0.4),
                              blurRadius: 16,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          stateData.state == VoiceAssistantState.listening
                              ? Icons.mic
                              : Icons.mic_none,
                          size: 48,
                          color: AppColors.textLight,
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
    );
  }

  Widget _buildVoiceChip({required String label, required VoidCallback onTap}) {
    return ActionChip(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      backgroundColor: AppColors.primaryContainer,
      side: const BorderSide(color: AppColors.primary, width: 1),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      onPressed: onTap,
    );
  }

  Widget _buildStateIndicatorIcon(VoiceAssistantState state) {
    switch (state) {
      case VoiceAssistantState.idle:
        return const Icon(Icons.mic, color: AppColors.primary);
      case VoiceAssistantState.listening:
        return const Icon(Icons.graphic_eq, color: AppColors.emergency);
      case VoiceAssistantState.processing:
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
        );
      case VoiceAssistantState.speaking:
        return const Icon(Icons.volume_up, color: AppColors.secondary);
    }
  }

  String _getStateText(VoiceAssistantState state) {
    switch (state) {
      case VoiceAssistantState.idle:
        return 'جاهز للاستماع / Ready to listen';
      case VoiceAssistantState.listening:
        return 'أنا أسمعك الآن... / Listening...';
      case VoiceAssistantState.processing:
        return 'جاري الفهم والإجابة... / Processing...';
      case VoiceAssistantState.speaking:
        return 'جاري الرد بصوت واضح... / Speaking...';
    }
  }
}
