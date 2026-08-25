import 'dart:math' as math;

import 'matrix3.dart';
import 'matrix4.dart';
import 'vector2.dart';

/// Shared operations for [Vector3] and [MVector3].
mixin _Vector3 {
  /// The x component.
  double get x;

  /// The y component.
  double get y;

  /// The z component.
  double get z;

  /// Access the component of the vector at the index [index].
  double operator [](int index) {
    switch (index) {
      case 0:
        return x;

      case 1:
        return y;

      case 2:
        return z;

      default:
        throw RangeError.value(index, 'index');
    }
  }

  /// True if all components are zero.
  bool get isZero => x == 0 && y == 0 && z == 0;

  /// True if any component is infinite.
  bool get isInfinite => x.isInfinite || y.isInfinite || z.isInfinite;

  /// True if any component is NaN.
  bool get isNaN => x.isNaN || y.isNaN || z.isNaN;

  /// The length of the vector.
  double get length => math.sqrt(length2);

  /// The squared length of the vector.
  double get length2 => x * x + y * y + z * z;

  /// Distance from this to [other].
  double distance(Vector3 other) => math.sqrt(distance2(other));

  /// Squared distance from this to [other].
  double distance2(Vector3 other) {
    final dx = x - other.x;
    final dy = y - other.y;
    final dz = z - other.z;
    return dx * dx + dy * dy + dz * dz;
  }

  /// Returns the absolute error between this and [correct].
  double absoluteError(Vector3 correct) => distance(correct);

  /// Returns the relative error between this and [correct].
  double relativeError(Vector3 correct) =>
      absoluteError(correct) / correct.length;

  /// Returns the angle between this and [other] in radians.
  double angleTo(Vector3 other) {
    if (this == other) {
      return 0;
    }

    final cosine = dot(other) / (length * other.length);
    return math.acos(cosine.clamp(-1.0, 1.0));
  }

  /// Returns the signed angle between this and [other] around [normal] in
  /// radians.
  double angleToSigned(Vector3 other, Vector3 normal) {
    final angle = angleTo(other);
    final sign = cross(other).dot(normal);
    return sign < 0 ? -angle : angle;
  }

  /// Negated copy of this.
  Vector3 operator -() => .new(-x, -y, -z);

  /// Add two vectors.
  Vector3 operator +(Vector3 other) =>
      .new(x + other.x, y + other.y, z + other.z);

  /// Subtract two vectors.
  Vector3 operator -(Vector3 other) =>
      .new(x - other.x, y - other.y, z - other.z);

  /// Scaled copy of this.
  Vector3 operator *(double value) => scaled(value);

  /// Copy of this scaled by the inverse of [value].
  Vector3 operator /(double value) => scaled(1.0 / value);

  /// Inner product.
  double dot(Vector3 other) => x * other.x + y * other.y + z * other.z;

  /// Cross product.
  Vector3 cross(Vector3 other) => .new(
    y * other.z - z * other.y,
    z * other.x - x * other.z,
    x * other.y - y * other.x,
  );

  /// Floored copy of this.
  Vector3 floored() =>
      .new(x.floorToDouble(), y.floorToDouble(), z.floorToDouble());

  /// Ceiled copy of this.
  Vector3 ceiled() =>
      .new(x.ceilToDouble(), y.ceilToDouble(), z.ceilToDouble());

  /// Rounded copy of this.
  Vector3 rounded() =>
      .new(x.roundToDouble(), y.roundToDouble(), z.roundToDouble());

  /// Copy of this, rounded towards zero.
  Vector3 roundedToZero() => .new(
    x < 0 ? x.ceilToDouble() : x.floorToDouble(),
    y < 0 ? y.ceilToDouble() : y.floorToDouble(),
    z < 0 ? z.ceilToDouble() : z.floorToDouble(),
  );

  /// Scaled copy of this.
  Vector3 scaled(double value) => .new(x * value, y * value, z * value);

  /// Copy of this multiplied by [other].
  Vector3 multiplied(Vector3 other) =>
      .new(x * other.x, y * other.y, z * other.z);

  /// Copy of this divided by [other].
  Vector3 divided(Vector3 other) => .new(x / other.x, y / other.y, z / other.z);

  /// Normalized copy of this.
  Vector3 normalized() {
    final length = this.length;
    if (length == 0) {
      return .new(x, y, z);
    }

    final scale = 1 / length;
    return .new(x * scale, y * scale, z * scale);
  }

  /// Reflected copy of this.
  Vector3 reflected(Vector3 normal) {
    final dotProduct = dot(normal) * 2;
    return .new(
      x - normal.x * dotProduct,
      y - normal.y * dotProduct,
      z - normal.z * dotProduct,
    );
  }

  /// Copy of this with each component clamped between [range.x] and
  /// [range.y].
  Vector3 clamped(Vector2 range) => .new(
    x.clamp(range.x, range.y).toDouble(),
    y.clamp(range.x, range.y).toDouble(),
    z.clamp(range.x, range.y).toDouble(),
  );

  /// Copy of this with the x component clamped between [range.x] and
  /// [range.y].
  Vector3 clampedX(Vector2 range) =>
      .new(x.clamp(range.x, range.y).toDouble(), y, z);

  /// Copy of this with the y component clamped between [range.x] and
  /// [range.y].
  Vector3 clampedY(Vector2 range) =>
      .new(x, y.clamp(range.x, range.y).toDouble(), z);

  /// Copy of this with the z component clamped between [range.x] and
  /// [range.y].
  Vector3 clampedZ(Vector2 range) =>
      .new(x, y, z.clamp(range.x, range.y).toDouble());

  /// Copy of this with each component clamped between [min] and [max].
  Vector3 clampedTo(double min, double max) => .new(
    x.clamp(min, max).toDouble(),
    y.clamp(min, max).toDouble(),
    z.clamp(min, max).toDouble(),
  );

  /// Copy of this with the x component clamped between [min] and [max].
  Vector3 clampedToX(double min, double max) =>
      .new(x.clamp(min, max).toDouble(), y, z);

  /// Copy of this with the y component clamped between [min] and [max].
  Vector3 clampedToY(double min, double max) =>
      .new(x, y.clamp(min, max).toDouble(), z);

  /// Copy of this with the z component clamped between [min] and [max].
  Vector3 clampedToZ(double min, double max) =>
      .new(x, y, z.clamp(min, max).toDouble());

  /// Copy of this with each component clamped between the matching components
  /// of [min] and [max].
  Vector3 clampedBetween(Vector3 min, Vector3 max) => .new(
    x.clamp(min.x, max.x).toDouble(), //
    y.clamp(min.y, max.y).toDouble(),
    z.clamp(min.z, max.z).toDouble(),
  );

  /// Returns [matrix] multiplied by this. Note the order.
  Vector3 premultiplied(Matrix3 matrix) => .new(
    (matrix[0] * x) + (matrix[3] * y) + (matrix[6] * z),
    (matrix[1] * x) + (matrix[4] * y) + (matrix[7] * z),
    (matrix[2] * x) + (matrix[5] * y) + (matrix[8] * z),
  );

  /// Returns this, as a row vector, multiplied by [matrix]. Note the order. If
  /// [matrix] is a rotation matrix, this is a computational shortcut for
  /// applying the inverse of the transformation.
  Vector3 postmultiplied(Matrix3 matrix) => .new(
    (x * matrix[0]) + (y * matrix[1]) + (z * matrix[2]),
    (x * matrix[3]) + (y * matrix[4]) + (z * matrix[5]),
    (x * matrix[6]) + (y * matrix[7]) + (z * matrix[8]),
  );

  /// Transforms this by [matrix] and returns the result.
  Vector3 transformed(Matrix4 matrix) => .new(
    (matrix[0] * x) + (matrix[4] * y) + (matrix[8] * z) + matrix[12],
    (matrix[1] * x) + (matrix[5] * y) + (matrix[9] * z) + matrix[13],
    (matrix[2] * x) + (matrix[6] * y) + (matrix[10] * z) + matrix[14],
  );

  /// Rotates this by the upper-left 3x3 of [matrix], ignoring translation, and
  /// returns the result.
  Vector3 rotated(Matrix4 matrix) => .new(
    (matrix[0] * x) + (matrix[4] * y) + (matrix[8] * z),
    (matrix[1] * x) + (matrix[5] * y) + (matrix[9] * z),
    (matrix[2] * x) + (matrix[6] * y) + (matrix[10] * z),
  );

  /// Returns a printable string.
  @override
  String toString() => '($x, $y, $z)';

  /// Check if two vectors are the same.
  @override
  bool operator ==(Object other) =>
      other is Vector3 && //
      x == other.x &&
      y == other.y &&
      z == other.z;

  @override
  int get hashCode => Object.hash(x, y, z);
}

