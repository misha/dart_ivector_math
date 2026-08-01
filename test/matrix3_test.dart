import 'dart:math';

import 'package:ivector_math/ivector_math.dart';
import 'package:test/test.dart';

import 'support/matchers.dart';

void main() {
  group('construction', () {
    test('creates a zero matrix', () {
      expectMatrix3(Matrix3.zero(), 0, 0, 0, 0, 0, 0, 0, 0, 0);
    });

    test('creates a matrix from column-major values', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      expectMatrix3(matrix, 1, 2, 3, 4, 5, 6, 7, 8, 9);
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
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
      );
    });

    test('creates the identity matrix', () {
      expectMatrix3(Matrix3.identity(), 1, 0, 0, 0, 1, 0, 0, 0, 1);
    });

    test('copies without sharing storage', () {
      final original = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final copy = Matrix3.copy(original);

      original.mutate()[0] = 99;

      expectMatrix3(copy, 1, 2, 3, 4, 5, 6, 7, 8, 9);
    });

    test('creates a rotation around the x axis', () {
      expectMatrix3(Matrix3.rotationX(pi / 2), 1, 0, 0, 0, 0, 1, 0, -1, 0);
    });

    test('creates a rotation around the y axis', () {
      expectMatrix3(Matrix3.rotationY(pi / 2), 0, 0, -1, 0, 1, 0, 1, 0, 0);
    });

    test('creates a rotation around the z axis', () {
      expectMatrix3(Matrix3.rotationZ(pi / 2), 0, 1, 0, -1, 0, 0, 0, 0, 1);
    });
  });

  group('immutable view', () {
    test('reads components by index', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      for (var i = 0; i < 9; i += 1) {
        expect(matrix[i], i + 1);
      }
      expect(() => matrix[9], throwsRangeError);
    });

    test('reports its dimension', () {
      expect(Matrix3.zero().dimension, 3);
    });

    test('clones without sharing storage', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final clone = matrix.clone();

      matrix.mutate()[0] = 99;

      expectMatrix3(clone, 1, 2, 3, 4, 5, 6, 7, 8, 9);
    });

    test('computes the determinant', () {
      expect(Matrix3(2, 0, 0, 0, 3, 0, 0, 0, 1).determinant(), 6);
    });

    test('computes the trace', () {
      expect(Matrix3(2, 0, 0, 0, 3, 0, 0, 0, 1).trace(), 6);
    });

    test('detects the identity matrix', () {
      expect(Matrix3.identity().isIdentity(), isTrue);
      expect(Matrix3.zero().isIdentity(), isFalse);
    });

    test('detects the zero matrix', () {
      expect(Matrix3.zero().isZero(), isTrue);
      expect(Matrix3.identity().isZero(), isFalse);
    });

    test('computes the infinity norm', () {
      expect(Matrix3(1, -2, 3, -4, 5, -6, 7, -8, 9).infinityNorm(), 24);
    });

    test('computes relative and absolute error against a correct matrix', () {
      final correct = Matrix3.identity();
      final approximate = Matrix3(1.1, 0, 0, 0, 1, 0, 0, 0, 1);

      expect(approximate.relativeError(correct), closeTo(0.1, 0.0000001));
      expect(approximate.absoluteError(correct), closeTo(0.1, 0.0000001));
    });

    test('transforms a 2D point', () {
      final matrix = Matrix3(2, 0, 0, 0, 3, 0, 10, 20, 1);
      final point = Vector2(1, 1);

      matrix.transform(point.mutate());

      expectVector2(point, 12, 23);
    });

    test(
      'rotates a 2D point by the absolute rotation, ignoring translation',
      () {
        final matrix = Matrix3(0, 1, 0, -1, 0, 0, 5, 6, 1);
        final point = Vector2(2, 3);

        matrix.absoluteRotate2(point.mutate());

        expectVector2(point, 3, 2);
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

      final transposed = matrix.transpose();

      expectMatrix3(transposed, 1, 4, 7, 2, 5, 8, 3, 6, 9);
      expectMatrix3(matrix, 1, 2, 3, 4, 5, 6, 7, 8, 9);
    });

    test(
      'creates a component-wise absolute copy without changing the source',
      () {
        final matrix = Matrix3(-1, 2, -3, 4, -5, 6, -7, 8, -9);

        final absolute = matrix.absolute();

        expectMatrix3(absolute, 1, 2, 3, 4, 5, 6, 7, 8, 9);
        expectMatrix3(matrix, -1, 2, -3, 4, -5, 6, -7, 8, -9);
      },
    );

    test('creates a scaled copy without changing the source', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      final scaled = matrix.scale(2);

      expectMatrix3(scaled, 2, 4, 6, 8, 10, 12, 14, 16, 18);
      expectMatrix3(matrix, 1, 2, 3, 4, 5, 6, 7, 8, 9);
    });

    test('creates a multiplied copy without changing its sources', () {
      final translate = Matrix3(1, 0, 0, 0, 1, 0, 5, 0, 1);
      final scaleMatrix = Matrix3(2, 0, 0, 0, 2, 0, 0, 0, 1);

      final combined = translate.multiply(scaleMatrix);

      expectMatrix3(combined, 2, 0, 0, 0, 2, 0, 5, 0, 1);
      expectMatrix3(translate, 1, 0, 0, 0, 1, 0, 5, 0, 1);
      expectMatrix3(scaleMatrix, 2, 0, 0, 0, 2, 0, 0, 0, 1);
    });

    test(
      'creates a premultiplied copy equivalent to the other multiply order',
      () {
        final translate = Matrix3(1, 0, 0, 0, 1, 0, 5, 0, 1);
        final scaleMatrix = Matrix3(2, 0, 0, 0, 2, 0, 0, 0, 1);

        final combined = scaleMatrix.premultiply(translate);

        expectMatrix3(combined, 2, 0, 0, 0, 2, 0, 5, 0, 1);
        expectMatrix3(translate, 1, 0, 0, 0, 1, 0, 5, 0, 1);
        expectMatrix3(scaleMatrix, 2, 0, 0, 0, 2, 0, 0, 0, 1);
      },
    );

    test('adds without changing its sources', () {
      final a = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final b = Matrix3(9, 8, 7, 6, 5, 4, 3, 2, 1);

      expectMatrix3(a + b, 10, 10, 10, 10, 10, 10, 10, 10, 10);
      expectMatrix3(a, 1, 2, 3, 4, 5, 6, 7, 8, 9);
      expectMatrix3(b, 9, 8, 7, 6, 5, 4, 3, 2, 1);
    });

    test('subtracts without changing its sources', () {
      final a = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final b = Matrix3(9, 8, 7, 6, 5, 4, 3, 2, 1);

      expectMatrix3(b - a, 8, 6, 4, 2, 0, -2, -4, -6, -8);
      expectMatrix3(a, 1, 2, 3, 4, 5, 6, 7, 8, 9);
      expectMatrix3(b, 9, 8, 7, 6, 5, 4, 3, 2, 1);
    });

    test('negates without changing the source', () {
      final matrix = Matrix3(1, -2, 3, -4, 5, -6, 7, -8, 9);

      expectMatrix3(-matrix, -1, 2, -3, 4, -5, 6, -7, 8, -9);
      expectMatrix3(matrix, 1, -2, 3, -4, 5, -6, 7, -8, 9);
    });

    test('compares and hashes by component values', () {
      final first = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final equal = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      expect(first, equal);
      expect(first.hashCode, equal.hashCode);
      expect(first, isNot(Matrix3(0, 2, 3, 4, 5, 6, 7, 8, 9)));
      expect(first, isNot(Object()));
    });

    test('formats every row', () {
      expect(
        Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9).toString(),
        '[0] [1.0, 4.0, 7.0]\n[1] [2.0, 5.0, 8.0]\n[2] [3.0, 6.0, 9.0]',
      );
    });
  });

  group('mutable view', () {
    test('reads through without changing the source', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final mutable = matrix.mutate();

      for (var i = 0; i < 9; i += 1) {
        expect(mutable[i], i + 1);
      }
      expect(mutable.dimension, 3);
      expect(mutable.entry(0, 1), matrix.entry(0, 1));
      expect(mutable.determinant(), matrix.determinant());
      expect(mutable.trace(), matrix.trace());
      expect(mutable.isIdentity(), isFalse);
      expect(mutable.isZero(), isFalse);
      expect(mutable.infinityNorm(), matrix.infinityNorm());
      expectMatrix3(matrix, 1, 2, 3, 4, 5, 6, 7, 8, 9);
    });

    test('writes components by index', () {
      final matrix = Matrix3.zero();
      final mutable = matrix.mutate();

      for (var i = 0; i < 9; i += 1) {
        mutable[i] = (i + 1).toDouble();
      }

      for (var i = 0; i < 9; i += 1) {
        expect(matrix[i], i + 1);
      }
      expect(() => mutable[9] = 1, throwsRangeError);
    });

    test('writes components by row and column', () {
      final matrix = Matrix3.zero();
      final mutable = matrix.mutate();

      mutable.setEntry(0, 0, 1);
      mutable.setEntry(1, 0, 2);
      mutable.setEntry(2, 0, 3);
      mutable.setEntry(0, 1, 4);
      mutable.setEntry(1, 1, 5);
      mutable.setEntry(2, 1, 6);
      mutable.setEntry(0, 2, 7);
      mutable.setEntry(1, 2, 8);
      mutable.setEntry(2, 2, 9);

      expectMatrix3(matrix, 1, 2, 3, 4, 5, 6, 7, 8, 9);
    });

    test('sets column-major values directly', () {
      final matrix = Matrix3.zero();

      matrix.mutate().setValues(1, 2, 3, 4, 5, 6, 7, 8, 9);

      expectMatrix3(matrix, 1, 2, 3, 4, 5, 6, 7, 8, 9);
    });

    test('sets all components from another matrix', () {
      final matrix = Matrix3.zero();

      matrix.mutate().setFrom(Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9));

      expectMatrix3(matrix, 1, 2, 3, 4, 5, 6, 7, 8, 9);
    });

    test('copies from an array', () {
      final matrix = Matrix3.zero();

      matrix.mutate().copyFromArray([1, 2, 3, 4, 5, 6, 7, 8, 9]);

      expectMatrix3(matrix, 1, 2, 3, 4, 5, 6, 7, 8, 9);
    });

    test('copies from an array at an offset', () {
      final matrix = Matrix3.zero();

      matrix.mutate().copyFromArray([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 1);

      expectMatrix3(matrix, 1, 2, 3, 4, 5, 6, 7, 8, 9);
    });

    test('zeros in place', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      matrix.mutate().setZero();

      expectMatrix3(matrix, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    });

    test('resets to the identity matrix in place', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      matrix.mutate().setIdentity();

      expectMatrix3(matrix, 1, 0, 0, 0, 1, 0, 0, 0, 1);
    });

    test('sets the diagonal in place', () {
      final matrix = Matrix3.zero();

      matrix.mutate().splatDiagonal(5);

      expectMatrix3(matrix, 5, 0, 0, 0, 5, 0, 0, 0, 5);
    });

    test('sets a rotation around the x axis in place', () {
      final matrix = Matrix3.zero();

      matrix.mutate().setRotationX(pi / 2);

      expectMatrix3(matrix, 1, 0, 0, 0, 0, 1, 0, -1, 0);
    });

    test('sets a rotation around the y axis in place', () {
      final matrix = Matrix3.zero();

      matrix.mutate().setRotationY(pi / 2);

      expectMatrix3(matrix, 0, 0, -1, 0, 1, 0, 1, 0, 0);
    });

    test('sets a rotation around the z axis in place', () {
      final matrix = Matrix3.zero();

      matrix.mutate().setRotationZ(pi / 2);

      expectMatrix3(matrix, 0, 1, 0, -1, 0, 0, 0, 0, 1);
    });

    test('transposes in place', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      matrix.mutate().transpose();

      expectMatrix3(matrix, 1, 4, 7, 2, 5, 8, 3, 6, 9);
    });

    test('scales every entry in place', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      matrix.mutate().scale(2);

      expectMatrix3(matrix, 2, 4, 6, 8, 10, 12, 14, 16, 18);
    });

    test('adds in place', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      matrix.mutate().add(Matrix3(9, 8, 7, 6, 5, 4, 3, 2, 1));

      expectMatrix3(matrix, 10, 10, 10, 10, 10, 10, 10, 10, 10);
    });

    test('subtracts in place', () {
      final matrix = Matrix3(9, 8, 7, 6, 5, 4, 3, 2, 1);

      matrix.mutate().sub(Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9));

      expectMatrix3(matrix, 8, 6, 4, 2, 0, -2, -4, -6, -8);
    });

    test('negates in place', () {
      final matrix = Matrix3(1, -2, 3, -4, 5, -6, 7, -8, 9);

      matrix.mutate().negate();

      expectMatrix3(matrix, -1, 2, -3, 4, -5, 6, -7, 8, -9);
    });

    test('multiplies in place', () {
      final matrix = Matrix3(1, 0, 0, 0, 1, 0, 5, 0, 1);

      matrix.mutate().multiply(Matrix3(2, 0, 0, 0, 2, 0, 0, 0, 1));

      expectMatrix3(matrix, 2, 0, 0, 0, 2, 0, 5, 0, 1);
    });

    test('multiplies by itself safely', () {
      final matrix = Matrix3.rotationZ(pi / 2);

      matrix.mutate().multiply(matrix);

      expectMatrix3(matrix, -1, 0, 0, 0, -1, 0, 0, 0, 1);
    });

    test('premultiplies in place', () {
      final matrix = Matrix3(2, 0, 0, 0, 2, 0, 0, 0, 1);

      matrix.mutate().premultiply(Matrix3(1, 0, 0, 0, 1, 0, 5, 0, 1));

      expectMatrix3(matrix, 2, 0, 0, 0, 2, 0, 5, 0, 1);
    });

    test('premultiplies by itself safely', () {
      final matrix = Matrix3.rotationZ(pi / 2);

      matrix.mutate().premultiply(matrix);

      expectMatrix3(matrix, -1, 0, 0, 0, -1, 0, 0, 0, 1);
    });

    test('transpose-multiplies an orthogonal matrix back to the identity', () {
      final matrix = Matrix3.rotationZ(pi / 3);
      final other = Matrix3.copy(matrix);

      matrix.mutate().transposeMultiply(other);

      expectMatrix3(matrix, 1, 0, 0, 0, 1, 0, 0, 0, 1);
    });

    test(
      'multiplies by a transposed orthogonal matrix back to the identity',
      () {
        final matrix = Matrix3.rotationZ(pi / 4);
        final other = Matrix3.copy(matrix);

        matrix.mutate().multiplyTranspose(other);

        expectMatrix3(matrix, 1, 0, 0, 0, 1, 0, 0, 0, 1);
      },
    );

    test('computes the scaled adjugate in place', () {
      final matrix = Matrix3(2, 0, 0, 0, 3, 0, 0, 0, 4);

      matrix.mutate().scaleAdjoint(1);

      expectMatrix3(matrix, 12, 0, 0, 0, 8, 0, 0, 0, 6);
    });

    test('inverts in place and returns the determinant', () {
      final matrix = Matrix3(2, 0, 0, 0, 4, 0, 0, 0, 1);

      final det = matrix.mutate().invert();

      expect(det, 8);
      expectMatrix3(matrix, 0.5, 0, 0, 0, 0.25, 0, 0, 0, 1);
    });

    test(
      'sets itself to the inverse of another matrix, returning the determinant',
      () {
        final matrix = Matrix3.zero();
        final other = Matrix3(2, 0, 0, 0, 4, 0, 0, 0, 1);

        final det = matrix.mutate().copyInverse(other);

        expect(det, 8);
        expectMatrix3(matrix, 0.5, 0, 0, 0, 0.25, 0, 0, 0, 1);
        expectMatrix3(other, 2, 0, 0, 0, 4, 0, 0, 0, 1);
      },
    );

    test('copies the source into itself when the determinant is zero', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final singular = Matrix3.zero();

      final det = matrix.mutate().copyInverse(singular);

      expect(det, 0);
      expectMatrix3(matrix, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    });
  });
}
