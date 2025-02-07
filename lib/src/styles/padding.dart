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

  PaddingStyle applyAt(double screenSize) {
    return PaddingStyle(
      left: left?.applyAt(screenSize),
      top: top?.applyAt(screenSize),
      right: right?.applyAt(screenSize),
      bottom: bottom?.applyAt(screenSize),
    );
  }

  PaddingStyle get sm => applyAt(600);
  PaddingStyle get md => applyAt(768);
  PaddingStyle get lg => applyAt(1024);
  PaddingStyle get xl => applyAt(1280);
  PaddingStyle get xxl => applyAt(1536);

  PaddingStyle mergeWith(PaddingStyle other, double screenWidth) {
    return PaddingStyle(
      left: left.pick(other.left, screenWidth),
      top: top.pick(other.top, screenWidth),
      right: right.pick(other.right, screenWidth),
      bottom: bottom.pick(other.bottom, screenWidth),
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
