import 'package:araya_core_prefs/araya_core_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestableWidget extends StatelessWidget {
  const TestableWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: context.watch<ArayaThemeProvider>().appThemeMode(context),
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
    late BuildContext _context;
    await SharedPrefs().init();
    await tester.pump();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ArayaThemeProvider()),
        ],
        builder: (context, child) {
          _context = context;
          return const TestableWidget();
        },
      ),
    );

    _context.read<ArayaThemeProvider>().toggleAppThemeMode(_context);
    await tester.pump();
    var expected = _context.read<ArayaThemeProvider>().appThemeMode(_context);
    expect(expected, ThemeMode.dark);
  });

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
}
