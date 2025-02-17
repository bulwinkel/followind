part of "style.dart";

class ModifierStyle extends Style {
  const ModifierStyle._({required this.style, this.sizeClass, this.hover});

  /// Prevent stacking of [ModifierStyle]s.
  /// If the style is already a [ModifierStyle],
  /// it will be replaced with the new [ModifierStyle].
  factory ModifierStyle.mergeWith({
    required Style style,
    SizeClass? sizeClass,
    bool? hover,
  }) {
    if (style is ModifierStyle) {
      return ModifierStyle._(
        style: style.style,
        sizeClass: sizeClass ?? style.sizeClass,
        hover: hover ?? style.hover,
      );
    }

    return ModifierStyle._(style: style, sizeClass: sizeClass, hover: hover);
  }

  final Style style;
  final SizeClass? sizeClass;
  final bool? hover;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModifierStyle &&
          runtimeType == other.runtimeType &&
          style == other.style &&
          sizeClass == other.sizeClass &&
          hover == other.hover;

  @override
  int get hashCode => style.hashCode ^ sizeClass.hashCode ^ hover.hashCode;

  @override
  String toString() {
    return 'ModifierStyle{style: $style, sizeClass: $sizeClass, hover: $hover}';
  }
}

extension ModifierStyleX on Style {
  Style get sm => ModifierStyle.mergeWith(sizeClass: SizeClass.sm, style: this);

  Style get md => ModifierStyle.mergeWith(sizeClass: SizeClass.md, style: this);

  Style get lg => ModifierStyle.mergeWith(sizeClass: SizeClass.lg, style: this);

  Style get xl => ModifierStyle.mergeWith(sizeClass: SizeClass.xl, style: this);

  Style get xxl =>
      ModifierStyle.mergeWith(sizeClass: SizeClass.xxl, style: this);

  Style get hover => ModifierStyle.mergeWith(hover: true, style: this);
}

Style Function(Style) _wrapWithSizeClass(SizeClass sizeClass) {
  return (style) => ModifierStyle.mergeWith(sizeClass: sizeClass, style: style);
}

final _wrapWithSm = _wrapWithSizeClass(SizeClass.sm);
final _wrapWithMd = _wrapWithSizeClass(SizeClass.md);
final _wrapWithLg = _wrapWithSizeClass(SizeClass.lg);
final _wrapWithXl = _wrapWithSizeClass(SizeClass.xl);
final _wrapWithXxl = _wrapWithSizeClass(SizeClass.xxl);

/// Any size classes already applied to [Style]s in
/// [sm], [md], [lg], [xl], [xxl] will be replace with
/// the new style.
List<Style> bySizeClass({
  List<Style> base = const [],
  List<Style> sm = const [],
  List<Style> md = const [],
  List<Style> lg = const [],
  List<Style> xl = const [],
  List<Style> xxl = const [],
}) {
  return [
    ...base,
    ...sm.map(_wrapWithSm),
    ...md.map(_wrapWithMd),
    ...lg.map(_wrapWithLg),
    ...xl.map(_wrapWithXl),
    ...xxl.map(_wrapWithXxl),
  ];
}
