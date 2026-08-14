import 'dart:math';
import 'dart:typed_data';

import 'vector2.dart';

/// Shared operations for [Matrix3] and [MMatrix3]. Values are stored in
/// column-major order.
mixin _Matrix3 {
  /// Access the element of the matrix at the index [index].
  double operator [](int index);

  /// Dimension of the matrix.
  int get dimension => 3;

  /// Value at [row], [col].
  double entry(int row, int col) {
    assert(row >= 0 && row < dimension);
    assert(col >= 0 && col < dimension);
    return this[(col * 3) + row];
  }

  /// Returns the determinant of this matrix.
  double determinant() {
    final x = this[0] * ((this[4] * this[8]) - (this[5] * this[7]));
    final y = this[1] * ((this[3] * this[8]) - (this[5] * this[6]));
    final z = this[2] * ((this[3] * this[7]) - (this[4] * this[6]));
    return x - y + z;
  }

  /// Returns the trace of the matrix: the sum of the diagonal entries.
  double trace() => this[0] + this[4] + this[8];

  /// Is this the identity matrix?
  bool isIdentity() =>
      // dart format off
      this[0] == 1.0 && this[1] == 0.0 && this[2] == 0.0 &&
      this[3] == 0.0 && this[4] == 1.0 && this[5] == 0.0 &&
      this[6] == 0.0 && this[7] == 0.0 && this[8] == 1.0;
      // dart format on

  /// Is this the zero matrix?
  bool isZero() {
    for (var i = 0; i < 9; i += 1) {
      if (this[i] != 0.0) return false;
    }

    return true;
  }

  /// Returns the infinity norm of the matrix. Used for numerical analysis.
  double infinityNorm() {
    var norm = 0.0;

    for (var column = 0; column < 9; column += 3) {
      final columnNorm =
          this[column].abs() + //
          this[column + 1].abs() +
          this[column + 2].abs();

      norm = columnNorm > norm ? columnNorm : norm;
    }

    return norm;
  }

  /// Returns the relative error between this and [correct].
  double relativeError(Matrix3 correct) {
    final diff = Matrix3(
      // dart format off
      correct[0] - this[0], correct[1] - this[1], correct[2] - this[2],
      correct[3] - this[3], correct[4] - this[4], correct[5] - this[5],
      correct[6] - this[6], correct[7] - this[7], correct[8] - this[8],
      // dart format on
    );

    return diff.infinityNorm() / correct.infinityNorm();
  }

  /// Returns the absolute error between this and [correct].
  double absoluteError(Matrix3 correct) =>
      (infinityNorm() - correct.infinityNorm()).abs();

  /// Transforms [point] by this and returns the result.
  Vector2 transformed(Vector2 point) => .new(
    (this[0] * point.x) + (this[3] * point.y) + this[6],
    (this[1] * point.x) + (this[4] * point.y) + this[7],
  );

  /// Copies this into [array] starting at [offset].
  void copyIntoArray(List<num> array, [int offset = 0]) {
    for (var i = 0; i < 9; i += 1) {
      array[offset + i] = this[i];
    }
  }

  /// Returns the transpose of this.
  Matrix3 transposed() => .new(
    // dart format off
    this[0], this[3], this[6],
    this[1], this[4], this[7],
    this[2], this[5], this[8],
    // dart format on
  );

  /// Returns a copy of this scaled by [scale].
  Matrix3 scaled(double scale) => .new(
    // dart format off
    this[0] * scale, this[1] * scale, this[2] * scale,
    this[3] * scale, this[4] * scale, this[5] * scale,
    this[6] * scale, this[7] * scale, this[8] * scale,
    // dart format on
  );

  /// Returns a copy with the diagonal set to [value].
  Matrix3 diagonal(double value) => .new(
    // dart format off
    value,   this[1], this[2],
    this[3], value,   this[5],
    this[6], this[7], value,
    // dart format on
  );

  /// Returns this matrix multiplied by [arg]. Note the order.
  Matrix3 multiplied(Matrix3 arg) {
    final m00 = this[0], m01 = this[3], m02 = this[6];
    final m10 = this[1], m11 = this[4], m12 = this[7];
    final m20 = this[2], m21 = this[5], m22 = this[8];
    final n00 = arg[0], n01 = arg[3], n02 = arg[6];
    final n10 = arg[1], n11 = arg[4], n12 = arg[7];
    final n20 = arg[2], n21 = arg[5], n22 = arg[8];

    return .new(
      (m00 * n00) + (m01 * n10) + (m02 * n20),
      (m10 * n00) + (m11 * n10) + (m12 * n20),
      (m20 * n00) + (m21 * n10) + (m22 * n20),
      (m00 * n01) + (m01 * n11) + (m02 * n21),
      (m10 * n01) + (m11 * n11) + (m12 * n21),
      (m20 * n01) + (m21 * n11) + (m22 * n21),
      (m00 * n02) + (m01 * n12) + (m02 * n22),
      (m10 * n02) + (m11 * n12) + (m12 * n22),
      (m20 * n02) + (m21 * n12) + (m22 * n22),
    );
  }

  /// Returns [arg] multiplied by this. Note the order.
  Matrix3 premultiplied(Matrix3 arg) {
    final m00 = arg[0], m01 = arg[3], m02 = arg[6];
    final m10 = arg[1], m11 = arg[4], m12 = arg[7];
    final m20 = arg[2], m21 = arg[5], m22 = arg[8];
    final n00 = this[0], n01 = this[3], n02 = this[6];
    final n10 = this[1], n11 = this[4], n12 = this[7];
    final n20 = this[2], n21 = this[5], n22 = this[8];

    return .new(
      (m00 * n00) + (m01 * n10) + (m02 * n20),
      (m10 * n00) + (m11 * n10) + (m12 * n20),
      (m20 * n00) + (m21 * n10) + (m22 * n20),
      (m00 * n01) + (m01 * n11) + (m02 * n21),
      (m10 * n01) + (m11 * n11) + (m12 * n21),
      (m20 * n01) + (m21 * n11) + (m22 * n21),
      (m00 * n02) + (m01 * n12) + (m02 * n22),
      (m10 * n02) + (m11 * n12) + (m12 * n22),
      (m20 * n02) + (m21 * n12) + (m22 * n22),
    );
  }

  /// Returns this matrix transposed, then multiplied by [arg].
  Matrix3 transposeMultiplied(Matrix3 arg) {
    final m00 = this[0], m01 = this[1], m02 = this[2];
    final m10 = this[3], m11 = this[4], m12 = this[5];
    final m20 = this[6], m21 = this[7], m22 = this[8];

    return .new(
      (m00 * arg[0]) + (m01 * arg[1]) + (m02 * arg[2]),
      (m10 * arg[0]) + (m11 * arg[1]) + (m12 * arg[2]),
      (m20 * arg[0]) + (m21 * arg[1]) + (m22 * arg[2]),
      (m00 * arg[3]) + (m01 * arg[4]) + (m02 * arg[5]),
      (m10 * arg[3]) + (m11 * arg[4]) + (m12 * arg[5]),
      (m20 * arg[3]) + (m21 * arg[4]) + (m22 * arg[5]),
      (m00 * arg[6]) + (m01 * arg[7]) + (m02 * arg[8]),
      (m10 * arg[6]) + (m11 * arg[7]) + (m12 * arg[8]),
      (m20 * arg[6]) + (m21 * arg[7]) + (m22 * arg[8]),
    );
  }

  /// Returns this matrix multiplied by [arg] transposed.
  Matrix3 multiplyTransposed(Matrix3 arg) {
    final m00 = this[0], m01 = this[3], m02 = this[6];
    final m10 = this[1], m11 = this[4], m12 = this[7];
    final m20 = this[2], m21 = this[5], m22 = this[8];

    return .new(
      (m00 * arg[0]) + (m01 * arg[3]) + (m02 * arg[6]),
      (m10 * arg[0]) + (m11 * arg[3]) + (m12 * arg[6]),
      (m20 * arg[0]) + (m21 * arg[3]) + (m22 * arg[6]),
      (m00 * arg[1]) + (m01 * arg[4]) + (m02 * arg[7]),
      (m10 * arg[1]) + (m11 * arg[4]) + (m12 * arg[7]),
      (m20 * arg[1]) + (m21 * arg[4]) + (m22 * arg[7]),
      (m00 * arg[2]) + (m01 * arg[5]) + (m02 * arg[8]),
      (m10 * arg[2]) + (m11 * arg[5]) + (m12 * arg[8]),
      (m20 * arg[2]) + (m21 * arg[5]) + (m22 * arg[8]),
    );
  }

  /// Returns the adjugate matrix, scaled by [scale].
  Matrix3 scaledAdjoint(double scale) {
    final m00 = this[0], m01 = this[3], m02 = this[6];
    final m10 = this[1], m11 = this[4], m12 = this[7];
    final m20 = this[2], m21 = this[5], m22 = this[8];

    return .new(
      (m11 * m22 - m12 * m21) * scale,
      (m12 * m20 - m10 * m22) * scale,
      (m10 * m21 - m11 * m20) * scale,
      (m02 * m21 - m01 * m22) * scale,
      (m00 * m22 - m02 * m20) * scale,
      (m01 * m20 - m00 * m21) * scale,
      (m01 * m12 - m02 * m11) * scale,
      (m02 * m10 - m00 * m12) * scale,
      (m00 * m11 - m01 * m10) * scale,
    );
  }

  /// Returns the inverse of this matrix.
  Matrix3 inverted() {
    final det = determinant();

    if (det == 0.0) {
      return .new(
        // dart format off
        this[0], this[1], this[2],
        this[3], this[4], this[5],
        this[6], this[7], this[8],
        // dart format on
      );
    }

    final invDet = 1.0 / det;
    final ix = invDet * (this[4] * this[8] - this[5] * this[7]);
    final iy = invDet * (this[2] * this[7] - this[1] * this[8]);
    final iz = invDet * (this[1] * this[5] - this[2] * this[4]);
    final jx = invDet * (this[5] * this[6] - this[3] * this[8]);
    final jy = invDet * (this[0] * this[8] - this[2] * this[6]);
    final jz = invDet * (this[2] * this[3] - this[0] * this[5]);
    final kx = invDet * (this[3] * this[7] - this[4] * this[6]);
    final ky = invDet * (this[1] * this[6] - this[0] * this[7]);
    final kz = invDet * (this[0] * this[4] - this[1] * this[3]);
    return .new(ix, iy, iz, jx, jy, jz, kx, ky, kz);
  }

  /// Add two matrices.
  Matrix3 operator +(Matrix3 arg) => .new(
    // dart format off
    this[0] + arg[0], this[1] + arg[1], this[2] + arg[2],
    this[3] + arg[3], this[4] + arg[4], this[5] + arg[5],
    this[6] + arg[6], this[7] + arg[7], this[8] + arg[8],
    // dart format on
  );

  /// Subtract two matrices.
  Matrix3 operator -(Matrix3 arg) => .new(
    // dart format off
    this[0] - arg[0], this[1] - arg[1], this[2] - arg[2],
    this[3] - arg[3], this[4] - arg[4], this[5] - arg[5],
    this[6] - arg[6], this[7] - arg[7], this[8] - arg[8],
    // dart format on
  );

  /// Negate.
  Matrix3 operator -() => .new(
    // dart format off
    -this[0], -this[1], -this[2],
    -this[3], -this[4], -this[5],
    -this[6], -this[7], -this[8],
    // dart format on
  );

  /// Returns a printable string.
  @override
  String toString() =>
      '[0] [${entry(0, 0)}, ${entry(0, 1)}, ${entry(0, 2)}]\n'
      '[1] [${entry(1, 0)}, ${entry(1, 1)}, ${entry(1, 2)}]\n'
      '[2] [${entry(2, 0)}, ${entry(2, 1)}, ${entry(2, 2)}]';

  /// Check if two matrices are the same.
  @override
  bool operator ==(Object other) =>
      other is Matrix3 && //
      this[0] == other[0] &&
      this[1] == other[1] &&
      this[2] == other[2] &&
      this[3] == other[3] &&
      this[4] == other[4] &&
      this[5] == other[5] &&
      this[6] == other[6] &&
      this[7] == other[7] &&
      this[8] == other[8];

  @override
  int get hashCode => Object.hash(
    // dart format off
    this[0], this[1], this[2],
    this[3], this[4], this[5],
    this[6], this[7], this[8],
    // dart format on
  );
}

