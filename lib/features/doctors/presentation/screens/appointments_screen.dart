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

  Future<void> _showAddAppointmentDialog(bool isDark) async {
    final l10n = AppLocalizations.of(context);
    final doctorNameController = TextEditingController();
    final specialtyController = TextEditingController(text: 'General Practitioner');

    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);

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
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.calendar_month, color: primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Text(l10n.addNewAppointment, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textPrimary)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Doctor Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: doctorNameController,
                      style: TextStyle(fontSize: 16, color: textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Dr. Ahmed Hassan',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Specialty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: specialtyController,
                      style: TextStyle(fontSize: 16, color: textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Cardiology',
                        prefixIcon: Icon(Icons.medical_information_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimary)),
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
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 48),
                              foregroundColor: primaryColor,
                            ),
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
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 48),
                              foregroundColor: primaryColor,
                            ),
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
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 48),
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
                          minimumSize: const Size(0, 48),
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
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;
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
                icon: const Icon(Icons.arrow_back_rounded, size: 28),
                tooltip: 'Back',
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              const SizedBox(width: 8),
              _CalendarBadge(isDark: isDark),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.myAppointments,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      l10n.manageAppointments,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColorsDark.surface : AppColors.chipUnselected,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(4),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: textSecondary,
              labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: '${l10n.upcoming} (${upcoming.length})'),
                Tab(text: l10n.past),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _AppointmentList(items: upcoming),
                _AppointmentList(items: past),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () => _showAddAppointmentDialog(isDark),
            icon: const Icon(Icons.add_circle_outline_rounded, size: 26),
            label: Text(
              l10n.addNewAppointment,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarBadge extends StatelessWidget {
  const _CalendarBadge({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final primaryContainer = isDark ? AppColorsDark.primaryContainer : AppColors.primaryContainer;

    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: primaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(Icons.calendar_month_rounded, color: primaryColor, size: 28),
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
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      );
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final emergencyColor = isDark ? AppColorsDark.emergency : AppColors.emergency;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColorsDark.surface : AppColors.surface,
          title: Text(l10n.cancelAppointment, style: TextStyle(color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary)),
          content: Text(l10n.confirmCancel(appt.doctorName), style: TextStyle(color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.keepAppointment),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: emergencyColor),
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
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final primaryContainer = isDark ? AppColorsDark.primaryContainer : AppColors.primaryContainer;
    final emergencyColor = isDark ? AppColorsDark.emergency : AppColors.emergency;
    final emergencyContainer = isDark ? AppColorsDark.emergencyContainer : AppColors.emergencyContainer;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;
    final surface = isDark ? AppColorsDark.surface : AppColors.surface;
    final border = isDark ? AppColorsDark.border : AppColors.border;

    final isCancelled = appt.status == 'Cancelled';
    final isUpcoming = appt.status == 'Upcoming';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: border,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 10,
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
                CircleAvatar(
                  radius: 26,
                  backgroundColor: isCancelled ? emergencyContainer : primaryContainer,
                  child: Icon(
                    isCancelled ? Icons.event_busy_rounded : Icons.medical_information_rounded,
                    color: isCancelled ? emergencyColor : primaryColor,
                    size: 26,
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
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                                color: textPrimary,
                                decoration: isCancelled
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          _AppointmentStatusBadge(status: appt.status, l10n: l10n, isDark: isDark),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        appt.doctorType,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 16, color: primaryColor),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              _formatAppointment(appt.dateTime),
                              style: TextStyle(
                                color: textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
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
                      foregroundColor: emergencyColor,
                      side: BorderSide(color: emergencyColor, width: 2.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
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
    required this.isDark,
  });

  final String status;
  final AppLocalizations l10n;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final primaryContainer = isDark ? AppColorsDark.primaryContainer : AppColors.primaryContainer;
    final emergencyColor = isDark ? AppColorsDark.emergency : AppColors.emergency;
    final emergencyContainer = isDark ? AppColorsDark.emergencyContainer : AppColors.emergencyContainer;
    final chipUnselected = isDark ? AppColorsDark.chipUnselected : AppColors.chipUnselected;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;

    final (label, bgColor, textColor) = switch (status) {
      'Upcoming' => (l10n.upcoming, primaryContainer, primaryColor),
      'Cancelled' => (l10n.cancelled, emergencyContainer, emergencyColor),
      _ => (l10n.past, chipUnselected, textSecondary),
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
