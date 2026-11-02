import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repositories/rafiq_repositories.dart';
import '../data/models/doctor_model.dart';

/// Nearby Hospitals Cubit (`المستشفيات القريبة` — Sequence Diagram 2).
class DoctorsCubit extends Cubit<List<DoctorModel>> {
  DoctorsCubit({HealthcareRepository? repository})
      : _repository = repository ?? HealthcareRepository(),
        super(HealthcareRepository.initialHospitals);

  final HealthcareRepository _repository;

  static List<DoctorModel> get mockDoctors =>
      HealthcareRepository.initialHospitals;

  void filterBySpecialtyOrQuery({
    String specialty = 'الكل',
    String query = '',
  }) {
    emit(_repository.filterHospitals(specialty: specialty, query: query));
  }

  void filterByType(String type) {
    filterBySpecialtyOrQuery(specialty: type);
  }
}

typedef DoctorsNotifier = DoctorsCubit;
