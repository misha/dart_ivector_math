import 'dart:math';
import 'dart:typed_data';

import 'matrix3.dart';
import 'vector3.dart';

/// Shared operations for [Matrix4] and [MMatrix4]. Values are stored in
/// column-major order.
mixin _Matrix4 {
  /// Access the element of the matrix at the index [index].
  double operator [](int index);

  /// Dimension of the matrix.
  int get dimension => 4;

  /// Value at [row], [col].
  double entry(int row, int col) {
    assert(row >= 0 && row < dimension);
    assert(col >= 0 && col < dimension);
    return this[(col * 4) + row];
  }

  /// Returns the determinant of this matrix.
  double determinant() {
    // dart format off
    final d01 = this[0] * this[5] - this[1] * this[4];
    final d02 = this[0] * this[6] - this[2] * this[4];
    final d03 = this[0] * this[7] - this[3] * this[4];
    final d12 = this[1] * this[6] - this[2] * this[5];
    final d13 = this[1] * this[7] - this[3] * this[5];
    final d23 = this[2] * this[7] - this[3] * this[6];
    final t012 = this[8] * d12 - this[9] * d02 + this[10] * d01;
    final t013 = this[8] * d13 - this[9] * d03 + this[11] * d01;
    final t023 = this[8] * d23 - this[10] * d03 + this[11] * d02;
    final t123 = this[9] * d23 - this[10] * d13 + this[11] * d12;
    return -t123 * this[12] + t023 * this[13] - t013 * this[14] + t012 * this[15];
    // dart format on
  }

  /// Returns the trace of the matrix: the sum of the diagonal entries.
  double trace() => this[0] + this[5] + this[10] + this[15];

  /// Is this the identity matrix?
  bool isIdentity() =>
      // dart format off
      this[0] == 1.0 && this[1] == 0.0 && this[2] == 0.0 && this[3] == 0.0 &&
      this[4] == 0.0 && this[5] == 1.0 && this[6] == 0.0 && this[7] == 0.0 &&
      this[8] == 0.0 && this[9] == 0.0 && this[10] == 1.0 && this[11] == 0.0 &&
      this[12] == 0.0 && this[13] == 0.0 && this[14] == 0.0 && this[15] == 1.0;
      // dart format on

  /// Is this the zero matrix?
  bool isZero() {
    for (var i = 0; i < 16; i += 1) {
      if (this[i] != 0.0) {
        return false;
      }
    }

    return true;
  }

  /// Returns the infinity norm of the matrix. Used for numerical analysis.
  double infinityNorm() {
    var norm = 0.0;

    for (var column = 0; column < 16; column += 4) {
      final columnNorm =
          this[column].abs() + //
          this[column + 1].abs() +
          this[column + 2].abs() +
          this[column + 3].abs();

      norm = columnNorm > norm ? columnNorm : norm;
    }

    return norm;
  }

  /// Returns the relative error between this and [correct].
  double relativeError(Matrix4 correct) =>
      (this - correct).infinityNorm() / correct.infinityNorm();

  /// Returns the absolute error between this and [correct].
  double absoluteError(Matrix4 correct) =>
      (infinityNorm() - correct.infinityNorm()).abs();

  /// The translation part of this. Allocates a new [Vector3].
  Vector3 get translation => .new(this[12], this[13], this[14]);

  /// The upper-left 3x3 of this. Allocates a new [Matrix3].
  Matrix3 get rotation => .new(
    // dart format off
    this[0], this[1], this[2],
    this[4], this[5], this[6],
    this[8], this[9], this[10],
    // dart format on
  );

  /// Copies this into [array] starting at [offset].
  void copyIntoArray(List<num> array, [int offset = 0]) {
    for (var i = 0; i < 16; i += 1) {
      array[offset + i] = this[i];
    }
  }

  /// Returns the transpose of this.
  Matrix4 transposed() => .new(
    // dart format off
    this[0], this[4], this[8],  this[12],
    this[1], this[5], this[9],  this[13],
    this[2], this[6], this[10], this[14],
    this[3], this[7], this[11], this[15],
    // dart format on
  );

  /// Returns a copy of this with every entry scaled by [scale].
  Matrix4 scaled(double scale) => .new(
    // dart format off
    this[0]  * scale, this[1]  * scale, this[2]  * scale, this[3]  * scale,
    this[4]  * scale, this[5]  * scale, this[6]  * scale, this[7]  * scale,
    this[8]  * scale, this[9]  * scale, this[10] * scale, this[11] * scale,
    this[12] * scale, this[13] * scale, this[14] * scale, this[15] * scale,
    // dart format on
  );

  /// Returns this multiplied by a scale matrix of [scale]. Note the order.
  Matrix4 scaledBy(Vector3 scale) {
    final sx = scale.x, sy = scale.y, sz = scale.z;

    return .new(
      // dart format off
      this[0]  * sx, this[1]  * sx, this[2]  * sx, this[3]  * sx,
      this[4]  * sy, this[5]  * sy, this[6]  * sy, this[7]  * sy,
      this[8]  * sz, this[9]  * sz, this[10] * sz, this[11] * sz,
      this[12],      this[13],      this[14],      this[15],
      // dart format on
    );
  }

  /// Returns this multiplied by a translation matrix of [translation]. Note
  /// the order.
  Matrix4 translated(Vector3 translation) {
    final tx = translation.x, ty = translation.y, tz = translation.z;

    return .new(
      // dart format off
      this[0], this[1], this[2],  this[3],
      this[4], this[5], this[6],  this[7],
      this[8], this[9], this[10], this[11],
      // dart format on
      (this[0] * tx) + (this[4] * ty) + (this[8] * tz) + this[12],
      (this[1] * tx) + (this[5] * ty) + (this[9] * tz) + this[13],
      (this[2] * tx) + (this[6] * ty) + (this[10] * tz) + this[14],
      (this[3] * tx) + (this[7] * ty) + (this[11] * tz) + this[15],
    );
  }

  /// Returns a copy with the diagonal set to [value].
  Matrix4 diagonal(double value) => .new(
    // dart format off
    value,    this[1],  this[2],  this[3],
    this[4],  value,    this[6],  this[7],
    this[8],  this[9],  value,    this[11],
    this[12], this[13], this[14], value,
    // dart format on
  );

  /// Returns this matrix multiplied by [arg]. Note the order.
  Matrix4 multiplied(Matrix4 arg) {
    final m00 = this[0], m01 = this[4], m02 = this[8], m03 = this[12];
    final m10 = this[1], m11 = this[5], m12 = this[9], m13 = this[13];
    final m20 = this[2], m21 = this[6], m22 = this[10], m23 = this[14];
    final m30 = this[3], m31 = this[7], m32 = this[11], m33 = this[15];
    final n00 = arg[0], n01 = arg[4], n02 = arg[8], n03 = arg[12];
    final n10 = arg[1], n11 = arg[5], n12 = arg[9], n13 = arg[13];
    final n20 = arg[2], n21 = arg[6], n22 = arg[10], n23 = arg[14];
    final n30 = arg[3], n31 = arg[7], n32 = arg[11], n33 = arg[15];

    return .new(
      (m00 * n00) + (m01 * n10) + (m02 * n20) + (m03 * n30),
      (m10 * n00) + (m11 * n10) + (m12 * n20) + (m13 * n30),
      (m20 * n00) + (m21 * n10) + (m22 * n20) + (m23 * n30),
      (m30 * n00) + (m31 * n10) + (m32 * n20) + (m33 * n30),
      (m00 * n01) + (m01 * n11) + (m02 * n21) + (m03 * n31),
      (m10 * n01) + (m11 * n11) + (m12 * n21) + (m13 * n31),
      (m20 * n01) + (m21 * n11) + (m22 * n21) + (m23 * n31),
      (m30 * n01) + (m31 * n11) + (m32 * n21) + (m33 * n31),
      (m00 * n02) + (m01 * n12) + (m02 * n22) + (m03 * n32),
      (m10 * n02) + (m11 * n12) + (m12 * n22) + (m13 * n32),
      (m20 * n02) + (m21 * n12) + (m22 * n22) + (m23 * n32),
      (m30 * n02) + (m31 * n12) + (m32 * n22) + (m33 * n32),
      (m00 * n03) + (m01 * n13) + (m02 * n23) + (m03 * n33),
      (m10 * n03) + (m11 * n13) + (m12 * n23) + (m13 * n33),
      (m20 * n03) + (m21 * n13) + (m22 * n23) + (m23 * n33),
      (m30 * n03) + (m31 * n13) + (m32 * n23) + (m33 * n33),
    );
  }

  /// Returns [arg] multiplied by this. Note the order.
  Matrix4 premultiplied(Matrix4 arg) {
    final m00 = arg[0], m01 = arg[4], m02 = arg[8], m03 = arg[12];
    final m10 = arg[1], m11 = arg[5], m12 = arg[9], m13 = arg[13];
    final m20 = arg[2], m21 = arg[6], m22 = arg[10], m23 = arg[14];
    final m30 = arg[3], m31 = arg[7], m32 = arg[11], m33 = arg[15];
    final n00 = this[0], n01 = this[4], n02 = this[8], n03 = this[12];
    final n10 = this[1], n11 = this[5], n12 = this[9], n13 = this[13];
    final n20 = this[2], n21 = this[6], n22 = this[10], n23 = this[14];
    final n30 = this[3], n31 = this[7], n32 = this[11], n33 = this[15];

    return .new(
      (m00 * n00) + (m01 * n10) + (m02 * n20) + (m03 * n30),
      (m10 * n00) + (m11 * n10) + (m12 * n20) + (m13 * n30),
      (m20 * n00) + (m21 * n10) + (m22 * n20) + (m23 * n30),
      (m30 * n00) + (m31 * n10) + (m32 * n20) + (m33 * n30),
      (m00 * n01) + (m01 * n11) + (m02 * n21) + (m03 * n31),
      (m10 * n01) + (m11 * n11) + (m12 * n21) + (m13 * n31),
      (m20 * n01) + (m21 * n11) + (m22 * n21) + (m23 * n31),
      (m30 * n01) + (m31 * n11) + (m32 * n21) + (m33 * n31),
      (m00 * n02) + (m01 * n12) + (m02 * n22) + (m03 * n32),
      (m10 * n02) + (m11 * n12) + (m12 * n22) + (m13 * n32),
      (m20 * n02) + (m21 * n12) + (m22 * n22) + (m23 * n32),
      (m30 * n02) + (m31 * n12) + (m32 * n22) + (m33 * n32),
      (m00 * n03) + (m01 * n13) + (m02 * n23) + (m03 * n33),
      (m10 * n03) + (m11 * n13) + (m12 * n23) + (m13 * n33),
      (m20 * n03) + (m21 * n13) + (m22 * n23) + (m23 * n33),
      (m30 * n03) + (m31 * n13) + (m32 * n23) + (m33 * n33),
    );
  }

  /// Returns this matrix transposed, then multiplied by [arg].
  Matrix4 transposeMultiplied(Matrix4 arg) {
    final m00 = this[0], m01 = this[1], m02 = this[2], m03 = this[3];
    final m10 = this[4], m11 = this[5], m12 = this[6], m13 = this[7];
    final m20 = this[8], m21 = this[9], m22 = this[10], m23 = this[11];
    final m30 = this[12], m31 = this[13], m32 = this[14], m33 = this[15];
    final n00 = arg[0], n01 = arg[4], n02 = arg[8], n03 = arg[12];
    final n10 = arg[1], n11 = arg[5], n12 = arg[9], n13 = arg[13];
    final n20 = arg[2], n21 = arg[6], n22 = arg[10], n23 = arg[14];
    final n30 = arg[3], n31 = arg[7], n32 = arg[11], n33 = arg[15];

    return .new(
      (m00 * n00) + (m01 * n10) + (m02 * n20) + (m03 * n30),
      (m10 * n00) + (m11 * n10) + (m12 * n20) + (m13 * n30),
      (m20 * n00) + (m21 * n10) + (m22 * n20) + (m23 * n30),
      (m30 * n00) + (m31 * n10) + (m32 * n20) + (m33 * n30),
      (m00 * n01) + (m01 * n11) + (m02 * n21) + (m03 * n31),
      (m10 * n01) + (m11 * n11) + (m12 * n21) + (m13 * n31),
      (m20 * n01) + (m21 * n11) + (m22 * n21) + (m23 * n31),
      (m30 * n01) + (m31 * n11) + (m32 * n21) + (m33 * n31),
      (m00 * n02) + (m01 * n12) + (m02 * n22) + (m03 * n32),
      (m10 * n02) + (m11 * n12) + (m12 * n22) + (m13 * n32),
      (m20 * n02) + (m21 * n12) + (m22 * n22) + (m23 * n32),
      (m30 * n02) + (m31 * n12) + (m32 * n22) + (m33 * n32),
      (m00 * n03) + (m01 * n13) + (m02 * n23) + (m03 * n33),
      (m10 * n03) + (m11 * n13) + (m12 * n23) + (m13 * n33),
      (m20 * n03) + (m21 * n13) + (m22 * n23) + (m23 * n33),
      (m30 * n03) + (m31 * n13) + (m32 * n23) + (m33 * n33),
    );
  }

  /// Returns this matrix multiplied by [arg] transposed.
  Matrix4 multiplyTransposed(Matrix4 arg) {
    final m00 = this[0], m01 = this[4], m02 = this[8], m03 = this[12];
    final m10 = this[1], m11 = this[5], m12 = this[9], m13 = this[13];
    final m20 = this[2], m21 = this[6], m22 = this[10], m23 = this[14];
    final m30 = this[3], m31 = this[7], m32 = this[11], m33 = this[15];
    final n00 = arg[0], n01 = arg[1], n02 = arg[2], n03 = arg[3];
    final n10 = arg[4], n11 = arg[5], n12 = arg[6], n13 = arg[7];
    final n20 = arg[8], n21 = arg[9], n22 = arg[10], n23 = arg[11];
    final n30 = arg[12], n31 = arg[13], n32 = arg[14], n33 = arg[15];

    return .new(
      (m00 * n00) + (m01 * n10) + (m02 * n20) + (m03 * n30),
      (m10 * n00) + (m11 * n10) + (m12 * n20) + (m13 * n30),
      (m20 * n00) + (m21 * n10) + (m22 * n20) + (m23 * n30),
      (m30 * n00) + (m31 * n10) + (m32 * n20) + (m33 * n30),
      (m00 * n01) + (m01 * n11) + (m02 * n21) + (m03 * n31),
      (m10 * n01) + (m11 * n11) + (m12 * n21) + (m13 * n31),
      (m20 * n01) + (m21 * n11) + (m22 * n21) + (m23 * n31),
      (m30 * n01) + (m31 * n11) + (m32 * n21) + (m33 * n31),
      (m00 * n02) + (m01 * n12) + (m02 * n22) + (m03 * n32),
      (m10 * n02) + (m11 * n12) + (m12 * n22) + (m13 * n32),
      (m20 * n02) + (m21 * n12) + (m22 * n22) + (m23 * n32),
      (m30 * n02) + (m31 * n12) + (m32 * n22) + (m33 * n32),
      (m00 * n03) + (m01 * n13) + (m02 * n23) + (m03 * n33),
      (m10 * n03) + (m11 * n13) + (m12 * n23) + (m13 * n33),
      (m20 * n03) + (m21 * n13) + (m22 * n23) + (m23 * n33),
      (m30 * n03) + (m31 * n13) + (m32 * n23) + (m33 * n33),
    );
  }

  /// Returns the adjugate matrix, scaled by [scale].
  Matrix4 scaledAdjoint(double scale) {
    final a00 = this[0], a01 = this[1], a02 = this[2], a03 = this[3];
    final a10 = this[4], a11 = this[5], a12 = this[6], a13 = this[7];
    final a20 = this[8], a21 = this[9], a22 = this[10], a23 = this[11];
    final a30 = this[12], a31 = this[13], a32 = this[14], a33 = this[15];
    final b00 = a00 * a11 - a01 * a10;
    final b01 = a00 * a12 - a02 * a10;
    final b02 = a00 * a13 - a03 * a10;
    final b03 = a01 * a12 - a02 * a11;
    final b04 = a01 * a13 - a03 * a11;
    final b05 = a02 * a13 - a03 * a12;
    final b06 = a20 * a31 - a21 * a30;
    final b07 = a20 * a32 - a22 * a30;
    final b08 = a20 * a33 - a23 * a30;
    final b09 = a21 * a32 - a22 * a31;
    final b10 = a21 * a33 - a23 * a31;
    final b11 = a22 * a33 - a23 * a32;

    return .new(
      (a11 * b11 - a12 * b10 + a13 * b09) * scale,
      (-a01 * b11 + a02 * b10 - a03 * b09) * scale,
      (a31 * b05 - a32 * b04 + a33 * b03) * scale,
      (-a21 * b05 + a22 * b04 - a23 * b03) * scale,
      (-a10 * b11 + a12 * b08 - a13 * b07) * scale,
      (a00 * b11 - a02 * b08 + a03 * b07) * scale,
      (-a30 * b05 + a32 * b02 - a33 * b01) * scale,
      (a20 * b05 - a22 * b02 + a23 * b01) * scale,
      (a10 * b10 - a11 * b08 + a13 * b06) * scale,
      (-a00 * b10 + a01 * b08 - a03 * b06) * scale,
      (a30 * b04 - a31 * b02 + a33 * b00) * scale,
      (-a20 * b04 + a21 * b02 - a23 * b00) * scale,
      (-a10 * b09 + a11 * b07 - a12 * b06) * scale,
      (a00 * b09 - a01 * b07 + a02 * b06) * scale,
      (-a30 * b03 + a31 * b01 - a32 * b00) * scale,
      (a20 * b03 - a21 * b01 + a22 * b00) * scale,
    );
  }

  /// Returns the inverse of this matrix.
  Matrix4 inverted() {
    final det = determinant();

    if (det == 0.0) {
      return .new(
        // dart format off
        this[0],  this[1],  this[2],  this[3],
        this[4],  this[5],  this[6],  this[7],
        this[8],  this[9],  this[10], this[11],
        this[12], this[13], this[14], this[15],
        // dart format on
      );
    }

    return scaledAdjoint(1.0 / det);
  }

  /// Add two matrices.
  Matrix4 operator +(Matrix4 arg) => .new(
    // dart format off
    this[0] + arg[0], this[1] + arg[1], this[2] + arg[2], this[3] + arg[3],
    this[4] + arg[4], this[5] + arg[5], this[6] + arg[6], this[7] + arg[7],
    this[8] + arg[8], this[9] + arg[9], this[10] + arg[10], this[11] + arg[11],
    this[12] + arg[12], this[13] + arg[13], this[14] + arg[14], this[15] + arg[15],
    // dart format on
  );

  /// Subtract two matrices.
  Matrix4 operator -(Matrix4 arg) => .new(
    // dart format off
    this[0] - arg[0], this[1] - arg[1], this[2] - arg[2], this[3] - arg[3],
    this[4] - arg[4], this[5] - arg[5], this[6] - arg[6], this[7] - arg[7],
    this[8] - arg[8], this[9] - arg[9], this[10] - arg[10], this[11] - arg[11],
    this[12] - arg[12], this[13] - arg[13], this[14] - arg[14], this[15] - arg[15],
    // dart format on
  );

  /// Negate.
  Matrix4 operator -() => .new(
    // dart format off
    -this[0],  -this[1],  -this[2],  -this[3],
    -this[4],  -this[5],  -this[6],  -this[7],
    -this[8],  -this[9],  -this[10], -this[11],
    -this[12], -this[13], -this[14], -this[15],
    // dart format on
  );

  /// Returns a printable string.
  @override
  String toString() =>
      '[0] [${entry(0, 0)}, ${entry(0, 1)}, ${entry(0, 2)}, ${entry(0, 3)}]\n'
      '[1] [${entry(1, 0)}, ${entry(1, 1)}, ${entry(1, 2)}, ${entry(1, 3)}]\n'
      '[2] [${entry(2, 0)}, ${entry(2, 1)}, ${entry(2, 2)}, ${entry(2, 3)}]\n'
      '[3] [${entry(3, 0)}, ${entry(3, 1)}, ${entry(3, 2)}, ${entry(3, 3)}]';

  /// Check if two matrices are the same.
  @override
  bool operator ==(Object other) =>
      other is Matrix4 && //
      this[0] == other[0] &&
      this[1] == other[1] &&
      this[2] == other[2] &&
      this[3] == other[3] &&
      this[4] == other[4] &&
      this[5] == other[5] &&
      this[6] == other[6] &&
      this[7] == other[7] &&
      this[8] == other[8] &&
      this[9] == other[9] &&
      this[10] == other[10] &&
      this[11] == other[11] &&
      this[12] == other[12] &&
      this[13] == other[13] &&
      this[14] == other[14] &&
      this[15] == other[15];

  @override
  int get hashCode => Object.hash(
    // dart format off
    this[0],  this[1],  this[2],  this[3],
    this[4],  this[5],  this[6],  this[7],
    this[8],  this[9],  this[10], this[11],
    this[12], this[13], this[14], this[15],
    // dart format on
  );
}

