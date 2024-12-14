import 'package:following_wind/src/support_internal.dart';

import '../following_wind.dart';
import '../parser.dart';

typedef ParsedSize = ({
  double? height,
  double? width,
});

class SizeParser implements Parser<ParsedSize> {
  static const String sizeKey = 'size';
  static const String heightKey = 'h';
  static const String widthKey = 'w';

  static const order = [sizeKey, heightKey, widthKey];

  SizeParser(this.fw);

  final FollowingWindData fw;

  final List<ParsedClass> _parsedClasses = [];

  @override
  ParsedSize? get result {
    if (_parsedClasses.isEmpty) return null;
    _parsedClasses.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    // dpl("parsedClasses: $_parsedClasses");

    double? height;
    double? width;

    for (final parsed in _parsedClasses) {
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
      return null;
    }

    return (height: height, width: width);
  }

  @override
  bool parse(String className) {
    final (consumed, parsed) = parseClass(
      className,
      order,
      fw.sizeClasses,
    );
    if (parsed != null) _parsedClasses.add(parsed);
    return consumed;
  }
}