class Matrix3 with _Matrix3 {
  /// A matrix with the given values, in column-major order.
  Matrix3(
    // dart format off
    double arg0, double arg1, double arg2,
    double arg3, double arg4, double arg5,
    double arg6, double arg7, double arg8,
    // dart format on
  ) {
    // dart format off
    _storage[0] = arg0; _storage[3] = arg3; _storage[6] = arg6;
    _storage[1] = arg1; _storage[4] = arg4; _storage[7] = arg7;
    _storage[2] = arg2; _storage[5] = arg5; _storage[8] = arg8;
    // dart format on
  }

  /// A matrix with the given [values], in column-major order.
  factory Matrix3.fromList(List<double> values) => .new(
    // dart format off
    values[0], values[1], values[2],
    values[3], values[4], values[5],
    values[6], values[7], values[8],
    // dart format on
  );

  /// Create a new matrix as a copy of [other].
  factory Matrix3.copy(Matrix3 other) => .new(
    // dart format off
    other[0], other[1], other[2],
    other[3], other[4], other[5],
    other[6], other[7], other[8],
    // dart format on
  );

  /// Rotation of [radians] around the x axis.
  factory Matrix3.rotationX(double radians) {
    final c = cos(radians);
    final s = sin(radians);
    return .new(1, 0, 0, 0, c, s, 0, -s, c);
  }

