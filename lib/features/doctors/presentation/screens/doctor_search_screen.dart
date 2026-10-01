import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/demo_snackbar.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/doctor_model.dart';
import '../../providers/appointments_provider.dart';
import '../../providers/doctors_provider.dart';
import '../widgets/doctor_card.dart';

class DoctorSearchScreen extends ConsumerStatefulWidget {
  const DoctorSearchScreen({super.key});

  @override
  ConsumerState<DoctorSearchScreen> createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends ConsumerState<DoctorSearchScreen> {
  String _selectedFilter = 'All';
  String _query = '';
  final List<String> _filters = [
    'All',
    'General',
    'Cardiology',
    'Dermatology',
  ];

  List<DoctorModel> _visible(List<DoctorModel> doctors) {
    if (_query.trim().isEmpty) return doctors;
    final q = _query.toLowerCase();
    return doctors
        .where(
          (d) =>
              d.name.toLowerCase().contains(q) ||
              d.type.toLowerCase().contains(q),
        )
        .toList();
  }

  Future<void> _book(DoctorModel doctor) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      helpText: 'Select Appointment Date for ${doctor.name}',
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
      helpText: 'Select Appointment Time',
    );

    if (pickedTime == null || !mounted) return;

    final selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    ref.read(appointmentsProvider.notifier).addAppointment(
          AppointmentModel(
            appointmentId: 'app_${DateTime.now().millisecondsSinceEpoch}',
            doctorId: doctor.providerId,
            doctorName: doctor.name,
            doctorType: doctor.type,
            dateTime: selectedDateTime,
            status: 'Upcoming',
          ),
        );

    if (mounted) {
      showDemoSnackBar(
        context,
        'Appointment booked with ${doctor.name} on ${pickedDate.day}/${pickedDate.month} at ${pickedTime.format(context)}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final doctors = _visible(ref.watch(doctorsProvider));

    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;
    final chipUnselected = isDark ? AppColorsDark.chipUnselected : AppColors.chipUnselected;
    final chipTextUnselected = isDark ? AppColorsDark.chipTextUnselected : AppColors.chipTextUnselected;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const BackButtonIcon(),
                tooltip: l10n.back,
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home',
                      (route) => false,
                    );
                  }
                },
              ),
              const SizedBox(width: 8),
              _TitleIcon(icon: Icons.person_search_rounded, isDark: isDark),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find a Doctor',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Search for nearby doctors and book an appointment',
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
          const SizedBox(height: 20),
          TextField(
            onChanged: (value) => setState(() => _query = value),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
            decoration: InputDecoration(
              hintText: 'Search by speciality (e.g. cardiologist)',
              prefixIcon: Icon(Icons.search_rounded, size: 24, color: primaryColor),
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = filter == _selectedFilter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Semantics(
                    button: true,
                    selected: isSelected,
                    label: 'Filter $filter',
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : chipTextUnselected,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      selectedColor: primaryColor,
                      backgroundColor: chipUnselected,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      onSelected: (selected) {
                        if (!selected) return;
                        setState(() => _selectedFilter = filter);
                        ref.read(doctorsProvider.notifier).filterByType(filter);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: doctors.isEmpty
                ? Center(
                    child: Text(
                      'No doctors match this search.',
                      style: TextStyle(
                        fontSize: 16,
                        color: textSecondary,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      return DoctorCard(
                        doctor: doctors[index],
                        onBook: () => _book(doctors[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _TitleIcon extends StatelessWidget {
  const _TitleIcon({required this.icon, required this.isDark});

  final IconData icon;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