class Matrix4 with _Matrix4 {
  /// A matrix with the given values, in column-major order.
  Matrix4(
    // dart format off
    double arg0,  double arg1,  double arg2,  double arg3,
    double arg4,  double arg5,  double arg6,  double arg7,
    double arg8,  double arg9,  double arg10, double arg11,
    double arg12, double arg13, double arg14, double arg15,
    // dart format on
  ) {
    _storage[0] = arg0;
    _storage[1] = arg1;
    _storage[2] = arg2;
    _storage[3] = arg3;
    _storage[4] = arg4;
    _storage[5] = arg5;
    _storage[6] = arg6;
    _storage[7] = arg7;
    _storage[8] = arg8;
    _storage[9] = arg9;
    _storage[10] = arg10;
    _storage[11] = arg11;
    _storage[12] = arg12;
    _storage[13] = arg13;
    _storage[14] = arg14;
    _storage[15] = arg15;
  }

  /// A matrix with the given [values], in column-major order.
  factory Matrix4.fromList(List<double> values) => .new(
    // dart format off
    values[0],  values[1],  values[2],  values[3],
    values[4],  values[5],  values[6],  values[7],
    values[8],  values[9],  values[10], values[11],
    values[12], values[13], values[14], values[15],
    // dart format on
  );

  /// Create a new matrix as a copy of [other].
  factory Matrix4.copy(Matrix4 other) => .new(
    // dart format off
    other[0],  other[1],  other[2],  other[3],
    other[4],  other[5],  other[6],  other[7],
    other[8],  other[9],  other[10], other[11],
    other[12], other[13], other[14], other[15],
    // dart format on
  );

