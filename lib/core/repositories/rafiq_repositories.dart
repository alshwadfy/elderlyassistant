import 'dart:async';
import '../../features/doctors/data/models/appointment_model.dart';
import '../../features/doctors/data/models/doctor_model.dart';
import '../../features/emergency/data/models/caregiver_request_model.dart';
import '../../features/emergency/data/models/emergency_contact_model.dart';
import '../../features/reminders/data/models/reminder_model.dart';
import '../services/rafiq_api_service.dart';

/// Single-Source-of-Truth Reactive Repository for Medications & Daily Routines.
///
/// Decouples `VoiceAssistantBloc` (Sequence Diagram 1 `LOG_DOSE`),
/// `SocketService` (Sequence Diagram 4 remote Caregiver reminder sync),
/// and `RemindersCubit` (`أدويتي` & `الرئيسية` UI) so presentation controllers
/// never call or depend on each other directly.
class MedicationRepository {
  MedicationRepository({RafiqApiService? apiService})
      : _api = apiService ?? RafiqApiService(),
        _items = List<ReminderModel>.from(initialReminders);

  // ignore: unused_field
  final RafiqApiService _api;
  List<ReminderModel> _items;
  final StreamController<List<ReminderModel>> _controller =
      StreamController<List<ReminderModel>>.broadcast();

  static final List<ReminderModel> initialReminders = [
    ReminderModel(
      reminderId: 'rem_morning_pill',
      userId: 'user_01',
      type: 'medication',
      title: 'حبة الصباح',
      scheduledTime: DateTime(2026, 10, 9, 8, 0),
      repeatPattern: '٨:٠٠ ص • يوميًا',
      status: 'completed',
      completedAt: DateTime(2026, 10, 9, 8, 12),
      dosage: '١ قرص',
      instructions: 'بعد الفطور مباشرة مع كوب ماء',
      durationDays: 30,
      startDate: DateTime(2026, 10, 1),
    ),
    ReminderModel(
      reminderId: 'rem_bp_pill',
      userId: 'user_01',
      type: 'medication',
      title: 'حبة الضغط',
      scheduledTime: DateTime(2026, 10, 9, 14, 0),
      repeatPattern: '٢:٠٠ م • يوميًا',
      status: 'pending',
      dosage: '١ قرص (٥ ملجم)',
      instructions: 'مع كوب ماء كامل في موعد الغداء',
      durationDays: 30,
      startDate: DateTime(2026, 10, 1),
    ),
    ReminderModel(
      reminderId: 'rem_drink_water',
      userId: 'user_01',
      type: 'routine',
      title: 'اشرب الماء',
      scheduledTime: DateTime(2026, 10, 9, 16, 0),
      repeatPattern: '٤:٠٠ م • يوميًا',
      status: 'pending',
      dosage: 'كوب ماء كبير',
      instructions: 'تذكير يومي للترطيب والنشاط',
      durationDays: 30,
      startDate: DateTime(2026, 10, 1),
    ),
    ReminderModel(
      reminderId: 'rem_evening_walk',
      userId: 'user_01',
      type: 'routine',
      title: 'مشي المساء',
      scheduledTime: DateTime(2026, 10, 9, 18, 0),
      repeatPattern: '٦:٠٠ م • يوميًا',
      status: 'pending',
      dosage: '١٥ دقيقة',
      instructions: 'مشي هادئ لتحريك الدورة الدموية',
      durationDays: 30,
      startDate: DateTime(2026, 10, 1),
    ),
    ReminderModel(
      reminderId: 'rem_vitamin_d',
      userId: 'user_01',
      type: 'other_medication',
      title: 'فيتامين د',
      scheduledTime: DateTime(2026, 10, 9, 22, 0),
      repeatPattern: '١٠:٠٠ م • يوميًا',
      status: 'pending',
      dosage: '١ كبسولة (١٠٠٠ وحدة)',
      instructions: 'قبل النوم',
      durationDays: 60,
      startDate: DateTime(2026, 9, 20),
    ),
    ReminderModel(
      reminderId: 'rem_eye_drops',
      userId: 'user_01',
      type: 'other_medication',
      title: 'قطرة العين المرطبة',
      scheduledTime: DateTime(2026, 10, 9, 12, 0),
      repeatPattern: '١٢:٠٠ م • عند اللزوم',
      status: 'skipped',
      dosage: 'نقطة واحدة',
      instructions: 'توضع قبل الراحة',
      durationDays: 14,
      startDate: DateTime(2026, 10, 1),
    ),
  ];

  List<ReminderModel> get currentReminders => List.unmodifiable(_items);
  Stream<List<ReminderModel>> get remindersStream => _controller.stream;

