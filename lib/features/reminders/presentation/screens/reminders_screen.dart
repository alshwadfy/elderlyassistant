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
    required bool isDark,
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
    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final primaryContainer = isDark ? AppColorsDark.primaryContainer : AppColors.primaryContainer;
    final surface = isDark ? AppColorsDark.surface : AppColors.surface;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;

    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.medication, color: primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEdit ? l10n.editReminder : l10n.addNewReminder,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.reminderTitleLabel,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimary),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: titleController,
                      style: TextStyle(fontSize: 18, color: textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Blood Pressure Medicine',
                        prefixIcon: Icon(Icons.medication_liquid),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      l10n.dosageLabel,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimary),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: dosageController,
                      style: TextStyle(fontSize: 16, color: textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'e.g. 1 Tablet (500mg)',
                        prefixIcon: Icon(Icons.vaccines),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      l10n.instructionsLabel,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimary),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: instructionsController,
                      style: TextStyle(fontSize: 16, color: textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Take after breakfast',
                        prefixIcon: Icon(Icons.info_outline),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      l10n.scheduledTime,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimary),
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
                          color: primaryContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.access_time_filled, color: primaryColor, size: 24),
                                const SizedBox(width: 12),
                                Text(
                                  selectedTime.format(context),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            Text('Change', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      l10n.durationLabel,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimary),
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
                          selectedColor: primaryColor,
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
                          foregroundColor: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
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
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
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
      BuildContext context, WidgetRef ref, ReminderModel reminder, bool isDark) async {
    final l10n = AppLocalizations.of(context);
    final emergencyColor = isDark ? AppColorsDark.emergency : AppColors.emergency;
    final surface = isDark ? AppColorsDark.surface : AppColors.surface;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: surface,
          title: Text(l10n.deleteReminder, style: TextStyle(color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary)),
          content: Text(l10n.confirmDelete(reminder.title), style: TextStyle(color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: emergencyColor),
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
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;

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

    return Column(
      children: [
        // ─── Static Screen Header ───
        Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
          decoration: BoxDecoration(
            color: isDark ? AppColorsDark.surface : AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                blurRadius: 8,
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
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.medication_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.medicationReminders,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      l10n.neverMissMed,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ─── Scrollable Body ───
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              // ─── Summary Card Header ───
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColorsDark.surface : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColorsDark.border : AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryStatItem(
                      label: 'Total',
                      count: reminders.length,
                      color: primaryColor,
                      isDark: isDark,
                    ),
                    Container(
                      height: 32,
                      width: 1,
                      color: isDark ? AppColorsDark.border : AppColors.border,
                    ),
                    _SummaryStatItem(
                      label: 'Completed',
                      count: completedCount,
                      color: isDark ? AppColorsDark.success : AppColors.success,
                      isDark: isDark,
                    ),
                    Container(
                      height: 32,
                      width: 1,
                      color: isDark ? AppColorsDark.border : AppColors.border,
                    ),
                    _SummaryStatItem(
                      label: 'Pending',
                      count: pendingCount,
                      color: isDark ? AppColorsDark.warning : AppColors.warning,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ─── Time Period Filter Chips ───
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _FilterChipItem(
                      label: l10n.allReminders,
                      icon: Icons.apps_rounded,
                      isSelected: _selectedPeriodFilter == 'all',
                      isDark: isDark,
                      onTap: () => setState(() => _selectedPeriodFilter = 'all'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChipItem(
                      label: '${l10n.morning} 🌅',
                      icon: Icons.wb_sunny_outlined,
                      isSelected: _selectedPeriodFilter == 'morning',
                      isDark: isDark,
                      onTap: () => setState(() => _selectedPeriodFilter = 'morning'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChipItem(
                      label: '${l10n.afternoon} ☀️',
                      icon: Icons.wb_sunny_rounded,
                      isSelected: _selectedPeriodFilter == 'afternoon',
                      isDark: isDark,
                      onTap: () => setState(() => _selectedPeriodFilter = 'afternoon'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChipItem(
                      label: '${l10n.evening} 🌆',
                      icon: Icons.wb_twilight_rounded,
                      isSelected: _selectedPeriodFilter == 'evening',
                      isDark: isDark,
                      onTap: () => setState(() => _selectedPeriodFilter = 'evening'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChipItem(
                      label: '${l10n.night} 🌙',
                      icon: Icons.nightlight_round,
                      isSelected: _selectedPeriodFilter == 'night',
                      isDark: isDark,
                      onTap: () => setState(() => _selectedPeriodFilter = 'night'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ─── List of Medication Cards ───
              if (filteredReminders.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: Center(
                    child: Text(
                      'No reminders found for this period.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                  ),
                )
              else
                for (final reminder in filteredReminders)
                  ReminderCard(
                    reminder: reminder,
                    accent: primaryColor,
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
                      isDark: isDark,
                    ),
                    onDelete: () => _deleteReminder(context, ref, reminder, isDark),
                  ),

              const SizedBox(height: 12),

              // ─── Add Reminder Button ───
              ElevatedButton.icon(
                onPressed: () => _showAddEditReminderDialog(context: context, ref: ref, isDark: isDark),
                icon: const Icon(Icons.add_circle_outline_rounded, size: 24),
                label: Text(
                  l10n.addNewReminder,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  const _FilterChipItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final unselectedBg = isDark ? AppColorsDark.surface : const Color(0xFFE9ECFF);
    final unselectedText = isDark ? AppColorsDark.textSecondary : AppColors.textPrimary;

    return ChoiceChip(
      showCheckmark: false,
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? Colors.white : primaryColor,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : unselectedText,
        ),
      ),
      selected: isSelected,
      selectedColor: primaryColor,
      backgroundColor: unselectedBg,
      onSelected: (val) => onTap(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}

class _SummaryStatItem extends StatelessWidget {
  const _SummaryStatItem({
    required this.label,
    required this.count,
    required this.color,
    required this.isDark,
  });

  final String label;
  final int count;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