  /// Rotation of [radians] around the x axis.
  factory Matrix4.rotationX(double radians) {
    final c = cos(radians);
    final s = sin(radians);
    return .new(1, 0, 0, 0, 0, c, s, 0, 0, -s, c, 0, 0, 0, 0, 1);
  }

  /// Rotation of [radians] around the y axis.
  factory Matrix4.rotationY(double radians) {
    final c = cos(radians);
    final s = sin(radians);
    return .new(c, 0, -s, 0, 0, 1, 0, 0, s, 0, c, 0, 0, 0, 0, 1);
  }

  /// Rotation of [radians] around the z axis.
  factory Matrix4.rotationZ(double radians) {
    final c = cos(radians);
    final s = sin(radians);
    return .new(c, s, 0, 0, -s, c, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  }

  /// Translation by [translation].
  factory Matrix4.translation(Vector3 translation) =>
      .translationValues(translation.x, translation.y, translation.z);

  /// Translation by [x], [y], and [z].
  factory Matrix4.translationValues(double x, double y, double z) =>
      .new(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, y, z, 1);

  /// Scale by [scale].
  factory Matrix4.diagonal3(Vector3 scale) =>
      .diagonal3Values(scale.x, scale.y, scale.z);

  /// Scale by [x], [y], and [z].
  factory Matrix4.diagonal3Values(double x, double y, double z) =>
      .new(x, 0, 0, 0, 0, y, 0, 0, 0, 0, z, 0, 0, 0, 0, 1);

  final _storage = Float64List(16);

  @override
  double operator [](int index) => _storage[index];

  /// Canonical zero matrix.
  static final Matrix4 zero = .new(
    // dart format off
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    // dart format on
  );

  /// Canonical identity matrix.
  static final Matrix4 identity = .new(
    // dart format off
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1,
    // dart format on
  );

  /// Clone of this.
  Matrix4 clone() => .copy(this);
}

class MMatrix4 with _Matrix4 implements Matrix4 {
  /// Constructs a new matrix filled with zeros.
  MMatrix4.zero();

