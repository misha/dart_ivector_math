import 'matrix4.dart';
import 'vector3.dart';

/// Shared operations for [Quad] and [MQuad]. Defines a quad by four points.
mixin _Quad {
  /// The first point of the quad.
  Vector3 get point0;

  /// The second point of the quad.
  Vector3 get point1;

  /// The third point of the quad.
  Vector3 get point2;

  /// The fourth point of the quad.
  Vector3 get point3;

  /// The normal of the quad. Allocates a new [Vector3].
  Vector3 get normal => (point2 - point1).cross(point0 - point1).normalized();

  /// Copy of this with each point transformed by [matrix].
  Quad transformed(Matrix4 matrix) => .new(
    point0.transformed(matrix),
    point1.transformed(matrix),
    point2.transformed(matrix),
    point3.transformed(matrix),
  );

  /// Copy of this with each point translated by [offset].
  Quad translated(Vector3 offset) => .new(
    point0 + offset, //
    point1 + offset,
    point2 + offset,
    point3 + offset,
  );

  /// Returns a printable string.
  @override
  String toString() =>
      '[0] $point0\n'
      '[1] $point1\n'
      '[2] $point2\n'
      '[3] $point3';

  /// Check if two quads are the same.
  @override
  bool operator ==(Object other) =>
      other is Quad && //
      point0 == other.point0 &&
      point1 == other.point1 &&
      point2 == other.point2 &&
      point3 == other.point3;

  @override
  int get hashCode => Object.hash(point0, point1, point2, point3);
}

class Quad with _Quad {
  /// Create a new quad from four points. Aliases them rather than copying, so
  /// all four must already be immutable — this is checked with an assertion.
  /// Copy mutable points with [Vector3.copy] first if needed.
  const Quad(this.point0, this.point1, this.point2, this.point3)
    : assert(
        point0 is! MVector3 &&
            point1 is! MVector3 &&
            point2 is! MVector3 &&
            point3 is! MVector3,
        'point0, point1, point2, and point3 must be immutable. '
        'Copy mutable points with Vector3.copy first.',
      );

  /// Create a new quad as a copy of [other].
  factory Quad.copy(Quad other) => .new(
    .copy(other.point0),
    .copy(other.point1),
    .copy(other.point2),
    .copy(other.point3),
  );

  @override
  final Vector3 point0;

  @override
  final Vector3 point1;

  @override
  final Vector3 point2;

  @override
  final Vector3 point3;

  /// Canonical zero quad.
  static const Quad zero = .new(.zero, .zero, .zero, .zero);

  /// Clone of this.
  Quad clone() => .copy(this);
}

class MQuad with _Quad implements Quad {
  /// Create a new quad from four points. Copies all four.
  MQuad(Vector3 point0, Vector3 point1, Vector3 point2, Vector3 point3)
    : point0 = .copy(point0),
      point1 = .copy(point1),
      point2 = .copy(point2),
      point3 = .copy(point3);

  /// Create a new quad with all four points set to the origin.
  MQuad.zero()
    : point0 = .zero(),
      point1 = .zero(),
      point2 = .zero(),
      point3 = .zero();

  /// Create a new quad as a copy of [other].
  factory MQuad.copy(Quad other) =>
      .new(other.point0, other.point1, other.point2, other.point3);

  @override
  final MVector3 point0;

  @override
  final MVector3 point1;

  @override
  final MVector3 point2;

  @override
  final MVector3 point3;

  /// Clone of this.
  @override
  MQuad clone() => .copy(this);

  /// Copy the points from [other] into this.
  void setFrom(Quad other) {
    point0.setFrom(other.point0);
    point1.setFrom(other.point1);
    point2.setFrom(other.point2);
    point3.setFrom(other.point3);
  }

  /// Transform each point of this by [matrix] in place.
  void transform(Matrix4 matrix) {
    point0.transform(matrix);
    point1.transform(matrix);
    point2.transform(matrix);
    point3.transform(matrix);
  }

  /// Translate each point of this by [offset] in place.
  void translate(Vector3 offset) {
    point0.add(offset);
    point1.add(offset);
    point2.add(offset);
    point3.add(offset);
  }
}
