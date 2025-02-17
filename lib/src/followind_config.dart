class FollowindConfig {
  static const double defaultSpacingScale = 4;
  static const defaultSizeClasses = {
    SizeClass.sm: 640.0,
    SizeClass.md: 768.0,
    SizeClass.lg: 1024.0,
    SizeClass.xl: 1280.0,
    SizeClass.xxl: 1536.0,
  };

  const FollowindConfig({
    this.spacingScale = defaultSpacingScale,
    this.sizeClasses = defaultSizeClasses,
  });

  final double spacingScale;
  final Map<SizeClass, double?> sizeClasses;

  // region -- regenerate when new properties are added --

  FollowindConfig copyWith({
    double? spacingScale,
    Map<SizeClass, double?>? sizeClasses,
  }) {
    return FollowindConfig(
      spacingScale: spacingScale ?? this.spacingScale,
      sizeClasses: sizeClasses ?? this.sizeClasses,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FollowindConfig &&
          runtimeType == other.runtimeType &&
          spacingScale == other.spacingScale &&
          sizeClasses == other.sizeClasses;

  @override
  int get hashCode => Object.hash(spacingScale, sizeClasses);

  @override
  String toString() {
    return 'FollowindConfig{spacingScale: $spacingScale, sizeClasses: $sizeClasses}';
  }

  // endregion
}

enum SizeClass { sm, md, lg, xl, xxl }

extension FollowindConfigX on FollowindConfig {
  double sizeForClass(SizeClass? className) {
    return sizeClasses[className] ?? 0.0;
  }
}
