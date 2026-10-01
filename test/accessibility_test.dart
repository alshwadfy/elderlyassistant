import 'package:elderlyassistant/core/providers/app_settings_provider.dart';
import 'package:elderlyassistant/core/l10n/app_localizations.dart';
import 'package:elderlyassistant/core/widgets/accessibility_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccessibilityNotifier', () {
    test('font size increase and decrease clamp within bounds', () {
      final notifier = AccessibilityNotifier();
      expect(notifier.state.fontScale, equals(1.0));

      notifier.increaseFontSize();
      expect(notifier.state.fontScale, equals(1.15));

      notifier.decreaseFontSize();
      expect(notifier.state.fontScale, equals(1.0));

      notifier.resetDefaults();
      expect(notifier.state.fontScale, equals(1.0));
      expect(notifier.state.letterSpacing, equals(0.0));
    });

    test('text spacing increase and decrease', () {
      final notifier = AccessibilityNotifier();
      notifier.increaseTextSpacing();
      expect(notifier.state.letterSpacing, equals(0.5));

      notifier.decreaseTextSpacing();
      expect(notifier.state.letterSpacing, equals(0.0));
    });

    test('toggle high contrast mode', () {
      final notifier = AccessibilityNotifier();
      expect(notifier.state.highContrast, isFalse);

      notifier.toggleHighContrast();
      expect(notifier.state.highContrast, isTrue);

      notifier.toggleHighContrast();
      expect(notifier.state.highContrast, isFalse);
    });
  });

  testWidgets('AccessibilityFloatingButton opens AccessibilityMenuSheet modal',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
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
