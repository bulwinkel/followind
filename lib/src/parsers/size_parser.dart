import 'package:flutter/widgets.dart';
import 'package:following_wind/src/support_internal.dart';

import '../following_wind.dart';
import '../parser.dart';

typedef ParsedSize = ({
  double? height,
  double? width,
});

class SizeParser extends BaseParser {
  static const String sizeKey = 'size';
  static const String heightKey = 'h';
  static const String widthKey = 'w';

  static const order = [sizeKey, heightKey, widthKey];

  SizeParser({
    required super.fw,
    super.classPrefixes = order,
  });

  @override
  Widget apply(Widget child) {
    sort();
    if (values.isEmpty) return child;

    double? height;
    double? width;

    for (final parsed in values) {
      // skip any that are not for the current screen size
      // dpl("applyAtWidth: ${parsed.applyAtWidth}, screenWidth: ${fw.screenSize.width}");
      if (parsed.applyAtWidth != 0.0 &&
          parsed.applyAtWidth > fw.screenSize.width) {
        continue;
      }

      final d = fw.spacings[parsed.value];
      final size = fw.fractionals[parsed.value];
      // dpl("d: $d, size: $size");

      //TODO:KB 9/12/2024 handle custom sizes

      if (parsed.type == sizeKey) {
        if (d != null) {
          height = d;
          width = d;
        } else if (size != null) {
          height = size.height;
          width = size.width;
        }
        continue;
      }

      if (parsed.type == heightKey) {
        height = d ?? size?.height;
        continue;
      }

      if (parsed.type == widthKey) {
        width = d ?? size?.width;
      }
    }

    if (height == null && width == null) {
      return child;
    }

    return SizedBox(
      height: height,
      width: width,
      child: child,
    );
  }
}
