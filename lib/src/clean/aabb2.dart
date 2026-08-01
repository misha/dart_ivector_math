// GENERATED FILE. DO NOT EDIT.

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

  /// The center of this AABB. Allocates a new [Vector2].
  Vector2 get center => min.clone()
    ..mutate().add(max)
    ..mutate().scale(0.5);

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
  MutableAabb2 mutate() {
    return MutableAabb2(this);
  }

  void modify(void Function(MutableAabb2 aabb) mutation) {
    mutation(mutate());
  }

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

extension type MutableAabb2(Aabb2 aabb) {
  Vector2 get min => aabb.min;
  Vector2 get max => aabb.max;
  bool containsAabb2(Aabb2 other) => aabb.containsAabb2(other);
  bool containsVector2(Vector2 point) => aabb.containsVector2(point);
  bool overlapsX(Aabb2 other) => aabb.overlapsX(other);
  bool overlapsY(Aabb2 other) => aabb.overlapsY(other);
  bool intersectsWithAabb2(Aabb2 other) => aabb.intersectsWithAabb2(other);
  bool intersectsWithVector2(Vector2 point) =>
      aabb.intersectsWithVector2(point);

  void setFrom(Aabb2 other) {
    aabb.min.mutate().setFrom(other.min);
    aabb.max.mutate().setFrom(other.max);
  }

  /// Sets both corners from raw components, without allocating.
  void setValues(double minX, double minY, double maxX, double maxY) {
    aabb.min.mutate()
      ..x = minX
      ..y = minY;

    aabb.max.mutate()
      ..x = maxX
      ..y = maxY;
  }

  void setCenterAndHalfExtents(Vector2 center, Vector2 halfExtents) {
    aabb.min.mutate()
      ..x = center.x - halfExtents.x
      ..y = center.y - halfExtents.y;

    aabb.max.mutate()
      ..x = center.x + halfExtents.x
      ..y = center.y + halfExtents.y;
  }

  void hull(Aabb2 other) {
    aabb.min.mutate()
      ..x = math.min(aabb.min.x, other.min.x)
      ..y = math.min(aabb.min.y, other.min.y);
    aabb.max.mutate()
      ..x = math.max(aabb.max.x, other.max.x)
      ..y = math.max(aabb.max.y, other.max.y);
  }

  void hullPoint(Vector2 point) {
    aabb.min.mutate()
      ..x = math.min(aabb.min.x, point.x)
      ..y = math.min(aabb.min.y, point.y);
    aabb.max.mutate()
      ..x = math.max(aabb.max.x, point.x)
      ..y = math.max(aabb.max.y, point.y);
  }
}
