// GENERATED FILE. DO NOT EDIT.

import 'dart:math';
import 'dart:typed_data';

import 'mutable.dart';
import 'vector2.dart';

/// 3x3 matrix, values stored in column-major order — identical layout and
/// operations to `vector_math`'s own `Matrix3`, adapted to this library's
/// controlled-mutability model. `Vector3`/`Matrix2`/`Matrix4` don't exist in
/// this library yet, so every `vector_math` operation that depends on one of
/// those (row/column vectors, 3D `transform`, `setUpper2x2`,
/// `copyNormalMatrix`, ...) is left out; everything else — including 2D
/// affine use via [transform2]/[absoluteRotate2], exactly as `vector_math`'s
/// own `Aabb2.transform` uses it — is ported as-is, formulas included.
///
/// One deliberate naming departure: `vector_math` gives its mutating and
/// copy-producing operations distinct names (`multiply`/`multiplied`,
/// `scale`/`scaled`, `transpose`/`transposed`). This library follows
/// [Vector2]'s convention instead — the same present-tense name on both
/// [Matrix3] and [MutableMatrix3], shifting from "returns a new copy" to
/// "mutates in place" depending on which one you're holding.
class Matrix3 implements Mutable<MutableMatrix3> {
  Matrix3.zero();

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

  factory Matrix3.fromList(List<double> values) => Matrix3(
    // dart format off
    values[0], values[1], values[2],
    values[3], values[4], values[5],
    values[6], values[7], values[8],
    // dart format on
  );

  Matrix3.copy(Matrix3 other) {
    _storage.setAll(0, other._storage);
  }

  factory Matrix3.identity() => Matrix3.zero()..mutate().setIdentity();

  /// Rotation of [radians] around the x axis.
  factory Matrix3.rotationX(double radians) =>
      Matrix3.zero()..mutate().setRotationX(radians);

  /// Rotation of [radians] around the y axis.
  factory Matrix3.rotationY(double radians) =>
      Matrix3.zero()..mutate().setRotationY(radians);

  /// Rotation of [radians] around the z axis.
  factory Matrix3.rotationZ(double radians) =>
      Matrix3.zero()..mutate().setRotationZ(radians);

  final _storage = Float64List(9);

  Float64List get storage => _storage;

  /// Dimension of the matrix.
  int get dimension => 3;

  /// Value at [row], [col].
  double entry(int row, int col) {
    assert(row >= 0 && row < dimension);
    assert(col >= 0 && col < dimension);
    return _storage[(col * 3) + row];
  }

  double operator [](int index) => _storage[index];

  Matrix3 clone() => .copy(this);

  /// Returns the determinant of this matrix.
  double determinant() {
    final x =
        _storage[0] *
        ((_storage[4] * _storage[8]) - (_storage[5] * _storage[7]));
    final y =
        _storage[1] *
        ((_storage[3] * _storage[8]) - (_storage[5] * _storage[6]));
    final z =
        _storage[2] *
        ((_storage[3] * _storage[7]) - (_storage[4] * _storage[6]));
    return x - y + z;
  }

  /// Returns the trace of the matrix: the sum of the diagonal entries.
  double trace() => _storage[0] + _storage[4] + _storage[8];

  /// Is this the identity matrix?
  bool isIdentity() =>
      _storage[0] == 1.0 &&
      _storage[1] == 0.0 &&
      _storage[2] == 0.0 &&
      _storage[3] == 0.0 &&
      _storage[4] == 1.0 &&
      _storage[5] == 0.0 &&
      _storage[6] == 0.0 &&
      _storage[7] == 0.0 &&
      _storage[8] == 1.0;

  /// Is this the zero matrix?
  bool isZero() => _storage.every((value) => value == 0.0);

  /// Returns the infinity norm of the matrix. Used for numerical analysis.
  double infinityNorm() {
    var norm = 0.0;

    for (var column = 0; column < 9; column += 3) {
      final columnNorm =
          _storage[column].abs() +
          _storage[column + 1].abs() +
          _storage[column + 2].abs();
      norm = columnNorm > norm ? columnNorm : norm;
    }

    return norm;
  }

  /// Returns the relative error between this and [correct].
  double relativeError(Matrix3 correct) {
    final diffNorm = (correct - this).infinityNorm();
    return diffNorm / correct.infinityNorm();
  }

  /// Returns the absolute error between this and [correct].
  double absoluteError(Matrix3 correct) =>
      (infinityNorm() - correct.infinityNorm()).abs();

  /// Transforms [arg] with this. Primarily used for 2D affine transforms,
  /// treating the third row/column as homogeneous translation.
  MutableVector2 transform2(MutableVector2 arg) {
    final x = arg.x;
    final y = arg.y;
    arg.x = (_storage[0] * x) + (_storage[3] * y) + _storage[6];
    arg.y = (_storage[1] * x) + (_storage[4] * y) + _storage[7];
    return arg;
  }