class Vector3 with _Vector3 {
  @override
  final double x;

  @override
  final double y;

  @override
  final double z;

  /// Create a new vector with the given values.
  const Vector3(this.x, this.y, this.z);

  /// Create a new vector with all components set to [value].
  const Vector3.all(double value) : x = value, y = value, z = value;

  /// Create a new vector from [x], [y], and [z], cast to doubles.
  factory Vector3.cast(num x, num y, num z) =>
      .new(x.toDouble(), y.toDouble(), z.toDouble());

  /// Create a new vector as a copy of [other].
  factory Vector3.copy(Vector3 other) => .new(other.x, other.y, other.z);

  /// Canonical zero vector.
  static const Vector3 zero = .all(0);

  /// Canonical infinity vector.
  static const Vector3 infinity = .all(double.infinity);

  /// Component-wise minimum of [a] and [b].
  static Vector3 min(Vector3 a, Vector3 b) =>
      .new(math.min(a.x, b.x), math.min(a.y, b.y), math.min(a.z, b.z));

  /// Component-wise maximum of [a] and [b].
  static Vector3 max(Vector3 a, Vector3 b) =>
      .new(math.max(a.x, b.x), math.max(a.y, b.y), math.max(a.z, b.z));

  /// Linear interpolation from [a] to [b] by [amount].
  static Vector3 mix(Vector3 a, Vector3 b, double amount) => .new(
    a.x + amount * (b.x - a.x),
    a.y + amount * (b.y - a.y),
    a.z + amount * (b.z - a.z),
  );

