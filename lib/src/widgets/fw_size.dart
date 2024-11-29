import 'package:flutter/widgets.dart';

class FwSize extends StatelessWidget {
  FwSize({
    super.key,
    required this.spacingMultiplier,
    required this.spacings,
    required this.findValueForClass,
    required this.child,
  });

  final double spacingMultiplier;
  final List<String> spacings;
  final T Function<T>(
    Map<String, T> lookup,
    T defaultValue,
  ) findValueForClass;
  final Widget child;

  late final Map<String, double> _lookupSize = {
    "size-full": double.infinity,
    for (final size in spacings)
      'size-$size': double.parse(size) * spacingMultiplier,
  };

  late final Map<String, double> _lookupHeight = {
    "h-full": double.infinity,
    for (final size in spacings)
      'h-$size': double.parse(size) * spacingMultiplier,
  };

  late final Map<String, double> _lookupWidth = {
    "w-full": double.infinity,
    for (final size in spacings)
      'w-$size': double.parse(size) * spacingMultiplier,
  };

  @override
  Widget build(BuildContext context) {
    double? size = findValueForClass(
      _lookupSize,
      null,
    );

    if (size != null) {
      return SizedBox(
        height: size,
        width: size,
        child: child,
      );
    }

    double? height = findValueForClass(
      _lookupHeight,
      null,
    );

    double? width = findValueForClass(
      _lookupWidth,
      null,
    );

    if (height == null && width == null) {
      return child;
    }

    // dpl('height: $height, width: $width');

    return SizedBox(
      height: height,
      width: width,
      child: child,
    );
  }
}
