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
  final BorderSubStyle? border;

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
      border: border?.mergeWith(other.border) ?? other.border,
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

class BorderSubStyle {
  const BorderSubStyle({this.top, this.right, this.bottom, this.left});

  const BorderSubStyle.all(BorderSideSubStyle all)
    : top = all,
      right = all,
      bottom = all,
      left = all;

  final BorderSideSubStyle? top;
  final BorderSideSubStyle? right;
  final BorderSideSubStyle? bottom;
  final BorderSideSubStyle? left;

  BorderSubStyle mergeWith(BorderSubStyle? other) {
    return BorderSubStyle(
      top: top?.mergeWith(other?.top) ?? other?.top,
      right: right?.mergeWith(other?.right) ?? other?.right,
      bottom: bottom?.mergeWith(other?.bottom) ?? other?.bottom,
      left: left?.mergeWith(other?.left) ?? other?.left,
    );
  }

  Border? unpack() {
    if (top == null && right == null && bottom == null && left == null) {
      return null;
    }

    return Border(
      top: top?.unpack() ?? BorderSide.none,
      right: right?.unpack() ?? BorderSide.none,
      bottom: bottom?.unpack() ?? BorderSide.none,
      left: left?.unpack() ?? BorderSide.none,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BorderSubStyle &&
          runtimeType == other.runtimeType &&
          top == other.top &&
          right == other.right &&
          bottom == other.bottom &&
          left == other.left;

  @override
  int get hashCode =>
      top.hashCode ^ right.hashCode ^ bottom.hashCode ^ left.hashCode;

  @override
  String toString() {
    return 'BorderSubStyle{top: $top, right: $right, bottom: $bottom, left: $left}';
  }
}

class BorderSideSubStyle {
  static const none = BorderSideSubStyle(width: 0.0, style: BorderStyle.none);

  const BorderSideSubStyle({this.color, this.width, this.style});

  final Color? color;
  final double? width;
  final BorderStyle? style;

  BorderSideSubStyle mergeWith(BorderSideSubStyle? other) {
    return BorderSideSubStyle(
      color: other?.color ?? color,
      width: other?.width ?? width,
      style: other?.style ?? style,
    );
  }

  BorderSide? unpack() {
    // if all null then return null
    if (color == null && width == null && style == null) {
      return null;
    }

    // otherwise use defaults
    return BorderSide(
      color: color ?? colors['gray']![200]!,
      width: width ?? 1,
      style: style ?? BorderStyle.solid,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BorderSideSubStyle &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          width == other.width &&
          style == other.style;

  @override
  int get hashCode => color.hashCode ^ width.hashCode ^ style.hashCode;

  @override
  String toString() {
    return 'BorderSideSubStyle{color: $color, width: $width, style: $style}';
  }
}

extension ColorDecoratedBoxStyles on Color {
  DecoratedBoxStyle get bg => DecoratedBoxStyle(color: this);

  DecoratedBoxStyle get border => DecoratedBoxStyle(
    border: BorderSubStyle.all(BorderSideSubStyle(color: this)),
  );
}

extension RoundedNumX on num {
  Style get rounded => DecoratedBoxStyle(
    borderRadius: BorderRadius.all(Radius.circular(toDouble())),
  );
}

extension BorderNumX on num {
  DecoratedBoxStyle get border {
    return DecoratedBoxStyle(
      border: BorderSubStyle.all(switch (this) {
        0 => BorderSideSubStyle.none,
        _ => BorderSideSubStyle(width: toDouble()),
      }),
    );
  }

  DecoratedBoxStyle get borderTop {
    return DecoratedBoxStyle(
      border: BorderSubStyle(
        top: switch (this) {
          0 => BorderSideSubStyle.none,
          _ => BorderSideSubStyle(width: toDouble()),
        },
      ),
    );
  }

  DecoratedBoxStyle get borderRight {
    return DecoratedBoxStyle(
      border: BorderSubStyle(
        right: switch (this) {
          0 => BorderSideSubStyle.none,
          _ => BorderSideSubStyle(width: toDouble()),
        },
      ),
    );
  }

  DecoratedBoxStyle get borderBottom {
    return DecoratedBoxStyle(
      border: BorderSubStyle(
        bottom: switch (this) {
          0 => BorderSideSubStyle.none,
          _ => BorderSideSubStyle(width: toDouble()),
        },
      ),
    );
  }

  DecoratedBoxStyle get borderLeft {
    return DecoratedBoxStyle(
      border: BorderSubStyle(
        left: switch (this) {
          0 => BorderSideSubStyle.none,
          _ => BorderSideSubStyle(width: toDouble()),
        },
      ),
    );
  }

  DecoratedBoxStyle get borderX {
    return DecoratedBoxStyle(
      border: BorderSubStyle(
        left: switch (this) {
          0 => BorderSideSubStyle.none,
          _ => BorderSideSubStyle(width: toDouble()),
        },
        right: switch (this) {
          0 => BorderSideSubStyle.none,
          _ => BorderSideSubStyle(width: toDouble()),
        },
      ),
    );
  }

  DecoratedBoxStyle get borderY {
    return DecoratedBoxStyle(
      border: BorderSubStyle(
        top: switch (this) {
          0 => BorderSideSubStyle.none,
          _ => BorderSideSubStyle(width: toDouble()),
        },
        bottom: switch (this) {
          0 => BorderSideSubStyle.none,
          _ => BorderSideSubStyle(width: toDouble()),
        },
      ),
    );
  }
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
