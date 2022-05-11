import 'package:araya_core_screen/araya_core_screen.dart';
import 'package:araya_core_screen/araya_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeScreen extends StatefulWidget {
  const FakeScreen({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<FakeScreen> createState() => _FakeScreenState();
}

class _FakeScreenState extends State<FakeScreen> with ArayaCoreScreenImpl {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    super.setApplicationSwitcherDescription(context, 'testWidget');
    ScreenSize screenSize = super.buildScreenSize(context);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: widget.child,
      body: SizedBox(
        width: screenSize.isMobile() ? screenSize.width : screenSize.height,
        height: screenSize.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                child: const Text('Open EndDrawer')),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  ArayaSnackBar.loadingOverlay(
                    context,
                    duration: const Duration(milliseconds: 500),
                  ),
                );
              },
              child: const Text('Show Snackbar'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTestableWidget(Widget widget, [Size size = const Size(480, 700)]) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: MaterialApp(home: widget),
  );
}

void main() {
  group('Araya Core Screen - ArayaOverlay class', () {
    testWidgets('EndDrawer as Overlay must has a spinner',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          _buildTestableWidget(const FakeScreen(child: ArayaOverlayLoading())));
      await tester.pump();
      ElevatedButton button = find
          .widgetWithText(ElevatedButton, 'Open EndDrawer')
          .evaluate()
          .first
          .widget as ElevatedButton;
      button.onPressed!();
      await tester.pump();
      final spinner = find.byKey(const Key('spinner'));
      expect(spinner, findsOneWidget);
    });
    testWidgets('EndDrawer as Overlay spinner dismissable',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _buildTestableWidget(const FakeScreen(
          child: ArayaOverlayLoading(
            key: Key('arayaOverlayLoading'),
            loadingDismissible: true,
          ),
        )),
      );
      await tester.pump();
      ElevatedButton button = find
          .widgetWithText(ElevatedButton, 'Open EndDrawer')
          .evaluate()
          .first
          .widget as ElevatedButton;
      button.onPressed!();
      await tester.pump();
      final spinner = find.byKey(const Key('spinner'));
      expect(spinner, findsOneWidget);
      GestureDetector detector = find
          .byKey(const Key('spinnerTapDetector'))
          .evaluate()
          .first
          .widget as GestureDetector;
      detector.onTap!();
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('spinner')), findsNothing);
    });
    testWidgets('EndDrawer as Overlay with Custom Contents',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildTestableWidget(
        FakeScreen(
          child: ArayaOverlay(
            barrierDismissible: true,
            childBuilder: (context) => const Center(
              child: Text('Overlay Content'),
            ),
          ),
        ),
      ));
      await tester.pump();
      ElevatedButton button = find
          .widgetWithText(ElevatedButton, 'Open EndDrawer')
          .evaluate()
          .first
          .widget as ElevatedButton;
      button.onPressed!();
      await tester.pump();
      final spinner = find.text('Overlay Content');
      expect(spinner, findsOneWidget);
      GestureDetector barrier = find
          .byKey(const Key('arayaOverlayBarrier'))
          .evaluate()
          .first
          .widget as GestureDetector;
      barrier.onTap!();
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('arayaOverlayBarrier')), findsNothing);
    });
    testWidgets('SnackBar as Overlay must has a spinner',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          _buildTestableWidget(const FakeScreen(child: ArayaOverlayLoading())));
      await tester.pump();
      ElevatedButton button = find
          .widgetWithText(ElevatedButton, 'Show Snackbar')
          .evaluate()
          .first
          .widget as ElevatedButton;
      button.onPressed!();
      await tester.pump(const Duration(seconds: 1));
      final spinner = find.byKey(const Key('spinner'));
      expect(spinner, findsOneWidget);
    });
  });
}
