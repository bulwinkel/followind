part of "style.dart";

enum SizeClass {
  sm,
  md,
  lg,
  xl,
  xxl,
}

class SizeClassStyle extends Style {
  const SizeClassStyle._({
    required this.sizeClass,
    required this.style,
  });

  /// If the style is already a [SizeClassStyle],
  /// it will be replaced with the new [SizeClass]
  factory SizeClassStyle({
    required SizeClass sizeClass,
    required Style style,
  }) {
    if (style is SizeClassStyle) {
      return SizeClassStyle._(
        sizeClass: sizeClass,
        style: style.style,
      );
    }

    return SizeClassStyle._(
      sizeClass: sizeClass,
      style: style,
    );
  }

  final SizeClass sizeClass;
  final Style style;
}

extension SizeClassStyleX on Style {
  Style get sm => SizeClassStyle(sizeClass: SizeClass.sm, style: this);

  Style get md => SizeClassStyle(sizeClass: SizeClass.md, style: this);

  Style get lg => SizeClassStyle(sizeClass: SizeClass.lg, style: this);

  Style get xl => SizeClassStyle(sizeClass: SizeClass.xl, style: this);

  Style get xxl => SizeClassStyle(sizeClass: SizeClass.xxl, style: this);
}

Style Function(Style) _wrapWithSizeClass(SizeClass sizeClass) {
  return (style) => SizeClassStyle(sizeClass: sizeClass, style: style);
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