  void _emit(List<ReminderModel> next) {
    _items = List<ReminderModel>.unmodifiable(next);
    if (!_controller.isClosed) {
      _controller.add(_items);
    }
  }

  void toggleStatus(String reminderId) {
    _emit([
      for (final rem in _items)
        if (rem.reminderId == reminderId)
          rem.copyWith(
            status: rem.status == 'completed' ? 'pending' : 'completed',
            completedAt: rem.status == 'completed' ? null : DateTime.now(),
          )
        else
          rem,
    ]);
  }

  void setStatus(String reminderId, String newStatus) {
    ReminderModel? updatedItem;
    _emit([
      for (final rem in _items)
        if (rem.reminderId == reminderId)
          updatedItem = rem.copyWith(
            status: newStatus,
            completedAt: newStatus == 'completed' ? DateTime.now() : null,
          )
        else
          rem,
    ]);
    if (updatedItem != null) {
      unawaited(
        _api.notifyFamilyDoseLogged(
          reminderId: updatedItem.reminderId,
          title: updatedItem.title,
          status: newStatus,
        ),
      );
    }
  }

  /// Called by `VoiceAssistantBloc` when AI detects `LOG_DOSE` (Sequence Diagram 1).
  /// Updates the canonical medication list and broadcasts to all listening Cubits.
  String logDoseByMedicationName(String? medicationQuery) {
    final q = (medicationQuery ?? '').trim();
    var matchedId = 'rem_bp_pill';
    for (final rem in _items) {
      if (q.isNotEmpty && rem.title.contains(q)) {
        matchedId = rem.reminderId;
        break;
      }
      if (rem.status == 'pending' && rem.type == 'medication') {
        matchedId = rem.reminderId;
        break;
      }
    }
    setStatus(matchedId, 'completed');
    final found = _items.where((r) => r.reminderId == matchedId).firstOrNull;
    return found?.title ?? 'حبة الضغط';
  }

  void addReminder(ReminderModel reminder) {
    _emit([..._items, reminder]);
  }

  void updateReminder(ReminderModel updated) {
    _emit([
      for (final rem in _items)
        if (rem.reminderId == updated.reminderId) updated else rem,
    ]);
  }

  void deleteReminder(String reminderId) {
    _emit(_items.where((rem) => rem.reminderId != reminderId).toList());
  }

  void dispose() {
    _controller.close();
  }
}

/// Single-Source-of-Truth Repository for Nearby Hospitals (Sequence Diagram 2)
/// & Family Caregiver Visit Plans (Sequence Diagram 4).
class HealthcareRepository {
  HealthcareRepository();

  static final List<DoctorModel> initialHospitals = [
    DoctorModel(
      providerId: 'hosp_amal',
      name: 'مستشفى الأمل',
      type: 'العيادات الخارجية • عام والقلب',
      address: '١٤ شارع الجلاء، مصر الجديدة، القاهرة',
      distanceKm: 1.2,
      estimatedMinutes: 5,
      distanceLabelAr: '١٫٢ كم • ٥ دقائق',
      specialties: const [
        'عيادة العيون',
        'عيادة القلب',
        'عيادة العظام',
        'عام',
      ],
      phone: '+20 2 2415 1001',
    ),
    DoctorModel(
      providerId: 'hosp_reaya',
      name: 'مستشفى الرعاية',
      type: 'مركز متخصص • القلب والعظام',
      address: '٢٨ شارع الثورة، مصر الجديدة، القاهرة',
      distanceKm: 2.4,
      estimatedMinutes: 8,
      distanceLabelAr: '٢٫٤ كم • ٨ دقائق',
      specialties: const [
        'عيادة القلب',
        'عيادة العظام',
        'عيادة الأسنان',
        'عام',
      ],
      phone: '+20 2 2415 2002',
    ),
    DoctorModel(
      providerId: 'hosp_nour',
      name: 'مستشفى النور',
      type: 'مستشفى تخصصي • العظام والجلدية',
      address: '٥ ميدان الحجاز، مصر الجديدة، القاهرة',
      distanceKm: 3.1,
      estimatedMinutes: 12,
      distanceLabelAr: '٣٫١ كم • ١٢ دقيقة',
      specialties: const [
        'عيادة العظام',
        'عيادة الأسنان',
        'عيادة الجلدية',
      ],
      phone: '+20 2 2415 3003',
    ),
  ];