  /// Rotation of [radians] around the y axis.
  factory Matrix3.rotationY(double radians) {
    final c = cos(radians);
    final s = sin(radians);
    return .new(c, 0, -s, 0, 1, 0, s, 0, c);
  }

  /// Rotation of [radians] around the z axis.
  factory Matrix3.rotationZ(double radians) {
    final c = cos(radians);
    final s = sin(radians);
    return .new(c, s, 0, -s, c, 0, 0, 0, 1);
  }

  final _storage = Float64List(9);

  @override
  double operator [](int index) => _storage[index];

  /// Canonical zero matrix.
  static final Matrix3 zero = .new(0, 0, 0, 0, 0, 0, 0, 0, 0);

  /// Canonical identity matrix.
  static final Matrix3 identity = .new(1, 0, 0, 0, 1, 0, 0, 0, 1);

  /// Clone of this.
  Matrix3 clone() => .copy(this);
}

class MMatrix3 with _Matrix3 implements Matrix3 {
  /// Constructs a new matrix filled with zeros.
  MMatrix3.zero();

  /// A matrix with the given values, in column-major order.
  MMatrix3(
    // dart format off
    double arg0, double arg1, double arg2,
    double arg3, double arg4, double arg5,
    double arg6, double arg7, double arg8,
    // dart format on
  ) {
    // dart format off
    _storage[0] = arg0; _storage[3] = arg3; _storage[6] = arg6;
    _storage[1] = arg1; _storage[4] = arg4; _storage[7] = arg7;
    _storage[2] = arg2; _storage[5] = arg5; _storage[8] = arg8;
    // dart format on
  }

