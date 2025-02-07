part of 'style.dart';

class FlexStyle extends Style {
  const FlexStyle({
    this.direction,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.spacing,
    this.sizeClass,
  });

  final Axis? direction;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final CrossAxisAlignment? crossAxisAlignment;
  final Spacing? spacing;

  final SizeClass? sizeClass;

  FlexStyle applyAt(SizeClass sizeClass) {
    return FlexStyle(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      sizeClass: sizeClass,
    );
  }

  FlexStyle get sm => applyAt(SizeClass.sm);

  FlexStyle get md => applyAt(SizeClass.md);

  FlexStyle get lg => applyAt(SizeClass.lg);

  FlexStyle get xl => applyAt(SizeClass.xl);

  FlexStyle get xxl => applyAt(SizeClass.xxl);

  FlexStyle mergeWith(FlexStyle other, FollowingWindData fw) {
    // choose which properties to keep based on sizeClass and screenWidth
    final useOther = fw.screenSize.width >= fw.sizeForClass(other.sizeClass);

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
