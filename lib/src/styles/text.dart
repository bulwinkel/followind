part of 'style.dart';

class FWTextStyle extends Style {
  FWTextStyle({this.fontSize, this.fontWeight, this.color, this.textAlign});

  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  FWTextStyle mergeWith(FWTextStyle other) {
    return FWTextStyle(
      fontSize: other.fontSize ?? fontSize,
      fontWeight: other.fontWeight ?? fontWeight,
      color: other.color ?? color,
      textAlign: other.textAlign ?? textAlign,
    );
  }

  TextStyle? unpack() {
    if (fontSize == null && fontWeight == null && color == null) return null;

    return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FWTextStyle &&
          runtimeType == other.runtimeType &&
          fontSize == other.fontSize &&
          fontWeight == other.fontWeight &&
          color == other.color &&
          textAlign == other.textAlign;

  @override
  int get hashCode =>
      fontSize.hashCode ^
      fontWeight.hashCode ^
      color.hashCode ^
      textAlign.hashCode;

  @override
  String toString() {
    return 'TextStyle{fontSize: $fontSize, fontWeight: $fontWeight, color: $color, textAlign: $textAlign}';
  }
}

extension TextColorX on Color {
  FWTextStyle get text => FWTextStyle(color: this);
}

extension NumFontSizeX on num {
  FWTextStyle get fontSize => FWTextStyle(fontSize: toDouble());
}
