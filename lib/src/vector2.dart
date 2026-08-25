import 'dart:math' as math;

import 'matrix3.dart';

/// Shared operations for [Vector2] and [MVector2].
mixin _Vector2 {
  /// The x component.
  double get x;

  /// The y component.
  double get y;

  /// Access the component of the vector at the index [index].
  double operator [](int index) {
    switch (index) {
      case 0:
        return x;

      case 1:
        return y;

      default:
        throw RangeError.value(index, 'index');
    }
  }

  /// True if both components are zero.
  bool get isZero => x == 0 && y == 0;

  /// True if any component is infinite.
  bool get isInfinite => x.isInfinite || y.isInfinite;

  /// True if any component is NaN.
  bool get isNaN => x.isNaN || y.isNaN;

  /// The length of the vector.
  double get length => math.sqrt(length2);

  /// The squared length of the vector.
  double get length2 => x * x + y * y;

  /// Distance from this to [other].
  double distance(Vector2 other) => math.sqrt(distance2(other));

  /// Squared distance from this to [other].
  double distance2(Vector2 other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return dx * dx + dy * dy;
  }

  /// Returns the absolute error between this and [correct].
  double absoluteError(Vector2 correct) => distance(correct);

  /// Returns the relative error between this and [correct].
  double relativeError(Vector2 correct) =>
      absoluteError(correct) / correct.length;

  /// Returns the angle between this and [other] in radians.
  double angleTo(Vector2 other) {
    if (this == other) {
      return 0;
    }

    final cosine = dot(other) / (length * other.length);
    return math.acos(cosine.clamp(-1.0, 1.0));
  }

  /// Returns the signed angle between this and [other] in radians.
  double angleToSigned(Vector2 other) {
    if (this == other) {
      return 0;
    }

    final sine = cross(other);
    final cosine = dot(other);
    return math.atan2(sine, cosine);
  }

  /// Negated copy of this.
  Vector2 operator -() => .new(-x, -y);

  /// Add two vectors.
  Vector2 operator +(Vector2 other) => .new(x + other.x, y + other.y);

  /// Subtract two vectors.
  Vector2 operator -(Vector2 other) => .new(x - other.x, y - other.y);

  /// Scaled copy of this.
  Vector2 operator *(double value) => scaled(value);

  /// Copy of this scaled by the inverse of [value].
  Vector2 operator /(double value) => scaled(1.0 / value);

  /// Inner product.
  double dot(Vector2 other) => x * other.x + y * other.y;

  /// Cross product.
  double cross(Vector2 other) => x * other.y - y * other.x;

  /// Floored copy of this.
  Vector2 floored() => .new(x.floorToDouble(), y.floorToDouble());

  /// Ceiled copy of this.
  Vector2 ceiled() => .new(x.ceilToDouble(), y.ceilToDouble());

  /// Rounded copy of this.
  Vector2 rounded() => .new(x.roundToDouble(), y.roundToDouble());

  /// Copy of this, rounded towards zero.
  Vector2 roundedToZero() => .new(
    x < 0 ? x.ceilToDouble() : x.floorToDouble(),
    y < 0 ? y.ceilToDouble() : y.floorToDouble(),
  );

  /// Scaled copy of this.
  Vector2 scaled(double value) => .new(x * value, y * value);

  /// Copy of this multiplied by [other].
  Vector2 multiplied(Vector2 other) => .new(x * other.x, y * other.y);

  /// Copy of this divided by [other].
  Vector2 divided(Vector2 other) => .new(x / other.x, y / other.y);

  /// Normalized copy of this.
  Vector2 normalized() {
    final length = this.length;
    if (length == 0) {
      return .new(x, y);
    }

    final scale = 1 / length;
    return .new(x * scale, y * scale);
  }

  /// Reflected copy of this.
  Vector2 reflected(Vector2 normal) {
    final dotProduct = dot(normal) * 2;
    return .new(x - normal.x * dotProduct, y - normal.y * dotProduct);
  }

  /// Copy of this with each component clamped between [range.x] and
  /// [range.y].
  Vector2 clamped(Vector2 range) => .new(
    x.clamp(range.x, range.y).toDouble(),
    y.clamp(range.x, range.y).toDouble(),
  );

  /// Copy of this with the x component clamped between [range.x] and
  /// [range.y].
  Vector2 clampedX(Vector2 range) =>
      .new(x.clamp(range.x, range.y).toDouble(), y);

  /// Copy of this with the y component clamped between [range.x] and
  /// [range.y].
  Vector2 clampedY(Vector2 range) =>
      .new(x, y.clamp(range.x, range.y).toDouble());

  /// Copy of this with each component clamped between [min] and [max].
  Vector2 clampedTo(double min, double max) =>
      .new(x.clamp(min, max).toDouble(), y.clamp(min, max).toDouble());

  /// Copy of this with the x component clamped between [min] and [max].
  Vector2 clampedToX(double min, double max) =>
      .new(x.clamp(min, max).toDouble(), y);

  /// Copy of this with the y component clamped between [min] and [max].
  Vector2 clampedToY(double min, double max) =>
      .new(x, y.clamp(min, max).toDouble());

  /// Copy of this with each component clamped between the matching components
  /// of [min] and [max].
  Vector2 clampedBetween(Vector2 min, Vector2 max) => .new(
    x.clamp(min.x, max.x).toDouble(), //
    y.clamp(min.y, max.y).toDouble(),
  );

  /// Transforms this by [matrix] and returns the result.
  Vector2 transformed(Matrix3 matrix) => .new(
    (matrix[0] * x) + (matrix[3] * y) + matrix[6],
    (matrix[1] * x) + (matrix[4] * y) + matrix[7],
  );

  /// Rotates this by the upper-left 2x2 of [matrix], ignoring translation, and
  /// returns the result.
  Vector2 rotated(Matrix3 matrix) => .new(
    (matrix[0] * x) + (matrix[3] * y), //
    (matrix[1] * x) + (matrix[4] * y),
  );

  /// Rotates this by the absolute rotation of the upper-left 2x2 of [matrix],
  /// ignoring translation, and returns the result. Primarily used by AABB
  /// transformation code.
  Vector2 absoluteRotated(Matrix3 matrix) => .new(
    (matrix[0].abs() * x) + (matrix[3].abs() * y),
    (matrix[1].abs() * x) + (matrix[4].abs() * y),
  );

  /// Returns a printable string.
  @override
  String toString() => '($x, $y)';

  /// Check if two vectors are the same.
  @override
  bool operator ==(Object other) =>
      other is Vector2 && //
      x == other.x &&
      y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}

