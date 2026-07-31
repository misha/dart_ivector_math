// GENERATED FILE. DO NOT EDIT.

import 'dart:math' as math;
import 'dart:typed_data';

import 'mutable.dart';
import 'vector2.dart';

/// Defines a 2-dimensional axis-aligned bounding box between a [min] and a
/// [max] position.
class Aabb2 implements Mutable<MutableAabb2> {
  Aabb2.zero();

  Aabb2(Vector2 min, Vector2 max) {
    _storage[0] = min.x;
    _storage[1] = min.y;
    _storage[2] = max.x;
    _storage[3] = max.y;
  }

  Aabb2.copy(Aabb2 other) {
    _storage.setAll(0, other._storage);
  }

  factory Aabb2.centerAndHalfExtents(Vector2 center, Vector2 halfExtents) =>
      Aabb2.zero()..mutate().setCenterAndHalfExtents(center, halfExtents);

  final _storage = Float64List(4);

  double operator [](int index) => _storage[index];
  double get minX => _storage[0];
  double get minY => _storage[1];
  double get maxX => _storage[2];
  double get maxY => _storage[3];

  /// The minimum point defining this AABB. Allocates a new [Vector2].
  Vector2 get min => .new(minX, minY);

  /// The maximum point defining this AABB. Allocates a new [Vector2].
  Vector2 get max => .new(maxX, maxY);

  /// The center of this AABB. Allocates a new [Vector2].
  Vector2 get center => .new((minX + maxX) / 2, (minY + maxY) / 2);

  /// Half the width and height of this AABB. Allocates a new [Vector2].
  Vector2 get halfExtents => .new((maxX - minX) / 2, (maxY - minY) / 2);

  Aabb2 clone() => .copy(this);

  /// The smallest AABB containing both this and [other].
  Aabb2 hull(Aabb2 other) => clone()..mutate().hull(other);

  /// The smallest AABB containing both this and [point].
  Aabb2 hullPoint(Vector2 point) => clone()..mutate().hullPoint(point);

  /// Whether this fully contains [other].
  bool containsAabb2(Aabb2 other) =>
      minX < other.minX &&
      minY < other.minY &&
      maxX > other.maxX &&
      maxY > other.maxY;

  /// Whether this contains [point].
  bool containsVector2(Vector2 point) =>
      minX < point.x && minY < point.y && maxX > point.x && maxY > point.y;

  /// Whether this overlaps [other].
  bool intersectsWithAabb2(Aabb2 other) =>
      minX <= other.maxX &&
      minY <= other.maxY &&
      maxX >= other.minX &&
      maxY >= other.minY;

  /// Whether this overlaps [point].
  bool intersectsWithVector2(Vector2 point) =>
      minX <= point.x && minY <= point.y && maxX >= point.x && maxY >= point.y;

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
      minX == other.minX &&
      minY == other.minY &&
      maxX == other.maxX &&
      maxY == other.maxY;

  @override
  int get hashCode => Object.hashAll(_storage);
}

extension type MutableAabb2(Aabb2 aabb) {
  Float64List get storage => aabb._storage;
  double operator [](int index) => aabb[index];
  double get minX => aabb.minX;
  double get minY => aabb.minY;
  double get maxX => aabb.maxX;
  double get maxY => aabb.maxY;
  bool containsAabb2(Aabb2 other) => aabb.containsAabb2(other);
  bool containsVector2(Vector2 point) => aabb.containsVector2(point);
  bool intersectsWithAabb2(Aabb2 other) => aabb.intersectsWithAabb2(other);
  bool intersectsWithVector2(Vector2 point) =>
      aabb.intersectsWithVector2(point);

  void operator []=(int index, double value) {
    aabb._storage[index] = value;
  }

  set minX(double value) {
    aabb._storage[0] = value;
  }

  set minY(double value) {
    aabb._storage[1] = value;
  }

  set maxX(double value) {
    aabb._storage[2] = value;
  }

  set maxY(double value) {
    aabb._storage[3] = value;
  }

  void set(Aabb2 other) {
    aabb._storage.setAll(0, other._storage);
  }

  /// Sets both corners from raw components, without allocating.
  void setMinMax(double minX, double minY, double maxX, double maxY) {
    final storage = aabb._storage;
    storage[0] = minX;
    storage[1] = minY;
    storage[2] = maxX;
    storage[3] = maxY;
  }

  void setCenterAndHalfExtents(Vector2 center, Vector2 halfExtents) {
    minX = center.x - halfExtents.x;
    minY = center.y - halfExtents.y;
    maxX = center.x + halfExtents.x;
    maxY = center.y + halfExtents.y;
  }

  void hull(Aabb2 other) {
    minX = math.min(minX, other.minX);
    minY = math.min(minY, other.minY);
    maxX = math.max(maxX, other.maxX);
    maxY = math.max(maxY, other.maxY);
  }

  void hullPoint(Vector2 point) {
    minX = math.min(minX, point.x);
    minY = math.min(minY, point.y);
    maxX = math.max(maxX, point.x);
    maxY = math.max(maxY, point.y);
  }
}