  /// Transforms [point] and returns the result. Not from `vector_math` —
  /// unlike [transform2], this leaves [point] itself unchanged. If [out] is
  /// given, the result is written into it (no allocation) and [out] itself
  /// is returned; otherwise a new [Vector2] is allocated.
  Vector2 transform(Vector2 point, [Vector2? out]) {
    final x = point.x;
    final y = point.y;
    final resultX = (_storage[0] * x) + (_storage[3] * y) + _storage[6];
    final resultY = (_storage[1] * x) + (_storage[4] * y) + _storage[7];

    if (out == null) return .new(resultX, resultY);

    out.mutate()
      ..x = resultX
      ..y = resultY;
    return out;
  }

  /// Rotates [arg] by the absolute rotation of this. Primarily used by AABB
  /// transformation code.
  MutableVector2 absoluteRotate2(MutableVector2 arg) {
    final m00 = _storage[0].abs();
    final m01 = _storage[3].abs();
    final m10 = _storage[1].abs();
    final m11 = _storage[4].abs();
    final x = arg.x;
    final y = arg.y;
    arg.x = x * m00 + y * m01;
    arg.y = x * m10 + y * m11;
    return arg;
  }

  /// Copies this into [array] starting at [offset].
  void copyIntoArray(List<num> array, [int offset = 0]) {
    for (var i = 0; i < 9; i += 1) {
      array[offset + i] = _storage[i];
    }
  }

  /// Returns the transpose of this.
  Matrix3 transpose() => clone()..mutate().transpose();

  /// Returns the component-wise absolute value of this.
  Matrix3 absolute() {
    final result = Matrix3.zero();

    for (var i = 0; i < 9; i += 1) {
      result._storage[i] = _storage[i].abs();
    }

    return result;
  }

  /// Returns a copy of this scaled by [scale].
  Matrix3 scale(double scale) => clone()..mutate().scale(scale);

  /// Returns this matrix multiplied by [arg]: applying the result to a
  /// point is equivalent to applying [arg] first, then this.
  Matrix3 multiply(Matrix3 arg) => clone()..mutate().multiply(arg);

  /// Returns [arg] multiplied by this: applying the result to a point is
  /// equivalent to applying this first, then [arg]. Not from `vector_math`
  /// — the natural counterpart to [multiply] for accumulating a chain of
  /// transforms where each new one applies on the *outside* (e.g. walking
  /// up a scene graph composing ancestor transforms one at a time).
  Matrix3 premultiply(Matrix3 arg) => clone()..mutate().premultiply(arg);

  Matrix3 operator +(Matrix3 arg) => clone()..mutate().add(arg);
  Matrix3 operator -(Matrix3 arg) => clone()..mutate().sub(arg);
  Matrix3 operator -() => clone()..mutate().negate();

  @override
  MutableMatrix3 mutate() {
    return MutableMatrix3(this);
  }

  void modify(void Function(MutableMatrix3 matrix) mutation) {
    mutation(mutate());
  }

  @override
  String toString() =>
      '[0] [${entry(0, 0)}, ${entry(0, 1)}, ${entry(0, 2)}]\n'
      '[1] [${entry(1, 0)}, ${entry(1, 1)}, ${entry(1, 2)}]\n'
      '[2] [${entry(2, 0)}, ${entry(2, 1)}, ${entry(2, 2)}]';

  @override
  bool operator ==(Object other) =>
      other is Matrix3 && //
      _storage[0] == other._storage[0] &&
      _storage[1] == other._storage[1] &&
      _storage[2] == other._storage[2] &&
      _storage[3] == other._storage[3] &&
      _storage[4] == other._storage[4] &&
      _storage[5] == other._storage[5] &&
      _storage[6] == other._storage[6] &&
      _storage[7] == other._storage[7] &&
      _storage[8] == other._storage[8];

  @override
  int get hashCode => Object.hashAll(_storage);
}

extension type MutableMatrix3(Matrix3 matrix) {
  Float64List get storage => matrix._storage;
  int get dimension => matrix.dimension;
  double entry(int row, int col) => matrix.entry(row, col);
  double operator [](int index) => matrix[index];
  double determinant() => matrix.determinant();
  double trace() => matrix.trace();
  bool isIdentity() => matrix.isIdentity();
  bool isZero() => matrix.isZero();
  double infinityNorm() => matrix.infinityNorm();
  double relativeError(Matrix3 correct) => matrix.relativeError(correct);
  double absoluteError(Matrix3 correct) => matrix.absoluteError(correct);
  MutableVector2 transform2(MutableVector2 arg) => matrix.transform2(arg);
  Vector2 transform(Vector2 point, [Vector2? out]) =>
      matrix.transform(point, out);
  MutableVector2 absoluteRotate2(MutableVector2 arg) =>
      matrix.absoluteRotate2(arg);
  void copyIntoArray(List<num> array, [int offset = 0]) =>
      matrix.copyIntoArray(array, offset);

