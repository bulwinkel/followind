part of 'style.dart';

class FlexStyle extends Style {
  const FlexStyle({
    this.direction,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.spacing,
    this.sizeClass = 0,
  });

  final Axis? direction;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final CrossAxisAlignment? crossAxisAlignment;
  final Spacing? spacing;

  final double sizeClass;

  FlexStyle applyAt(double sizeClass) {
    return FlexStyle(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      sizeClass: sizeClass,
    );
  }

  FlexStyle get sm => applyAt(600);

  FlexStyle get md => applyAt(768);

  FlexStyle get lg => applyAt(1024);

  FlexStyle get xl => applyAt(1280);

  FlexStyle get xxl => applyAt(1536);

  FlexStyle mergeWith(FlexStyle other, double screenWidth) {
    // choose which properties to keep based on sizeClass and screenWidth
    final useOther = screenWidth >= other.sizeClass;

    final d = useOther && other.direction != null ? other.direction : direction;

    return FlexStyle(
      direction: d,
      mainAxisAlignment: useOther && other.mainAxisAlignment != null
          ? other.mainAxisAlignment
          : mainAxisAlignment,
      mainAxisSize: useOther && other.mainAxisSize != null
          ? other.mainAxisSize
          : mainAxisSize,
      crossAxisAlignment: useOther && other.crossAxisAlignment != null
          ? other.crossAxisAlignment
          : crossAxisAlignment,
      spacing: useOther && other.spacing != null ? other.spacing : spacing,
      sizeClass: sizeClass,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlexStyle &&
          runtimeType == other.runtimeType &&
          direction == other.direction &&
          mainAxisAlignment == other.mainAxisAlignment &&
          mainAxisSize == other.mainAxisSize &&
          crossAxisAlignment == other.crossAxisAlignment;

  @override
  int get hashCode =>
      direction.hashCode ^
      mainAxisAlignment.hashCode ^
      mainAxisSize.hashCode ^
      crossAxisAlignment.hashCode;

  @override
  String toString() {
    return 'FlexStyle{direction: $direction, mainAxisAlignment: $mainAxisAlignment, mainAxisSize: $mainAxisSize, crossAxisAlignment: $crossAxisAlignment, spacing: $spacing, sizeClass: $sizeClass}';
  }
}
