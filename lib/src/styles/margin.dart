part of "style.dart";

class MarginStyle extends Style {
  const MarginStyle({this.left, this.top, this.right, this.bottom});

  const MarginStyle.all(Spacing all)
    : left = all,
      top = all,
      right = all,
      bottom = all;

  const MarginStyle.ltrb(Spacing? l, Spacing? t, Spacing? r, Spacing? b)
    : left = l,
      top = t,
      right = r,
      bottom = b;

  final Spacing? left;
  final Spacing? top;
  final Spacing? right;
  final Spacing? bottom;

  MarginStyle mergeWith(MarginStyle other) {
    return MarginStyle(
      left: other.left ?? left,
      top: other.top ?? top,
      right: other.right ?? right,
      bottom: other.bottom ?? bottom,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarginStyle &&
          runtimeType == other.runtimeType &&
          left == other.left &&
          top == other.top &&
          right == other.right &&
          bottom == other.bottom;

  @override
  int get hashCode =>
      left.hashCode ^ top.hashCode ^ right.hashCode ^ bottom.hashCode;
}

extension SpacingMarginStyles on Spacing {
  MarginStyle get m => MarginStyle.all(this);

  MarginStyle get mx => MarginStyle(left: this, right: this);

  MarginStyle get my => MarginStyle(top: this, bottom: this);

  MarginStyle get mt => MarginStyle(top: this);

  MarginStyle get mr => MarginStyle(right: this);

  MarginStyle get mb => MarginStyle(bottom: this);

  MarginStyle get ml => MarginStyle(left: this);
}

extension NumMarginStyles on num {
  MarginStyle get m => dp.m;

  MarginStyle get mx => dp.mx;

  MarginStyle get my => dp.my;

  MarginStyle get mt => dp.mt;

  MarginStyle get mr => dp.mr;

  MarginStyle get mb => dp.mb;

  MarginStyle get ml => dp.ml;
}
