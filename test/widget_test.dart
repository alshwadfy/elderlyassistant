import 'package:elderlyassistant/main.dart';
import 'package:elderlyassistant/core/widgets/accessible_button.dart';
import 'package:elderlyassistant/core/widgets/error_view.dart';
import 'package:elderlyassistant/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('login splash shows Get Started and Login', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.text('Get Started'), findsOneWidget);
    // Button text simplified per new design
    expect(find.text('Log In'), findsOneWidget);
    expect(find.textContaining('Your voice'), findsOneWidget);
  });

  testWidgets('Get Started opens onboarding then Home', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Meet Your Assistant'), findsOneWidget);

    // Scroll the first (vertical page) Scrollable only, not any text field inside
    await tester.scrollUntilVisible(
      find.text('Complete Setup & Go Home'),
      200.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Complete Setup & Go Home'));
    await tester.pumpAndSettle();

    expect(find.text('Good morning, Adel'), findsOneWidget);
    expect(find.text('Find a Doctor'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
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

  testWidgets('primary palette uses correct brand blue per ui.md spec', (tester) async {
    // Updated from old Figma blue #3B5BDB to spec-mandated #1647AD
    expect(AppColors.primary, const Color(0xFF1647AD));
  });
}
