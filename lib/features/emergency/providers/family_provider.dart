import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/emergency_contact_model.dart';

class FamilyNotifier extends StateNotifier<List<EmergencyContactModel>> {
  FamilyNotifier() : super(_mockContacts);

  static final List<EmergencyContactModel> _mockContacts = [
    EmergencyContactModel(
      contactId: 'contact_1',
      name: 'Hala',
      relation: 'Daughter',
      phone: '+20 10 1234 5678',
      priorityOrder: 1,
    ),
    EmergencyContactModel(
      contactId: 'contact_2',
      name: 'Ahmed',
      relation: 'Son',
      phone: '+20 11 9876 5432',
      priorityOrder: 2,
    ),
    EmergencyContactModel(
      contactId: 'contact_3',
      name: 'Youssef',
      relation: 'Grandson',
      phone: '+20 12 3456 7890',
      priorityOrder: 3,
    ),
    EmergencyContactModel(
      contactId: 'contact_4',
      name: 'Mona',
      relation: 'Sister',
      phone: '+20 10 2222 3333',
      priorityOrder: 4,
    ),
  ];
}

final familyProvider = StateNotifierProvider.autoDispose<FamilyNotifier, List<EmergencyContactModel>>((ref) {
  return FamilyNotifier();
});
