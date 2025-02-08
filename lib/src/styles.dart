import 'package:flutter/widgets.dart';
import 'package:following_wind/src/spacings.dart';
import 'package:following_wind/src/styles/style.dart';

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
