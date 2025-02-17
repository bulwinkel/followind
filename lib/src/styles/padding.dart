part of "style.dart";

class PaddingStyle extends Style {
  const PaddingStyle({this.left, this.top, this.right, this.bottom});

  const PaddingStyle.all(Spacing all)
    : left = all,
      top = all,
      right = all,
      bottom = all;

  const PaddingStyle.ltrb(Spacing? l, Spacing? t, Spacing? r, Spacing? b)
    : left = l,
      top = t,
      right = r,
      bottom = b;

  final Spacing? left;
  final Spacing? top;
  final Spacing? right;
  final Spacing? bottom;

  PaddingStyle mergeWith(PaddingStyle other) {
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

extension SpacingPaddingStyles on Spacing {
  PaddingStyle get p => PaddingStyle.all(this);

  PaddingStyle get px => PaddingStyle(left: this, right: this);

  PaddingStyle get py => PaddingStyle(top: this, bottom: this);

  PaddingStyle get pt => PaddingStyle(top: this);

  PaddingStyle get pr => PaddingStyle(right: this);

  PaddingStyle get pb => PaddingStyle(bottom: this);

  PaddingStyle get pl => PaddingStyle(left: this);
}

extension NumPaddingStyles on num {
  PaddingStyle get p => dp.p;

  PaddingStyle get px => dp.px;

  PaddingStyle get py => dp.py;

  PaddingStyle get pt => dp.pt;

  PaddingStyle get pr => dp.pr;

  PaddingStyle get pb => dp.pb;

  PaddingStyle get pl => dp.pl;
}