  static final List<AppointmentModel> initialVisits = [
    AppointmentModel(
      appointmentId: 'visit_amal_01',
      doctorId: 'hosp_amal',
      doctorName: 'د. كريم نبيل',
      doctorType: 'استشاري أمراض القلب',
      hospitalName: 'مستشفى الأمل',
      department: 'العيادات الخارجية',
      specialty: 'القلب',
      dateTime: DateTime(2026, 10, 29, 10, 0),
      dateLabelAr: '٢٩ أكتوبر ٢٠٢٦',
      timeLabelAr: '١٠:٠٠ ص',
      address: '١٤ شارع الجلاء، مصر الجديدة، القاهرة',
      companionName: 'فاطمة أحمد',
      companionRelation: 'الابنة · المرافق المحدد',
      familyNote:
          'أضافت العائلة زيارة حسن إبراهيم وحدّدت المرافق. التفاصيل للعرض فقط.',
      status: 'Upcoming',
      isFamilySynced: true,
    ),
    AppointmentModel(
      appointmentId: 'visit_reaya_02',
      doctorId: 'hosp_reaya',
      doctorName: 'د. سلمى عبد العزيز',
      doctorType: 'باطنة ومتابعة دورية',
      hospitalName: 'مستشفى الرعاية',
      department: 'العيادات التخصصية',
      specialty: 'عام',
      dateTime: DateTime(2026, 9, 18, 11, 30),
      dateLabelAr: '١٨ سبتمبر ٢٠٢٦',
      timeLabelAr: '١١:٣٠ ص',
      address: '٢٨ شارع الثورة، مصر الجديدة، القاهرة',
      companionName: 'ليلى أحمد',
      companionRelation: 'الابنة · المرافق المحدد',
      familyNote: 'تمت الزيارة بنجاح وسُجّلت الملاحظات لدى العائلة.',
      status: 'Past',
      isFamilySynced: true,
    ),
  ];

  List<DoctorModel> filterHospitals({
    String specialty = 'الكل',
    String query = '',
  }) {
    final trimmedQuery = query.trim().toLowerCase();
    return initialHospitals.where((hosp) {
      final matchesSpecialty = specialty == 'الكل' ||
          specialty == 'All' ||
          hosp.type.contains(specialty) ||
          hosp.specialties.any((s) => s.contains(specialty));
      final matchesQuery = trimmedQuery.isEmpty ||
          hosp.name.toLowerCase().contains(trimmedQuery) ||
          hosp.type.toLowerCase().contains(trimmedQuery) ||
          hosp.address.toLowerCase().contains(trimmedQuery) ||
          hosp.specialties.any((s) => s.toLowerCase().contains(trimmedQuery));
      return matchesSpecialty && matchesQuery;
    }).toList();
  }
}

/// Single-Source-of-Truth Repository for Priority Family Contacts & Emergency Escalation.
class EmergencyRepository {
  EmergencyRepository({RafiqApiService? apiService})
      : _api = apiService ?? RafiqApiService();

  final RafiqApiService _api;

  static const List<EmergencyContactModel> initialContacts = [
    EmergencyContactModel(
      contactId: 'contact_laila',
      name: 'ليلى',
      relation: 'الابنة',
      phone: '+20 10 1234 5678',
      priorityOrder: 1,
      isEmergencyContact: true,
    ),
    EmergencyContactModel(
      contactId: 'contact_omar',
      name: 'عمر',
      relation: 'الابن',
      phone: '+20 11 9876 5432',
      priorityOrder: 2,
      isEmergencyContact: true,
    ),
    EmergencyContactModel(
      contactId: 'contact_hoda',
      name: 'هدى',
      relation: 'الجارة',
      phone: '+20 12 3456 7890',
      priorityOrder: 3,
      isEmergencyContact: true,
    ),
  ];

  static final List<CaregiverRequestModel> initialRequests = [
    CaregiverRequestModel(
      requestId: 'req_1',
      caregiverName: 'فاطمة أحمد',
      role: 'الابنة • المرافق المحدد',
      phone: '+20 10 9988 7766',
      requestedAt: DateTime(2026, 10, 9, 9, 30),
      status: 'pending',
    ),
    CaregiverRequestModel(
      requestId: 'req_2',
      caregiverName: 'د. طارق فؤاد',
      role: 'طبيب العائلة المتابع',
      phone: '+20 11 5544 3322',
      requestedAt: DateTime(2026, 10, 8, 14, 15),
      status: 'pending',
    ),
  ];

  Future<String> triggerEmergency({
    required String userId,
    required double lat,
    required double lng,
    required String address,
  }) {
    return _api.triggerEmergency(
      userId: userId,
      lat: lat,
      lng: lng,
      address: address,
    );
  }

  Future<bool> cancelEmergency({required String eventId}) {
    return _api.updateEmergencyStatus(
      eventId: eventId,
      status: 'cancelled_by_elder',
    );
  }
}
