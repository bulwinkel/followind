part of "style.dart";

class ModifierStyle extends Style {
  const ModifierStyle._({
    required this.style,
    this.sizeClass,
    this.hover,
    this.children,
  });

  /// Prevent stacking of [ModifierStyle]s.
  /// If the style is already a [ModifierStyle],
  /// it will be replaced with the new [ModifierStyle].
  factory ModifierStyle.mergeWith({
    required Style style,
    SizeClass? sizeClass,
    bool? hover,
    bool? children,
  }) {
    if (style is ModifierStyle) {
      return ModifierStyle._(
        style: style.style,
        sizeClass: sizeClass ?? style.sizeClass,
        hover: hover ?? style.hover,
        children: children ?? style.children,
      );
    }

    return ModifierStyle._(
      style: style,
      sizeClass: sizeClass,
      hover: hover,
      children: children,
    );
  }

  final Style style;
  final SizeClass? sizeClass;
  final bool? hover;
  final bool? children;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModifierStyle &&
          runtimeType == other.runtimeType &&
          style == other.style &&
          sizeClass == other.sizeClass &&
          hover == other.hover &&
          children == other.children;

  @override
  int get hashCode =>
      style.hashCode ^ sizeClass.hashCode ^ hover.hashCode ^ children.hashCode;

  @override
  String toString() {
    return 'ModifierStyle{style: $style, sizeClass: $sizeClass, hover: $hover, children: $children}';
  }
}

extension ModifierStyleX on Style {
  Style get sm => ModifierStyle.mergeWith(sizeClass: SizeClass.sm, style: this);

  Style get md => ModifierStyle.mergeWith(sizeClass: SizeClass.md, style: this);

  Style get lg => ModifierStyle.mergeWith(sizeClass: SizeClass.lg, style: this);

  Style get xl => ModifierStyle.mergeWith(sizeClass: SizeClass.xl, style: this);

  Style get xl2 =>
      ModifierStyle.mergeWith(sizeClass: SizeClass.xl2, style: this);

  Style get hover => ModifierStyle.mergeWith(hover: true, style: this);

  Style get children => ModifierStyle.mergeWith(children: true, style: this);
}

Style Function(Style) _wrapWithSizeClass(SizeClass sizeClass) {
  return (style) => ModifierStyle.mergeWith(sizeClass: sizeClass, style: style);
}

final _wrapWithSm = _wrapWithSizeClass(SizeClass.sm);
final _wrapWithMd = _wrapWithSizeClass(SizeClass.md);
final _wrapWithLg = _wrapWithSizeClass(SizeClass.lg);
final _wrapWithXl = _wrapWithSizeClass(SizeClass.xl);
final _wrapWithXl2 = _wrapWithSizeClass(SizeClass.xl2);

/// Any size classes already applied to [Style]s in
/// [sm], [md], [lg], [xl], [xl2] will be replace with
/// the new style.
List<Style> bySizeClass({
  List<Style> base = const [],
  List<Style> sm = const [],
  List<Style> md = const [],
  List<Style> lg = const [],
  List<Style> xl = const [],
  List<Style> xl2 = const [],
}) {
  return [
    ...base,
    ...sm.map(_wrapWithSm),
    ...md.map(_wrapWithMd),
    ...lg.map(_wrapWithLg),
    ...xl.map(_wrapWithXl),
    ...xl2.map(_wrapWithXl2),
  ];
}
