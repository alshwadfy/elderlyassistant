import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/demo_snackbar.dart';
import '../../data/models/appointment_model.dart';
import '../../providers/appointments_provider.dart';

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showAddAppointmentDialog() async {
    final l10n = AppLocalizations.of(context);
    final doctorNameController = TextEditingController();
    final specialtyController = TextEditingController(text: 'General Practitioner');

    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);

    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.calendar_month, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Text(l10n.addNewAppointment, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Doctor Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: doctorNameController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Dr. Ahmed Hassan',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Specialty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: specialtyController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Cardiology',
                        prefixIcon: Icon(Icons.medical_information_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 180)),
                              );
                              if (picked != null) {
                                setDialogState(() => selectedDate = picked);
                              }
                            },
                            icon: const Icon(Icons.event, size: 18),
                            label: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                            style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                              );
                              if (picked != null) {
                                setDialogState(() => selectedTime = picked);
                              }
                            },
                            icon: const Icon(Icons.access_time, size: 18),
                            label: Text(selectedTime.format(context)),
                            style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
                          ),
                        ),
                      ],
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
                        style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(dialogContext, true),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 48),
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

    if (saved == true && doctorNameController.text.trim().isNotEmpty) {
      final appointmentDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      ref.read(appointmentsProvider.notifier).addAppointment(
            AppointmentModel(
              appointmentId: 'app_${DateTime.now().millisecondsSinceEpoch}',
              doctorId: 'doc_custom',
              doctorName: doctorNameController.text.trim(),
              doctorType: specialtyController.text.trim().isEmpty
                  ? 'General Practitioner'
                  : specialtyController.text.trim(),
              dateTime: appointmentDateTime,
              status: 'Upcoming',
            ),
          );

      if (mounted) {
        showDemoSnackBar(
          context,
          'New appointment scheduled with ${doctorNameController.text.trim()}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final appointments = ref.watch(appointmentsProvider);
    final upcoming =
        appointments.where((a) => a.status == 'Upcoming').toList();
    final past = appointments.where((a) => a.status == 'Past' || a.status == 'Cancelled').toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              const _CalendarBadge(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.myAppointments,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.manageAppointments,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(4),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              tabs: [
                Tab(text: '${l10n.upcoming} (${upcoming.length})'),
                Tab(text: l10n.past),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _AppointmentList(items: upcoming),
                _AppointmentList(items: past),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _showAddAppointmentDialog,
            icon: const Icon(Icons.add_circle_outline, size: 26),
            label: Text(
              l10n.addNewAppointment,
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

class _CalendarBadge extends StatelessWidget {
  const _CalendarBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.calendar_today, color: AppColors.primary, size: 24),
    );
  }
}

class _AppointmentList extends StatelessWidget {
  const _AppointmentList({required this.items});

  final List<AppointmentModel> items;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    if (items.isEmpty) {
      return Center(
        child: Text(
          l10n.noAppointments,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => _AppointmentCard(appt: items[index]),
    );
  }
}

class _AppointmentCard extends ConsumerWidget {
  const _AppointmentCard({required this.appt});

  final AppointmentModel appt;

  Future<void> _cancelAppointment(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.cancelAppointment),
          content: Text(l10n.confirmCancel(appt.doctorName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.keepAppointment),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: AppColors.emergency),
              child: Text(l10n.cancelAppointment),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      ref
          .read(appointmentsProvider.notifier)
          .cancelAppointment(appt.appointmentId);
      if (context.mounted) {
        showDemoSnackBar(
          context,
          'Appointment with ${appt.doctorName} cancelled',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isCancelled = appt.status == 'Cancelled';
    final isUpcoming = appt.status == 'Upcoming';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: isCancelled
                      ? AppColors.emergencyContainer
                      : AppColors.primaryContainer,
                  child: Icon(
                    isCancelled ? Icons.event_busy : Icons.medical_information,
                    color: isCancelled ? AppColors.emergency : AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              appt.doctorName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                decoration: isCancelled
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          _AppointmentStatusBadge(status: appt.status, l10n: l10n),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appt.doctorType,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            _formatAppointment(appt.dateTime),
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isUpcoming) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _cancelAppointment(context, ref),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(130, 44),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      foregroundColor: AppColors.emergency,
                      side: const BorderSide(color: AppColors.emergency, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: Text(l10n.cancel, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _formatAppointment(DateTime dateTime) {
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final weekday = weekdays[dateTime.weekday - 1];
  final month = months[dateTime.month - 1];
  final hour = dateTime.hour == 0
      ? 12
      : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour >= 12 ? 'PM' : 'AM';
  return '$weekday, $month ${dateTime.day}, ${dateTime.year}  •  $hour:$minute $period';
}

class _AppointmentStatusBadge extends StatelessWidget {
  const _AppointmentStatusBadge({
    required this.status,
    required this.l10n,
  });

  final String status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final (label, bgColor, textColor) = switch (status) {
      'Upcoming' => (l10n.upcoming, AppColors.primaryContainer, AppColors.primary),
      'Cancelled' => (l10n.cancelled, AppColors.emergencyContainer, AppColors.emergency),
      _ => (l10n.past, AppColors.chipUnselected, AppColors.textSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
