part of 'style.dart';

class FlexStyle extends Style {
  const FlexStyle({
    this.direction,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.spacing,
  });

  final Axis? direction;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final CrossAxisAlignment? crossAxisAlignment;
  final Spacing? spacing;

  Style applyAt(SizeClass sizeClass) {
    return SizeClassStyle(
      sizeClass: sizeClass,
      style: FlexStyle(
        direction: direction,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        spacing: spacing,
      ),
    );
  }

  Style get sm => applyAt(SizeClass.sm);
  Style get md => applyAt(SizeClass.md);
  Style get lg => applyAt(SizeClass.lg);
  Style get xl => applyAt(SizeClass.xl);
  Style get xxl => applyAt(SizeClass.xxl);

  FlexStyle mergeWith(FlexStyle other, FollowingWindData fw) {
    return FlexStyle(
      direction: other.direction ?? direction,
      mainAxisAlignment: other.mainAxisAlignment ?? mainAxisAlignment,
      mainAxisSize: other.mainAxisSize ?? mainAxisSize,
      crossAxisAlignment: other.crossAxisAlignment ?? crossAxisAlignment,
      spacing: other.spacing ?? spacing,
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
          crossAxisAlignment == other.crossAxisAlignment &&
          spacing == other.spacing;

  @override
  int get hashCode =>
      direction.hashCode ^
      mainAxisAlignment.hashCode ^
      mainAxisSize.hashCode ^
      crossAxisAlignment.hashCode ^
      spacing.hashCode;

  @override
  String toString() {
    return 'FlexStyle{direction: $direction, mainAxisAlignment: $mainAxisAlignment, mainAxisSize: $mainAxisSize, crossAxisAlignment: $crossAxisAlignment, spacing: $spacing}';
  }
}
