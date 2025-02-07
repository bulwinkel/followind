import 'package:flutter/widgets.dart';
import 'package:following_wind/src/spacings.dart';
import 'package:following_wind/src/styles/style.dart';

const row = FlexStyle(direction: Axis.horizontal);
const col = FlexStyle(direction: Axis.vertical);
const mainStart = FlexStyle(mainAxisAlignment: MainAxisAlignment.start);
const mainEnd = FlexStyle(mainAxisAlignment: MainAxisAlignment.end);
const mainCenter = FlexStyle(mainAxisAlignment: MainAxisAlignment.center);
const mainBetween =
    FlexStyle(mainAxisAlignment: MainAxisAlignment.spaceBetween);
const mainAround = FlexStyle(mainAxisAlignment: MainAxisAlignment.spaceAround);
const mainEvenly = FlexStyle(mainAxisAlignment: MainAxisAlignment.spaceEvenly);
const mainMin = FlexStyle(mainAxisSize: MainAxisSize.min);
const mainMax = FlexStyle(mainAxisSize: MainAxisSize.max);
const crossStart = FlexStyle(crossAxisAlignment: CrossAxisAlignment.start);
const crossEnd = FlexStyle(crossAxisAlignment: CrossAxisAlignment.end);
const crossCenter = FlexStyle(crossAxisAlignment: CrossAxisAlignment.center);
const crossStretch = FlexStyle(crossAxisAlignment: CrossAxisAlignment.stretch);
const crossBaseline =
    FlexStyle(crossAxisAlignment: CrossAxisAlignment.baseline);

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
  PaddingStyle get p => PaddingStyle.all(s);
  PaddingStyle get px => PaddingStyle(left: s, right: s);
  PaddingStyle get py => PaddingStyle(top: s, bottom: s);
  PaddingStyle get pt => PaddingStyle(top: s);
  PaddingStyle get pr => PaddingStyle(right: s);
}

extension GapStyles on num {
  FlexStyle get gap => FlexStyle(spacing: s);
}
