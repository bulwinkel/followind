import 'package:flutter/widgets.dart';

import '../parser.dart';
import '../support_internal.dart';

//TODO:KB 1/12/2024 this needs more testing
class DecoratedBoxParser extends BaseParser {
  static const bg = 'bg';
  static const border = 'border';
  static const rounded = 'rounded';

  static const order = [
    bg,
    rounded,
    border,
  ];

  DecoratedBoxParser({
    required super.fw,
    super.classPrefixes = order,
  });

  @override
  Widget apply(Widget child) {
    sort();
    if (values.isEmpty) return child;
    // dpl('values: ${values.map((e) => "${e.type}-${e.value}").toList()}');

    Color? bgColor;

    // rounded corners
    double? bottomLeft;
    double? bottomRight;
    double? topLeft;
    double? topRight;

    // border color
    var (
      colorBottom,
      colorLeft,
      colorRight,
      colorTop,
    ) = (null, null, null, null) as BLRT<Color>;

    // border width
    var (
      widthBottom,
      widthLeft,
      widthRight,
      widthTop,
    ) = (null, null, null, null) as BLRT<double>;

    for (final parsed in values) {
      if (parsed.applyAtWidth != 0.0 &&
          parsed.applyAtWidth > fw.screenSize.width) {
        continue;
      }

      // -- background color
      if (parsed.type == bg) {
        if (parsed.value == 'white') {
          bgColor = const Color(0xffffffff);
          continue;
        }

        if (parsed.value == 'black') {
          bgColor = const Color(0xff000000);
          continue;
        }

        final [c, s] = parsed.value.split('-');
        bgColor = fw.colors[c]?[int.parse(s)];
      }

      // -- border radius
      else if (parsed.type == rounded) {
        final corners = fw.borderRadiuses[parsed.value];
        if (corners == null) continue;
        var (bl, br, tl, tr) = corners;
        bottomLeft = bl ?? bottomLeft;
        bottomRight = br ?? bottomRight;
        topLeft = tl ?? topLeft;
        topRight = tr ?? topRight;
      }

      // -- border size and color
      else if (parsed.type == border) {
        final colors = fw.borderColors[parsed.value];
        if (colors != null) {
          final (b, l, r, t) = colors;
          colorBottom = b ?? colorBottom;
          colorLeft = l ?? colorLeft;
          colorRight = r ?? colorRight;
          colorTop = t ?? colorTop;
        }

        final widths = fw.borderWidths[parsed.value];
        if (widths != null) {
          final (b, l, r, t) = widths;
          widthBottom = b ?? widthBottom;
          widthLeft = l ?? widthLeft;
          widthRight = r ?? widthRight;
          widthTop = t ?? widthTop;
        }
      }
    }

    // dpl("widthBottom: $widthBottom, widthLeft: $widthLeft, widthRight: $widthRight, widthTop: $widthTop");

    // if any widths then we apply a border using the default color
    final borderColor = fw.borderColor;
    Border? b;
    if (widthBottom != null ||
        widthLeft != null ||
        widthRight != null ||
        widthTop != null) {
      b = Border(
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

    BorderRadius? borderRadius;
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

    final shouldWrap =
        bgColor != null || borderRadius != null || border != null;

    // dpl("shouldWrap: $shouldWrap");

    if (!shouldWrap) {
      return child;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
        border: b,
      ),
      child: child,
    );
  }
}
