library araya_core_screen;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

abstract class ScreenSize {
  /// get screen width.
  double get width;

  /// get screen height.
  double get height;

  /// get screen ratio.
  double get ratio;

  /// get default maxMobileWidth.
  double get maxMobileWidth;

  /// get default maxMobileLSWidth.
  double get maxMobileLSWidth;

  /// get default maxTabledWidth.
  double get maxTabledWidth;

  /// get default maxLaptopWidth.
  double get maxLaptopWidth;

  /// get default maxDesktopWidth.
  double get maxDesktopWidth;

  /// Screen max width mobile devices (Potrait).
  ///
  /// [decrease] to decrease calculation screen width.
  bool isMobile({double decrease = 0});

  /// Screen max width mobile devices (Landscape).
  ///
  /// [decrease] to decrease calculation screen width.
  bool isMobileLS({double decrease = 0});

  /// Screen max width Tablets, Ipads.
  ///
  /// [decrease] to decrease calculation screen width.
  bool isTablet({double decrease = 0});

  /// Screen max width Laptop.
  ///
  /// [decrease] to decrease calculation screen width.
  bool isLaptop({double decrease = 0});

  // Screen max width Desktop.
  ///
  /// [decrease] to decrease calculation screen width.
  bool isDestop({double decrease = 0});
}

class _ScreenSizeDictionary extends ScreenSize {
  _ScreenSizeDictionary(BuildContext context) {
    _context = context;
  }
  late BuildContext _context;

  /// get screen width
  @override
  double get width => MediaQuery.of(_context).size.width;

  /// get screen height
  @override
  double get height => MediaQuery.of(_context).size.height;

  /// get screen ratio
  @override
  double get ratio => _context.size!.aspectRatio;

  /// get default maxMobileWidth
  @override
  double get maxMobileWidth => 480;

  /// get default maxMobileLSWidth
  @override
  double get maxMobileLSWidth => 767;

  /// get default maxTabledWidth
  @override
  double get maxTabledWidth => 1024;

  /// get default maxLaptopWidth
  @override
  double get maxLaptopWidth => 1280;

  /// get default maxDesktopWidth
  @override
  double get maxDesktopWidth => 1281;

  /// Screen max width mobile devices (Potrait)
  @override
  bool isMobile({double decrease = 0}) => width <= (maxMobileWidth - decrease);

  /// Screen max width mobile devices (Landscape)
  @override
  bool isMobileLS({double decrease = 0}) =>
      width > (maxMobileWidth - decrease) &&
      width <= (maxMobileLSWidth - decrease);

  /// Screen max width Tablets, Ipads
  @override
  bool isTablet({double decrease = 0}) =>
      width > (maxMobileLSWidth - decrease) &&
      width <= (maxTabledWidth - decrease);

  /// Screen max width Laptop
  @override
  bool isLaptop({double decrease = 0}) =>
      width > (maxTabledWidth - decrease) &&
      width <= (maxLaptopWidth - decrease);

  // Screen max width Desktop
  @override
  bool isDestop({double decrease = 0}) => width > (maxLaptopWidth - decrease);
}

abstract class ArayaCoreScreenImpl {
  /// Call `super.buildScreenSize` inside `build` method
  /// when using `ArayaScreenSizeImpl`.
  /// to get screen size.
  @mustCallSuper
  ScreenSize buildScreenSize(BuildContext context) {
    return _ScreenSizeDictionary(context);
  }

  /// Call `super.setApplicationSwitcherDescription` inside `build` method
  ///
  /// Dynamic app title in Flutter. required [context] BuildContext,
  /// reuired [title] String.
  ///
  /// Specifies the description of the current state of the application as it
  /// pertains to the application switcher (also known as "recent tasks").
  ///
  /// implement SystemChrome.setApplicationSwitcherDescription(
  /// ApplicationSwitcherDescription(String title) ).
  @mustCallSuper
  void setApplicationSwitcherDescription(BuildContext context, String title) {
    SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(label: title),
    );
  }
}