  /// Clone of this.
  Vector3 clone() => .copy(this);
}

class MVector3 with _Vector3 implements Vector3 {
  @override
  double x;

  @override
  double y;

  @override
  double z;

  /// Create a new vector with the given values.
  MVector3(this.x, this.y, this.z);

  /// Create a new vector with all components set to zero.
  MVector3.zero() : x = 0, y = 0, z = 0;

  /// Create a new vector with all components set to [value].
  MVector3.all(double value) : x = value, y = value, z = value;

  /// Create a new vector from [x], [y], and [z], cast to doubles.
  factory MVector3.cast(num x, num y, num z) =>
      .new(x.toDouble(), y.toDouble(), z.toDouble());

  /// Create a new vector as a copy of [other].
  factory MVector3.copy(Vector3 other) => .new(other.x, other.y, other.z);

  /// Clone of this.
  @override
  MVector3 clone() => .copy(this);

  /// Sets the component of the vector at the index [index].
  void operator []=(int index, double value) {
    switch (index) {
      case 0:
        x = value;

      case 1:
        y = value;

      case 2:
        z = value;

      default:
        throw RangeError.value(index, 'index');
    }
  }

  /// Sets the values of this by copying them from [other].
  void setFrom(Vector3 other) {
    x = other.x;
    y = other.y;
    z = other.z;
  }