  /// A matrix with the given [values], in column-major order.
  factory MMatrix3.fromList(List<double> values) => .new(
    // dart format off
    values[0], values[1], values[2],
    values[3], values[4], values[5],
    values[6], values[7], values[8],
    // dart format on
  );

  /// Create a new matrix as a copy of [other].
  factory MMatrix3.copy(Matrix3 other) => .new(
    // dart format off
    other[0], other[1], other[2],
    other[3], other[4], other[5],
    other[6], other[7], other[8],
    // dart format on
  );

  /// Identity matrix.
  factory MMatrix3.identity() => .zero()..setIdentity();

  /// Rotation of [radians] around the x axis.
  factory MMatrix3.rotationX(double radians) => .zero()..setRotationX(radians);

  /// Rotation of [radians] around the y axis.
  factory MMatrix3.rotationY(double radians) => .zero()..setRotationY(radians);

  /// Rotation of [radians] around the z axis.
  factory MMatrix3.rotationZ(double radians) => .zero()..setRotationZ(radians);

  @override
  final _storage = Float64List(9);

  @override
  double operator [](int index) => _storage[index];

  /// Clone of this.
  @override
  MMatrix3 clone() => .copy(this);

  /// Set the element of the matrix at the index [index].
  void operator []=(int index, double value) {
    _storage[index] = value;
  }

