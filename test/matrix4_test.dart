import 'dart:math' as math;

import 'package:ivector_math/ivector_math.dart';
import 'package:test/test.dart';

import 'support/matchers.dart';

void main() {
  group('Matrix4', () {
    test('creates a zero matrix', () {
      expectMatrix4(
        Matrix4.zero,
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      );
    });

    test('reuses a canonical zero instance', () {
      expect(identical(Matrix4.zero, Matrix4.zero), isTrue);
    });

    test('creates the identity matrix', () {
      expectMatrix4(
        Matrix4.identity,
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1],
      );
    });

    test('reuses a canonical identity instance', () {
      expect(identical(Matrix4.identity, Matrix4.identity), isTrue);
    });

    test('creates a matrix from column-major values', () {
      final matrix = Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      expectMatrix4(
        matrix,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
      expect(matrix.entry(0, 0), 1);
      expect(matrix.entry(1, 0), 2);
      expect(matrix.entry(2, 0), 3);
      expect(matrix.entry(3, 0), 4);
      expect(matrix.entry(0, 1), 5);
      expect(matrix.entry(1, 1), 6);
      expect(matrix.entry(2, 1), 7);
      expect(matrix.entry(3, 1), 8);
      expect(matrix.entry(0, 2), 9);
      expect(matrix.entry(1, 2), 10);
      expect(matrix.entry(2, 2), 11);
      expect(matrix.entry(3, 2), 12);
      expect(matrix.entry(0, 3), 13);
      expect(matrix.entry(1, 3), 14);
      expect(matrix.entry(2, 3), 15);
      expect(matrix.entry(3, 3), 16);
    });

    test('creates a matrix from a list', () {
      expectMatrix4(
        Matrix4.fromList([
          // dart format off
          1,  2,  3,  4,
          5,  6,  7,  8,
          9,  10, 11, 12,
          13, 14, 15, 16,
          // dart format on
        ]),
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
    });

    test('copies without sharing storage', () {
      final original = MMatrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );
      final copy = Matrix4.copy(original);

      original[0] = 99;

      expectMatrix4(
        copy,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
    });

    test('creates a rotation around the x axis', () {
      expectMatrix4(
        Matrix4.rotationX(math.pi / 2),
        [1, 0, 0, 0],
        [0, 0, 1, 0],
        [0, -1, 0, 0],
        [0, 0, 0, 1],
      );
    });

    test('creates a rotation around the y axis', () {
      expectMatrix4(
        Matrix4.rotationY(math.pi / 2),
        [0, 0, -1, 0],
        [0, 1, 0, 0],
        [1, 0, 0, 0],
        [0, 0, 0, 1],
      );
    });

    test('creates a rotation around the z axis', () {
      expectMatrix4(
        Matrix4.rotationZ(math.pi / 2),
        [0, 1, 0, 0],
        [-1, 0, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1],
      );
    });

    test('creates a translation from a vector', () {
      expectMatrix4(
        Matrix4.translation(Vector3(1, 2, 3)),
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [1, 2, 3, 1],
      );
    });

    test('creates a translation from values', () {
      expectMatrix4(
        Matrix4.translationValues(1, 2, 3),
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [1, 2, 3, 1],
      );
    });

    test('creates a scale from a vector', () {
      expectMatrix4(
        Matrix4.diagonal3(Vector3(2, 3, 4)),
        [2, 0, 0, 0],
        [0, 3, 0, 0],
        [0, 0, 4, 0],
        [0, 0, 0, 1],
      );
    });

    test('creates a scale from values', () {
      expectMatrix4(
        Matrix4.diagonal3Values(2, 3, 4),
        [2, 0, 0, 0],
        [0, 3, 0, 0],
        [0, 0, 4, 0],
        [0, 0, 0, 1],
      );
    });

    test('reads components by index', () {
      final matrix = Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      for (var i = 0; i < 16; i += 1) {
        expect(matrix[i], i + 1);
      }
      expect(() => matrix[16], throwsRangeError);
    });

    test('reports its dimension', () {
      expect(Matrix4.zero.dimension, 4);
    });

    test('clones without sharing storage', () {
      final matrix = Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );
      final clone = matrix.clone();

      expectMatrix4(
        clone,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
      expect(clone, isNot(same(matrix)));
    });

    test('computes the determinant', () {
      final matrix = Matrix4(
        // dart format off
        2, 0, 0, 0,
        0, 4, 0, 0,
        0, 0, 8, 0,
        1, 2, 3, 1,
        // dart format on
      );
      final singular = Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      expect(matrix.determinant(), 64);
      expect(singular.determinant(), 0);
    });

    test('computes the trace', () {
      final matrix = Matrix4(
        // dart format off
        2, 0, 0, 0,
        0, 4, 0, 0,
        0, 0, 8, 0,
        1, 2, 3, 1,
        // dart format on
      );

      expect(matrix.trace(), 15);
    });

    test('detects the identity matrix', () {
      expect(Matrix4.identity.isIdentity, isTrue);
      expect(Matrix4.zero.isIdentity, isFalse);
    });

    test('detects the zero matrix', () {
      expect(Matrix4.zero.isZero, isTrue);
      expect(Matrix4.identity.isZero, isFalse);
    });

    test('computes the infinity norm', () {
      final matrix = Matrix4(
        // dart format off
        1,  -2,  3,  -4,
        5,  -6,  7,  -8,
        9,  -10, 11, -12,
        13, -14, 15, -16,
        // dart format on
      );

      expect(matrix.infinityNorm(), 58);
    });

    test('computes relative and absolute error against a correct matrix', () {
      final correct = Matrix4.identity;
      final approximate = Matrix4(
        // dart format off
        1.1, 0,   0,   0,
        0,   1,   0,   0,
        0,   0,   1,   0,
        0,   0,   0,   1,
        // dart format on
      );

      expect(approximate.relativeError(correct), closeTo(0.1, 0.0000001));
      expect(approximate.absoluteError(correct), closeTo(0.1, 0.0000001));
    });

    test('reads the translation', () {
      final matrix = Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      expectVector3(matrix.getTranslation(), 13, 14, 15);
    });

    test('reads the rotation', () {
      final matrix = Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      expectMatrix3(matrix.getRotation(), [1, 2, 3], [5, 6, 7], [9, 10, 11]);
    });

    test('copies into an array', () {
      final array = List<double>.filled(16, 0);

      Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      ).copyIntoArray(array);

      expect(array, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);
    });

    test('copies into an array at an offset', () {
      final array = List<double>.filled(17, 0);

      Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      ).copyIntoArray(array, 1);

      expect(array, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);
    });

    test('creates a transposed copy without changing the source', () {
      final matrix = Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      final transposed = matrix.transposed();

      expectMatrix4(
        transposed,
        [1, 5, 9, 13],
        [2, 6, 10, 14],
        [3, 7, 11, 15],
        [4, 8, 12, 16],
      );
      expectMatrix4(
        matrix,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
    });

    test('creates a scaled copy without changing the source', () {
      final matrix = Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      final scaled = matrix.scaled(2);

      expectMatrix4(
        scaled,
        [2, 4, 6, 8],
        [10, 12, 14, 16],
        [18, 20, 22, 24],
        [26, 28, 30, 32],
      );

      expectMatrix4(
        matrix,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
    });

    test('creates a copy scaled by a vector without changing the source', () {
      final matrix = Matrix4.translationValues(1, 2, 3);

      final scaled = matrix.scaledByVector3(Vector3(2, 3, 4));

      expectMatrix4(
        scaled,
        [2, 0, 0, 0],
        [0, 3, 0, 0],
        [0, 0, 4, 0],
        [1, 2, 3, 1],
      );

      expectMatrix4(
        matrix,
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [1, 2, 3, 1],
      );
    });

    test('creates a translated copy without changing the source', () {
      final matrix = Matrix4.diagonal3Values(2, 3, 4);

      final translated = matrix.translated(Vector3(1, 2, 3));

      expectMatrix4(
        translated,
        [2, 0, 0, 0],
        [0, 3, 0, 0],
        [0, 0, 4, 0],
        [2, 6, 12, 1],
      );

      expectMatrix4(
        matrix,
        [2, 0, 0, 0],
        [0, 3, 0, 0],
        [0, 0, 4, 0],
        [0, 0, 0, 1],
      );
    });

    test('creates a left-translated copy without changing the source', () {
      final matrix = Matrix4.diagonal3Values(2, 3, 4);

      final translated = matrix.leftTranslated(Vector3(1, 2, 3));

      expectMatrix4(
        translated,
        [2, 0, 0, 0],
        [0, 3, 0, 0],
        [0, 0, 4, 0],
        [1, 2, 3, 1],
      );
      expectMatrix4(
        matrix,
        [2, 0, 0, 0],
        [0, 3, 0, 0],
        [0, 0, 4, 0],
        [0, 0, 0, 1],
      );
    });

    test('creates rotated copies without changing the source', () {
      final matrix = Matrix4.translationValues(1, 2, 3);

      expectMatrix4(
        matrix.rotatedX(math.pi / 2),
        [1, 0, 0, 0],
        [0, 0, 1, 0],
        [0, -1, 0, 0],
        [1, 2, 3, 1],
      );
      expectMatrix4(
        matrix.rotatedY(math.pi / 2),
        [0, 0, -1, 0],
        [0, 1, 0, 0],
        [1, 0, 0, 0],
        [1, 2, 3, 1],
      );
      expectMatrix4(
        matrix.rotatedZ(math.pi / 2),
        [0, 1, 0, 0],
        [-1, 0, 0, 0],
        [0, 0, 1, 0],
        [1, 2, 3, 1],
      );
      expectMatrix4(
        matrix,
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [1, 2, 3, 1],
      );
    });

    test(
      'creates a copy with the diagonal set without changing the source',
      () {
        final matrix = Matrix4.zero;

        final diagonal = matrix.diagonal(5);

        expectMatrix4(
          diagonal,
          [5, 0, 0, 0],
          [0, 5, 0, 0],
          [0, 0, 5, 0],
          [0, 0, 0, 5],
        );

        expectMatrix4(
          matrix,
          [0, 0, 0, 0],
          [0, 0, 0, 0],
          [0, 0, 0, 0],
          [0, 0, 0, 0],
        );
      },
    );

    test('creates a multiplied copy without changing its sources', () {
      final translate = Matrix4.translationValues(5, 0, 0);
      final scaleMatrix = Matrix4.diagonal3Values(2, 2, 2);

      final combined = translate.multiplied(scaleMatrix);

      expectMatrix4(
        combined,
        [2, 0, 0, 0],
        [0, 2, 0, 0],
        [0, 0, 2, 0],
        [5, 0, 0, 1],
      );

      expectMatrix4(
        translate,
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [5, 0, 0, 1],
      );

      expectMatrix4(
        scaleMatrix,
        [2, 0, 0, 0],
        [0, 2, 0, 0],
        [0, 0, 2, 0],
        [0, 0, 0, 1],
      );
    });

    test(
      'creates a premultiplied copy equivalent to the other multiply order',
      () {
        final translate = Matrix4.translationValues(5, 0, 0);
        final scaleMatrix = Matrix4.diagonal3Values(2, 2, 2);

        final combined = scaleMatrix.premultiplied(translate);

        expectMatrix4(
          combined,
          [2, 0, 0, 0],
          [0, 2, 0, 0],
          [0, 0, 2, 0],
          [5, 0, 0, 1],
        );

        expectMatrix4(
          translate,
          [1, 0, 0, 0],
          [0, 1, 0, 0],
          [0, 0, 1, 0],
          [5, 0, 0, 1],
        );

        expectMatrix4(
          scaleMatrix,
          [2, 0, 0, 0],
          [0, 2, 0, 0],
          [0, 0, 2, 0],
          [0, 0, 0, 1],
        );
      },
    );

    test('creates a transpose-multiplied copy without changing the source', () {
      final matrix = Matrix4.rotationZ(math.pi / 3);

      final result = matrix.transposeMultiplied(matrix);

      expectMatrix4(
        result,
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1],
      );

      expect(matrix, Matrix4.rotationZ(math.pi / 3));
    });

    test('creates a multiply-transposed copy without changing the source', () {
      final matrix = Matrix4.rotationZ(math.pi / 4);

      final result = matrix.multiplyTransposed(matrix);

      expectMatrix4(
        result,
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1],
      );

      expect(matrix, Matrix4.rotationZ(math.pi / 4));
    });

    test('creates a scaled adjugate copy without changing the source', () {
      final matrix = Matrix4(
        // dart format off
        2, 0, 0, 0,
        0, 4, 0, 0,
        0, 0, 8, 0,
        1, 2, 3, 1,
        // dart format on
      );

      final adjugate = matrix.scaledAdjoint(1);

      expectMatrix4(
        adjugate,
        [32, 0, 0, 0],
        [0, 16, 0, 0],
        [0, 0, 8, 0],
        [-32, -32, -24, 64],
      );
      expectMatrix4(
        matrix,
        [2, 0, 0, 0],
        [0, 4, 0, 0],
        [0, 0, 8, 0],
        [1, 2, 3, 1],
      );
    });

    test('creates the inverse without changing the source', () {
      final matrix = Matrix4(
        // dart format off
        2, 0, 0, 0,
        0, 4, 0, 0,
        0, 0, 8, 0,
        1, 2, 3, 1,
        // dart format on
      );

      final inverted = matrix.inverted();

      expectMatrix4(
        inverted,
        [0.5, 0, 0, 0],
        [0, 0.25, 0, 0],
        [0, 0, 0.125, 0],
        [-0.5, -0.5, -0.375, 1],
      );
      expectMatrix4(
        matrix,
        [2, 0, 0, 0],
        [0, 4, 0, 0],
        [0, 0, 8, 0],
        [1, 2, 3, 1],
      );
    });

    test('returns a copy of a singular matrix when it has no inverse', () {
      final matrix = Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      final inverted = matrix.inverted();

      expectMatrix4(
        inverted,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
      expect(inverted, matrix);
      expect(inverted, isNot(same(matrix)));
    });

    test('adds without changing its sources', () {
      final a = Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      final b = Matrix4(
        // dart format off
        16, 15, 14, 13,
        12, 11, 10, 9,
        8,  7,  6,  5,
        4,  3,  2,  1,
        // dart format on
      );

      expectMatrix4(
        a + b,
        [17, 17, 17, 17],
        [17, 17, 17, 17],
        [17, 17, 17, 17],
        [17, 17, 17, 17],
      );

      expectMatrix4(
        a,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );

      expectMatrix4(
        b,
        [16, 15, 14, 13],
        [12, 11, 10, 9],
        [8, 7, 6, 5],
        [4, 3, 2, 1],
      );
    });

    test('subtracts without changing its sources', () {
      final a = Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      final b = Matrix4(
        // dart format off
        16, 15, 14, 13,
        12, 11, 10, 9,
        8,  7,  6,  5,
        4,  3,  2,  1,
        // dart format on
      );

      expectMatrix4(
        b - a,
        [15, 13, 11, 9],
        [7, 5, 3, 1],
        [-1, -3, -5, -7],
        [-9, -11, -13, -15],
      );

      expectMatrix4(
        a,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );

      expectMatrix4(
        b,
        [16, 15, 14, 13],
        [12, 11, 10, 9],
        [8, 7, 6, 5],
        [4, 3, 2, 1],
      );
    });

    test('negates without changing the source', () {
      final matrix = Matrix4(
        // dart format off
        1,  -2,  3,  -4,
        5,  -6,  7,  -8,
        9,  -10, 11, -12,
        13, -14, 15, -16,
        // dart format on
      );

      expectMatrix4(
        -matrix,
        [-1, 2, -3, 4],
        [-5, 6, -7, 8],
        [-9, 10, -11, 12],
        [-13, 14, -15, 16],
      );

      expectMatrix4(
        matrix,
        [1, -2, 3, -4],
        [5, -6, 7, -8],
        [9, -10, 11, -12],
        [13, -14, 15, -16],
      );
    });

    test('compares and hashes by component values across both forms', () {
      final immutable = Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      final mutable = MMatrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      expect(immutable, mutable);
      expect(immutable.hashCode, mutable.hashCode);
      expect(immutable, isNot(Matrix4.identity));
      expect(immutable, isNot(Object()));
    });

    test('formats every row', () {
      expect(
        Matrix4(
          // dart format off
          1,  2,  3,  4,
          5,  6,  7,  8,
          9,  10, 11, 12,
          13, 14, 15, 16,
          // dart format on
        ).toString(),
        '[0] [1.0, 5.0, 9.0, 13.0]\n'
        '[1] [2.0, 6.0, 10.0, 14.0]\n'
        '[2] [3.0, 7.0, 11.0, 15.0]\n'
        '[3] [4.0, 8.0, 12.0, 16.0]',
      );
    });
  });

  group('MMatrix4', () {
    test('creates a zero matrix', () {
      expectMatrix4(
        MMatrix4.zero(),
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      );
    });

    test('creates the identity matrix', () {
      expectMatrix4(
        MMatrix4.identity(),
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1],
      );
    });

    test('creates a matrix from column-major values', () {
      expectMatrix4(
        MMatrix4(
          // dart format off
          1,  2,  3,  4,
          5,  6,  7,  8,
          9,  10, 11, 12,
          13, 14, 15, 16,
          // dart format on
        ),
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
    });

    test('creates a matrix from a list', () {
      expectMatrix4(
        MMatrix4.fromList([
          // dart format off
          1,  2,  3,  4,
          5,  6,  7,  8,
          9,  10, 11, 12,
          13, 14, 15, 16,
          // dart format on
        ]),
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
    });

    test('converts between immutable and mutable forms via copy', () {
      final immutable = Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      final mutable = MMatrix4.copy(immutable);
      mutable[0] = 99;

      expectMatrix4(
        immutable,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );

      expectMatrix4(
        mutable,
        [99, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );

      final frozen = Matrix4.copy(mutable);
      mutable[0] = 0;

      expectMatrix4(
        frozen,
        [99, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
    });

    test('creates a rotation around the x axis', () {
      expectMatrix4(
        MMatrix4.rotationX(math.pi / 2),
        [1, 0, 0, 0],
        [0, 0, 1, 0],
        [0, -1, 0, 0],
        [0, 0, 0, 1],
      );
    });

    test('creates a rotation around the y axis', () {
      expectMatrix4(
        MMatrix4.rotationY(math.pi / 2),
        [0, 0, -1, 0],
        [0, 1, 0, 0],
        [1, 0, 0, 0],
        [0, 0, 0, 1],
      );
    });

    test('creates a rotation around the z axis', () {
      expectMatrix4(
        MMatrix4.rotationZ(math.pi / 2),
        [0, 1, 0, 0],
        [-1, 0, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1],
      );
    });

    test('creates a translation from a vector', () {
      expectMatrix4(
        MMatrix4.translation(Vector3(1, 2, 3)),
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [1, 2, 3, 1],
      );
    });

    test('creates a translation from values', () {
      expectMatrix4(
        MMatrix4.translationValues(1, 2, 3),
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [1, 2, 3, 1],
      );
    });

    test('creates a scale from a vector', () {
      expectMatrix4(
        MMatrix4.diagonal3(Vector3(2, 3, 4)),
        [2, 0, 0, 0],
        [0, 3, 0, 0],
        [0, 0, 4, 0],
        [0, 0, 0, 1],
      );
    });

    test('creates a scale from values', () {
      expectMatrix4(
        MMatrix4.diagonal3Values(2, 3, 4),
        [2, 0, 0, 0],
        [0, 3, 0, 0],
        [0, 0, 4, 0],
        [0, 0, 0, 1],
      );
    });

    test('clones without sharing storage', () {
      final matrix = MMatrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );
      final clone = matrix.clone();

      expectMatrix4(
        clone,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
      expect(clone, isNot(same(matrix)));

      clone[0] = 99;

      expectMatrix4(
        matrix,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
    });

    test('computes relative and absolute error against a correct matrix', () {
      final correct = MMatrix4.identity();
      final approximate = MMatrix4(
        // dart format off
        1.1, 0,   0,   0,
        0,   1,   0,   0,
        0,   0,   1,   0,
        0,   0,   0,   1,
        // dart format on
      );

      expect(approximate.relativeError(correct), closeTo(0.1, 0.0000001));
      expect(approximate.absoluteError(correct), closeTo(0.1, 0.0000001));
    });

    test('reads through without changing the source', () {
      final matrix = MMatrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      for (var i = 0; i < 16; i += 1) {
        expect(matrix[i], i + 1);
      }

      expect(matrix.dimension, 4);
      expect(matrix.entry(0, 1), 5);
      expect(matrix.determinant(), 0);
      expect(matrix.trace(), 34);
      expect(matrix.isIdentity, isFalse);
      expect(matrix.isZero, isFalse);
      expectVector3(matrix.getTranslation(), 13, 14, 15);
      expectMatrix3(matrix.getRotation(), [1, 2, 3], [5, 6, 7], [9, 10, 11]);
      expectMatrix4(
        matrix,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
    });

    test('writes components by index', () {
      final matrix = MMatrix4.zero();

      for (var i = 0; i < 16; i += 1) {
        matrix[i] = (i + 1).toDouble();
      }

      for (var i = 0; i < 16; i += 1) {
        expect(matrix[i], i + 1);
      }

      expect(() => matrix[16] = 1, throwsRangeError);
    });

    test('writes components by row and column', () {
      final matrix = MMatrix4.zero();

      matrix.setEntry(0, 0, 1);
      matrix.setEntry(1, 0, 2);
      matrix.setEntry(2, 0, 3);
      matrix.setEntry(3, 0, 4);
      matrix.setEntry(0, 1, 5);
      matrix.setEntry(1, 1, 6);
      matrix.setEntry(2, 1, 7);
      matrix.setEntry(3, 1, 8);
      matrix.setEntry(0, 2, 9);
      matrix.setEntry(1, 2, 10);
      matrix.setEntry(2, 2, 11);
      matrix.setEntry(3, 2, 12);
      matrix.setEntry(0, 3, 13);
      matrix.setEntry(1, 3, 14);
      matrix.setEntry(2, 3, 15);
      matrix.setEntry(3, 3, 16);

      expectMatrix4(
        matrix,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
    });

    test('sets column-major values directly', () {
      final matrix = MMatrix4.zero();

      matrix.setValues(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      expectMatrix4(
        matrix,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
    });

    test('sets all components from another matrix', () {
      final matrix = MMatrix4.zero();

      matrix.setFrom(
        Matrix4(
          // dart format off
          1,  2,  3,  4,
          5,  6,  7,  8,
          9,  10, 11, 12,
          13, 14, 15, 16,
          // dart format on
        ),
      );

      expectMatrix4(
        matrix,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
    });

    test('copies from an array', () {
      final matrix = MMatrix4.zero();

      matrix.copyFromArray([
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      ]);

      expectMatrix4(
        matrix,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
    });

    test('copies from an array at an offset', () {
      final matrix = MMatrix4.zero();

      matrix.copyFromArray([
        // dart format off
        0,
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      ], 1);

      expectMatrix4(
        matrix,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
    });

    test('zeros in place', () {
      final matrix = MMatrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      matrix.setZero();

      expectMatrix4(
        matrix,
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      );
    });

    test('resets to the identity matrix in place', () {
      final matrix = MMatrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      matrix.setIdentity();

      expectMatrix4(
        matrix,
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1],
      );
    });

    test('sets the diagonal in place', () {
      final matrix = MMatrix4.zero();

      matrix.setDiagonal(5);

      expectMatrix4(
        matrix,
        [5, 0, 0, 0],
        [0, 5, 0, 0],
        [0, 0, 5, 0],
        [0, 0, 0, 5],
      );
    });

    test('sets the upper-left diagonal from a vector in place', () {
      final matrix = MMatrix4.identity();

      matrix.setDiagonal3(Vector3(2, 3, 4));

      expectMatrix4(
        matrix,
        [2, 0, 0, 0],
        [0, 3, 0, 0],
        [0, 0, 4, 0],
        [0, 0, 0, 1],
      );
    });

    test('sets the upper-left diagonal from values in place', () {
      final matrix = MMatrix4.identity();

      matrix.setDiagonal3Values(2, 3, 4);

      expectMatrix4(
        matrix,
        [2, 0, 0, 0],
        [0, 3, 0, 0],
        [0, 0, 4, 0],
        [0, 0, 0, 1],
      );
    });

    test(
      'sets a rotation around the x axis in place, keeping the translation',
      () {
        final matrix = MMatrix4.translationValues(1, 2, 3);

        matrix.setRotationX(math.pi / 2);

        expectMatrix4(
          matrix,
          [1, 0, 0, 0],
          [0, 0, 1, 0],
          [0, -1, 0, 0],
          [1, 2, 3, 1],
        );
      },
    );

    test(
      'sets a rotation around the y axis in place, keeping the translation',
      () {
        final matrix = MMatrix4.translationValues(1, 2, 3);

        matrix.setRotationY(math.pi / 2);

        expectMatrix4(
          matrix,
          [0, 0, -1, 0],
          [0, 1, 0, 0],
          [1, 0, 0, 0],
          [1, 2, 3, 1],
        );
      },
    );

    test(
      'sets a rotation around the z axis in place, keeping the translation',
      () {
        final matrix = MMatrix4.translationValues(1, 2, 3);

        matrix.setRotationZ(math.pi / 2);

        expectMatrix4(
          matrix,
          [0, 1, 0, 0],
          [-1, 0, 0, 0],
          [0, 0, 1, 0],
          [1, 2, 3, 1],
        );
      },
    );

    test('sets the translation from a vector in place', () {
      final matrix = MMatrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      matrix.setTranslation(Vector3(1, 2, 3));

      expectMatrix4(
        matrix,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [1, 2, 3, 16],
      );
    });

    test('sets the translation from values in place', () {
      final matrix = MMatrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      matrix.setTranslationRaw(1, 2, 3);

      expectMatrix4(
        matrix,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [1, 2, 3, 16],
      );
    });

    test('sets the rotation in place, keeping the translation', () {
      final matrix = MMatrix4.translationValues(1, 2, 3);

      matrix.setRotation(Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9));

      expectMatrix4(
        matrix,
        [1, 2, 3, 0],
        [4, 5, 6, 0],
        [7, 8, 9, 0],
        [1, 2, 3, 1],
      );
    });

    test('transposes in place', () {
      final matrix = MMatrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      matrix.transpose();

      expectMatrix4(
        matrix,
        [1, 5, 9, 13],
        [2, 6, 10, 14],
        [3, 7, 11, 15],
        [4, 8, 12, 16],
      );
    });

    test('computes the absolute value of every entry in place', () {
      final matrix = MMatrix4(
        // dart format off
        1,  -2,  3,  -4,
        5,  -6,  7,  -8,
        9,  -10, 11, -12,
        13, -14, 15, -16,
        // dart format on
      );

      matrix.absolute();

      expectMatrix4(
        matrix,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
      );
    });

    test('scales every entry in place', () {
      final matrix = MMatrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      matrix.scale(2);

      expectMatrix4(
        matrix,
        [2, 4, 6, 8],
        [10, 12, 14, 16],
        [18, 20, 22, 24],
        [26, 28, 30, 32],
      );
    });

    test('scales by a vector in place', () {
      final matrix = MMatrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      matrix.scaleByVector3(Vector3(2, 3, 4));

      expectMatrix4(
        matrix,
        [2, 4, 6, 8],
        [15, 18, 21, 24],
        [36, 40, 44, 48],
        [13, 14, 15, 16],
      );
    });

    test('translates in place', () {
      final matrix = MMatrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      matrix.translate(Vector3(1, 1, 1));

      expectMatrix4(
        matrix,
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [28, 32, 36, 40],
      );
    });

    test('left-translates in place', () {
      final matrix = MMatrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      matrix.leftTranslate(Vector3(1, 1, 1));

      expectMatrix4(
        matrix,
        [5, 6, 7, 4],
        [13, 14, 15, 8],
        [21, 22, 23, 12],
        [29, 30, 31, 16],
      );
    });

    test('rotates around the x axis in place', () {
      final matrix = MMatrix4.identity();

      matrix.rotateX(math.pi / 2);

      expectMatrix4(
        matrix,
        [1, 0, 0, 0],
        [0, 0, 1, 0],
        [0, -1, 0, 0],
        [0, 0, 0, 1],
      );
    });

    test('rotates around the y axis in place', () {
      final matrix = MMatrix4.identity();

      matrix.rotateY(math.pi / 2);

      expectMatrix4(
        matrix,
        [0, 0, -1, 0],
        [0, 1, 0, 0],
        [1, 0, 0, 0],
        [0, 0, 0, 1],
      );
    });

    test('rotates around the z axis in place, keeping the translation', () {
      final matrix = MMatrix4.translationValues(1, 2, 3);

      matrix.rotateZ(math.pi / 2);

      expectMatrix4(
        matrix,
        [0, 1, 0, 0],
        [-1, 0, 0, 0],
        [0, 0, 1, 0],
        [1, 2, 3, 1],
      );
    });

    test('adds in place', () {
      final matrix = MMatrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      matrix.add(
        Matrix4(
          // dart format off
          16, 15, 14, 13,
          12, 11, 10, 9,
          8,  7,  6,  5,
          4,  3,  2,  1,
          // dart format on
        ),
      );

      expectMatrix4(
        matrix,
        [17, 17, 17, 17],
        [17, 17, 17, 17],
        [17, 17, 17, 17],
        [17, 17, 17, 17],
      );
    });

    test('subtracts in place', () {
      final matrix = MMatrix4(
        // dart format off
        16, 15, 14, 13,
        12, 11, 10, 9,
        8,  7,  6,  5,
        4,  3,  2,  1,
        // dart format on
      );

      matrix.subtract(
        Matrix4(
          // dart format off
          1,  2,  3,  4,
          5,  6,  7,  8,
          9,  10, 11, 12,
          13, 14, 15, 16,
          // dart format on
        ),
      );

      expectMatrix4(
        matrix,
        [15, 13, 11, 9],
        [7, 5, 3, 1],
        [-1, -3, -5, -7],
        [-9, -11, -13, -15],
      );
    });

    test('negates in place', () {
      final matrix = MMatrix4(
        // dart format off
        1,  -2,  3,  -4,
        5,  -6,  7,  -8,
        9,  -10, 11, -12,
        13, -14, 15, -16,
        // dart format on
      );

      matrix.negate();

      expectMatrix4(
        matrix,
        [-1, 2, -3, 4],
        [-5, 6, -7, 8],
        [-9, 10, -11, 12],
        [-13, 14, -15, 16],
      );
    });

    test('multiplies in place', () {
      final matrix = MMatrix4.translationValues(5, 0, 0);

      matrix.multiply(Matrix4.diagonal3Values(2, 2, 2));

      expectMatrix4(
        matrix,
        [2, 0, 0, 0],
        [0, 2, 0, 0],
        [0, 0, 2, 0],
        [5, 0, 0, 1],
      );
    });

    test('multiplies by itself safely', () {
      final matrix = MMatrix4.rotationZ(math.pi / 2);

      matrix.multiply(matrix);

      expectMatrix4(
        matrix,
        [-1, 0, 0, 0],
        [0, -1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1],
      );
    });

    test('premultiplies in place', () {
      final matrix = MMatrix4.diagonal3Values(2, 2, 2);

      matrix.premultiply(Matrix4.translationValues(5, 0, 0));

      expectMatrix4(
        matrix,
        [2, 0, 0, 0],
        [0, 2, 0, 0],
        [0, 0, 2, 0],
        [5, 0, 0, 1],
      );
    });

    test('premultiplies by itself safely', () {
      final matrix = MMatrix4.rotationZ(math.pi / 2);

      matrix.premultiply(matrix);

      expectMatrix4(
        matrix,
        [-1, 0, 0, 0],
        [0, -1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1],
      );
    });

    test('transpose-multiplies an orthogonal matrix back to the identity', () {
      final matrix = MMatrix4.rotationZ(math.pi / 3);
      final other = MMatrix4.copy(matrix);

      matrix.transposeMultiply(other);

      expectMatrix4(
        matrix,
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1],
      );
    });

    test(
      'multiplies by a transposed orthogonal matrix back to the identity',
      () {
        final matrix = MMatrix4.rotationZ(math.pi / 4);
        final other = MMatrix4.copy(matrix);

        matrix.multiplyTranspose(other);

        expectMatrix4(
          matrix,
          [1, 0, 0, 0],
          [0, 1, 0, 0],
          [0, 0, 1, 0],
          [0, 0, 0, 1],
        );
      },
    );

    test('computes the scaled adjugate in place', () {
      final matrix = MMatrix4(
        // dart format off
        2, 0, 0, 0,
        0, 4, 0, 0,
        0, 0, 8, 0,
        1, 2, 3, 1,
        // dart format on
      );

      matrix.scaleAdjoint(1);

      expectMatrix4(
        matrix,
        [32, 0, 0, 0],
        [0, 16, 0, 0],
        [0, 0, 8, 0],
        [-32, -32, -24, 64],
      );
    });

    test('inverts in place and returns the determinant', () {
      final matrix = MMatrix4(
        // dart format off
        2, 0, 0, 0,
        0, 4, 0, 0,
        0, 0, 8, 0,
        1, 2, 3, 1,
        // dart format on
      );

      final det = matrix.invert();

      expect(det, 64);
      expectMatrix4(
        matrix,
        [0.5, 0, 0, 0],
        [0, 0.25, 0, 0],
        [0, 0, 0.125, 0],
        [-0.5, -0.5, -0.375, 1],
      );
    });

    test('sets itself to the inverse, returning the determinant', () {
      final matrix = MMatrix4.zero();
      final other = Matrix4(
        // dart format off
        2, 0, 0, 0,
        0, 4, 0, 0,
        0, 0, 8, 0,
        1, 2, 3, 1,
        // dart format on
      );

      final det = matrix.copyInverse(other);

      expect(det, 64);
      expectMatrix4(
        matrix,
        [0.5, 0, 0, 0],
        [0, 0.25, 0, 0],
        [0, 0, 0.125, 0],
        [-0.5, -0.5, -0.375, 1],
      );

      expectMatrix4(
        other,
        [2, 0, 0, 0],
        [0, 4, 0, 0],
        [0, 0, 8, 0],
        [1, 2, 3, 1],
      );
    });

    test('copies the source into itself when the determinant is zero', () {
      final matrix = MMatrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      final singular = Matrix4.zero;
      final det = matrix.copyInverse(singular);

      expect(det, 0);
      expectMatrix4(
        matrix,
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      );
    });
  });
}
