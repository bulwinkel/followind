part of "style.dart";

/// Not composable across size classes.
/// Will use the last value found for the
/// current size class.
class FlexibleStyle extends Style {
  const FlexibleStyle({this.flex = 1, this.fit = FlexFit.loose});

  final int flex;
  final FlexFit? fit;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlexibleStyle &&
          runtimeType == other.runtimeType &&
          flex == other.flex &&
          fit == other.fit;

  @override
  int get hashCode => flex.hashCode ^ fit.hashCode;

  @override
  String toString() {
    return 'FlexibleStyle{flex: $flex, fit: $fit}';
  }
}

const flexible = FlexibleStyle();
const expanded = FlexibleStyle(flex: 1, fit: FlexFit.tight);

/// Useful for disabling flex in a specific size class.
/// e.g. On larger screens you want the content to use
/// up all available space but on smaller screens you
/// will need the content to be scrollable.
const flexNone = FlexibleStyle(flex: 0, fit: null);

extension IntFlexibleX on int {
  FlexibleStyle get flexible => FlexibleStyle(flex: this);

  FlexibleStyle get expanded => FlexibleStyle(flex: this, fit: FlexFit.tight);
}