  /// Set the value at [row], [col] to [value].
  void setEntry(int row, int col, double value) {
    assert(row >= 0 && row < dimension);
    assert(col >= 0 && col < dimension);
    _storage[(col * 3) + row] = value;
  }

  /// Sets the matrix with the given values, in column-major order.
  void setValues(
    // dart format off
    double arg0, double arg1, double arg2,
    double arg3, double arg4, double arg5,
    double arg6, double arg7, double arg8,
    // dart format on
  ) {
    final storage = _storage;
    // dart format off
    storage[0] = arg0; storage[3] = arg3; storage[6] = arg6;
    storage[1] = arg1; storage[4] = arg4; storage[7] = arg7;
    storage[2] = arg2; storage[5] = arg5; storage[8] = arg8;
    // dart format on
  }

  /// Sets the entire matrix to the matrix in [arg].
  void setFrom(Matrix3 arg) {
    final storage = _storage;
    for (var i = 0; i < 9; i += 1) {
      storage[i] = arg[i];
    }
  }

  /// Copies elements from [array] into this starting at [offset].
  void copyFromArray(List<double> array, [int offset = 0]) {
    final storage = _storage;

    for (var i = 0; i < 9; i += 1) {
      storage[i] = array[offset + i];
    }
  }

  /// Zeros this.
  void setZero() {
    _storage.fillRange(0, 9, 0.0);
  }

  /// Makes this into the identity matrix.
  void setIdentity() {
    final storage = _storage;
    // dart format off
    storage[0] = 1.0; storage[3] = 0.0; storage[6] = 0.0;
    storage[1] = 0.0; storage[4] = 1.0; storage[7] = 0.0;
    storage[2] = 0.0; storage[5] = 0.0; storage[8] = 1.0;
    // dart format on
  }

  /// Set the diagonal of the matrix.
  void setDiagonal(double arg) {
    final storage = _storage;
    storage[0] = arg;
    storage[4] = arg;
    storage[8] = arg;
  }

  /// Turns the matrix into a rotation of [radians] around the x axis.
  void setRotationX(double radians) {
    final c = cos(radians);
    final s = sin(radians);
    final storage = _storage;
    // dart format off
    storage[0] = 1.0; storage[3] = 0.0; storage[6] = 0.0;
    storage[1] = 0.0; storage[4] = c;   storage[7] = -s;
    storage[2] = 0.0; storage[5] = s;   storage[8] = c;
    // dart format on
  }

  /// Turns the matrix into a rotation of [radians] around the y axis.
  void setRotationY(double radians) {
    final c = cos(radians);
    final s = sin(radians);
    final storage = _storage;
    // dart format off
    storage[0] = c;   storage[3] = 0.0; storage[6] = s;
    storage[1] = 0.0; storage[4] = 1.0; storage[7] = 0.0;
    storage[2] = -s;  storage[5] = 0.0; storage[8] = c;
    // dart format on
  }

  /// Turns the matrix into a rotation of [radians] around the z axis.
  void setRotationZ(double radians) {
    final c = cos(radians);
    final s = sin(radians);
    final storage = _storage;
    // dart format off
    storage[0] = c;   storage[3] = -s;  storage[6] = 0.0;
    storage[1] = s;   storage[4] = c;   storage[7] = 0.0;
    storage[2] = 0.0; storage[5] = 0.0; storage[8] = 1.0;
    // dart format on
  }

  /// Transpose this.
  void transpose() {
    final storage = _storage;
    var temp = storage[3];
    storage[3] = storage[1];
    storage[1] = temp;
    temp = storage[6];
    storage[6] = storage[2];
    storage[2] = temp;
    temp = storage[7];
    storage[7] = storage[5];
    storage[5] = temp;
  }

  /// Sets this to the component-wise absolute value of itself.
  void absolute() {
    final storage = _storage;

    for (var i = 0; i < 9; i += 1) {
      storage[i] = storage[i].abs();
    }
  }

  /// Scales this by [scale].
  void scale(double scale) {
    final storage = _storage;

    for (var i = 0; i < 9; i += 1) {
      storage[i] *= scale;
    }
  }

