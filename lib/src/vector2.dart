import 'dart:math';
import 'dart:typed_data';

import 'matrix3.dart';
import 'mutable.dart';

class Vector2 implements Mutable<MutableVector2> {
  Vector2.zero();

  Vector2(double x, double y) {
    _storage[0] = x;
    _storage[1] = y;
  }

  Vector2.cast(num x, num y) {
    _storage[0] = x.toDouble();
    _storage[1] = y.toDouble();
  }

  Vector2.copy(Vector2 other) {
    _storage[0] = other.x;
    _storage[1] = other.y;
  }

  Vector2.all(double value) {
    _storage[0] = value;
    _storage[1] = value;
  }

  static Random? _random;

  Vector2.random([Random? random]) {
    random ??= (_random ??= Random());
    _storage[0] = random.nextDouble();
    _storage[1] = random.nextDouble();
  }

  final _storage = Float64List(2);

  double operator [](int index) => _storage[index];
  double get x => _storage[0];
  double get y => _storage[1];
  Vector2 clone() => .copy(this);

  bool get isZero => x == 0 && y == 0;
  bool get isInfinite => x.isInfinite || y.isInfinite;
  bool get isNaN => x.isNaN || y.isNaN;
  double get length => sqrt(length2);
  double get length2 => x * x + y * y;
  double distance(Vector2 other) => sqrt(distance2(other));
  double distance2(Vector2 other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return dx * dx + dy * dy;
  }

  double angleTo(Vector2 other) {
    if (this == other) return 0;
    final cosine = dot(other) / (length * other.length);
    return acos(cosine.clamp(-1.0, 1.0));
  }

  double angleToSigned(Vector2 other) {
    if (this == other) return 0;
    final sine = cross(other);
    final cosine = dot(other);
    return atan2(sine, cosine);
  }

  Vector2 operator -() => .new(-x, -y);
  Vector2 operator +(Vector2 other) => .new(x + other.x, y + other.y);
  Vector2 operator -(Vector2 other) => .new(x - other.x, y - other.y);
  Vector2 operator *(double value) => scale(value);
  Vector2 operator /(double value) => scale(1.0 / value);
  double dot(Vector2 other) => x * other.x + y * other.y;
  double cross(Vector2 other) => x * other.y - y * other.x;
  Vector2 absolute() => clone()..mutate().absolute();
  Vector2 scale(double value) => clone()..mutate().scale(value);
  Vector2 multiply(Vector2 other) => clone()..mutate().multiply(other);
  Vector2 normalize() => clone()..mutate().normalize();
  Vector2 reflect(Vector2 normal) => clone()..mutate().reflect(normal);
  Vector2 clamp(Vector2 xRange, [Vector2? yRange]) => clone()..mutate().clamp(xRange, yRange);
  Vector2 clampTo(double min, double max) => clone()..mutate().clampTo(min, max);

  /// Transforms this by [matrix] and returns the result.
  Vector2 transformWith(Matrix3 matrix) => clone()..mutate().transformWith(matrix);

  /// Rotates this by the absolute rotation of the top-left 2x2 of [matrix],
  /// ignoring translation, and returns the result. Primarily used by AABB
  /// transformation code.
  Vector2 absoluteRotate2With(Matrix3 matrix) => clone()..mutate().absoluteRotate2With(matrix);

  @override
  MutableVector2 mutate() => MutableVector2._(this);
  void modify(void Function(MutableVector2 vector) mutation) => mutation(mutate());

  @override
  String toString() => '($x, $y)';

  @override
  bool operator ==(Object other) =>
      other is Vector2 && //
      x == other.x &&
      y == other.y;

  @override
  int get hashCode => Object.hashAll(_storage);
}

extension type MutableVector2._(Vector2 source) {
  Float64List get storage => source._storage;
  double operator [](int index) => source[index];
  double get x => source.x;
  double get y => source.y;
  bool get isZero => source.isZero;
  bool get isInfinite => source.isInfinite;
  bool get isNaN => source.isNaN;
  double get length => source.length;
  double get length2 => source.length2;
  double distance(Vector2 other) => source.distance(other);
  double distance2(Vector2 other) => source.distance2(other);
  double angleTo(Vector2 other) => source.angleTo(other);
  double angleToSigned(Vector2 other) => source.angleToSigned(other);
  double dot(Vector2 other) => source.dot(other);
  double cross(Vector2 other) => source.cross(other);

  void operator []=(int index, double value) {
    source._storage[index] = value;
  }

  set x(double value) {
    source._storage[0] = value;
  }

  set y(double value) {
    source._storage[1] = value;
  }

  void setFrom(Vector2 other) {
    x = other.x;
    y = other.y;
  }

  void setValues(double x, double y) {
    this.x = x;
    this.y = y;
  }

  void setAll(double value) {
    x = value;
    y = value;
  }

  void negate() {
    x = -x;
    y = -y;
  }

  void absolute() {
    x = x.abs();
    y = y.abs();
  }

  void clamp(Vector2 xRange, [Vector2? yRange]) {
    yRange ??= xRange;
    x = x.clamp(xRange.x, xRange.y).toDouble();
    y = y.clamp(yRange.x, yRange.y).toDouble();
  }

  void clampTo(double min, double max) {
    x = x.clamp(min, max).toDouble();
    y = y.clamp(min, max).toDouble();
  }

  void floor() {
    x = x.floorToDouble();
    y = y.floorToDouble();
  }

  void ceil() {
    x = x.ceilToDouble();
    y = y.ceilToDouble();
  }

  void round() {
    x = x.roundToDouble();
    y = y.roundToDouble();
  }

  void roundToZero() {
    x = x < 0 ? x.ceilToDouble() : x.floorToDouble();
    y = y < 0 ? y.ceilToDouble() : y.floorToDouble();
  }

  void add(Vector2 other) {
    x += other.x;
    y += other.y;
  }

  void addAll(double value) {
    x += value;
    y += value;
  }

  void subtract(Vector2 other) {
    x -= other.x;
    y -= other.y;
  }

  void subtractAll(double value) {
    x -= value;
    y -= value;
  }

  void scale(double value) {
    x *= value;
    y *= value;
  }

  void multiply(Vector2 other) {
    x *= other.x;
    y *= other.y;
  }

  void addScaled(Vector2 other, double value) {
    x += other.x * value;
    y += other.y * value;
  }

  double normalize() {
    final length = source.length;
    if (length == 0) return 0;

    final scale = 1 / length;
    x *= scale;
    y *= scale;
    return length;
  }

  void reflect(Vector2 normal) {
    final dotProduct = normal.dot(source) * 2;
    x -= normal.x * dotProduct;
    y -= normal.y * dotProduct;
  }

  /// Transforms this by [matrix] in place.
  void transformWith(Matrix3 matrix) {
    final oldX = x;
    final oldY = y;
    x = (matrix[0] * oldX) + (matrix[3] * oldY) + matrix[6];
    y = (matrix[1] * oldX) + (matrix[4] * oldY) + matrix[7];
  }

  /// Rotates this by the absolute rotation of the top-left 2x2 of [matrix],
  /// ignoring translation, in place. Primarily used by AABB transformation
  /// code.
  void absoluteRotate2With(Matrix3 matrix) {
    final m00 = matrix[0].abs();
    final m01 = matrix[3].abs();
    final m10 = matrix[1].abs();
    final m11 = matrix[4].abs();
    final oldX = x;
    final oldY = y;
    x = (oldX * m00) + (oldY * m01);
    y = (oldX * m10) + (oldY * m11);
  }
}
