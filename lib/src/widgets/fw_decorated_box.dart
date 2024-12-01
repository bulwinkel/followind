import 'package:flutter/widgets.dart';

import '../support_internal.dart';

//TODO:KB 1/12/2024 this needs more testing
class FwDecoratedBox extends StatelessWidget {
  const FwDecoratedBox({
    super.key,
    required this.classes,
    required this.bgColors,
    required this.borderColor,
    required this.borderColors,
    required this.borderWidths,
    required this.borderRadiuses,
    required this.child,
  });

  final List<String> classes;
  final Map<String, Color> bgColors;
  final Color borderColor;
  final Map<String, BLRT<Color>> borderColors;
  final Map<String, BLRT<double>> borderWidths;
  final Map<String, Corners<double>> borderRadiuses;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    BorderRadius? borderRadius;
    Border? border;

    // -- bg color
    for (final entry in bgColors.entries) {
      if (classes.contains(entry.key)) {
        bgColor = entry.value;
        break;
      }
    }

    // -- border radius

    double? bottomLeft;
    double? bottomRight;
    double? topLeft;
    double? topRight;
    for (final entry in borderRadiuses.entries) {
      // more specific values override less specific values
      if (classes.contains(entry.key)) {
        var (bl, br, tl, tr) = entry.value;
        bottomLeft = bl ?? bottomLeft;
        bottomRight = br ?? bottomRight;
        topLeft = tl ?? topLeft;
        topRight = tr ?? topRight;
      }
    }

    if (bottomLeft != null ||
        bottomRight != null ||
        topLeft != null ||
        topRight != null) {
      borderRadius = BorderRadius.only(
        bottomLeft: Radius.circular(bottomLeft ?? 0),
        bottomRight: Radius.circular(bottomRight ?? 0),
        topLeft: Radius.circular(topLeft ?? 0),
        topRight: Radius.circular(topRight ?? 0),
      );
    }

    // -- border
    var (
      colorBottom,
      colorLeft,
      colorRight,
      colorTop,
    ) = (null, null, null, null) as BLRT<Color>;
    for (final entry in borderColors.entries) {
      if (classes.contains(entry.key)) {
        final (b, l, r, t) = entry.value;
        colorBottom = b ?? colorBottom;
        colorLeft = l ?? colorLeft;
        colorRight = r ?? colorRight;
        colorTop = t ?? colorTop;
      }
    }

    // dpl("colorBottom: $colorBottom, colorLeft: $colorLeft, colorRight: $colorRight, colorTop: $colorTop");

    var (
      widthBottom,
      widthLeft,
      widthRight,
      widthTop,
    ) = (null, null, null, null) as BLRT<double>;
    for (final entry in borderWidths.entries) {
      if (classes.contains(entry.key)) {
        final (b, l, r, t) = entry.value;
        widthBottom = b ?? widthBottom;
        widthLeft = l ?? widthLeft;
        widthRight = r ?? widthRight;
        widthTop = t ?? widthTop;
      }
    }

    // dpl("widthBottom: $widthBottom, widthLeft: $widthLeft, widthRight: $widthRight, widthTop: $widthTop");

    // if any widths then we apply a border using the default color
    if (widthBottom != null ||
        widthLeft != null ||
        widthRight != null ||
        widthTop != null) {
      border = Border(
        bottom: BorderSide(
          color: colorBottom ?? borderColor,
          width: widthBottom ?? 0,
        ),
        left: BorderSide(
          color: colorLeft ?? borderColor,
          width: widthLeft ?? 0,
        ),
        right: BorderSide(
          color: colorRight ?? borderColor,
          width: widthRight ?? 0,
        ),
        top: BorderSide(
          color: colorTop ?? borderColor,
          width: widthTop ?? 0,
        ),
      );
    }
    // dpl("border: $border");

    final shouldWrap =
        bgColor != null || borderRadius != null || border != null;

    // dpl("shouldWrap: $shouldWrap");

    if (!shouldWrap) {
      return child;
    }

    //TODO:KB 1/12/2024 support more properties of decorated box

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
        border: border,
      ),
      child: child,
    );
  }
}
