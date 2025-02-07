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

  Style applyAt(SizeClass sizeClass) {
    return SizeClassStyle(
      sizeClass: sizeClass,
      style: PaddingStyle(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
    );
  }

  Style get sm => applyAt(SizeClass.sm);
  Style get md => applyAt(SizeClass.md);
  Style get lg => applyAt(SizeClass.lg);
  Style get xl => applyAt(SizeClass.xl);
  Style get xxl => applyAt(SizeClass.xxl);

  PaddingStyle mergeWith(PaddingStyle other, FollowingWindData fw) {
    return PaddingStyle(
      left: other.left ?? left,
      top: other.top ?? top,
      right: other.right ?? right,
      bottom: other.bottom ?? bottom,
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
