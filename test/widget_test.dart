import 'package:elderlyassistant/core/bloc/rafiq_app_providers.dart';
import 'package:elderlyassistant/core/l10n/app_localizations.dart';
import 'package:elderlyassistant/core/repositories/rafiq_repositories.dart';
import 'package:elderlyassistant/core/services/rafiq_api_service.dart';
import 'package:elderlyassistant/core/theme/app_colors.dart';
import 'package:elderlyassistant/core/widgets/accessible_button.dart';
import 'package:elderlyassistant/core/widgets/app_bottom_nav_bar.dart';
import 'package:elderlyassistant/core/widgets/error_view.dart';
import 'package:elderlyassistant/features/check_in/presentation/screens/daily_check_in_screen.dart';
import 'package:elderlyassistant/features/doctors/presentation/screens/appointments_screen.dart';
import 'package:elderlyassistant/features/doctors/presentation/screens/doctor_search_screen.dart';
import 'package:elderlyassistant/features/emergency/providers/emergency_provider.dart';
import 'package:elderlyassistant/features/home/presentation/screens/home_shell_screen.dart';
import 'package:elderlyassistant/features/reminders/providers/reminders_provider.dart';
import 'package:elderlyassistant/features/voice_assistant/presentation/screens/voice_assistant_screen.dart';
import 'package:elderlyassistant/features/voice_assistant/providers/voice_assistant_provider.dart';
import 'package:elderlyassistant/features/way_home/presentation/screens/way_home_screen.dart';
import 'package:elderlyassistant/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Rafiq Welcome screen shows Arabic title and login/register buttons',
      (tester) async {
    await tester.pumpWidget(const RafiqAppProviders(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.text('أهلاً بك في رفيق'), findsWidgets);
    expect(find.text('تسجيل الدخول'), findsOneWidget);
    expect(find.text('إنشاء حساب جديد'), findsOneWidget);
  });

  testWidgets('Meet your assistant onboarding opens and navigates to Home v2',
      (tester) async {
    await tester.pumpWidget(const RafiqAppProviders(child: MyApp()));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('ابدأ سريعًا · تعرّف على مساعدك'),
      200.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('ابدأ سريعًا · تعرّف على مساعدك'));
    await tester.pumpAndSettle();

    expect(find.text('تعرّف على مساعدك'), findsOneWidget);
    expect(find.text('دافئ ولطيف'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('تابع بالأسلوب الدافئ واللطيف'),
      200.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('تابع بالأسلوب الدافئ واللطيف'));
    await tester.pumpAndSettle();

    expect(find.text('أهلاً , أحمد !'), findsOneWidget);
    expect(find.text('اسأل مساعدك'), findsOneWidget);
    expect(find.text('حبة الضغط'), findsOneWidget);
  });

  testWidgets('ErrorView retry is large and tappable', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorView(
            message: 'Could not load reminders',
            onRetry: () => retried = true,
          ),
        ),
      ),
    );

    expect(find.text('Could not load reminders'), findsOneWidget);
    await tester.tap(find.text('إعادة المحاولة / Retry'));
    expect(retried, isTrue);
  });

  testWidgets('AccessibleButton meets 48px minimum tap target', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 220,
              child: AccessibleButton(
                label: 'Continue',
                semanticLabel: 'Continue',
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );

    final size = tester.getSize(find.byType(AccessibleButton));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, greaterThanOrEqualTo(48));
  });

  testWidgets('primary palette uses correct brand blue per ui.md spec',
      (tester) async {
    expect(AppColors.primary, const Color(0xFF1647AD));
    expect(AppColors.rafiqPrimary, const Color(0xFF3B5BDB));
  });

  testWidgets('AppBottomNavBar displays Rafiq Arabic labels when locale is ar',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: 0,
            onTap: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('الرئيسية'), findsOneWidget);
    expect(find.text('المستشفيات'), findsOneWidget);
    expect(find.text('الأدوية'), findsOneWidget);
    expect(find.text('حسابي'), findsOneWidget);
  });

  testWidgets('HomeShellScreen switches tabs to Hospitals, Medicines, and Account',
      (tester) async {
    await tester.pumpWidget(
      const RafiqAppProviders(
        child: MaterialApp(
          locale: Locale('ar'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeShellScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Switch to Hospitals tab (`المستشفيات`)
    await tester.tap(find.text('المستشفيات').last);
    await tester.pumpAndSettle();

    expect(find.byType(DoctorSearchScreen), findsOneWidget);
    expect(find.text('المستشفيات القريبة'), findsOneWidget);
    expect(find.text('مستشفى الأمل'), findsOneWidget);

    // Switch back to Home (`الرئيسية`) via header back pill
    await tester.tap(find.text('الرئيسية').first);
    await tester.pumpAndSettle();

    expect(find.text('أهلاً , أحمد !'), findsOneWidget);
  });

  testWidgets('WayHomeScreen, DailyCheckInScreen, AppointmentsScreen, and VoiceAssistantScreen render cleanly',
      (tester) async {
    await tester.pumpWidget(
      const RafiqAppProviders(
        child: MaterialApp(
          locale: Locale('ar'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: WayHomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('ساعدني أرجع للبيت'), findsOneWidget);
    expect(find.text('امشِ للأمام ١٠٠ متر'), findsOneWidget);

    await tester.pumpWidget(
      const RafiqAppProviders(
        child: MaterialApp(
          locale: Locale('ar'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: DailyCheckInScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('طمنّا عليك'), findsOneWidget);
    expect(find.text('كيف تشعر اليوم؟'), findsOneWidget);

    await tester.pumpWidget(
      const RafiqAppProviders(
        child: MaterialApp(
          locale: Locale('ar'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: AppointmentsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('زيارتي القادمة'), findsOneWidget);
    expect(find.text('فاطمة أحمد'), findsOneWidget);

    await tester.pumpWidget(
      const RafiqAppProviders(
        child: MaterialApp(
          locale: Locale('ar'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: VoiceAssistantScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('اسأل مساعدك'), findsOneWidget);
    expect(find.text('✓ سُجّلت الجرعة'), findsOneWidget);
  });

  test(
      'Decoupled Reactive Repository: VoiceAssistantBloc logs dose and RemindersCubit updates via stream',
      () async {
    final medRepo = MedicationRepository();
    final remindersCubit = RemindersCubit(repository: medRepo);
    final voiceBloc = VoiceAssistantBloc(
      apiService: RafiqApiService(),
      medicationRepository: medRepo,
    );

    // Initially, rem_bp_pill (`حبة الضغط`) is pending
    expect(
      remindersCubit.state
          .firstWhere((r) => r.reminderId == 'rem_bp_pill')
          .status,
      equals('pending'),
    );

    // Dispatch voice command to log blood pressure medication
    final nextStateFuture = remindersCubit.stream.first;
    voiceBloc.add(
      const VoiceCommandSubmitted('نعم، أخذت حبة الضغط الآن مع الفطور.'),
    );

    await nextStateFuture;

    // RemindersCubit automatically reflects the logged dose without VoiceAssistantBloc knowing RemindersCubit exists
    expect(
      remindersCubit.state
          .firstWhere((r) => r.reminderId == 'rem_bp_pill')
          .status,
      equals('completed'),
    );

    await voiceBloc.close();
    await remindersCubit.close();
    medRepo.dispose();
  });

  test('EmergencyBloc handles session start, immediate dispatch, and escalation',
      () async {
    final emgBloc = EmergencyBloc();
    emgBloc.add(const EmergencySessionStarted());
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(emgBloc.state.countdownSeconds, equals(15));
    expect(emgBloc.state.isDispatched, isFalse);

    emgBloc.add(const EmergencyDispatchedImmediately());
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(emgBloc.state.isDispatched, isTrue);
    expect(emgBloc.state.activePriorityIndex, equals(1));

    emgBloc.add(const EmergencyContactEscalated(3));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(emgBloc.state.activePriorityIndex, equals(2));

    await emgBloc.close();
  });
}