class Vector2 with _Vector2 {
  @override
  final double x;

  @override
  final double y;

  /// Create a new vector with the given values.
  const Vector2(this.x, this.y);

  /// Create a new vector with all components set to [value].
  const Vector2.all(double value) : x = value, y = value;

  /// Create a new vector from [x] and [y], cast to doubles.
  factory Vector2.cast(num x, num y) => .new(x.toDouble(), y.toDouble());

  /// Create a new vector as a copy of [other].
  factory Vector2.copy(Vector2 other) => .new(other.x, other.y);

  /// Canonical zero vector.
  static const Vector2 zero = .all(0);

  /// Canonical infinity vector.
  static const Vector2 infinity = .all(double.infinity);

  /// Component-wise minimum of [a] and [b].
  static Vector2 min(Vector2 a, Vector2 b) =>
      .new(math.min(a.x, b.x), math.min(a.y, b.y));

  /// Component-wise maximum of [a] and [b].
  static Vector2 max(Vector2 a, Vector2 b) =>
      .new(math.max(a.x, b.x), math.max(a.y, b.y));

  /// Linear interpolation from [a] to [b] by [amount].
  static Vector2 mix(Vector2 a, Vector2 b, double amount) =>
      .new(a.x + amount * (b.x - a.x), a.y + amount * (b.y - a.y));

  /// Clone of this.
  Vector2 clone() => .copy(this);
}

class MVector2 with _Vector2 implements Vector2 {
  @override
  double x;

  @override
  double y;

  /// Create a new vector with the given values.
  MVector2(this.x, this.y);

  /// Create a new vector with all components set to zero.
  MVector2.zero() : x = 0, y = 0;

  /// Create a new vector with all components set to [value].
  MVector2.all(double value) : x = value, y = value;

  /// Create a new vector from [x] and [y], cast to doubles.
  factory MVector2.cast(num x, num y) => .new(x.toDouble(), y.toDouble());

  /// Create a new vector as a copy of [other].
  factory MVector2.copy(Vector2 other) => .new(other.x, other.y);

  /// Clone of this.
  @override
  MVector2 clone() => .copy(this);

  /// Sets the component of the vector at the index [index].
  void operator []=(int index, double value) {
    switch (index) {
      case 0:
        x = value;

      case 1:
        y = value;

      default:
        throw RangeError.value(index, 'index');
    }
  }

  /// Sets the values of this by copying them from [other].
  void setFrom(Vector2 other) {
    x = other.x;
    y = other.y;
  }

  /// Sets the values of this.
  void setValues(double x, double y) {
    this.x = x;
    this.y = y;
  }

  /// Sets all components of this to zero.
  void setZero() {
    x = 0;
    y = 0;
  }

  /// Sets all components of this to [value].
  void splat(double value) {
    x = value;
    y = value;
  }

  /// Negates this.
  void negate() {
    x = -x;
    y = -y;
  }

