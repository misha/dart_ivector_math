import 'dart:math';

import 'package:ivector_math/ivector_math.dart';
import 'package:test/test.dart';

import 'support/matchers.dart';

void main() {
  group('Matrix3', () {
    test('creates a zero matrix', () {
      expectMatrix3(Matrix3.zero, [0, 0, 0], [0, 0, 0], [0, 0, 0]);
    });

    test('reuses a canonical zero instance', () {
      expect(identical(Matrix3.zero, Matrix3.zero), isTrue);
    });

    test('creates the identity matrix', () {
      expectMatrix3(Matrix3.identity, [1, 0, 0], [0, 1, 0], [0, 0, 1]);
    });

    test('reuses a canonical identity instance', () {
      expect(identical(Matrix3.identity, Matrix3.identity), isTrue);
    });

    test('creates a matrix from column-major values', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      expectMatrix3(matrix, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
      expect(matrix.entry(0, 0), 1);
      expect(matrix.entry(1, 0), 2);
      expect(matrix.entry(2, 0), 3);
      expect(matrix.entry(0, 1), 4);
      expect(matrix.entry(1, 1), 5);
      expect(matrix.entry(2, 1), 6);
      expect(matrix.entry(0, 2), 7);
      expect(matrix.entry(1, 2), 8);
      expect(matrix.entry(2, 2), 9);
    });

    test('creates a matrix from a list', () {
      expectMatrix3(
        Matrix3.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9]),
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      );
    });

    test('copies without sharing storage', () {
      final original = MMatrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final copy = Matrix3.copy(original);

      original[0] = 99;

      expectMatrix3(copy, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
    });

    test('creates a rotation around the x axis', () {
      expectMatrix3(
        Matrix3.rotationX(pi / 2), //
        [1, 0, 0],
        [0, 0, 1],
        [0, -1, 0],
      );
    });

    test('creates a rotation around the y axis', () {
      expectMatrix3(
        Matrix3.rotationY(pi / 2), //
        [0, 0, -1],
        [0, 1, 0],
        [1, 0, 0],
      );
    });

    test('creates a rotation around the z axis', () {
      expectMatrix3(
        Matrix3.rotationZ(pi / 2), //
        [0, 1, 0],
        [-1, 0, 0],
        [0, 0, 1],
      );
    });

    test('reads components by index', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      for (var i = 0; i < 9; i += 1) {
        expect(matrix[i], i + 1);
      }
      expect(() => matrix[9], throwsRangeError);
    });

    test('reports its dimension', () {
      expect(Matrix3.zero.dimension, 3);
    });

    test('clones without sharing storage', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final clone = matrix.clone();

      expectMatrix3(clone, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
      expect(clone, isNot(same(matrix)));
    });

    test('computes the determinant', () {
      expect(Matrix3(2, 0, 0, 0, 3, 0, 0, 0, 1).determinant(), 6);
    });

    test('computes the trace', () {
      expect(Matrix3(2, 0, 0, 0, 3, 0, 0, 0, 1).trace(), 6);
    });

    test('detects the identity matrix', () {
      expect(Matrix3.identity.isIdentity(), isTrue);
      expect(Matrix3.zero.isIdentity(), isFalse);
    });

    test('detects the zero matrix', () {
      expect(Matrix3.zero.isZero(), isTrue);
      expect(Matrix3.identity.isZero(), isFalse);
    });

    test('computes the infinity norm', () {
      expect(Matrix3(1, -2, 3, -4, 5, -6, 7, -8, 9).infinityNorm(), 24);
    });

    test('computes relative and absolute error against a correct matrix', () {
      final correct = Matrix3.identity;
      final approximate = Matrix3(1.1, 0, 0, 0, 1, 0, 0, 0, 1);

      expect(approximate.relativeError(correct), closeTo(0.1, 0.0000001));
      expect(approximate.absoluteError(correct), closeTo(0.1, 0.0000001));
    });

    test(
      'transforms a point into a new Vector2 without changing the source',
      () {
        final matrix = Matrix3(2, 0, 0, 0, 3, 0, 10, 20, 1);
        final point = Vector2(1, 1);

        final transformed = matrix.transformed(point);

        expectVector2(transformed, 12, 23);
        expectVector2(point, 1, 1);
      },
    );

    test('copies into an array', () {
      final array = List<double>.filled(9, 0);

      Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9).copyIntoArray(array);

      expect(array, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });

    test('copies into an array at an offset', () {
      final array = List<double>.filled(10, 0);

      Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9).copyIntoArray(array, 1);

      expect(array, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });

    test('creates a transposed copy without changing the source', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      final transposed = matrix.transposed();

      expectMatrix3(transposed, [1, 4, 7], [2, 5, 8], [3, 6, 9]);
      expectMatrix3(matrix, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
    });

    test('creates a scaled copy without changing the source', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      final scaled = matrix.scaled(2);

      expectMatrix3(scaled, [2, 4, 6], [8, 10, 12], [14, 16, 18]);
      expectMatrix3(matrix, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
    });

    test(
      'creates a copy with the diagonal set without changing the source',
      () {
        final matrix = Matrix3.zero;

        final diagonal = matrix.diagonal(5);

        expectMatrix3(diagonal, [5, 0, 0], [0, 5, 0], [0, 0, 5]);
        expectMatrix3(matrix, [0, 0, 0], [0, 0, 0], [0, 0, 0]);
      },
    );

    test('creates a multiplied copy without changing its sources', () {
      final translate = Matrix3(1, 0, 0, 0, 1, 0, 5, 0, 1);
      final scaleMatrix = Matrix3(2, 0, 0, 0, 2, 0, 0, 0, 1);

      final combined = translate.multiplied(scaleMatrix);

      expectMatrix3(combined, [2, 0, 0], [0, 2, 0], [5, 0, 1]);
      expectMatrix3(translate, [1, 0, 0], [0, 1, 0], [5, 0, 1]);
      expectMatrix3(scaleMatrix, [2, 0, 0], [0, 2, 0], [0, 0, 1]);
    });

    test(
      'creates a premultiplied copy equivalent to the other multiply order',
      () {
        final translate = Matrix3(1, 0, 0, 0, 1, 0, 5, 0, 1);
        final scaleMatrix = Matrix3(2, 0, 0, 0, 2, 0, 0, 0, 1);

        final combined = scaleMatrix.premultiplied(translate);

        expectMatrix3(combined, [2, 0, 0], [0, 2, 0], [5, 0, 1]);
        expectMatrix3(translate, [1, 0, 0], [0, 1, 0], [5, 0, 1]);
        expectMatrix3(scaleMatrix, [2, 0, 0], [0, 2, 0], [0, 0, 1]);
      },
    );

    test('creates a transpose-multiplied copy without changing the source', () {
      final matrix = Matrix3.rotationZ(pi / 3);

      final result = matrix.transposeMultiplied(matrix);

      expectMatrix3(result, [1, 0, 0], [0, 1, 0], [0, 0, 1]);
      expect(matrix, Matrix3.rotationZ(pi / 3));
    });

    test('creates a multiply-transposed copy without changing the source', () {
      final matrix = Matrix3.rotationZ(pi / 4);

      final result = matrix.multiplyTransposed(matrix);

      expectMatrix3(result, [1, 0, 0], [0, 1, 0], [0, 0, 1]);
      expect(matrix, Matrix3.rotationZ(pi / 4));
    });

    test('creates a scaled adjugate copy without changing the source', () {
      final matrix = Matrix3(2, 0, 0, 0, 3, 0, 0, 0, 4);

      final adjugate = matrix.scaledAdjoint(1);

      expectMatrix3(adjugate, [12, 0, 0], [0, 8, 0], [0, 0, 6]);
      expectMatrix3(matrix, [2, 0, 0], [0, 3, 0], [0, 0, 4]);
    });

    test('creates the inverse without changing the source', () {
      final matrix = Matrix3(2, 0, 0, 0, 4, 0, 0, 0, 1);

      final inverted = matrix.inverted();

      expectMatrix3(inverted, [0.5, 0, 0], [0, 0.25, 0], [0, 0, 1]);
      expectMatrix3(matrix, [2, 0, 0], [0, 4, 0], [0, 0, 1]);
    });

    test('returns a copy of a singular matrix when it has no inverse', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      final inverted = matrix.inverted();

      expectMatrix3(inverted, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
      expect(inverted, matrix);
      expect(inverted, isNot(same(matrix)));
    });

    test('adds without changing its sources', () {
      final a = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final b = Matrix3(9, 8, 7, 6, 5, 4, 3, 2, 1);

      expectMatrix3(a + b, [10, 10, 10], [10, 10, 10], [10, 10, 10]);
      expectMatrix3(a, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
      expectMatrix3(b, [9, 8, 7], [6, 5, 4], [3, 2, 1]);
    });

    test('subtracts without changing its sources', () {
      final a = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final b = Matrix3(9, 8, 7, 6, 5, 4, 3, 2, 1);

      expectMatrix3(b - a, [8, 6, 4], [2, 0, -2], [-4, -6, -8]);
      expectMatrix3(a, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
      expectMatrix3(b, [9, 8, 7], [6, 5, 4], [3, 2, 1]);
    });

    test('negates without changing the source', () {
      final matrix = Matrix3(1, -2, 3, -4, 5, -6, 7, -8, 9);

      expectMatrix3(-matrix, [-1, 2, -3], [4, -5, 6], [-7, 8, -9]);
      expectMatrix3(matrix, [1, -2, 3], [-4, 5, -6], [7, -8, 9]);
    });

    test('compares and hashes by component values across both forms', () {
      final immutable = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final mutable = MMatrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      expect(immutable, mutable);
      expect(immutable.hashCode, mutable.hashCode);
      expect(immutable, isNot(Matrix3(0, 2, 3, 4, 5, 6, 7, 8, 9)));
      expect(immutable, isNot(Object()));
    });

    test('formats every row', () {
      expect(
        Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9).toString(),
        '[0] [1.0, 4.0, 7.0]\n[1] [2.0, 5.0, 8.0]\n[2] [3.0, 6.0, 9.0]',
      );
    });
  });

  group('MMatrix3', () {
    test('creates a zero matrix', () {
      expectMatrix3(MMatrix3.zero(), [0, 0, 0], [0, 0, 0], [0, 0, 0]);
    });

    test('creates the identity matrix', () {
      expectMatrix3(MMatrix3.identity(), [1, 0, 0], [0, 1, 0], [0, 0, 1]);
    });

    test('creates a matrix from column-major values', () {
      expectMatrix3(
        MMatrix3(1, 2, 3, 4, 5, 6, 7, 8, 9), //
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      );
    });

    test('creates a matrix from a list', () {
      expectMatrix3(
        MMatrix3.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9]),
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      );
    });

    test('converts between immutable and mutable forms via copy', () {
      final immutable = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final mutable = MMatrix3.copy(immutable);

      mutable[0] = 99;
      expectMatrix3(immutable, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
      expectMatrix3(mutable, [99, 2, 3], [4, 5, 6], [7, 8, 9]);

      final frozen = Matrix3.copy(mutable);
      mutable[0] = 0;

      expectMatrix3(frozen, [99, 2, 3], [4, 5, 6], [7, 8, 9]);
    });

    test('creates a rotation around the x axis', () {
      expectMatrix3(
        MMatrix3.rotationX(pi / 2), //
        [1, 0, 0],
        [0, 0, 1],
        [0, -1, 0],
      );
    });

    test('creates a rotation around the y axis', () {
      expectMatrix3(
        MMatrix3.rotationY(pi / 2), //
        [0, 0, -1],
        [0, 1, 0],
        [1, 0, 0],
      );
    });

    test('creates a rotation around the z axis', () {
      expectMatrix3(
        MMatrix3.rotationZ(pi / 2), //
        [0, 1, 0],
        [-1, 0, 0],
        [0, 0, 1],
      );
    });

    test('clones without sharing storage', () {
      final matrix = MMatrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final clone = matrix.clone();

      expectMatrix3(clone, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
      expect(clone, isNot(same(matrix)));

      clone[0] = 99;

      expectMatrix3(matrix, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
    });

    test('computes relative and absolute error against a correct matrix', () {
      final correct = MMatrix3.identity();
      final approximate = MMatrix3(1.1, 0, 0, 0, 1, 0, 0, 0, 1);

      expect(approximate.relativeError(correct), closeTo(0.1, 0.0000001));
      expect(approximate.absoluteError(correct), closeTo(0.1, 0.0000001));
    });

    test('reads through without changing the source', () {
      final matrix = MMatrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      for (var i = 0; i < 9; i += 1) {
        expect(matrix[i], i + 1);
      }
      expect(matrix.dimension, 3);
      expect(matrix.entry(0, 1), 4);
      expect(matrix.determinant(), 0);
      expect(matrix.trace(), 15);
      expect(matrix.isIdentity(), isFalse);
      expect(matrix.isZero(), isFalse);
      expect(matrix.transformed(.new(1, 1)), Vector2(12, 15));
      expectMatrix3(matrix, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
    });

    test('writes components by index', () {
      final matrix = MMatrix3.zero();

      for (var i = 0; i < 9; i += 1) {
        matrix[i] = (i + 1).toDouble();
      }

      for (var i = 0; i < 9; i += 1) {
        expect(matrix[i], i + 1);
      }

      expect(() => matrix[9] = 1, throwsRangeError);
    });

    test('writes components by row and column', () {
      final matrix = MMatrix3.zero();

      matrix.setEntry(0, 0, 1);
      matrix.setEntry(1, 0, 2);
      matrix.setEntry(2, 0, 3);
      matrix.setEntry(0, 1, 4);
      matrix.setEntry(1, 1, 5);
      matrix.setEntry(2, 1, 6);
      matrix.setEntry(0, 2, 7);
      matrix.setEntry(1, 2, 8);
      matrix.setEntry(2, 2, 9);

      expectMatrix3(matrix, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
    });

    test('sets column-major values directly', () {
      final matrix = MMatrix3.zero();

      matrix.setValues(1, 2, 3, 4, 5, 6, 7, 8, 9);

      expectMatrix3(matrix, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
    });

    test('sets all components from another matrix', () {
      final matrix = MMatrix3.zero();

      matrix.setFrom(Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9));

      expectMatrix3(matrix, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
    });

    test('copies from an array', () {
      final matrix = MMatrix3.zero();

      matrix.copyFromArray([1, 2, 3, 4, 5, 6, 7, 8, 9]);

      expectMatrix3(matrix, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
    });

    test('copies from an array at an offset', () {
      final matrix = MMatrix3.zero();

      matrix.copyFromArray([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 1);

      expectMatrix3(matrix, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
    });

    test('zeros in place', () {
      final matrix = MMatrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      matrix.setZero();

      expectMatrix3(matrix, [0, 0, 0], [0, 0, 0], [0, 0, 0]);
    });

    test('resets to the identity matrix in place', () {
      final matrix = MMatrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      matrix.setIdentity();

      expectMatrix3(matrix, [1, 0, 0], [0, 1, 0], [0, 0, 1]);
    });

    test('sets the diagonal in place', () {
      final matrix = MMatrix3.zero();

      matrix.setDiagonal(5);

      expectMatrix3(matrix, [5, 0, 0], [0, 5, 0], [0, 0, 5]);
    });

    test('sets a rotation around the x axis in place', () {
      final matrix = MMatrix3.zero();

      matrix.setRotationX(pi / 2);

      expectMatrix3(matrix, [1, 0, 0], [0, 0, 1], [0, -1, 0]);
    });

    test('sets a rotation around the y axis in place', () {
      final matrix = MMatrix3.zero();

      matrix.setRotationY(pi / 2);

      expectMatrix3(matrix, [0, 0, -1], [0, 1, 0], [1, 0, 0]);
    });

    test('sets a rotation around the z axis in place', () {
      final matrix = MMatrix3.zero();

      matrix.setRotationZ(pi / 2);

      expectMatrix3(matrix, [0, 1, 0], [-1, 0, 0], [0, 0, 1]);
    });

    test('transposes in place', () {
      final matrix = MMatrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      matrix.transpose();

      expectMatrix3(matrix, [1, 4, 7], [2, 5, 8], [3, 6, 9]);
    });

    test('computes the absolute value of every entry in place', () {
      final matrix = MMatrix3(-1, 2, -3, 4, -5, 6, -7, 8, -9);

      matrix.absolute();

      expectMatrix3(matrix, [1, 2, 3], [4, 5, 6], [7, 8, 9]);
    });

    test('scales every entry in place', () {
      final matrix = MMatrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      matrix.scale(2);

      expectMatrix3(matrix, [2, 4, 6], [8, 10, 12], [14, 16, 18]);
    });

    test('adds in place', () {
      final matrix = MMatrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      matrix.add(Matrix3(9, 8, 7, 6, 5, 4, 3, 2, 1));

      expectMatrix3(matrix, [10, 10, 10], [10, 10, 10], [10, 10, 10]);
    });

    test('subtracts in place', () {
      final matrix = MMatrix3(9, 8, 7, 6, 5, 4, 3, 2, 1);

      matrix.subtract(Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9));

      expectMatrix3(matrix, [8, 6, 4], [2, 0, -2], [-4, -6, -8]);
    });

    test('negates in place', () {
      final matrix = MMatrix3(1, -2, 3, -4, 5, -6, 7, -8, 9);

      matrix.negate();

      expectMatrix3(matrix, [-1, 2, -3], [4, -5, 6], [-7, 8, -9]);
    });

    test('multiplies in place', () {
      final matrix = MMatrix3(1, 0, 0, 0, 1, 0, 5, 0, 1);

      matrix.multiply(Matrix3(2, 0, 0, 0, 2, 0, 0, 0, 1));

      expectMatrix3(matrix, [2, 0, 0], [0, 2, 0], [5, 0, 1]);
    });

    test('multiplies by itself safely', () {
      final matrix = MMatrix3.rotationZ(pi / 2);

      matrix.multiply(matrix);

      expectMatrix3(matrix, [-1, 0, 0], [0, -1, 0], [0, 0, 1]);
    });

    test('premultiplies in place', () {
      final matrix = MMatrix3(2, 0, 0, 0, 2, 0, 0, 0, 1);

      matrix.premultiply(Matrix3(1, 0, 0, 0, 1, 0, 5, 0, 1));

      expectMatrix3(matrix, [2, 0, 0], [0, 2, 0], [5, 0, 1]);
    });

    test('premultiplies by itself safely', () {
      final matrix = MMatrix3.rotationZ(pi / 2);

      matrix.premultiply(matrix);

      expectMatrix3(matrix, [-1, 0, 0], [0, -1, 0], [0, 0, 1]);
    });

    test('transpose-multiplies an orthogonal matrix back to the identity', () {
      final matrix = MMatrix3.rotationZ(pi / 3);
      final other = MMatrix3.copy(matrix);

      matrix.transposeMultiply(other);

      expectMatrix3(matrix, [1, 0, 0], [0, 1, 0], [0, 0, 1]);
    });

    test(
      'multiplies by a transposed orthogonal matrix back to the identity',
      () {
        final matrix = MMatrix3.rotationZ(pi / 4);
        final other = MMatrix3.copy(matrix);

        matrix.multiplyTranspose(other);

        expectMatrix3(matrix, [1, 0, 0], [0, 1, 0], [0, 0, 1]);
      },
    );

    test('computes the scaled adjugate in place', () {
      final matrix = MMatrix3(2, 0, 0, 0, 3, 0, 0, 0, 4);

      matrix.scaleAdjoint(1);

      expectMatrix3(matrix, [12, 0, 0], [0, 8, 0], [0, 0, 6]);
    });

    test('inverts in place and returns the determinant', () {
      final matrix = MMatrix3(2, 0, 0, 0, 4, 0, 0, 0, 1);

      final det = matrix.invert();

      expect(det, 8);
      expectMatrix3(matrix, [0.5, 0, 0], [0, 0.25, 0], [0, 0, 1]);
    });

    test('sets itself to the inverse, returning the determinant', () {
      final matrix = MMatrix3.zero();
      final other = Matrix3(2, 0, 0, 0, 4, 0, 0, 0, 1);
      final det = matrix.copyInverse(other);

      expect(det, 8);
      expectMatrix3(matrix, [0.5, 0, 0], [0, 0.25, 0], [0, 0, 1]);
      expectMatrix3(other, [2, 0, 0], [0, 4, 0], [0, 0, 1]);
    });

    test('copies the source into itself when the determinant is zero', () {
      final matrix = MMatrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final singular = Matrix3.zero;

      final det = matrix.copyInverse(singular);

      expect(det, 0);
      expectMatrix3(matrix, [0, 0, 0], [0, 0, 0], [0, 0, 0]);
    });
  });
}
