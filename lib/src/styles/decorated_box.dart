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
  DecoratedBoxStyle get border =>
      DecoratedBoxStyle(border: Border.all(color: this));
}

extension RoundedNumX on num {
  Style get rounded => DecoratedBoxStyle(
    borderRadius: BorderRadius.all(Radius.circular(toDouble())),
  );
}

extension BorderNumX on num {
  DecoratedBoxStyle get border => DecoratedBoxStyle(
    border: Border.all(color: Color(0xFF000000), width: toDouble()),
  );
}

extension ColorNumX on num {
  Color get slate => colors['slate']![toInt()]!;
  Color get gray => colors['gray']![toInt()]!;
  Color get zinc => colors['zinc']![toInt()]!;
  Color get neutral => colors['neutral']![toInt()]!;
  Color get stone => colors['stone']![toInt()]!;
  Color get red => colors['red']![toInt()]!;
  Color get orange => colors['orange']![toInt()]!;
  Color get amber => colors['amber']![toInt()]!;
  Color get yellow => colors['yellow']![toInt()]!;
  Color get lime => colors['lime']![toInt()]!;
  Color get green => colors['green']![toInt()]!;
  Color get emerald => colors['emerald']![toInt()]!;
  Color get teal => colors['teal']![toInt()]!;
  Color get cyan => colors['cyan']![toInt()]!;
  Color get sky => colors['sky']![toInt()]!;
  Color get blue => colors['blue']![toInt()]!;
  Color get indigo => colors['indigo']![toInt()]!;
  Color get violet => colors['violet']![toInt()]!;
  Color get purple => colors['purple']![toInt()]!;
  Color get fuchsia => colors['fuchsia']![toInt()]!;
  Color get pink => colors['pink']![toInt()]!;
  Color get rose => colors['rose']![toInt()]!;
}
