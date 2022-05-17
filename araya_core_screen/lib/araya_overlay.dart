library araya_core_screen;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'araya_core_screen.dart';

/// Create base fullscreen overlay
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

/// create custom overlay card container modal-like.
class ArayaCardModal extends StatelessWidget with ArayaCoreScreenImpl {
  const ArayaCardModal({
    required Key key,
    this.width = 0,
    this.title = '',
    required this.body,
    this.actions,
    this.alignActions = MainAxisAlignment.end,
  }) : super(key: key);

  final double width;
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final MainAxisAlignment alignActions;

  @override
  Widget build(BuildContext context) {
    ScreenSize screenSize = super.buildScreenSize(context);
    return ArayaOverlay(
      childBuilder: (context) => Semantics(
        label: '$title modals',
        container: true,
        child: SizedBox(
          child: Align(
            child: Material(
              borderRadius: BorderRadius.circular(6.0),
              elevation: 3,
              child: Container(
                key: key,
                constraints: BoxConstraints(
                  minWidth: 100,
                  maxWidth: _setupMaxWidth(screenSize),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context),
                    _buildBody(context),
                    _buildActions(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        height: 46.0,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6.0),
              topRight: Radius.circular(6.0),
            )),
        padding: const EdgeInsets.fromLTRB(12, 8, 7, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              semanticsLabel: title,
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline6
                  ?.copyWith(fontSize: 18),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: InkWell(
                key: const Key('closeArayaCardModal'),
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close_rounded,
                  color: Theme.of(context).primaryIconTheme.color,
                  semanticLabel: 'close modal icons',
                ),
              ),
            ),
          ],
        ),
      );

  /// create content body
  Widget _buildBody(BuildContext context) => Container(
        padding: const EdgeInsets.all(12.0),
        child: body,
      );

  /// typically create buttons
  Widget _buildActions(BuildContext context) {
    if (actions == null) return const SizedBox();

    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: alignActions,
          children: actions!
              .mapIndexed((index, element) => Padding(
                    padding: EdgeInsets.only(left: index > 0 ? 8.0 : 0.0),
                    child: element,
                  ))
              .toList(),
        ),
      ),
    );
  }

  /// determine width of this widget.
  ///
  /// if [width] greater than screenSize.width * 0.9
  /// then return screenSize.width * 0.9.
  ///
  /// if [width] less 200 then return 200
  double _setupMaxWidth(ScreenSize screenSize) {
    if (width > 0 && width < 200) return 200;
    if (width > 0 && width <= screenSize.width * 0.9) return width;
    return screenSize.width * 0.9;
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
