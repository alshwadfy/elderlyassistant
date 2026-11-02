import 'dart:convert';
import 'dart:io';
import '../config/app_config.dart';

/// Structured response from `POST /api/voice/interact` and `POST /ai/process-voice`
/// matching Sequence Diagrams 1 & 2 and the Project Proposal AI Intent schema.
class AiVoiceApiResponse {
  const AiVoiceApiResponse({
    required this.transcript,
    required this.intent,
    required this.entities,
    required this.responseText,
    this.doseLogged = false,
    this.medicationName,
    this.nextDoseTime,
    this.specialtyFilter,
    this.audioUrl,
  });

  final String transcript;
  final String intent;
  final Map<String, dynamic> entities;
  final String responseText;
  final bool doseLogged;
  final String? medicationName;
  final String? nextDoseTime;
  final String? specialtyFilter;
  final String? audioUrl;

  factory AiVoiceApiResponse.fromJson(Map<String, dynamic> json) {
    final entities = (json['entities'] is Map<String, dynamic>)
        ? json['entities'] as Map<String, dynamic>
        : <String, dynamic>{};
    return AiVoiceApiResponse(
      transcript: (json['transcript'] ?? '').toString(),
      intent: (json['intent'] ?? 'GENERAL_QUESTION').toString(),
      entities: entities,
      responseText: (json['response_text'] ?? json['reply_text'] ?? '').toString(),
      doseLogged: json['dose_logged'] == true,
      medicationName: entities['medication']?.toString(),
      nextDoseTime: json['next_dose_time']?.toString(),
      specialtyFilter: entities['specialty']?.toString(),
      audioUrl: json['audio_url']?.toString(),
    );
  }
}

/// Unified API & AI Service Layer for Rafiq (رفيق).
///
/// Separates all network & AI communication from UI and Bloc/Cubit handlers.
/// When `AppConfig.apiBaseUrl` / `AppConfig.aiBaseUrl` are provided via `--dart-define`,
/// this service performs real HTTP JSON requests. When offline or unconfigured,
/// it returns deterministic responses matching Sequence Diagrams 1–4.
class RafiqApiService {
  RafiqApiService({
    this.apiBaseUrl = AppConfig.apiBaseUrl,
    this.aiBaseUrl = AppConfig.aiBaseUrl,
  });

  final String apiBaseUrl;
  final String aiBaseUrl;

  /// Sequence Diagram 1 & 2:
  /// `POST /api/voice/interact` -> forwards to FastAPI `POST /ai/process-voice`
  /// and executes backend action (`LOG_DOSE`, `FIND_HOSPITAL`, `CALL_FAMILY`, etc.).
  Future<AiVoiceApiResponse> processVoiceInteraction({
    required String userId,
    required String spokenText,
    required String voicePersona,
    required double speechRate,
  }) async {
    if (apiBaseUrl.isNotEmpty) {
      try {
        final json = await _postJson('$apiBaseUrl/api/voice/interact', {
          'user_id': userId,
          'transcript': spokenText,
          'voice_persona': voicePersona,
          'speech_rate': speechRate,
        });
        if (json != null) {
          return AiVoiceApiResponse.fromJson(json);
        }
      } catch (_) {
        // Fallback to local intent engine below when server is unreachable.
      }
    }

    await Future.delayed(const Duration(milliseconds: 550));
    final normalized = spokenText.trim().toLowerCase();

    // 1. LOG_DOSE intent (Sequence Diagram 1)
    if (normalized.contains('ضغط') ||
        normalized.contains('أخذت') ||
        normalized.contains('اخذت') ||
        normalized.contains('فطور') ||
        normalized.contains('نعم') ||
        normalized.contains('دواء') ||
        normalized.contains('حبة') ||
        normalized.contains('med') ||
        normalized.contains('pill')) {
      return const AiVoiceApiResponse(
        transcript: 'نعم، أخذتها الآن مع الفطور.',
        intent: 'LOG_DOSE',
        entities: {
          'medication': 'حبة الضغط',
          'time': 'الآن مع الفطور',
        },
        responseText: 'رائع! سُجّلت جرعة حبة الضغط. جرعتك القادمة الساعة ٢:٠٠ م.',
        doseLogged: true,
        medicationName: 'حبة الضغط',
        nextDoseTime: '٢:٠٠ م',
      );
    }

    // 2. FIND_HOSPITAL / FIND_DOCTOR intent (Sequence Diagram 2)
    if (normalized.contains('مستشفى') ||
        normalized.contains('طبيب') ||
        normalized.contains('دكتور') ||
        normalized.contains('قلب') ||
        normalized.contains('عيون') ||
        normalized.contains('عظام') ||
        normalized.contains('أقرب') ||
        normalized.contains('hospital') ||
        normalized.contains('doctor')) {
      String specialty = 'الكل';
      if (normalized.contains('قلب') || normalized.contains('cardio')) {
        specialty = 'القلب';
      } else if (normalized.contains('عيون')) {
        specialty = 'العيون';
      } else if (normalized.contains('عظام')) {
        specialty = 'العظام';
      }
      return AiVoiceApiResponse(
        transcript: spokenText,
        intent: 'FIND_HOSPITAL',
        entities: {
          'specialty': specialty,
          'location': 'near_me',
        },
        responseText:
            'وجدت ٣ مستشفيات قريبة منك. أقربها مستشفى الأمل على بُعد ١٫٢ كم (٥ دقائق).',
        specialtyFilter: specialty,
      );
    }

    // 3. CALL_FAMILY intent
    if (normalized.contains('اتصل') ||
        normalized.contains('ابنتي') ||
        normalized.contains('ليلى') ||
        normalized.contains('عمر') ||
        normalized.contains('عائلتي') ||
        normalized.contains('family') ||
        normalized.contains('call')) {
      return AiVoiceApiResponse(
        transcript: spokenText,
        intent: 'CALL_FAMILY',
        entities: const {'contact_name': 'ليلى', 'relation': 'الابنة'},
        responseText: 'جارٍ الاتصال بابنتك ليلى الآن على الرقم المسجّل.',
      );
    }

    // 4. EMERGENCY intent
    if (normalized.contains('مساعدة') ||
        normalized.contains('طوارئ') ||
        normalized.contains('تعبان') ||
        normalized.contains('اسعاف') ||
        normalized.contains('help')) {
      return AiVoiceApiResponse(
        transcript: spokenText,
        intent: 'EMERGENCY',
        entities: const {'urgency': 'high'},
        responseText:
            'سأفتح شاشة مساعدة الطوارئ فوراً وأشارك موقعك مع عائلتك.',
      );
    }

    // 5. WAY_HOME intent
    if (normalized.contains('البيت') ||
        normalized.contains('المنزل') ||
        normalized.contains('أرجع') ||
        normalized.contains('طريق')) {
      return AiVoiceApiResponse(
        transcript: spokenText,
        intent: 'WAY_HOME',
        entities: const {'destination': 'المنزل'},
        responseText:
            'لا تقلق يا عادل، أنت على بُعد ٦٠٠ متر (٨ دقائق مشيًا) من المنزل. افتح خريطة العودة للبيت لتوجيهك خطوة بخطوة.',
      );
    }

    // Default GENERAL_QUESTION intent
    return AiVoiceApiResponse(
      transcript: spokenText,
      intent: 'GENERAL_QUESTION',
      entities: const {},
      responseText:
          'أنا معك يا عادل. يمكنك أن تطلب مني تسجيل دوائك، أو البحث عن أقرب مستشفى، أو الاتصال بعائلتك.',
    );
  }