  /// A matrix with the given values, in column-major order.
  MMatrix4(
    // dart format off
    double arg0,  double arg1,  double arg2,  double arg3,
    double arg4,  double arg5,  double arg6,  double arg7,
    double arg8,  double arg9,  double arg10, double arg11,
    double arg12, double arg13, double arg14, double arg15,
    // dart format on
  ) {
    _storage[0] = arg0;
    _storage[1] = arg1;
    _storage[2] = arg2;
    _storage[3] = arg3;
    _storage[4] = arg4;
    _storage[5] = arg5;
    _storage[6] = arg6;
    _storage[7] = arg7;
    _storage[8] = arg8;
    _storage[9] = arg9;
    _storage[10] = arg10;
    _storage[11] = arg11;
    _storage[12] = arg12;
    _storage[13] = arg13;
    _storage[14] = arg14;
    _storage[15] = arg15;
  }

  /// A matrix with the given [values], in column-major order.
  factory MMatrix4.fromList(List<double> values) => .new(
    // dart format off
    values[0],  values[1],  values[2],  values[3],
    values[4],  values[5],  values[6],  values[7],
    values[8],  values[9],  values[10], values[11],
    values[12], values[13], values[14], values[15],
    // dart format on
  );

  /// Create a new matrix as a copy of [other].
  factory MMatrix4.copy(Matrix4 other) => .new(
    // dart format off
    other[0],  other[1],  other[2],  other[3],
    other[4],  other[5],  other[6],  other[7],
    other[8],  other[9],  other[10], other[11],
    other[12], other[13], other[14], other[15],
    // dart format on
  );

