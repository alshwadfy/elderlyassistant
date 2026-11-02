import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../../features/check_in/providers/daily_check_in_provider.dart';
import '../../features/doctors/providers/appointments_provider.dart';
import '../../features/doctors/providers/doctors_provider.dart';
import '../../features/emergency/providers/caregiver_requests_provider.dart';
import '../../features/emergency/providers/emergency_provider.dart';
import '../../features/emergency/providers/family_provider.dart';
import '../../features/reminders/providers/reminders_provider.dart';
import '../../features/voice_assistant/providers/voice_assistant_provider.dart';
import '../../features/way_home/providers/way_home_provider.dart';
import '../providers/app_settings_provider.dart';
import '../repositories/rafiq_repositories.dart';
import '../services/rafiq_api_service.dart';
import '../socket/socket_providers.dart';

/// Root dependency injection & state management tree for Rafiq (رفيق).
///
/// Separates the application into two explicit layers:
/// 1. `MultiRepositoryProvider`: Reactive domain repositories (`MedicationRepository`,
///    `HealthcareRepository`, `EmergencyRepository`) + infrastructure services
///    (`RafiqApiService`).
/// 2. `MultiBlocProvider`: Event-driven `Bloc`s (`EmergencyBloc`, `VoiceAssistantBloc`)
///    for life-critical / multi-step async state machines, and pragmatic `Cubit`s
///    for synchronous/CRUD domain slices.
class RafiqAppProviders extends StatelessWidget {
  const RafiqAppProviders({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RafiqApiService>(
          create: (_) => RafiqApiService(),
        ),
        RepositoryProvider<MedicationRepository>(
          create: (_) => MedicationRepository(),
          dispose: (repo) => repo.dispose(),
        ),
        RepositoryProvider<HealthcareRepository>(
          create: (_) => HealthcareRepository(),
        ),
        RepositoryProvider<EmergencyRepository>(
          create: (ctx) => EmergencyRepository(
            apiService: ctx.read<RafiqApiService>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<SocketCubit>(
                create: (_) => SocketCubit(),
              ),
              BlocProvider<AppSettingsCubit>(
                create: (_) => AppSettingsCubit(),
              ),
              BlocProvider<AuthCubit>(
                create: (_) => AuthCubit(),
              ),
              BlocProvider<RemindersCubit>(
                create: (ctx) => RemindersCubit(
                  repository: ctx.read<MedicationRepository>(),
                ),
              ),
              BlocProvider<DoctorsCubit>(
                create: (ctx) => DoctorsCubit(
                  repository: ctx.read<HealthcareRepository>(),
                ),
              ),
              BlocProvider<AppointmentsCubit>(
                create: (_) => AppointmentsCubit(),
              ),
              BlocProvider<FamilyCubit>(
                create: (_) => FamilyCubit(),
              ),
              BlocProvider<CaregiverRequestsCubit>(
                create: (_) => CaregiverRequestsCubit(),
              ),
              BlocProvider<EmergencyBloc>(
                create: (ctx) => EmergencyBloc(
                  repository: ctx.read<EmergencyRepository>(),
                ),
              ),
              BlocProvider<VoiceAssistantBloc>(
                create: (ctx) => VoiceAssistantBloc(
                  apiService: ctx.read<RafiqApiService>(),
                  medicationRepository: ctx.read<MedicationRepository>(),
                ),
              ),
              BlocProvider<DailyCheckInCubit>(
                create: (ctx) => DailyCheckInCubit(
                  apiService: ctx.read<RafiqApiService>(),
                ),
              ),
              BlocProvider<WayHomeCubit>(
                create: (_) => WayHomeCubit(),
              ),
            ],
            child: child,
          );
        },
      ),
    );
  }
}