  /// Add [other] to this.
  void add(Matrix3 other) {
    final storage = _storage;

    for (var i = 0; i < 9; i += 1) {
      storage[i] += other[i];
    }
  }

  /// Subtract [other] from this.
  void subtract(Matrix3 other) {
    final storage = _storage;

    for (var i = 0; i < 9; i += 1) {
      storage[i] -= other[i];
    }
  }

  /// Negate this.
  void negate() {
    final storage = _storage;
    for (var i = 0; i < 9; i += 1) {
      storage[i] = -storage[i];
    }
  }

  /// Multiply this by [arg]: `this * arg`.
  void multiply(Matrix3 arg) {
    final storage = _storage;
    final m00 = storage[0], m01 = storage[3], m02 = storage[6];
    final m10 = storage[1], m11 = storage[4], m12 = storage[7];
    final m20 = storage[2], m21 = storage[5], m22 = storage[8];
    final n00 = arg[0], n01 = arg[3], n02 = arg[6];
    final n10 = arg[1], n11 = arg[4], n12 = arg[7];
    final n20 = arg[2], n21 = arg[5], n22 = arg[8];
    storage[0] = (m00 * n00) + (m01 * n10) + (m02 * n20);
    storage[3] = (m00 * n01) + (m01 * n11) + (m02 * n21);
    storage[6] = (m00 * n02) + (m01 * n12) + (m02 * n22);
    storage[1] = (m10 * n00) + (m11 * n10) + (m12 * n20);
    storage[4] = (m10 * n01) + (m11 * n11) + (m12 * n21);
    storage[7] = (m10 * n02) + (m11 * n12) + (m12 * n22);
    storage[2] = (m20 * n00) + (m21 * n10) + (m22 * n20);
    storage[5] = (m20 * n01) + (m21 * n11) + (m22 * n21);
    storage[8] = (m20 * n02) + (m21 * n12) + (m22 * n22);
  }

  /// Premultiplies this by [arg]: `arg * this`.
  void premultiply(Matrix3 arg) {
    final storage = _storage;
    final m00 = arg[0], m01 = arg[3], m02 = arg[6];
    final m10 = arg[1], m11 = arg[4], m12 = arg[7];
    final m20 = arg[2], m21 = arg[5], m22 = arg[8];
    final n00 = storage[0], n01 = storage[3], n02 = storage[6];
    final n10 = storage[1], n11 = storage[4], n12 = storage[7];
    final n20 = storage[2], n21 = storage[5], n22 = storage[8];
    storage[0] = (m00 * n00) + (m01 * n10) + (m02 * n20);
    storage[3] = (m00 * n01) + (m01 * n11) + (m02 * n21);
    storage[6] = (m00 * n02) + (m01 * n12) + (m02 * n22);
    storage[1] = (m10 * n00) + (m11 * n10) + (m12 * n20);
    storage[4] = (m10 * n01) + (m11 * n11) + (m12 * n21);
    storage[7] = (m10 * n02) + (m11 * n12) + (m12 * n22);
    storage[2] = (m20 * n00) + (m21 * n10) + (m22 * n20);
    storage[5] = (m20 * n01) + (m21 * n11) + (m22 * n21);
    storage[8] = (m20 * n02) + (m21 * n12) + (m22 * n22);
  }

  /// Transpose this, then multiply by [arg].
  void transposeMultiply(Matrix3 arg) {
    final storage = _storage;
    final m00 = storage[0], m01 = storage[1], m02 = storage[2];
    final m10 = storage[3], m11 = storage[4], m12 = storage[5];
    final m20 = storage[6], m21 = storage[7], m22 = storage[8];
    storage[0] = (m00 * arg[0]) + (m01 * arg[1]) + (m02 * arg[2]);
    storage[3] = (m00 * arg[3]) + (m01 * arg[4]) + (m02 * arg[5]);
    storage[6] = (m00 * arg[6]) + (m01 * arg[7]) + (m02 * arg[8]);
    storage[1] = (m10 * arg[0]) + (m11 * arg[1]) + (m12 * arg[2]);
    storage[4] = (m10 * arg[3]) + (m11 * arg[4]) + (m12 * arg[5]);
    storage[7] = (m10 * arg[6]) + (m11 * arg[7]) + (m12 * arg[8]);
    storage[2] = (m20 * arg[0]) + (m21 * arg[1]) + (m22 * arg[2]);
    storage[5] = (m20 * arg[3]) + (m21 * arg[4]) + (m22 * arg[5]);
    storage[8] = (m20 * arg[6]) + (m21 * arg[7]) + (m22 * arg[8]);
  }

