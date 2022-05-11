library araya_core_screen;

import 'package:flutter/material.dart';

/// Create fullscreen overlay use endDrawer attribute of Scaffold
///
/// to close this overlay use Navigator.pop.
class ArayaOverlay extends StatelessWidget {
  const ArayaOverlay({
    Key? key,
    required this.childBuilder,
    this.barrierDismissible = false,
  }) : super(key: key);

  final Widget Function(BuildContext context) childBuilder;
  final bool barrierDismissible;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          GestureDetector(
            key: const Key('arayaOverlayBarrier'),
            onTap: barrierDismissible ? () => Navigator.pop(context) : null,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
          childBuilder(context),
        ],
      ),
    );
  }
}

/// Create fullscreen overlay CircularProgressIndicator,
/// use endDrawer attribute of Scaffold.
///
/// to close this overlay use Navigator.pop.
class ArayaOverlayLoading extends StatelessWidget {
  const ArayaOverlayLoading({
    Key? key,
    this.loadingDismissible = false,
  }) : super(key: key);

  final bool loadingDismissible;

  @override
  Widget build(BuildContext context) {
    return ArayaOverlay(
      childBuilder: (cContext) => Center(
        child: GestureDetector(
          key: const Key('spinnerTapDetector'),
          onTap: loadingDismissible ? () => Navigator.pop(context) : null,
          child: const CircularProgressIndicator(key: Key('spinner')),
        ),
      ),
    );
  }
}

class ArayaSnackBar {
  /// Create fullscreen overlay CircularProgressIndicator, use custom SnackBar.
  static SnackBar loadingOverlay(
    BuildContext context, {
    Duration duration = const Duration(seconds: 4),
  }) {
    return SnackBar(
      content: SizedBox(
        height: double.infinity,
        child: Center(
          child: CircularProgressIndicator(
            key: const Key('spinner'),
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      backgroundColor: Colors.black38,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      dismissDirection: DismissDirection.none,
      duration: duration,
    );
  }
}
