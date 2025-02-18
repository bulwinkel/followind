class FollowindConfig {
  static const double defaultSpacingScale = 4;
  static const defaultBreakpoints = {
    SizeClass.sm: 640.0,
    SizeClass.md: 768.0,
    SizeClass.lg: 1024.0,
    SizeClass.xl: 1280.0,
    SizeClass.xl2: 1536.0,
  };

  const FollowindConfig({
    this.spacingScale = defaultSpacingScale,
    this.breakpoints = defaultBreakpoints,
  });

  final double spacingScale;
  final Map<SizeClass, double?> breakpoints;

  // region -- regenerate when new properties are added --

  FollowindConfig copyWith({
    double? spacingScale,
    Map<SizeClass, double?>? breakpoints,
  }) {
    return FollowindConfig(
      spacingScale: spacingScale ?? this.spacingScale,
      breakpoints: breakpoints ?? this.breakpoints,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FollowindConfig &&
          runtimeType == other.runtimeType &&
          spacingScale == other.spacingScale &&
          breakpoints == other.breakpoints;

  @override
  int get hashCode => spacingScale.hashCode ^ breakpoints.hashCode;

  @override
  String toString() {
    return 'FollowindConfig{spacingScale: $spacingScale, breakpoints: $breakpoints}';
  }

  // endregion
}

enum SizeClass { sm, md, lg, xl, xl2, xl3, xl4, full }

extension FollowindConfigX on FollowindConfig {
  // if the user override some but not all of the breakpoints
  // we fall back to the defaults for the missing ones
  double breakpointForSizeClass(SizeClass? sizeClass) {
    return breakpoints[sizeClass] ??
        //TODO:KB 18/2/2025 not sure if this is the correct / desired behavior
        FollowindConfig.defaultBreakpoints[sizeClass] ??
        0.0;
  }
}