  void operator []=(int index, double value) {
    matrix._storage[index] = value;
  }

  void setEntry(int row, int col, double v) {
    assert(row >= 0 && row < dimension);
    assert(col >= 0 && col < dimension);
    matrix._storage[(col * 3) + row] = v;
  }

  /// Sets the matrix with the given values, in column-major order.
  void setValues(
    double arg0,
    double arg1,
    double arg2,
    double arg3,
    double arg4,
    double arg5,
    double arg6,
    double arg7,
    double arg8,
  ) {
    final storage = matrix._storage;
    // dart format off
    storage[0] = arg0; storage[3] = arg3; storage[6] = arg6;
    storage[1] = arg1; storage[4] = arg4; storage[7] = arg7;
    storage[2] = arg2; storage[5] = arg5; storage[8] = arg8;
    // dart format on
  }

  /// Sets the entire matrix to the matrix in [arg].
  void setFrom(Matrix3 arg) {
    matrix._storage.setAll(0, arg._storage);
  }

  /// Copies elements from [array] into this starting at [offset].
  void copyFromArray(List<double> array, [int offset = 0]) {
    final storage = matrix._storage;
    for (var i = 0; i < 9; i += 1) {
      storage[i] = array[offset + i];
    }
  }

  void setZero() {
    matrix._storage.fillRange(0, 9, 0.0);
  }

  /// Makes this into the identity matrix.
  void setIdentity() {
    final storage = matrix._storage;
    // dart format off
    storage[0] = 1.0; storage[3] = 0.0; storage[6] = 0.0;
    storage[1] = 0.0; storage[4] = 1.0; storage[7] = 0.0;
    storage[2] = 0.0; storage[5] = 0.0; storage[8] = 1.0;
    // dart format on
  }

  /// Set the diagonal of the matrix.
  void splatDiagonal(double arg) {
    final storage = matrix._storage;
    storage[0] = arg;
    storage[4] = arg;
    storage[8] = arg;
  }

  /// Turns the matrix into a rotation of [radians] around the x axis.
  void setRotationX(double radians) {
    final c = cos(radians);
    final s = sin(radians);
    final storage = matrix._storage;
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
    final storage = matrix._storage;
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
    final storage = matrix._storage;
    // dart format off
    storage[0] = c;   storage[3] = -s;  storage[6] = 0.0;
    storage[1] = s;   storage[4] = c;   storage[7] = 0.0;
    storage[2] = 0.0; storage[5] = 0.0; storage[8] = 1.0;
    // dart format on
  }

