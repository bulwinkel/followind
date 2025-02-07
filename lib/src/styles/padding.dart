part of "style.dart";

class PaddingStyle extends Style {
  const PaddingStyle({
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  const PaddingStyle.all(Spacing all)
      : left = all,
        top = all,
        right = all,
        bottom = all;

  const PaddingStyle.ltrb(
    Spacing? l,
    Spacing? t,
    Spacing? r,
    Spacing? b,
  )   : left = l,
        top = t,
        right = r,
        bottom = b;

  final Spacing? left;
  final Spacing? top;
  final Spacing? right;
  final Spacing? bottom;

  PaddingStyle applyAt(SizeClass sizeClass) {
    return PaddingStyle(
      left: left?.applyAt(sizeClass),
      top: top?.applyAt(sizeClass),
      right: right?.applyAt(sizeClass),
      bottom: bottom?.applyAt(sizeClass),
    );
  }

  PaddingStyle get sm => applyAt(SizeClass.sm);
  PaddingStyle get md => applyAt(SizeClass.md);
  PaddingStyle get lg => applyAt(SizeClass.lg);
  PaddingStyle get xl => applyAt(SizeClass.xl);
  PaddingStyle get xxl => applyAt(SizeClass.xxl);

  PaddingStyle mergeWith(PaddingStyle other, FollowingWindData fw) {
    return PaddingStyle(
      left: left.pick(other.left, fw),
      top: top.pick(other.top, fw),
      right: right.pick(other.right, fw),
      bottom: bottom.pick(other.bottom, fw),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaddingStyle &&
          runtimeType == other.runtimeType &&
          left == other.left &&
          top == other.top &&
          right == other.right &&
          bottom == other.bottom;

  @override
  int get hashCode =>
      left.hashCode ^ top.hashCode ^ right.hashCode ^ bottom.hashCode;
}