  /// Multiply this by [arg] transposed.
  void multiplyTranspose(Matrix3 arg) {
    final storage = _storage;
    final m00 = storage[0], m01 = storage[3], m02 = storage[6];
    final m10 = storage[1], m11 = storage[4], m12 = storage[7];
    final m20 = storage[2], m21 = storage[5], m22 = storage[8];
    storage[0] = (m00 * arg[0]) + (m01 * arg[3]) + (m02 * arg[6]);
    storage[3] = (m00 * arg[1]) + (m01 * arg[4]) + (m02 * arg[7]);
    storage[6] = (m00 * arg[2]) + (m01 * arg[5]) + (m02 * arg[8]);
    storage[1] = (m10 * arg[0]) + (m11 * arg[3]) + (m12 * arg[6]);
    storage[4] = (m10 * arg[1]) + (m11 * arg[4]) + (m12 * arg[7]);
    storage[7] = (m10 * arg[2]) + (m11 * arg[5]) + (m12 * arg[8]);
    storage[2] = (m20 * arg[0]) + (m21 * arg[3]) + (m22 * arg[6]);
    storage[5] = (m20 * arg[1]) + (m21 * arg[4]) + (m22 * arg[7]);
    storage[8] = (m20 * arg[2]) + (m21 * arg[5]) + (m22 * arg[8]);
  }

  /// Converts into the adjugate matrix and scales by [scale].
  void scaleAdjoint(double scale) {
    final storage = _storage;
    final m00 = storage[0], m01 = storage[3], m02 = storage[6];
    final m10 = storage[1], m11 = storage[4], m12 = storage[7];
    final m20 = storage[2], m21 = storage[5], m22 = storage[8];
    storage[0] = (m11 * m22 - m12 * m21) * scale;
    storage[1] = (m12 * m20 - m10 * m22) * scale;
    storage[2] = (m10 * m21 - m11 * m20) * scale;
    storage[3] = (m02 * m21 - m01 * m22) * scale;
    storage[4] = (m00 * m22 - m02 * m20) * scale;
    storage[5] = (m01 * m20 - m00 * m21) * scale;
    storage[6] = (m01 * m12 - m02 * m11) * scale;
    storage[7] = (m02 * m10 - m00 * m12) * scale;
    storage[8] = (m00 * m11 - m01 * m10) * scale;
  }

  /// Set this matrix to be the inverse of [arg]. Returns the determinant.
  double copyInverse(Matrix3 arg) {
    final det = arg.determinant();

    if (det == 0.0) {
      setFrom(arg);
      return 0.0;
    }

    final invDet = 1.0 / det;
    final ix = invDet * (arg[4] * arg[8] - arg[5] * arg[7]);
    final iy = invDet * (arg[2] * arg[7] - arg[1] * arg[8]);
    final iz = invDet * (arg[1] * arg[5] - arg[2] * arg[4]);
    final jx = invDet * (arg[5] * arg[6] - arg[3] * arg[8]);
    final jy = invDet * (arg[0] * arg[8] - arg[2] * arg[6]);
    final jz = invDet * (arg[2] * arg[3] - arg[0] * arg[5]);
    final kx = invDet * (arg[3] * arg[7] - arg[4] * arg[6]);
    final ky = invDet * (arg[1] * arg[6] - arg[0] * arg[7]);
    final kz = invDet * (arg[0] * arg[4] - arg[1] * arg[3]);

    final storage = _storage;
    // dart format off
    storage[0] = ix; storage[1] = iy; storage[2] = iz;
    storage[3] = jx; storage[4] = jy; storage[5] = jz;
    storage[6] = kx; storage[7] = ky; storage[8] = kz;
    // dart format on
    return det;
  }

  /// Invert the matrix. Returns the determinant.
  double invert() => copyInverse(this);
}
