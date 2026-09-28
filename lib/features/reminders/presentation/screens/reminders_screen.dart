import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/demo_snackbar.dart';
import '../../data/models/reminder_model.dart';
import '../../providers/reminders_provider.dart';
import '../widgets/reminder_card.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  String _selectedPeriodFilter = 'all'; // 'all', 'morning', 'afternoon', 'evening', 'night'

  Future<void> _showAddEditReminderDialog({
    required BuildContext context,
    required WidgetRef ref,
    ReminderModel? existing,
  }) async {
    final l10n = AppLocalizations.of(context);
    final titleController = TextEditingController(text: existing?.title ?? '');
    final dosageController = TextEditingController(text: existing?.dosage ?? '1 Tablet');
    final instructionsController = TextEditingController(
      text: existing?.instructions ?? 'Take after meal with water',
    );

    int selectedDuration = existing?.durationDays ?? 14;
    TimeOfDay selectedTime = existing != null
        ? TimeOfDay.fromDateTime(existing.scheduledTime)
        : const TimeOfDay(hour: 8, minute: 0);

    final isEdit = existing != null;

    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.medication, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEdit ? l10n.editReminder : l10n.addNewReminder,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Medication Name
                    Text(
                      l10n.reminderTitleLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: titleController,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'e.g. Blood Pressure Medicine',
                        prefixIcon: const Icon(Icons.medication_liquid),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. Dosage
                    Text(
                      l10n.dosageLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: dosageController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'e.g. 1 Tablet (500mg)',
                        prefixIcon: Icon(Icons.vaccines),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. Instructions
                    Text(
                      l10n.instructionsLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: instructionsController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Take after breakfast',
                        prefixIcon: Icon(Icons.info_outline),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 4. Time Picker Presets & Custom
                    Text(
                      l10n.scheduledTime,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.access_time_filled, color: AppColors.primary, size: 24),
                                const SizedBox(width: 12),
                                Text(
                                  selectedTime.format(context),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const Text('Change', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 5. Treatment Duration (Days)
                    Text(
                      l10n.durationLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [7, 14, 30, 60].map((days) {
                        final isSelected = selectedDuration == days;
                        return ChoiceChip(
                          label: Text(
                            '$days Days',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : null,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          onSelected: (val) {
                            if (val) {
                              setDialogState(() {
                                selectedDuration = days;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                        ),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(dialogContext, true),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          backgroundColor: AppColors.primary,
                        ),
                        child: Text(l10n.save),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    if (saved == true && titleController.text.trim().isNotEmpty) {
      final now = DateTime.now();
      final scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      if (isEdit) {
        ref.read(remindersProvider.notifier).updateReminder(
              existing.copyWith(
                title: titleController.text.trim(),
                dosage: dosageController.text.trim(),
                instructions: instructionsController.text.trim(),
                scheduledTime: scheduledDate,
                durationDays: selectedDuration,
              ),
            );
        if (context.mounted) {
          showDemoSnackBar(context, 'Reminder updated');
        }
      } else {
        ref.read(remindersProvider.notifier).addReminder(
              ReminderModel(
                reminderId: 'rem_${DateTime.now().millisecondsSinceEpoch}',
                userId: 'user_01',
                type: 'medication',
                title: titleController.text.trim(),
                scheduledTime: scheduledDate,
                repeatPattern: 'Daily',
                status: 'pending',
                dosage: dosageController.text.trim(),
                instructions: instructionsController.text.trim(),
                durationDays: selectedDuration,
                startDate: DateTime.now(),
              ),
            );
        if (context.mounted) {
          showDemoSnackBar(context, 'New reminder added');
        }
      }
    }
  }

  Future<void> _deleteReminder(
      BuildContext context, WidgetRef ref, ReminderModel reminder) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteReminder),
          content: Text(l10n.confirmDelete(reminder.title)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: AppColors.emergency),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      ref.read(remindersProvider.notifier).deleteReminder(reminder.reminderId);
      if (context.mounted) {
        showDemoSnackBar(context, 'Reminder deleted');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final reminders = ref.watch(remindersProvider);

    final completedCount = reminders.where((r) => r.status == 'completed').length;
    final pendingCount = reminders.where((r) => r.status == 'pending').length;

    final filteredReminders = reminders.where((r) {
      if (_selectedPeriodFilter == 'all') return true;
      final hour = r.scheduledTime.hour;
      if (_selectedPeriodFilter == 'morning') return hour >= 5 && hour < 12;
      if (_selectedPeriodFilter == 'afternoon') return hour >= 12 && hour < 17;
      if (_selectedPeriodFilter == 'evening') return hour >= 17 && hour < 21;
      if (_selectedPeriodFilter == 'night') return hour >= 21 || hour < 5;
      return true;
    }).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Screen Header ───
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 28),
                tooltip: 'Back',
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              const SizedBox(width: 8),
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.medication, color: AppColors.textLight, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.medicationReminders,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.neverMissMed,
                      style: TextStyle(
                        fontSize: 15,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ─── Summary Card Header ───
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B5BDB), Color(0xFF4C6EF5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.remindersScheduled(reminders.length),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Completed: $completedCount • Pending: $pendingCount',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.event_available,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ─── Time Period Filter Chips ───
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChipItem(
                  label: l10n.allReminders,
                  icon: Icons.apps,
                  isSelected: _selectedPeriodFilter == 'all',
                  onTap: () => setState(() => _selectedPeriodFilter = 'all'),
                ),
                const SizedBox(width: 8),
                _FilterChipItem(
                  label: '${l10n.morning} 🌅',
                  icon: Icons.wb_sunny_outlined,
                  isSelected: _selectedPeriodFilter == 'morning',
                  onTap: () => setState(() => _selectedPeriodFilter = 'morning'),
                ),
                const SizedBox(width: 8),
                _FilterChipItem(
                  label: '${l10n.afternoon} ☀️',
                  icon: Icons.wb_sunny,
                  isSelected: _selectedPeriodFilter == 'afternoon',
                  onTap: () => setState(() => _selectedPeriodFilter = 'afternoon'),
                ),
                const SizedBox(width: 8),
                _FilterChipItem(
                  label: '${l10n.evening} 🌆',
                  icon: Icons.wb_twilight,
                  isSelected: _selectedPeriodFilter == 'evening',
                  onTap: () => setState(() => _selectedPeriodFilter = 'evening'),
                ),
                const SizedBox(width: 8),
                _FilterChipItem(
                  label: '${l10n.night} 🌙',
                  icon: Icons.nightlight_round,
                  isSelected: _selectedPeriodFilter == 'night',
                  onTap: () => setState(() => _selectedPeriodFilter = 'night'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ─── List of Medication Cards ───
          Expanded(
            child: filteredReminders.isEmpty
                ? Center(
                    child: Text(
                      'No reminders found for this period.',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredReminders.length,
                    itemBuilder: (context, index) {
                      final reminder = filteredReminders[index];
                      return ReminderCard(
                        reminder: reminder,
                        accent: AppColors.primary,
                        onToggle: () {
                          ref
                              .read(remindersProvider.notifier)
                              .toggleStatus(reminder.reminderId);
                        },
                        onSkip: () {
                          ref
                              .read(remindersProvider.notifier)
                              .setStatus(reminder.reminderId, 'skipped');
                        },
                        onEdit: () => _showAddEditReminderDialog(
                          context: context,
                          ref: ref,
                          existing: reminder,
                        ),
                        onDelete: () => _deleteReminder(context, ref, reminder),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 12),

          // ─── Bottom Add Reminder Button (Min 56px height) ───
          ElevatedButton.icon(
            onPressed: () => _showAddEditReminderDialog(context: context, ref: ref),
            icon: const Icon(Icons.add_circle_outline, size: 26),
            label: Text(
              l10n.addNewReminder,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  const _FilterChipItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChoiceChip(
      showCheckmark: false,
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? Colors.white : theme.colorScheme.primary,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : theme.colorScheme.onSurface,
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      onSelected: (val) => onTap(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
