import 'package:araya_core_prefs/araya_core_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockArayaThemeProvider extends Mock implements ArayaThemeProvider {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

class TestableWidget extends StatelessWidget {
  const TestableWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: TextButton(
          key: const Key('toggleTheme'),
          child: const Text('Toggle Button'),
          onPressed: () {
            context.read<MockArayaThemeProvider>().toggleAppThemeMode(context);
          },
        ),
      ),
    );
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    SharedPrefs().clear();
  });

  testWidgets('Toggle ThemeMode test', (WidgetTester tester) async {
    await SharedPrefs().init();
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MockArayaThemeProvider()),
        ],
        child: const TestableWidget(),
      ),
    );

    expect(find.text('Toggle Button'), findsOneWidget);
    final button = find.byKey(const Key('toggleTheme'));
    TextButton toggle = button.evaluate().first.widget as TextButton;

    toggle.onPressed;
    SharedPrefs().setThemeMode(ThemeMode.dark);
    await tester.pump();
    expect(ThemeMode.dark, SharedPrefs().getThemeMode);

    toggle.onPressed;
    SharedPrefs().setThemeMode(ThemeMode.light);
    await tester.pump();
    expect(SharedPrefs().getThemeMode, ThemeMode.light);
  });

  group('SharedPrefs test', () {
    test('SharedPrefs getter - setter test', () async {
      await SharedPrefs().init();
      SharedPrefs().setBool('key', true);
      expect(SharedPrefs().getBool('key'), true);

      SharedPrefs().clear('key');
      SharedPrefs().setDouble('key', 1.0);
      expect(SharedPrefs().getDouble('key'), 1.0);

      SharedPrefs().clear('key');
      SharedPrefs().setInt('key', 1);
      expect(SharedPrefs().getInt('key'), 1);

      SharedPrefs().clear('key');
      SharedPrefs().setString('key', 'value');
      expect(SharedPrefs().getString('key'), 'value');

      SharedPrefs().clear('key');
      SharedPrefs().setStringList('key', ['value']);
      expect(SharedPrefs().getStringList('key'), ['value']);
    });
  });
}