  /// Identity matrix.
  factory MMatrix4.identity() => .zero()..setIdentity();

  /// Rotation of [radians] around the x axis.
  factory MMatrix4.rotationX(double radians) => .zero()..setRotationX(radians);

  /// Rotation of [radians] around the y axis.
  factory MMatrix4.rotationY(double radians) => .zero()..setRotationY(radians);

  /// Rotation of [radians] around the z axis.
  factory MMatrix4.rotationZ(double radians) => .zero()..setRotationZ(radians);

  /// Translation by [translation].
  factory MMatrix4.translation(Vector3 translation) =>
      .identity()..setTranslation(translation);

  /// Translation by [x], [y], and [z].
  factory MMatrix4.translationValues(double x, double y, double z) =>
      .identity()..setTranslationRaw(x, y, z);

  /// Scale by [scale].
  factory MMatrix4.diagonal3(Vector3 scale) =>
      .diagonal3Values(scale.x, scale.y, scale.z);

  /// Scale by [x], [y], and [z].
  factory MMatrix4.diagonal3Values(double x, double y, double z) =>
      .new(x, 0, 0, 0, 0, y, 0, 0, 0, 0, z, 0, 0, 0, 0, 1);

  @override
  final _storage = Float64List(16);

  @override
  double operator [](int index) => _storage[index];

  /// Clone of this.
  @override
  MMatrix4 clone() => .copy(this);

  /// Set the element of the matrix at the index [index].
  void operator []=(int index, double value) {
    _storage[index] = value;
  }

  /// Set the value at [row], [col] to [value].
  void setEntry(int row, int col, double value) {
    assert(row >= 0 && row < dimension);
    assert(col >= 0 && col < dimension);
    _storage[(col * 4) + row] = value;
  }

  /// Sets the matrix with the given values, in column-major order.
  void setValues(
    // dart format off
    double arg0,  double arg1,  double arg2,  double arg3,
    double arg4,  double arg5,  double arg6,  double arg7,
    double arg8,  double arg9,  double arg10, double arg11,
    double arg12, double arg13, double arg14, double arg15,
    // dart format on
  ) {
    final storage = _storage;
    storage[0] = arg0;
    storage[1] = arg1;
    storage[2] = arg2;
    storage[3] = arg3;
    storage[4] = arg4;
    storage[5] = arg5;
    storage[6] = arg6;
    storage[7] = arg7;
    storage[8] = arg8;
    storage[9] = arg9;
    storage[10] = arg10;
    storage[11] = arg11;
    storage[12] = arg12;
    storage[13] = arg13;
    storage[14] = arg14;
    storage[15] = arg15;
  }

  /// Sets the entire matrix to the matrix in [arg].
  void setFrom(Matrix4 arg) {
    final storage = _storage;
    for (var i = 0; i < 16; i += 1) {
      storage[i] = arg[i];
    }
  }

  /// Copies elements from [array] into this starting at [offset].
  void copyFromArray(List<double> array, [int offset = 0]) {
    final storage = _storage;

    for (var i = 0; i < 16; i += 1) {
      storage[i] = array[offset + i];
    }
  }

  /// Zeros this.
  void setZero() {
    _storage.fillRange(0, 16, 0.0);
  }

  /// Makes this into the identity matrix.
  void setIdentity() {
    final storage = _storage;
    // dart format off
    storage[0] = 1.0; storage[4] = 0.0; storage[8]  = 0.0; storage[12] = 0.0;
    storage[1] = 0.0; storage[5] = 1.0; storage[9]  = 0.0; storage[13] = 0.0;
    storage[2] = 0.0; storage[6] = 0.0; storage[10] = 1.0; storage[14] = 0.0;
    storage[3] = 0.0; storage[7] = 0.0; storage[11] = 0.0; storage[15] = 1.0;
    // dart format on
  }

  /// Set the diagonal of the matrix.
  void setDiagonal(double arg) {
    final storage = _storage;
    storage[0] = arg;
    storage[5] = arg;
    storage[10] = arg;
    storage[15] = arg;
  }

  /// Turns the matrix into a rotation of [radians] around the x axis.
  void setRotationX(double radians) {
    final c = cos(radians);
    final s = sin(radians);
    final storage = _storage;
    // dart format off
    storage[0] = 1.0; storage[4] = 0.0; storage[8]  = 0.0; storage[12] = 0.0;
    storage[1] = 0.0; storage[5] = c;   storage[9]  = -s;  storage[13] = 0.0;
    storage[2] = 0.0; storage[6] = s;   storage[10] = c;   storage[14] = 0.0;
    storage[3] = 0.0; storage[7] = 0.0; storage[11] = 0.0; storage[15] = 1.0;
    // dart format on
  }

