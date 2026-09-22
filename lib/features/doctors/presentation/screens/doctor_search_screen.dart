import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  void _book(DoctorModel doctor) {
    ref.read(appointmentsProvider.notifier).addAppointment(
          AppointmentModel(
            appointmentId: 'app_${DateTime.now().millisecondsSinceEpoch}',
            doctorId: doctor.providerId,
            doctorName: doctor.name,
            doctorType: doctor.type,
            dateTime: DateTime.now().add(const Duration(days: 3, hours: 2)),
            status: 'Upcoming',
          ),
        );
    showDemoSnackBar(context, 'Appointment booked with ${doctor.name} (demo)');
  }

  @override
  Widget build(BuildContext context) {
    final doctors = _visible(ref.watch(doctorsProvider));

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              _TitleIcon(icon: Icons.person_outline),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find a Doctor',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Search for nearby doctors and book an appointment',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
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
            decoration: const InputDecoration(
              hintText: 'Search by speciality (e.g. cardiologist)',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
                            ? AppColors.textLight
                            : AppColors.chipTextUnselected,
                        fontWeight: FontWeight.w600,
                      ),
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
          const SizedBox(height: 16),
          Expanded(
            child: doctors.isEmpty
                ? const Center(
                    child: Text(
                      'No doctors match this search.',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : ListView.builder(
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
  const _TitleIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppColors.textLight),
    );
  }
}
