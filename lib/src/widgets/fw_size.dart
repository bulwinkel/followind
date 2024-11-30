import 'package:flutter/widgets.dart';

class FwSize extends StatelessWidget {
  const FwSize({
    super.key,
    required this.findValueForClass,
    required this.lookupSize,
    required this.lookupWidth,
    required this.lookupHeight,
    required this.child,
  });

  final Map<String, Size> lookupSize;
  final Map<String, double> lookupWidth;
  final Map<String, double> lookupHeight;

  final T Function<T>(
    Map<String, T> lookup,
    T defaultValue,
  ) findValueForClass;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = findValueForClass(
      lookupSize,
      null,
    );

    if (size != null) {
      return SizedBox(
        height: size.height,
        width: size.width,
        child: child,
      );
    }

    double? height = findValueForClass(
      lookupHeight,
      null,
    );

    double? width = findValueForClass(
      lookupWidth,
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
