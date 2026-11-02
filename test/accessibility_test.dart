import 'package:elderlyassistant/core/bloc/rafiq_app_providers.dart';
import 'package:elderlyassistant/core/l10n/app_localizations.dart';
import 'package:elderlyassistant/core/providers/app_settings_provider.dart';
import 'package:elderlyassistant/core/widgets/accessibility_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSettingsCubit (Accessibility)', () {
    test('font size increase and decrease clamp within bounds', () {
      final cubit = AppSettingsCubit();
      expect(cubit.state.accessibility.fontScale, equals(1.0));

      cubit.increaseFontSize();
      expect(cubit.state.accessibility.fontScale, equals(1.15));

      cubit.decreaseFontSize();
      expect(cubit.state.accessibility.fontScale, equals(1.0));

      cubit.resetDefaults();
      expect(cubit.state.accessibility.fontScale, equals(1.0));
      expect(cubit.state.accessibility.letterSpacing, equals(0.0));
      cubit.close();
    });

    test('text spacing increase and decrease', () {
      final cubit = AppSettingsCubit();
      cubit.increaseTextSpacing();
      expect(cubit.state.accessibility.letterSpacing, equals(0.5));

      cubit.decreaseTextSpacing();
      expect(cubit.state.accessibility.letterSpacing, equals(0.0));
      cubit.close();
    });

    test('toggle high contrast mode', () {
      final cubit = AppSettingsCubit();
      expect(cubit.state.accessibility.highContrast, isFalse);

      cubit.toggleHighContrast();
      expect(cubit.state.accessibility.highContrast, isTrue);

      cubit.toggleHighContrast();
      expect(cubit.state.accessibility.highContrast, isFalse);
      cubit.close();
    });
  });

  testWidgets('AccessibilityFloatingButton opens AccessibilityMenuSheet modal',
      (tester) async {
    await tester.pumpWidget(
      const RafiqAppProviders(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            floatingActionButton: AccessibilityFloatingButton(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify FAB is rendered
    expect(find.byType(AccessibilityFloatingButton), findsOneWidget);
    expect(find.byIcon(Icons.accessibility_new_rounded), findsOneWidget);

    // Tap FAB to open modal sheet
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify sheet items
    expect(find.byType(AccessibilityMenuSheet), findsOneWidget);
    expect(find.text('Font Size'), findsOneWidget);
    expect(find.text('Text Spacing'), findsOneWidget);
    expect(find.text('High Contrast Mode'), findsOneWidget);
    expect(find.text('Read Aloud'), findsOneWidget);
  });
}