  /// Turns the matrix into a rotation of [radians] around the y axis.
  void setRotationY(double radians) {
    final c = cos(radians);
    final s = sin(radians);
    final storage = _storage;
    // dart format off
    storage[0] = c;   storage[4] = 0.0; storage[8]  = s;   storage[12] = 0.0;
    storage[1] = 0.0; storage[5] = 1.0; storage[9]  = 0.0; storage[13] = 0.0;
    storage[2] = -s;  storage[6] = 0.0; storage[10] = c;   storage[14] = 0.0;
    storage[3] = 0.0; storage[7] = 0.0; storage[11] = 0.0; storage[15] = 1.0;
    // dart format on
  }

  /// Turns the matrix into a rotation of [radians] around the z axis.
  void setRotationZ(double radians) {
    final c = cos(radians);
    final s = sin(radians);
    final storage = _storage;
    // dart format off
    storage[0] = c;   storage[4] = -s;  storage[8]  = 0.0; storage[12] = 0.0;
    storage[1] = s;   storage[5] = c;   storage[9]  = 0.0; storage[13] = 0.0;
    storage[2] = 0.0; storage[6] = 0.0; storage[10] = 1.0; storage[14] = 0.0;
    storage[3] = 0.0; storage[7] = 0.0; storage[11] = 0.0; storage[15] = 1.0;
    // dart format on
  }

  /// Sets the translation part of this to [translation].
  void setTranslation(Vector3 translation) {
    setTranslationRaw(translation.x, translation.y, translation.z);
  }

  /// Sets the translation part of this to [x], [y], and [z].
  void setTranslationRaw(double x, double y, double z) {
    final storage = _storage;
    storage[12] = x;
    storage[13] = y;
    storage[14] = z;
  }

  /// Sets the upper-left 3x3 of this to [rotation], keeping the translation.
  void setRotation(Matrix3 rotation) {
    final storage = _storage;
    storage[0] = rotation[0];
    storage[1] = rotation[1];
    storage[2] = rotation[2];
    storage[4] = rotation[3];
    storage[5] = rotation[4];
    storage[6] = rotation[5];
    storage[8] = rotation[6];
    storage[9] = rotation[7];
    storage[10] = rotation[8];
  }

  /// Transpose this.
  void transpose() {
    final storage = _storage;
    var temp = storage[4];
    storage[4] = storage[1];
    storage[1] = temp;
    temp = storage[8];
    storage[8] = storage[2];
    storage[2] = temp;
    temp = storage[12];
    storage[12] = storage[3];
    storage[3] = temp;
    temp = storage[9];
    storage[9] = storage[6];
    storage[6] = temp;
    temp = storage[13];
    storage[13] = storage[7];
    storage[7] = temp;
    temp = storage[14];
    storage[14] = storage[11];
    storage[11] = temp;
  }

  /// Sets this to the component-wise absolute value of itself.
  void absolute() {
    final storage = _storage;

    for (var i = 0; i < 16; i += 1) {
      storage[i] = storage[i].abs();
    }
  }

  /// Scales every entry of this by [scale].
  void scale(double scale) {
    final storage = _storage;

    for (var i = 0; i < 16; i += 1) {
      storage[i] *= scale;
    }
  }

  /// Multiplies this by a scale matrix of [scale]: `this * S`.
  void scaleBy(Vector3 scale) {
    final storage = _storage;
    final sx = scale.x, sy = scale.y, sz = scale.z;
    // dart format off
    storage[0] *= sx; storage[4] *= sy; storage[8]  *= sz;
    storage[1] *= sx; storage[5] *= sy; storage[9]  *= sz;
    storage[2] *= sx; storage[6] *= sy; storage[10] *= sz;
    storage[3] *= sx; storage[7] *= sy; storage[11] *= sz;
    // dart format on
  }

  /// Multiplies this by a translation matrix of [translation]: `this * T`.
  void translate(Vector3 translation) {
    final storage = _storage;
    final tx = translation.x, ty = translation.y, tz = translation.z;
    final t1 = (this[0] * tx) + (this[4] * ty) + (this[8] * tz) + this[12];
    final t2 = (this[1] * tx) + (this[5] * ty) + (this[9] * tz) + this[13];
    final t3 = (this[2] * tx) + (this[6] * ty) + (this[10] * tz) + this[14];
    final t4 = (this[3] * tx) + (this[7] * ty) + (this[11] * tz) + this[15];
    storage[12] = t1;
    storage[13] = t2;
    storage[14] = t3;
    storage[15] = t4;
  }

  /// Add [other] to this.
  void add(Matrix4 other) {
    final storage = _storage;

    for (var i = 0; i < 16; i += 1) {
      storage[i] += other[i];
    }
  }

  /// Subtract [other] from this.
  void subtract(Matrix4 other) {
    final storage = _storage;

    for (var i = 0; i < 16; i += 1) {
      storage[i] -= other[i];
    }
  }

  /// Negate this.
  void negate() {
    final storage = _storage;
    for (var i = 0; i < 16; i += 1) {
      storage[i] = -storage[i];
    }
  }

