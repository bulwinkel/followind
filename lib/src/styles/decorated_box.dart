part of "style.dart";

class DecoratedBoxStyle extends Style {
  const DecoratedBoxStyle({
    this.color,
    this.image,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.backgroundBlendMode,
    this.shape,
  });

  final Color? color;
  final DecorationImage? image;
  final BoxBorder? border;

  // TODO:KB 10/2/2025 create a wrapper for this
  // so we can merge values
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final BlendMode? backgroundBlendMode;
  final BoxShape? shape;

  DecoratedBoxStyle mergeWith(DecoratedBoxStyle other) {
    return DecoratedBoxStyle(
      color: other.color ?? color,
      image: other.image ?? image,
      border: other.border ?? border,
      borderRadius: other.borderRadius ?? borderRadius,
      boxShadow: other.boxShadow ?? boxShadow,
      gradient: other.gradient ?? gradient,
      backgroundBlendMode: other.backgroundBlendMode ?? backgroundBlendMode,
      shape: other.shape ?? shape,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DecoratedBoxStyle &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          image == other.image &&
          border == other.border &&
          borderRadius == other.borderRadius &&
          boxShadow == other.boxShadow &&
          gradient == other.gradient &&
          backgroundBlendMode == other.backgroundBlendMode &&
          shape == other.shape;

  @override
  int get hashCode =>
      color.hashCode ^
      image.hashCode ^
      border.hashCode ^
      borderRadius.hashCode ^
      boxShadow.hashCode ^
      gradient.hashCode ^
      backgroundBlendMode.hashCode ^
      shape.hashCode;

  @override
  String toString() {
    return 'DecoratedBoxStyle{color: $color, image: $image, border: $border, borderRadius: $borderRadius, boxShadow: $boxShadow, gradient: $gradient, backgroundBlendMode: $backgroundBlendMode, shape: $shape}';
  }
}

extension ColorDecoratedBoxStyles on Color {
  DecoratedBoxStyle get bg => DecoratedBoxStyle(color: this);
}

extension RoundedDecoratedBoxStyles on BorderRadius {
  DecoratedBoxStyle get rounded => DecoratedBoxStyle(borderRadius: this);
}

extension RoundedNumX on int {
  Style get rounded => DecoratedBoxStyle(
      borderRadius: BorderRadius.all(Radius.circular(toDouble())));
}