  /// Transpose this.
  void transpose() {
    final storage = matrix._storage;
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

  /// Scales this by [scale].
  void scale(double scale) {
    final storage = matrix._storage;
    for (var i = 0; i < 9; i += 1) {
      storage[i] *= scale;
    }
  }

  /// Add [o] to this.
  void add(Matrix3 o) {
    final storage = matrix._storage;
    final oStorage = o._storage;
    for (var i = 0; i < 9; i += 1) {
      storage[i] += oStorage[i];
    }
  }

  /// Subtract [o] from this.
  void sub(Matrix3 o) {
    final storage = matrix._storage;
    final oStorage = o._storage;
    for (var i = 0; i < 9; i += 1) {
      storage[i] -= oStorage[i];
    }
  }

  /// Negate this.
  void negate() {
    final storage = matrix._storage;
    for (var i = 0; i < 9; i += 1) {
      storage[i] = -storage[i];
    }
  }

  /// Multiply this by [arg].
  void multiply(Matrix3 arg) {
    final storage = matrix._storage;
    final m00 = storage[0], m01 = storage[3], m02 = storage[6];
    final m10 = storage[1], m11 = storage[4], m12 = storage[7];
    final m20 = storage[2], m21 = storage[5], m22 = storage[8];
    final argStorage = arg._storage;
    final n00 = argStorage[0], n01 = argStorage[3], n02 = argStorage[6];
    final n10 = argStorage[1], n11 = argStorage[4], n12 = argStorage[7];
    final n20 = argStorage[2], n21 = argStorage[5], n22 = argStorage[8];
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

  /// Premultiplies this by [arg]: sets this to `arg * this`. Not from
  /// `vector_math` — see [Matrix3.premultiply].
  void premultiply(Matrix3 arg) {
    final storage = matrix._storage;
    final argStorage = arg._storage;
    final m00 = argStorage[0], m01 = argStorage[3], m02 = argStorage[6];
    final m10 = argStorage[1], m11 = argStorage[4], m12 = argStorage[7];
    final m20 = argStorage[2], m21 = argStorage[5], m22 = argStorage[8];
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

  void transposeMultiply(Matrix3 arg) {
    final storage = matrix._storage;
    final m00 = storage[0], m01 = storage[1], m02 = storage[2];
    final m10 = storage[3], m11 = storage[4], m12 = storage[5];
    final m20 = storage[6], m21 = storage[7], m22 = storage[8];
    final argStorage = arg._storage;
    storage[0] =
        (m00 * argStorage[0]) + (m01 * argStorage[1]) + (m02 * argStorage[2]);
    storage[3] =
        (m00 * argStorage[3]) + (m01 * argStorage[4]) + (m02 * argStorage[5]);
    storage[6] =
        (m00 * argStorage[6]) + (m01 * argStorage[7]) + (m02 * argStorage[8]);
    storage[1] =
        (m10 * argStorage[0]) + (m11 * argStorage[1]) + (m12 * argStorage[2]);
    storage[4] =
        (m10 * argStorage[3]) + (m11 * argStorage[4]) + (m12 * argStorage[5]);
    storage[7] =
        (m10 * argStorage[6]) + (m11 * argStorage[7]) + (m12 * argStorage[8]);
    storage[2] =
        (m20 * argStorage[0]) + (m21 * argStorage[1]) + (m22 * argStorage[2]);
    storage[5] =
        (m20 * argStorage[3]) + (m21 * argStorage[4]) + (m22 * argStorage[5]);
    storage[8] =
        (m20 * argStorage[6]) + (m21 * argStorage[7]) + (m22 * argStorage[8]);
  }

  void multiplyTranspose(Matrix3 arg) {
    final storage = matrix._storage;
    final m00 = storage[0], m01 = storage[3], m02 = storage[6];
    final m10 = storage[1], m11 = storage[4], m12 = storage[7];
    final m20 = storage[2], m21 = storage[5], m22 = storage[8];
    final argStorage = arg._storage;
    storage[0] =
        (m00 * argStorage[0]) + (m01 * argStorage[3]) + (m02 * argStorage[6]);
    storage[3] =
        (m00 * argStorage[1]) + (m01 * argStorage[4]) + (m02 * argStorage[7]);
    storage[6] =
        (m00 * argStorage[2]) + (m01 * argStorage[5]) + (m02 * argStorage[8]);
    storage[1] =
        (m10 * argStorage[0]) + (m11 * argStorage[3]) + (m12 * argStorage[6]);
    storage[4] =
        (m10 * argStorage[1]) + (m11 * argStorage[4]) + (m12 * argStorage[7]);
    storage[7] =
        (m10 * argStorage[2]) + (m11 * argStorage[5]) + (m12 * argStorage[8]);
    storage[2] =
        (m20 * argStorage[0]) + (m21 * argStorage[3]) + (m22 * argStorage[6]);
    storage[5] =
        (m20 * argStorage[1]) + (m21 * argStorage[4]) + (m22 * argStorage[7]);
    storage[8] =
        (m20 * argStorage[2]) + (m21 * argStorage[5]) + (m22 * argStorage[8]);
  }

  /// Converts into the adjugate matrix and scales by [scale].
  void scaleAdjoint(double scale) {
    final storage = matrix._storage;
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
    final argStorage = arg._storage;
    final ix =
        invDet *
        (argStorage[4] * argStorage[8] - argStorage[5] * argStorage[7]);
    final iy =
        invDet *
        (argStorage[2] * argStorage[7] - argStorage[1] * argStorage[8]);
    final iz =
        invDet *
        (argStorage[1] * argStorage[5] - argStorage[2] * argStorage[4]);
    final jx =
        invDet *
        (argStorage[5] * argStorage[6] - argStorage[3] * argStorage[8]);
    final jy =
        invDet *
        (argStorage[0] * argStorage[8] - argStorage[2] * argStorage[6]);
    final jz =
        invDet *
        (argStorage[2] * argStorage[3] - argStorage[0] * argStorage[5]);
    final kx =
        invDet *
        (argStorage[3] * argStorage[7] - argStorage[4] * argStorage[6]);
    final ky =
        invDet *
        (argStorage[1] * argStorage[6] - argStorage[0] * argStorage[7]);
    final kz =
        invDet *
        (argStorage[0] * argStorage[4] - argStorage[1] * argStorage[3]);

    final storage = matrix._storage;
    storage[0] = ix;
    storage[1] = iy;
    storage[2] = iz;
    storage[3] = jx;
    storage[4] = jy;
    storage[5] = jz;
    storage[6] = kx;
    storage[7] = ky;
    storage[8] = kz;
    return det;
  }

  /// Invert the matrix. Returns the determinant.
  double invert() => copyInverse(matrix);
}
