sealed class Spacing {
  const Spacing();
}

class DpSpacing extends Spacing {
  final double value;

  const DpSpacing(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DpSpacing &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'DpSpacing{value: $value}';
  }
}

// class FractionalSpacing extends Spacing {
//   final double value;
//
//   const FractionalSpacing(this.value);
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is FractionalSpacing &&
//           runtimeType == other.runtimeType &&
//           value == other.value;
//
//   @override
//   int get hashCode => value.hashCode;
//
//   @override
//   String toString() {
//     return 'FractionalSpacing{value: $value}';
//   }
// }

class ScaleSpacing extends Spacing {
  final double value;

  const ScaleSpacing(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScaleSpacing &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'ScaleSpacing{value: $value}';
  }
}

extension UnpackSpacing on Spacing {
  double unpack({required double axisMax, required double scale}) {
    return switch (this) {
      DpSpacing(:final value) => value,
      // FractionalSpacing(:final value) => value * axisMax,
      ScaleSpacing(:final value) => value * scale,
    };
  }
}

extension SpacingExtension on num {
  Spacing get dp => DpSpacing(toDouble());

  // Spacing get percent => FractionalSpacing(toDouble() / 100);

  Spacing get scaled => ScaleSpacing(toDouble());
}
