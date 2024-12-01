import 'package:flutter/widgets.dart';

class FwSize extends StatelessWidget {
  const FwSize({
    super.key,
    required this.findValueForClass,
    required this.sizes,
    required this.widths,
    required this.heights,
    required this.child,
  });

  final Map<String, Size> sizes;
  final Map<String, double> widths;
  final Map<String, double> heights;

  final T Function<T>(
    Map<String, T> lookup,
    T defaultValue,
  ) findValueForClass;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = findValueForClass(
      sizes,
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
      heights,
      null,
    );

    double? width = findValueForClass(
      widths,
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
