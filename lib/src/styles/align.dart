part of 'style.dart';

class AlignStyle extends Style {
  const AlignStyle({this.alignment});

  final Alignment? alignment;

  AlignStyle mergeWith(AlignStyle other) {
    return AlignStyle(alignment: other.alignment ?? alignment);
  }

  Alignment? unpack() {
    return alignment;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlignStyle &&
          runtimeType == other.runtimeType &&
          alignment == other.alignment;

  @override
  int get hashCode => alignment.hashCode;

  @override
  String toString() {
    return 'AlignStyle{alignment: $alignment}';
  }
}

/// The top left corner.
const alignTopLeft = AlignStyle(alignment: Alignment(-1.0, -1.0));

/// The center point along the top edge.
const alignTopCenter = AlignStyle(alignment: Alignment(0.0, -1.0));

/// The top right corner.
const alignTopRight = AlignStyle(alignment: Alignment(1.0, -1.0));

/// The center point along the left edge.
const alignCenterLeft = AlignStyle(alignment: Alignment(-1.0, 0.0));

/// The center point, both horizontally and vertically.
const alignCenter = AlignStyle(alignment: Alignment(0.0, 0.0));

/// The center point along the right edge.
const alignCenterRight = AlignStyle(alignment: Alignment(1.0, 0.0));

/// The bottom left corner.
const alignBottomLeft = AlignStyle(alignment: Alignment(-1.0, 1.0));

/// The center point along the bottom edge.
const alignBottomCenter = AlignStyle(alignment: Alignment(0.0, 1.0));

/// The bottom right corner.
const alignBottomRight = AlignStyle(alignment: Alignment(1.0, 1.0));

extension AlignStyleX on (num x, num y) {
  AlignStyle get align =>
      AlignStyle(alignment: Alignment($1.toDouble(), $2.toDouble()));
}
