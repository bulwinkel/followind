const Map<String, double> spacings = {
  '0': 0,
  '0.5': 0.5,
  '1': 1,
  '1.5': 1.5,
  '2': 2,
  '2.5': 2.5,
  '3': 3,
  '3.5': 3.5,
  '4': 4,
  '5': 5,
  '6': 6,
  '7': 7,
  '8': 8,
  '9': 9,
  '10': 10,
  '11': 11,
  '12': 12,
  '14': 14,
  '16': 16,
  '20': 20,
  '24': 24,
  '28': 28,
  '32': 32,
  '36': 36,
  '40': 40,
  '44': 44,
  '48': 48,
  '52': 52,
  '56': 56,
  '60': 60,
  '64': 64,
  '72': 72,
  '80': 80,
  '96': 96,
};

// for h- and w- classes
const Map<String, double> fractionalSizes = {
  '1/2': 0.5,
  '1/3': 1 / 3,
  '2/3': 2 / 3,
  '1/4': 1 / 4,
  '2/4': 2 / 4,
  '3/4': 3 / 4,
  '1/5': 1 / 5,
  '2/5': 2 / 5,
  '3/5': 3 / 5,
  '4/5': 4 / 5,
  '1/6': 1 / 6,
  '2/6': 2 / 6,
  '3/6': 3 / 6,
  '4/6': 4 / 6,
  '5/6': 5 / 6,
  '1/12': 1 / 12,
  '2/12': 2 / 12,
  '3/12': 3 / 12,
  '4/12': 4 / 12,
  '5/12': 5 / 12,
  '6/12': 6 / 12,
  '7/12': 7 / 12,
  '8/12': 8 / 12,
  '9/12': 9 / 12,
  '10/12': 10 / 12,
  '11/12': 11 / 12,
};

final List<String> additionalSizes = [
  // Special values
  'auto',
  'full', // 100%
  'screen', // 100vh/vw
  'svh', // Small viewport height
  'lvh', // Large viewport height
  'dvh', // Dynamic viewport height
  'min', // min-content
  'max', // max-content
  'fit', // fit-content

  // Viewport units
  'vh', // viewport height
  'vw', // viewport width
];

sealed class Spacing {
  const Spacing({
    this.sizeClass = 0,
  });

  final double sizeClass;

  Spacing applyAt(double sizeClass);
}

extension ChooseForScreenSize on Spacing? {
  Spacing? pick(Spacing? other, double screenWidth) {
    if (other == null) return this;
    if (this == null && other.sizeClass >= screenWidth) return other;

    // if they are both equal return the latter
    if ((this?.sizeClass ?? 0) == other.sizeClass) {
      return other;
    }

    final isThisSmaller = (this?.sizeClass ?? 0) < other.sizeClass;
    final min = isThisSmaller ? this : other;
    final max = isThisSmaller ? other : this;

    // scenario: min is 0, max is 600, and screenWidth is 300
    // this should be picked
    // scenario: min is 0, max is 600, and screenWidth is 900
    // other should be picked
    if (screenWidth >= (max?.sizeClass ?? 0)) {
      return max;
    }

    return min;
  }
}

class DpSpacing extends Spacing {
  final double value;

  const DpSpacing(this.value, {super.sizeClass = 0});

  @override
  DpSpacing applyAt(double sizeClass) {
    return DpSpacing(value, sizeClass: sizeClass);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DpSpacing &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

const zero = DpSpacing(0);

class FractionalSpacing extends Spacing {
  final double value;

  const FractionalSpacing(this.value, {super.sizeClass = 0});

  @override
  FractionalSpacing applyAt(double sizeClass) {
    return FractionalSpacing(value, sizeClass: sizeClass);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FractionalSpacing &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class ScaleSpacing extends Spacing {
  final double value;

  const ScaleSpacing(this.value, {super.sizeClass = 0});

  @override
  ScaleSpacing applyAt(double sizeClass) {
    return ScaleSpacing(value, sizeClass: sizeClass);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScaleSpacing &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

extension UnpackSpacing on Spacing {
  double unpack({
    required double axisMax,
    required double scale,
  }) {
    return switch (this) {
      DpSpacing(:final value) => value,
      FractionalSpacing(:final value) => value * axisMax,
      ScaleSpacing(:final value) => value * scale,
    };
  }
}

extension SpacingExtension on num {
  Spacing get dp => DpSpacing(toDouble());
  Spacing get pc => FractionalSpacing(toDouble());
  Spacing get s => ScaleSpacing(toDouble());
}