  /// Multiply this by [arg]: `this * arg`.
  void multiply(Matrix4 arg) {
    final storage = _storage;
    final m00 = this[0], m01 = this[4], m02 = this[8], m03 = this[12];
    final m10 = this[1], m11 = this[5], m12 = this[9], m13 = this[13];
    final m20 = this[2], m21 = this[6], m22 = this[10], m23 = this[14];
    final m30 = this[3], m31 = this[7], m32 = this[11], m33 = this[15];
    final n00 = arg[0], n01 = arg[4], n02 = arg[8], n03 = arg[12];
    final n10 = arg[1], n11 = arg[5], n12 = arg[9], n13 = arg[13];
    final n20 = arg[2], n21 = arg[6], n22 = arg[10], n23 = arg[14];
    final n30 = arg[3], n31 = arg[7], n32 = arg[11], n33 = arg[15];
    storage[0] = (m00 * n00) + (m01 * n10) + (m02 * n20) + (m03 * n30);
    storage[4] = (m00 * n01) + (m01 * n11) + (m02 * n21) + (m03 * n31);
    storage[8] = (m00 * n02) + (m01 * n12) + (m02 * n22) + (m03 * n32);
    storage[12] = (m00 * n03) + (m01 * n13) + (m02 * n23) + (m03 * n33);
    storage[1] = (m10 * n00) + (m11 * n10) + (m12 * n20) + (m13 * n30);
    storage[5] = (m10 * n01) + (m11 * n11) + (m12 * n21) + (m13 * n31);
    storage[9] = (m10 * n02) + (m11 * n12) + (m12 * n22) + (m13 * n32);
    storage[13] = (m10 * n03) + (m11 * n13) + (m12 * n23) + (m13 * n33);
    storage[2] = (m20 * n00) + (m21 * n10) + (m22 * n20) + (m23 * n30);
    storage[6] = (m20 * n01) + (m21 * n11) + (m22 * n21) + (m23 * n31);
    storage[10] = (m20 * n02) + (m21 * n12) + (m22 * n22) + (m23 * n32);
    storage[14] = (m20 * n03) + (m21 * n13) + (m22 * n23) + (m23 * n33);
    storage[3] = (m30 * n00) + (m31 * n10) + (m32 * n20) + (m33 * n30);
    storage[7] = (m30 * n01) + (m31 * n11) + (m32 * n21) + (m33 * n31);
    storage[11] = (m30 * n02) + (m31 * n12) + (m32 * n22) + (m33 * n32);
    storage[15] = (m30 * n03) + (m31 * n13) + (m32 * n23) + (m33 * n33);
  }

  /// Premultiplies this by [arg]: `arg * this`.
  void premultiply(Matrix4 arg) {
    final storage = _storage;
    final m00 = arg[0], m01 = arg[4], m02 = arg[8], m03 = arg[12];
    final m10 = arg[1], m11 = arg[5], m12 = arg[9], m13 = arg[13];
    final m20 = arg[2], m21 = arg[6], m22 = arg[10], m23 = arg[14];
    final m30 = arg[3], m31 = arg[7], m32 = arg[11], m33 = arg[15];
    final n00 = this[0], n01 = this[4], n02 = this[8], n03 = this[12];
    final n10 = this[1], n11 = this[5], n12 = this[9], n13 = this[13];
    final n20 = this[2], n21 = this[6], n22 = this[10], n23 = this[14];
    final n30 = this[3], n31 = this[7], n32 = this[11], n33 = this[15];
    storage[0] = (m00 * n00) + (m01 * n10) + (m02 * n20) + (m03 * n30);
    storage[4] = (m00 * n01) + (m01 * n11) + (m02 * n21) + (m03 * n31);
    storage[8] = (m00 * n02) + (m01 * n12) + (m02 * n22) + (m03 * n32);
    storage[12] = (m00 * n03) + (m01 * n13) + (m02 * n23) + (m03 * n33);
    storage[1] = (m10 * n00) + (m11 * n10) + (m12 * n20) + (m13 * n30);
    storage[5] = (m10 * n01) + (m11 * n11) + (m12 * n21) + (m13 * n31);
    storage[9] = (m10 * n02) + (m11 * n12) + (m12 * n22) + (m13 * n32);
    storage[13] = (m10 * n03) + (m11 * n13) + (m12 * n23) + (m13 * n33);
    storage[2] = (m20 * n00) + (m21 * n10) + (m22 * n20) + (m23 * n30);
    storage[6] = (m20 * n01) + (m21 * n11) + (m22 * n21) + (m23 * n31);
    storage[10] = (m20 * n02) + (m21 * n12) + (m22 * n22) + (m23 * n32);
    storage[14] = (m20 * n03) + (m21 * n13) + (m22 * n23) + (m23 * n33);
    storage[3] = (m30 * n00) + (m31 * n10) + (m32 * n20) + (m33 * n30);
    storage[7] = (m30 * n01) + (m31 * n11) + (m32 * n21) + (m33 * n31);
    storage[11] = (m30 * n02) + (m31 * n12) + (m32 * n22) + (m33 * n32);
    storage[15] = (m30 * n03) + (m31 * n13) + (m32 * n23) + (m33 * n33);
  }

  /// Transpose this, then multiply by [arg].
  void transposeMultiply(Matrix4 arg) {
    final storage = _storage;
    final m00 = this[0], m01 = this[1], m02 = this[2], m03 = this[3];
    final m10 = this[4], m11 = this[5], m12 = this[6], m13 = this[7];
    final m20 = this[8], m21 = this[9], m22 = this[10], m23 = this[11];
    final m30 = this[12], m31 = this[13], m32 = this[14], m33 = this[15];
    final n00 = arg[0], n01 = arg[4], n02 = arg[8], n03 = arg[12];
    final n10 = arg[1], n11 = arg[5], n12 = arg[9], n13 = arg[13];
    final n20 = arg[2], n21 = arg[6], n22 = arg[10], n23 = arg[14];
    final n30 = arg[3], n31 = arg[7], n32 = arg[11], n33 = arg[15];
    storage[0] = (m00 * n00) + (m01 * n10) + (m02 * n20) + (m03 * n30);
    storage[4] = (m00 * n01) + (m01 * n11) + (m02 * n21) + (m03 * n31);
    storage[8] = (m00 * n02) + (m01 * n12) + (m02 * n22) + (m03 * n32);
    storage[12] = (m00 * n03) + (m01 * n13) + (m02 * n23) + (m03 * n33);
    storage[1] = (m10 * n00) + (m11 * n10) + (m12 * n20) + (m13 * n30);
    storage[5] = (m10 * n01) + (m11 * n11) + (m12 * n21) + (m13 * n31);
    storage[9] = (m10 * n02) + (m11 * n12) + (m12 * n22) + (m13 * n32);
    storage[13] = (m10 * n03) + (m11 * n13) + (m12 * n23) + (m13 * n33);
    storage[2] = (m20 * n00) + (m21 * n10) + (m22 * n20) + (m23 * n30);
    storage[6] = (m20 * n01) + (m21 * n11) + (m22 * n21) + (m23 * n31);
    storage[10] = (m20 * n02) + (m21 * n12) + (m22 * n22) + (m23 * n32);
    storage[14] = (m20 * n03) + (m21 * n13) + (m22 * n23) + (m23 * n33);
    storage[3] = (m30 * n00) + (m31 * n10) + (m32 * n20) + (m33 * n30);
    storage[7] = (m30 * n01) + (m31 * n11) + (m32 * n21) + (m33 * n31);
    storage[11] = (m30 * n02) + (m31 * n12) + (m32 * n22) + (m33 * n32);
    storage[15] = (m30 * n03) + (m31 * n13) + (m32 * n23) + (m33 * n33);
  }

