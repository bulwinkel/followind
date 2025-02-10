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

const row = FlexStyle(direction: Axis.horizontal);
const col = FlexStyle(direction: Axis.vertical);
const mainStart = FlexStyle(mainAxisAlignment: MainAxisAlignment.start);
const mainEnd = FlexStyle(mainAxisAlignment: MainAxisAlignment.end);
const mainCenter = FlexStyle(mainAxisAlignment: MainAxisAlignment.center);
const mainBetween =
    FlexStyle(mainAxisAlignment: MainAxisAlignment.spaceBetween);
const mainAround = FlexStyle(mainAxisAlignment: MainAxisAlignment.spaceAround);
const mainEvenly = FlexStyle(mainAxisAlignment: MainAxisAlignment.spaceEvenly);
const mainMin = FlexStyle(mainAxisSize: MainAxisSize.min);
const mainMax = FlexStyle(mainAxisSize: MainAxisSize.max);
const crossStart = FlexStyle(crossAxisAlignment: CrossAxisAlignment.start);
const crossEnd = FlexStyle(crossAxisAlignment: CrossAxisAlignment.end);
const crossCenter = FlexStyle(crossAxisAlignment: CrossAxisAlignment.center);
const crossStretch = FlexStyle(crossAxisAlignment: CrossAxisAlignment.stretch);
const crossBaseline =
    FlexStyle(crossAxisAlignment: CrossAxisAlignment.baseline);

extension SpacingPagStyles on Spacing {
  FlexStyle get gap => FlexStyle(spacing: this);
}

extension GapStyles on num {
  FlexStyle get gap => FlexStyle(spacing: s);
}
