import 'dart:math' as math;

import 'mutable.dart';
import 'vector2.dart';

/// Defines a 2-dimensional axis-aligned bounding box between a [min] and a
/// [max] position.
class Aabb2 implements Mutable<MutableAabb2> {
  Aabb2() //
    : min = Vector2.zero(),
      max = Vector2.zero();

  Aabb2.copy(Aabb2 other) //
    : min = Vector2.copy(other.min),
      max = Vector2.copy(other.max);

  Aabb2.minMax(Vector2 min, Vector2 max) //
    : min = Vector2.copy(min),
      max = Vector2.copy(max);

  factory Aabb2.centerAndHalfExtents(Vector2 center, Vector2 halfExtents) =>
      Aabb2()..mutate().setCenterAndHalfExtents(center, halfExtents);

  /// The minimum point defining this AABB.
  final Vector2 min;

  /// The maximum point defining this AABB.
  final Vector2 max;

  double get width => (max.x - min.x).abs();
  double get height => (max.y - min.y).abs();
  double get centerX => (min.x + max.x) / 2;
  double get centerY => (min.y + max.y) / 2;

  /// The center of this AABB. Allocates a new [Vector2].
  Vector2 get center => Vector2(centerX, centerY);

  Aabb2 clone() => .copy(this);

  /// The smallest AABB containing both this and [other].
  Aabb2 hull(Aabb2 other) => clone()..mutate().hull(other);

  /// The smallest AABB containing both this and [point].
  Aabb2 hullPoint(Vector2 point) => clone()..mutate().hullPoint(point);

  /// Whether this fully contains [other].
  bool containsAabb2(Aabb2 other) =>
      min.x < other.min.x && //
      min.y < other.min.y &&
      max.x > other.max.x &&
      max.y > other.max.y;

  /// Whether this contains [point].
  bool containsVector2(Vector2 point) =>
      min.x < point.x && //
      min.y < point.y &&
      max.x > point.x &&
      max.y > point.y;

  /// Whether this and [other] overlap on the x axis.
  bool overlapsX(Aabb2 other) => min.x <= other.max.x && max.x >= other.min.x;

  /// Whether this and [other] overlap on the y axis.
  bool overlapsY(Aabb2 other) => min.y <= other.max.y && max.y >= other.min.y;

  /// Whether this overlaps [other].
  bool intersectsWithAabb2(Aabb2 other) => overlapsX(other) && overlapsY(other);

  /// Whether this overlaps [point].
  bool intersectsWithVector2(Vector2 point) =>
      min.x <= point.x && //
      min.y <= point.y &&
      max.x >= point.x &&
      max.y >= point.y;

  @override
  MutableAabb2 mutate() => MutableAabb2._(this);
  void modify(void Function(MutableAabb2 aabb) mutation) => mutation(mutate());

  @override
  String toString() => '$min -> $max';

  @override
  bool operator ==(Object other) =>
      other is Aabb2 && //
      min == other.min &&
      max == other.max;

  @override
  int get hashCode => Object.hash(min, max);
}

extension type MutableAabb2._(Aabb2 source) {
  Vector2 get min => source.min;
  Vector2 get max => source.max;
  double get width => source.width;
  double get height => source.height;
  double get centerX => source.centerX;
  double get centerY => source.centerY;
  bool containsAabb2(Aabb2 other) => source.containsAabb2(other);
  bool containsVector2(Vector2 point) => source.containsVector2(point);
  bool overlapsX(Aabb2 other) => source.overlapsX(other);
  bool overlapsY(Aabb2 other) => source.overlapsY(other);
  bool intersectsWithAabb2(Aabb2 other) => source.intersectsWithAabb2(other);
  bool intersectsWithVector2(Vector2 point) => source.intersectsWithVector2(point);

  void setFrom(Aabb2 other) {
    source.min.mutate().setFrom(other.min);
    source.max.mutate().setFrom(other.max);
  }

  /// Sets both corners from raw components, without allocating.
  void setValues(double minX, double minY, double maxX, double maxY) {
    source.min.mutate()
      ..x = minX
      ..y = minY;

    source.max.mutate()
      ..x = maxX
      ..y = maxY;
  }

  void setCenterAndHalfExtents(Vector2 center, Vector2 halfExtents) {
    source.min.mutate()
      ..x = center.x - halfExtents.x
      ..y = center.y - halfExtents.y;

    source.max.mutate()
      ..x = center.x + halfExtents.x
      ..y = center.y + halfExtents.y;
  }

  void hull(Aabb2 other) {
    source.min.mutate()
      ..x = math.min(source.min.x, other.min.x)
      ..y = math.min(source.min.y, other.min.y);

    source.max.mutate()
      ..x = math.max(source.max.x, other.max.x)
      ..y = math.max(source.max.y, other.max.y);
  }

  void hullPoint(Vector2 point) {
    source.min.mutate()
      ..x = math.min(source.min.x, point.x)
      ..y = math.min(source.min.y, point.y);

    source.max.mutate()
      ..x = math.max(source.max.x, point.x)
      ..y = math.max(source.max.y, point.y);
  }
}
