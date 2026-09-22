import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/doctor_model.dart';

class DoctorsNotifier extends StateNotifier<List<DoctorModel>> {
  DoctorsNotifier() : super(_mockDoctors);

  static List<DoctorModel> get mockDoctors => _mockDoctors;

  static final List<DoctorModel> _mockDoctors = [
    DoctorModel(
      providerId: 'doc_1',
      name: 'Dr. Ahmed Hassan',
      type: 'General Practitioner',
      address: 'Medical Center',
      distanceKm: 1.2,
      estimatedMinutes: 5,
    ),
    DoctorModel(
      providerId: 'doc_2',
      name: 'Dr. Salma Abdelaziz',
      type: 'Internal Medicine',
      address: 'City Hospital',
      distanceKm: 2.4,
      estimatedMinutes: 8,
    ),
    DoctorModel(
      providerId: 'doc_3',
      name: 'Dr. Karim Nabil',
      type: 'Cardiology',
      address: 'Heart Clinic',
      distanceKm: 3.1,
      estimatedMinutes: 12,
    ),
    DoctorModel(
      providerId: 'doc_4',
      name: 'Dr. Laila Mostafa',
      type: 'Dermatology',
      address: 'Skin Care Center',
      distanceKm: 4.0,
      estimatedMinutes: 15,
    ),
  ];

  void filterByType(String type) {
    if (type == 'All') {
      state = _mockDoctors;
      return;
    }
    if (type == 'General') {
      state = _mockDoctors
          .where((doc) => doc.type.toLowerCase().contains('general') ||
              doc.type.toLowerCase().contains('internal'))
          .toList();
      return;
    }
    state = _mockDoctors
        .where((doc) => doc.type.toLowerCase().contains(type.toLowerCase()))
        .toList();
  }
}

final doctorsProvider = StateNotifierProvider.autoDispose<DoctorsNotifier, List<DoctorModel>>((ref) {
  return DoctorsNotifier();
});