  /// Sets this to the component-wise absolute value of itself.
  void absolute() {
    x = x.abs();
    y = y.abs();
  }

  /// Floors each component of this.
  void floor() {
    x = x.floorToDouble();
    y = y.floorToDouble();
  }

  /// Ceils each component of this.
  void ceil() {
    x = x.ceilToDouble();
    y = y.ceilToDouble();
  }

  /// Rounds each component of this.
  void round() {
    x = x.roundToDouble();
    y = y.roundToDouble();
  }

  /// Rounds each component of this towards zero.
  void roundToZero() {
    x = x < 0 ? x.ceilToDouble() : x.floorToDouble();
    y = y < 0 ? y.ceilToDouble() : y.floorToDouble();
  }

  /// Adds [other] to this.
  void add(Vector2 other) {
    x += other.x;
    y += other.y;
  }

  /// Subtracts [other] from this.
  void subtract(Vector2 other) {
    x -= other.x;
    y -= other.y;
  }

  /// Scales this by [value].
  void scale(double value) {
    x *= value;
    y *= value;
  }

  /// Multiplies each component of this by the matching component of [other].
  void multiply(Vector2 other) {
    x *= other.x;
    y *= other.y;
  }

  /// Divides each component of this by the matching component of [other].
  void divide(Vector2 other) {
    x /= other.x;
    y /= other.y;
  }

  /// Sets this to the component-wise maximum of this and [other].
  void max(Vector2 other) {
    x = math.max(x, other.x);
    y = math.max(y, other.y);
  }

  /// Sets this to the component-wise minimum of this and [other].
  void min(Vector2 other) {
    x = math.min(x, other.x);
    y = math.min(y, other.y);
  }

  /// Sets this to the linear interpolation from this to [other] by [amount].
  void mix(Vector2 other, double amount) {
    x += amount * (other.x - x);
    y += amount * (other.y - y);
  }

  /// Adds [other] scaled by [value] to this.
  void addScaled(Vector2 other, double value) {
    x += other.x * value;
    y += other.y * value;
  }

  /// Normalizes this. Returns the length of the vector before normalization.
  double normalize() {
    final length = this.length;
    if (length == 0) {
      return 0;
    }

    final scale = 1 / length;
    x *= scale;
    y *= scale;
    return length;
  }

  /// Reflects this.
  void reflect(Vector2 normal) {
    final dotProduct = normal.dot(this) * 2;
    x -= normal.x * dotProduct;
    y -= normal.y * dotProduct;
  }

  /// Clamps each component of this between [range.x] and [range.y].
  void clamp(Vector2 range) {
    x = x.clamp(range.x, range.y).toDouble();
    y = y.clamp(range.x, range.y).toDouble();
  }

  /// Clamps the x component of this between [range.x] and [range.y].
  void clampX(Vector2 range) {
    x = x.clamp(range.x, range.y).toDouble();
  }

  /// Clamps the y component of this between [range.x] and [range.y].
  void clampY(Vector2 range) {
    y = y.clamp(range.x, range.y).toDouble();
  }

  /// Clamps each component of this between [min] and [max].
  void clampTo(double min, double max) {
    x = x.clamp(min, max).toDouble();
    y = y.clamp(min, max).toDouble();
  }

  /// Clamps the x component of this between [min] and [max].
  void clampToX(double min, double max) {
    x = x.clamp(min, max).toDouble();
  }

  /// Clamps the y component of this between [min] and [max].
  void clampToY(double min, double max) {
    y = y.clamp(min, max).toDouble();
  }

  /// Clamps each component of this between the matching components of [min]
  /// and [max].
  void clampBetween(Vector2 min, Vector2 max) {
    x = x.clamp(min.x, max.x).toDouble();
    y = y.clamp(min.y, max.y).toDouble();
  }

  /// Transforms this by [matrix].
  void transform(Matrix3 matrix) {
    final x = this.x;
    final y = this.y;
    this.x = (matrix[0] * x) + (matrix[3] * y) + matrix[6];
    this.y = (matrix[1] * x) + (matrix[4] * y) + matrix[7];
  }

  /// Rotates this by the upper-left 2x2 of [matrix], ignoring translation.
  void rotate(Matrix3 matrix) {
    final x = this.x;
    final y = this.y;
    this.x = (matrix[0] * x) + (matrix[3] * y);
    this.y = (matrix[1] * x) + (matrix[4] * y);
  }

  /// Rotates this by the absolute rotation of the upper-left 2x2 of [matrix],
  /// ignoring translation. Primarily used by AABB transformation code.
  void absoluteRotate(Matrix3 matrix) {
    final x = this.x;
    final y = this.y;
    this.x = (matrix[0].abs() * x) + (matrix[3].abs() * y);
    this.y = (matrix[1].abs() * x) + (matrix[4].abs() * y);
  }
}
