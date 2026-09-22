import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/doctor_model.dart';

class DoctorsNotifier extends StateNotifier<List<DoctorModel>> {
  DoctorsNotifier() : super(_mockDoctors);

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
  ];

  void filterByType(String type) {
    if (type == 'All') {
      state = _mockDoctors;
    } else {
      state = _mockDoctors.where((doc) => doc.type.contains(type) || type.contains(doc.type)).toList();
    }
  }
}

final doctorsProvider = StateNotifierProvider.autoDispose<DoctorsNotifier, List<DoctorModel>>((ref) {
  return DoctorsNotifier();
});