  /// Multiply this by [arg] transposed.
  void multiplyTranspose(Matrix4 arg) {
    final storage = _storage;
    final m00 = this[0], m01 = this[4], m02 = this[8], m03 = this[12];
    final m10 = this[1], m11 = this[5], m12 = this[9], m13 = this[13];
    final m20 = this[2], m21 = this[6], m22 = this[10], m23 = this[14];
    final m30 = this[3], m31 = this[7], m32 = this[11], m33 = this[15];
    final n00 = arg[0], n01 = arg[1], n02 = arg[2], n03 = arg[3];
    final n10 = arg[4], n11 = arg[5], n12 = arg[6], n13 = arg[7];
    final n20 = arg[8], n21 = arg[9], n22 = arg[10], n23 = arg[11];
    final n30 = arg[12], n31 = arg[13], n32 = arg[14], n33 = arg[15];
    storage[0] = (m00 * n00) + (m01 * n10) + (m02 * n20) + (m03 * n30);
    storage[4] = (m00 * n01) + (m01 * n11) + (m02 * n21) + (m03 * n31);
    storage[8] = (m00 * n02) + (m01 * n12) + (m02 * n22) + (m03 * n32);
    storage[12] = (m00 * n03) + (m01 * n13) + (m02 * n23) + (m03 * n33);
    storage[1] = (m10 * n00) + (m11 * n10) + (m12 * n20) + (m13 * n30);
    storage[5] = (m10 * n01) + (m11 * n11) + (m12 * n21) + (m13 * n31);
    storage[9] = (m10 * n02) + (m11 * n12) + (m12 * n22) + (m13 * n32);
    storage[13] = (m10 * n03) + (m11 * n13) + (m12 * n23) + (m13 * n33);
    storage[2] = (m20 * n00) + (m21 * n10) + (m22 * n20) + (m23 * n30);
    storage[6] = (m20 * n01) + (m21 * n11) + (m22 * n21) + (m23 * n31);
    storage[10] = (m20 * n02) + (m21 * n12) + (m22 * n22) + (m23 * n32);
    storage[14] = (m20 * n03) + (m21 * n13) + (m22 * n23) + (m23 * n33);
    storage[3] = (m30 * n00) + (m31 * n10) + (m32 * n20) + (m33 * n30);
    storage[7] = (m30 * n01) + (m31 * n11) + (m32 * n21) + (m33 * n31);
    storage[11] = (m30 * n02) + (m31 * n12) + (m32 * n22) + (m33 * n32);
    storage[15] = (m30 * n03) + (m31 * n13) + (m32 * n23) + (m33 * n33);
  }

  /// Converts into the adjugate matrix and scales by [scale].
  void scaleAdjoint(double scale) {
    final storage = _storage;
    final a00 = this[0], a01 = this[1], a02 = this[2], a03 = this[3];
    final a10 = this[4], a11 = this[5], a12 = this[6], a13 = this[7];
    final a20 = this[8], a21 = this[9], a22 = this[10], a23 = this[11];
    final a30 = this[12], a31 = this[13], a32 = this[14], a33 = this[15];
    final b00 = a00 * a11 - a01 * a10;
    final b01 = a00 * a12 - a02 * a10;
    final b02 = a00 * a13 - a03 * a10;
    final b03 = a01 * a12 - a02 * a11;
    final b04 = a01 * a13 - a03 * a11;
    final b05 = a02 * a13 - a03 * a12;
    final b06 = a20 * a31 - a21 * a30;
    final b07 = a20 * a32 - a22 * a30;
    final b08 = a20 * a33 - a23 * a30;
    final b09 = a21 * a32 - a22 * a31;
    final b10 = a21 * a33 - a23 * a31;
    final b11 = a22 * a33 - a23 * a32;
    storage[0] = (a11 * b11 - a12 * b10 + a13 * b09) * scale;
    storage[1] = (-a01 * b11 + a02 * b10 - a03 * b09) * scale;
    storage[2] = (a31 * b05 - a32 * b04 + a33 * b03) * scale;
    storage[3] = (-a21 * b05 + a22 * b04 - a23 * b03) * scale;
    storage[4] = (-a10 * b11 + a12 * b08 - a13 * b07) * scale;
    storage[5] = (a00 * b11 - a02 * b08 + a03 * b07) * scale;
    storage[6] = (-a30 * b05 + a32 * b02 - a33 * b01) * scale;
    storage[7] = (a20 * b05 - a22 * b02 + a23 * b01) * scale;
    storage[8] = (a10 * b10 - a11 * b08 + a13 * b06) * scale;
    storage[9] = (-a00 * b10 + a01 * b08 - a03 * b06) * scale;
    storage[10] = (a30 * b04 - a31 * b02 + a33 * b00) * scale;
    storage[11] = (-a20 * b04 + a21 * b02 - a23 * b00) * scale;
    storage[12] = (-a10 * b09 + a11 * b07 - a12 * b06) * scale;
    storage[13] = (a00 * b09 - a01 * b07 + a02 * b06) * scale;
    storage[14] = (-a30 * b03 + a31 * b01 - a32 * b00) * scale;
    storage[15] = (a20 * b03 - a21 * b01 + a22 * b00) * scale;
  }

  /// Set this matrix to be the inverse of [arg]. Returns the determinant.
  double copyInverse(Matrix4 arg) {
    final det = arg.determinant();
    setFrom(arg);

    if (det == 0.0) return 0.0;

    scaleAdjoint(1.0 / det);
    return det;
  }

  /// Invert the matrix. Returns the determinant.
  double invert() => copyInverse(this);
}
