import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repositories/rafiq_repositories.dart';
import '../data/models/emergency_contact_model.dart';

class FamilyCubit extends Cubit<List<EmergencyContactModel>> {
  FamilyCubit()
      : super(
          List<EmergencyContactModel>.from(EmergencyRepository.initialContacts),
        );

  void addContact({
    required String name,
    required String relation,
    required String phone,
    bool isEmergencyContact = true,
  }) {
    final nextPriority = state.length + 1;
    final contact = EmergencyContactModel(
      contactId: 'contact_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      relation: relation.trim(),
      phone: phone.trim(),
      priorityOrder: nextPriority,
      isEmergencyContact: isEmergencyContact,
    );
    emit([...state, contact]);
  }

  void updateContact(EmergencyContactModel updated) {
    emit([
      for (final c in state)
        if (c.contactId == updated.contactId) updated else c,
    ]);
  }

  void deleteContact(String contactId) {
    final filtered = state.where((c) => c.contactId != contactId).toList();
    emit([
      for (var i = 0; i < filtered.length; i++)
        filtered[i].copyWith(priorityOrder: i + 1),
    ]);
  }
}

typedef FamilyNotifier = FamilyCubit;
