import 'matrix3.dart';
import 'vector2.dart';

/// Shared operations for [Aabb2] and [MAabb2]. Defines a 2-dimensional
/// axis-aligned bounding box between a [min] and a [max] position.
mixin _Aabb2 {
  /// The minimum point defining the AABB.
  Vector2 get min;

  /// The maximum point defining the AABB.
  Vector2 get max;

  /// The width of the AABB.
  double get width => (max.x - min.x).abs();

  /// The height of the AABB.
  double get height => (max.y - min.y).abs();

  /// The x coordinate of the center of the AABB.
  double get centerX => (min.x + max.x) / 2;

  /// The y coordinate of the center of the AABB.
  double get centerY => (min.y + max.y) / 2;

  /// The center of the AABB. Allocates a new [Vector2].
  Vector2 get center => .new(centerX, centerY);

  /// The half extents of the AABB. Allocates a new [Vector2].
  Vector2 get halfExtents => .new((max.x - min.x) / 2, (max.y - min.y) / 2);

  /// True if this contains [other].
  bool containsAabb2(Aabb2 other) =>
      min.x < other.min.x && //
      min.y < other.min.y &&
      max.x > other.max.x &&
      max.y > other.max.y;

  /// True if this contains [point].
  bool containsVector2(Vector2 point) =>
      min.x < point.x && //
      min.y < point.y &&
      max.x > point.x &&
      max.y > point.y;

  /// True if this and [other] overlap on the x axis.
  bool overlapsX(Aabb2 other) => min.x <= other.max.x && max.x >= other.min.x;

  /// True if this and [other] overlap on the y axis.
  bool overlapsY(Aabb2 other) => min.y <= other.max.y && max.y >= other.min.y;

  /// True if this intersects with [other].
  bool intersectsWithAabb2(Aabb2 other) => overlapsX(other) && overlapsY(other);

  /// True if this intersects with [point].
  bool intersectsWithVector2(Vector2 point) =>
      min.x <= point.x && //
      min.y <= point.y &&
      max.x >= point.x &&
      max.y >= point.y;

  /// Copy of this transformed by [matrix].
  Aabb2 transformed(Matrix3 matrix) {
    final center = this.center.transformed(matrix);
    final halfExtents = this.halfExtents.absoluteRotated(matrix);
    return .new(center - halfExtents, center + halfExtents);
  }

  /// Copy of this rotated by the rotation matrix [matrix].
  Aabb2 rotated(Matrix3 matrix) {
    final center = this.center;
    final halfExtents = this.halfExtents.absoluteRotated(matrix);
    return .new(center - halfExtents, center + halfExtents);
  }

  /// Copy of this translated by [offset].
  Aabb2 translated(Vector2 offset) => .new(min + offset, max + offset);

  /// Returns a printable string.
  @override
  String toString() => '$min -> $max';

  /// Check if two AABBs are the same.
  @override
  bool operator ==(Object other) =>
      other is Aabb2 && //
      min == other.min &&
      max == other.max;

  @override
  int get hashCode => Object.hash(min, max);
}

class Aabb2 with _Aabb2 {
  /// Create a new AABB with a [min] and [max]. Aliases them rather than
  /// copying, so both must already be immutable — this is checked with an
  /// assertion. Copy mutable corners with [Vector2.copy] first if needed.
  const Aabb2(this.min, this.max)
    : assert(
        min is! MVector2 && max is! MVector2,
        'min and max must be immutable. '
        'Copy mutable corners with Vector2.copy first.',
      );

  /// Create a new AABB as a copy of [other].
  factory Aabb2.copy(Aabb2 other) => .new(.copy(other.min), .copy(other.max));

  /// Create a new AABB with a [center] and [halfExtents].
  factory Aabb2.centerAndHalfExtents(Vector2 center, Vector2 halfExtents) =>
      .new(
        .new(center.x - halfExtents.x, center.y - halfExtents.y),
        .new(center.x + halfExtents.x, center.y + halfExtents.y),
      );

  @override
  final Vector2 min;

  @override
  final Vector2 max;

  /// Canonical zero AABB.
  static const Aabb2 zero = .new(.zero, .zero);

  /// Clone of this.
  Aabb2 clone() => .copy(this);
}

class MAabb2 with _Aabb2 implements Aabb2 {
  /// Create a new AABB with a [min] and [max]. Copies both corners.
  MAabb2(Vector2 min, Vector2 max) : min = .copy(min), max = .copy(max);

  /// Create a new AABB with [min] and [max] set to the origin.
  MAabb2.zero() : min = .zero(), max = .zero();

  /// Create a new AABB as a copy of [other].
  factory MAabb2.copy(Aabb2 other) => .new(other.min, other.max);

  /// Create a new AABB with a [center] and [halfExtents].
  factory MAabb2.centerAndHalfExtents(Vector2 center, Vector2 halfExtents) =>
      .zero()..setCenterAndHalfExtents(center, halfExtents);

  @override
  final MVector2 min;

  @override
  final MVector2 max;

  /// Clone of this.
  @override
  MAabb2 clone() => .copy(this);

  /// Sets the corners of this by copying them from [other].
  void setFrom(Aabb2 other) {
    min.setFrom(other.min);
    max.setFrom(other.max);
  }

  /// Sets both corners from raw components.
  void setValues(double minX, double minY, double maxX, double maxY) {
    min.setValues(minX, minY);
    max.setValues(maxX, maxY);
  }

  /// Sets the AABB by a [center] and [halfExtents].
  void setCenterAndHalfExtents(Vector2 center, Vector2 halfExtents) {
    min.setValues(center.x - halfExtents.x, center.y - halfExtents.y);
    max.setValues(center.x + halfExtents.x, center.y + halfExtents.y);
  }

  /// Sets the min and max of this so that this is a hull of this and [other].
  void hull(Aabb2 other) {
    min.min(other.min);
    max.max(other.max);
  }

  /// Sets the min and max of this so that this contains [point].
  void hullPoint(Vector2 point) {
    min.min(point);
    max.max(point);
  }

  /// Transforms this by [matrix].
  void transform(Matrix3 matrix) {
    final center = this.center.transformed(matrix);
    final halfExtents = this.halfExtents.absoluteRotated(matrix);
    setCenterAndHalfExtents(center, halfExtents);
  }

  /// Rotates this by the rotation matrix [matrix].
  void rotate(Matrix3 matrix) {
    final center = this.center;
    final halfExtents = this.halfExtents.absoluteRotated(matrix);
    setCenterAndHalfExtents(center, halfExtents);
  }

  /// Translates this by [offset].
  void translate(Vector2 offset) {
    min.add(offset);
    max.add(offset);
  }
}