  /// Sets the values of this.
  void setValues(double x, double y, double z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  /// Sets all components of this to zero.
  void setZero() {
    x = 0;
    y = 0;
    z = 0;
  }

  /// Sets all components of this to [value].
  void splat(double value) {
    x = value;
    y = value;
    z = value;
  }

  /// Negates this.
  void negate() {
    x = -x;
    y = -y;
    z = -z;
  }

  /// Sets this to the component-wise absolute value of itself.
  void absolute() {
    x = x.abs();
    y = y.abs();
    z = z.abs();
  }

  /// Floors each component of this.
  void floor() {
    x = x.floorToDouble();
    y = y.floorToDouble();
    z = z.floorToDouble();
  }

  /// Ceils each component of this.
  void ceil() {
    x = x.ceilToDouble();
    y = y.ceilToDouble();
    z = z.ceilToDouble();
  }

  /// Rounds each component of this.
  void round() {
    x = x.roundToDouble();
    y = y.roundToDouble();
    z = z.roundToDouble();
  }

  /// Rounds each component of this towards zero.
  void roundToZero() {
    x = x < 0 ? x.ceilToDouble() : x.floorToDouble();
    y = y < 0 ? y.ceilToDouble() : y.floorToDouble();
    z = z < 0 ? z.ceilToDouble() : z.floorToDouble();
  }

  /// Adds [other] to this.
  void add(Vector3 other) {
    x += other.x;
    y += other.y;
    z += other.z;
  }

  /// Subtracts [other] from this.
  void subtract(Vector3 other) {
    x -= other.x;
    y -= other.y;
    z -= other.z;
  }

  /// Scales this by [value].
  void scale(double value) {
    x *= value;
    y *= value;
    z *= value;
  }

  /// Multiplies each component of this by the matching component of [other].
  void multiply(Vector3 other) {
    x *= other.x;
    y *= other.y;
    z *= other.z;
  }

  /// Divides each component of this by the matching component of [other].
  void divide(Vector3 other) {
    x /= other.x;
    y /= other.y;
    z /= other.z;
  }

  /// Sets this to the component-wise maximum of this and [other].
  void max(Vector3 other) {
    x = math.max(x, other.x);
    y = math.max(y, other.y);
    z = math.max(z, other.z);
  }

  /// Sets this to the component-wise minimum of this and [other].
  void min(Vector3 other) {
    x = math.min(x, other.x);
    y = math.min(y, other.y);
    z = math.min(z, other.z);
  }

  /// Sets this to the linear interpolation from this to [other] by [amount].
  void mix(Vector3 other, double amount) {
    x += amount * (other.x - x);
    y += amount * (other.y - y);
    z += amount * (other.z - z);
  }

  /// Adds [other] scaled by [value] to this.
  void addScaled(Vector3 other, double value) {
    x += other.x * value;
    y += other.y * value;
    z += other.z * value;
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
    z *= scale;
    return length;
  }

  /// Reflects this.
  void reflect(Vector3 normal) {
    final dotProduct = normal.dot(this) * 2;
    x -= normal.x * dotProduct;
    y -= normal.y * dotProduct;
    z -= normal.z * dotProduct;
  }

  /// Clamps each component of this between [range.x] and [range.y].
  void clamp(Vector2 range) {
    x = x.clamp(range.x, range.y).toDouble();
    y = y.clamp(range.x, range.y).toDouble();
    z = z.clamp(range.x, range.y).toDouble();
  }

  /// Clamps the x component of this between [range.x] and [range.y].
  void clampX(Vector2 range) {
    x = x.clamp(range.x, range.y).toDouble();
  }

  /// Clamps the y component of this between [range.x] and [range.y].
  void clampY(Vector2 range) {
    y = y.clamp(range.x, range.y).toDouble();
  }

  /// Clamps the z component of this between [range.x] and [range.y].
  void clampZ(Vector2 range) {
    z = z.clamp(range.x, range.y).toDouble();
  }

  /// Clamps each component of this between [min] and [max].
  void clampTo(double min, double max) {
    x = x.clamp(min, max).toDouble();
    y = y.clamp(min, max).toDouble();
    z = z.clamp(min, max).toDouble();
  }

  /// Clamps the x component of this between [min] and [max].
  void clampToX(double min, double max) {
    x = x.clamp(min, max).toDouble();
  }

  /// Clamps the y component of this between [min] and [max].
  void clampToY(double min, double max) {
    y = y.clamp(min, max).toDouble();
  }

  /// Clamps the z component of this between [min] and [max].
  void clampToZ(double min, double max) {
    z = z.clamp(min, max).toDouble();
  }

  /// Clamps each component of this between the matching components of [min]
  /// and [max].
  void clampBetween(Vector3 min, Vector3 max) {
    x = x.clamp(min.x, max.x).toDouble();
    y = y.clamp(min.y, max.y).toDouble();
    z = z.clamp(min.z, max.z).toDouble();
  }

  /// Sets this to [matrix] multiplied by this. Note the order.
  void premultiply(Matrix3 matrix) {
    final x = this.x;
    final y = this.y;
    final z = this.z;
    this.x = (matrix[0] * x) + (matrix[3] * y) + (matrix[6] * z);
    this.y = (matrix[1] * x) + (matrix[4] * y) + (matrix[7] * z);
    this.z = (matrix[2] * x) + (matrix[5] * y) + (matrix[8] * z);
  }

  /// Sets this to this, as a row vector, multiplied by [matrix]. Note the
  /// order. If [matrix] is a rotation matrix, this is a computational shortcut
  /// for applying the inverse of the transformation.
  void postmultiply(Matrix3 matrix) {
    final x = this.x;
    final y = this.y;
    final z = this.z;
    this.x = (x * matrix[0]) + (y * matrix[1]) + (z * matrix[2]);
    this.y = (x * matrix[3]) + (y * matrix[4]) + (z * matrix[5]);
    this.z = (x * matrix[6]) + (y * matrix[7]) + (z * matrix[8]);
  }

  /// Transforms this by [matrix].
  void transform(Matrix4 matrix) {
    final x = this.x;
    final y = this.y;
    final z = this.z;
    this.x = (matrix[0] * x) + (matrix[4] * y) + (matrix[8] * z) + matrix[12];
    this.y = (matrix[1] * x) + (matrix[5] * y) + (matrix[9] * z) + matrix[13];
    this.z = (matrix[2] * x) + (matrix[6] * y) + (matrix[10] * z) + matrix[14];
  }

  /// Rotates this by the upper-left 3x3 of [matrix], ignoring translation.
  void rotate(Matrix4 matrix) {
    final x = this.x;
    final y = this.y;
    final z = this.z;
    this.x = (matrix[0] * x) + (matrix[4] * y) + (matrix[8] * z);
    this.y = (matrix[1] * x) + (matrix[5] * y) + (matrix[9] * z);
    this.z = (matrix[2] * x) + (matrix[6] * y) + (matrix[10] * z);
  }
}
