part of 'style.dart';

class SizeStyle extends Style {
  const SizeStyle({
    this.minHeight,
    this.minWidth,
    this.maxHeight,
    this.maxWidth,
  });

  final Spacing? minHeight;
  final Spacing? minWidth;

  final Spacing? maxHeight;
  final Spacing? maxWidth;

  SizeStyle mergeWith(SizeStyle other) {
    return SizeStyle(
      minHeight: other.minHeight ?? minHeight,
      minWidth: other.minWidth ?? minWidth,
      maxHeight: other.maxHeight ?? maxHeight,
      maxWidth: other.maxWidth ?? maxWidth,
    );
  }

  BoxConstraints? unpack(FollowindConfig fw) {
    if (minHeight != null &&
        minWidth != null &&
        maxHeight != null &&
        maxWidth != null) {
      return null;
    }

    return BoxConstraints(
      minHeight: minHeight?.unpack(fw) ?? 0,
      minWidth: minWidth?.unpack(fw) ?? 0,
      maxHeight: maxHeight?.unpack(fw) ?? double.infinity,
      maxWidth: maxWidth?.unpack(fw) ?? double.infinity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SizeStyle &&
          runtimeType == other.runtimeType &&
          minHeight == other.minHeight &&
          minWidth == other.minWidth &&
          maxHeight == other.maxHeight &&
          maxWidth == other.maxWidth;

  @override
  int get hashCode =>
      minHeight.hashCode ^
      minWidth.hashCode ^
      maxHeight.hashCode ^
      maxWidth.hashCode;

  @override
  String toString() {
    return 'SizeStyle{minHeight: $minHeight, minWidth: $minWidth, maxHeight: $maxHeight, maxWidth: $maxWidth}';
  }
}

extension NumSizeStyleX on num {
  Style get width => dp.width;

  Style get height => dp.height;

  Style get size => dp.size;

  Style get minWidth => dp.minWidth;

  Style get minHeight => dp.minHeight;

  Style get maxWidth => dp.maxWidth;

  Style get maxHeight => dp.maxHeight;

  Style get w => dp.width;

  Style get h => dp.height;

  Style get minW => dp.minWidth;

  Style get minH => dp.minHeight;

  Style get maxW => dp.maxWidth;

  Style get maxH => dp.maxHeight;
}

extension SpacingSizeStyleX on Spacing {
  Style get width => SizeStyle(minWidth: this, maxWidth: this);

  Style get height => SizeStyle(minHeight: this, maxHeight: this);

  Style get size => SizeStyle(
    minHeight: this,
    maxHeight: this,
    minWidth: this,
    maxWidth: this,
  );

  Style get minWidth => SizeStyle(minWidth: this);

  Style get minHeight => SizeStyle(minHeight: this);

  Style get maxWidth => SizeStyle(maxWidth: this);

  Style get maxHeight => SizeStyle(maxHeight: this);

  Style get w => width;

  Style get h => height;

  Style get minW => minWidth;

  Style get minH => minHeight;

  Style get maxW => maxWidth;

  Style get maxH => maxHeight;
}