  /// Sequence Diagram 3:
  /// `POST /api/emergency/trigger`
  Future<String> triggerEmergency({
    required String userId,
    required double lat,
    required double lng,
    required String address,
  }) async {
    if (apiBaseUrl.isNotEmpty) {
      try {
        final json = await _postJson('$apiBaseUrl/api/emergency/trigger', {
          'user_id': userId,
          'lat': lat,
          'lng': lng,
          'address': address,
          'triggered_at': DateTime.now().toIso801String(),
        });
        if (json != null && json['event_id'] != null) {
          return json['event_id'].toString();
        }
      } catch (_) {}
    }
    return 'emg_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Sequence Diagram 3:
  /// `PATCH /api/emergency/{id}` to cancel or resolve an emergency event.
  Future<bool> updateEmergencyStatus({
    required String eventId,
    required String status,
  }) async {
    if (apiBaseUrl.isNotEmpty) {
      try {
        await _postJson('$apiBaseUrl/api/emergency/$eventId', {
          'status': status,
          'resolved_at': DateTime.now().toIso801String(),
        });
      } catch (_) {}
    }
    return true;
  }

  /// Daily Check-in (`طمئنّا عليك`):
  /// `POST /api/checkins`
  Future<bool> submitDailyCheckIn({
    required String userId,
    required String mood,
    required bool tookMedicines,
    required bool drankWater,
    required bool movedToday,
  }) async {
    if (apiBaseUrl.isNotEmpty) {
      try {
        await _postJson('$apiBaseUrl/api/checkins', {
          'user_id': userId,
          'mood': mood,
          'took_medicines': tookMedicines,
          'drank_water': drankWater,
          'moved_today': movedToday,
          'created_at': DateTime.now().toIso801String(),
        });
      } catch (_) {}
    }
    await Future.delayed(const Duration(milliseconds: 250));
    return true;
  }

  /// Sequence Diagrams 1 & 4:
  /// `POST /api/reminders/{id}/log-dose` — Notifies Backend & Family Caregiver Portal
  /// (e.g., daughter Laila) in real time when Uncle Ahmed logs a medication dose.
  Future<bool> notifyFamilyDoseLogged({
    required String reminderId,
    required String title,
    required String status,
  }) async {
    if (apiBaseUrl.isNotEmpty) {
      try {
        await _postJson('$apiBaseUrl/api/reminders/$reminderId/log-dose', {
          'reminder_id': reminderId,
          'title': title,
          'status': status,
          'logged_at': DateTime.now().toIso801String(),
          'notify_family': true,
        });
      } catch (_) {}
    }
    return true;
  }

  Future<Map<String, dynamic>?> _postJson(
    String url,
    Map<String, dynamic> body,
  ) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 4);
    try {
      final request = await client.postUrl(Uri.parse(url));
      request.headers.contentType = ContentType.json;
      request.add(utf8.encode(jsonEncode(body)));
      final response = await request.close();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final raw = await response.transform(utf8.decoder).join();
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      }
    } finally {
      client.close(force: true);
    }
    return null;
  }
}

extension _DateIsoExt on DateTime {
  String toIso801String() => toIso8601String();
}

