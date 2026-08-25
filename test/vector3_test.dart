import 'dart:math' as math;

import 'package:ivector_math/ivector_math.dart';
import 'package:test/test.dart';

import 'support/matchers.dart';

void main() {
  group('Vector3', () {
    test('creates a zero vector', () {
      expectVector3(Vector3.zero, 0, 0, 0);
    });

    test('reuses a canonical zero instance', () {
      expect(identical(Vector3.zero, Vector3.zero), isTrue);
    });

    test('creates an infinity vector', () {
      expectVector3(
        Vector3.infinity,
        double.infinity,
        double.infinity,
        double.infinity,
      );

      expect(Vector3.infinity.isInfinite, isTrue);
    });

    test('reuses a canonical infinity instance', () {
      expect(identical(Vector3.infinity, Vector3.infinity), isTrue);
    });

    test('creates a vector from doubles', () {
      expectVector3(Vector3(1.5, -2.5, 3.5), 1.5, -2.5, 3.5);
    });

    test('supports a const primary constructor', () {
      const vector = Vector3(1.5, -2.5, 3.5);
      const zero = Vector3.zero;

      expectVector3(vector, 1.5, -2.5, 3.5);
      expectVector3(zero, 0, 0, 0);
    });

    test('casts numeric values to doubles', () {
      expectVector3(Vector3.cast(1, 2.5, 3), 1, 2.5, 3);
    });

    test('copies without sharing storage', () {
      final original = MVector3(1, 2, 3);
      final copy = Vector3.copy(original);

      original.x = 9;

      expectVector3(copy, 1, 2, 3);
    });

    test('fills all components with one value', () {
      expectVector3(Vector3.all(2.5), 2.5, 2.5, 2.5);
    });

    test('reads components by index and name', () {
      final vector = Vector3(1, 2, 3);

      expect(vector[0], 1);
      expect(vector[1], 2);
      expect(vector[2], 3);
      expect(vector.x, 1);
      expect(vector.y, 2);
      expect(vector.z, 3);
      expect(() => vector[3], throwsRangeError);
    });

    test('clones without sharing storage', () {
      final vector = Vector3(1, 2, 3);
      final clone = vector.clone();

      expectVector3(clone, 1, 2, 3);
      expect(clone, isNot(same(vector)));
    });

    test('detects zero vectors', () {
      expect(Vector3.zero.isZero, isTrue);
      expect(Vector3(-0.0, 0, 0).isZero, isTrue);
      expect(Vector3(0, 0, 1).isZero, isFalse);
    });

    test('detects infinite components', () {
      expect(Vector3(double.infinity, 0, 0).isInfinite, isTrue);
      expect(Vector3(0, 0, double.negativeInfinity).isInfinite, isTrue);
      expect(Vector3(1, 2, 3).isInfinite, isFalse);
    });

    test('detects NaN components', () {
      expect(Vector3(double.nan, 0, 0).isNaN, isTrue);
      expect(Vector3(0, 0, double.nan).isNaN, isTrue);
      expect(Vector3(1, 2, 3).isNaN, isFalse);
    });

    test('computes length and squared length', () {
      final vector = Vector3(2, 3, 6);

      expect(vector.length, 7);
      expect(vector.length2, 49);
    });

    test('computes distance and squared distance', () {
      final first = Vector3(1, 2, 3);
      final second = Vector3(3, 5, 9);

      expect(first.distance(second), 7);
      expect(first.distance2(second), 49);
      expect(second.distance(first), 7);
      expect(second.distance2(first), 49);
    });

    test('computes absolute and relative error against a correct vector', () {
      final correct = Vector3(2, 3, 6);
      final approximate = Vector3(2, 3, 13);

      expect(approximate.absoluteError(correct), 7);
      expect(approximate.relativeError(correct), closeTo(1, 0.0000001));
    });

    test('computes the unsigned angle between vectors', () {
      final right = Vector3(1, 0, 0);
      final up = Vector3(0, 1, 0);
      final left = Vector3(-1, 0, 0);

      expect(right.angleTo(right), 0);
      expect(right.angleTo(up), closeTo(math.pi / 2, 0.0000001));
      expect(right.angleTo(left), closeTo(math.pi, 0.0000001));
    });

    test('computes the signed angle between vectors around a normal', () {
      final right = Vector3(1, 0, 0);
      final up = Vector3(0, 1, 0);
      final axis = Vector3(0, 0, 1);

      expect(right.angleToSigned(right, axis), 0);
      expect(right.angleToSigned(up, axis), closeTo(math.pi / 2, 0.0000001));
      expect(up.angleToSigned(right, axis), closeTo(-math.pi / 2, 0.0000001));
      expect(right.angleToSigned(up, -axis), closeTo(-math.pi / 2, 0.0000001));
    });

    test('creates a normalized copy', () {
      final vector = Vector3(2, 3, 6);

      final normalized = vector.normalized();

      expect(normalized.x, closeTo(2 / 7, 0.0000001));
      expect(normalized.y, closeTo(3 / 7, 0.0000001));
      expect(normalized.z, closeTo(6 / 7, 0.0000001));
    });

    test('normalizes a zero vector to a separate zero vector', () {
      final vector = Vector3.zero;

      final normalized = vector.normalized();

      expect(normalized, isNot(same(vector)));
      expectVector3(normalized, 0, 0, 0);
    });

    test('creates floored, ceiled, rounded, and round-to-zero copies', () {
      final vector = Vector3(1.9, -1.1, 2.5);

      expectVector3(vector.floored(), 1, -2, 2);
      expectVector3(vector.ceiled(), 2, -1, 3);
      expectVector3(Vector3(1.6, -1.6, 2.5).rounded(), 2, -2, 3);
      expectVector3(Vector3(1.9, -1.9, 2.9).roundedToZero(), 1, -1, 2);
    });

    test('computes the dot product', () {
      final first = Vector3(2, 3, 4);
      final second = Vector3(5, 6, 7);

      expect(first.dot(second), 56);
    });

    test('computes the cross product', () {
      final first = Vector3(2, 3, 4);
      final second = Vector3(5, 6, 7);

      expectVector3(first.cross(second), -3, 6, -3);
      expectVector3(second.cross(first), 3, -6, 3);
      expectVector3(Vector3(1, 0, 0).cross(Vector3(0, 1, 0)), 0, 0, 1);
    });

    test('creates a scaled copy', () {
      final vector = Vector3(2, 3, 4);

      final scaled = vector.scaled(4);

      expectVector3(scaled, 8, 12, 16);
    });

    test('creates a component-wise multiplied copy', () {
      final vector = Vector3(2, 3, 4);
      final other = Vector3(5, 6, 7);

      final multiplied = vector.multiplied(other);

      expectVector3(multiplied, 10, 18, 28);
    });

    test('creates a component-wise divided copy', () {
      final vector = Vector3(8, 15, 24);
      final other = Vector3(4, 5, 6);

      final divided = vector.divided(other);

      expectVector3(divided, 2, 3, 4);
    });

    test('creates a reflected copy', () {
      final vector = Vector3(1, -1, 2);
      final normal = Vector3(0, 1, 0);

      final reflected = vector.reflected(normal);

      expectVector3(reflected, 1, 1, 2);
    });

    test('creates a copy clamped to one range on all components', () {
      final vector = Vector3(-2, 10, 7);
      final range = Vector2(1, 5);

      final clamped = vector.clamped(range);

      expectVector3(clamped, 1, 5, 5);
    });

    test('creates a copy clamped to a range on just the x component', () {
      final vector = Vector3(-2, 10, 7);
      final range = Vector2(1, 5);

      final clamped = vector.clampedX(range);

      expectVector3(clamped, 1, 10, 7);
    });

    test('creates a copy clamped to a range on just the y component', () {
      final vector = Vector3(-2, 10, 7);
      final range = Vector2(1, 5);

      final clamped = vector.clampedY(range);

      expectVector3(clamped, -2, 5, 7);
    });

    test('creates a copy clamped to a range on just the z component', () {
      final vector = Vector3(-2, 10, 7);
      final range = Vector2(1, 5);

      final clamped = vector.clampedZ(range);

      expectVector3(clamped, -2, 10, 5);
    });

    test('creates copies clamped per-axis to different ranges', () {
      final vector = Vector3(0.5, 10, -3);
      final xRange = Vector2(-1, 1);
      final yRange = Vector2(0, 5);
      final zRange = Vector2(0, 2);

      final clamped = vector.clampedX(xRange).clampedY(yRange).clampedZ(zRange);

      expectVector3(clamped, 0.5, 5, 0);
    });

    test('creates a copy clamped between scalar bounds on all components', () {
      final vector = Vector3(-2, 10, 7);

      final clamped = vector.clampedTo(-1, 5);

      expectVector3(clamped, -1, 5, 5);
    });

    test(
      'creates a copy clamped between scalar bounds on just the x component',
      () {
        final vector = Vector3(-2, 10, 7);

        final clamped = vector.clampedToX(-1, 5);

        expectVector3(clamped, -1, 10, 7);
      },
    );

    test(
      'creates a copy clamped between scalar bounds on just the y component',
      () {
        final vector = Vector3(-2, 10, 7);

        final clamped = vector.clampedToY(-1, 5);

        expectVector3(clamped, -2, 5, 7);
      },
    );

    test(
      'creates a copy clamped between scalar bounds on just the z component',
      () {
        final vector = Vector3(-2, 10, 7);

        final clamped = vector.clampedToZ(-1, 5);

        expectVector3(clamped, -2, 10, 5);
      },
    );

    test('creates a copy clamped between two vector bounds', () {
      final vector = Vector3(-2, 10, 7);
      final min = Vector3(-1, 0, 0);
      final max = Vector3(1, 5, 6);

      final clamped = vector.clampedBetween(min, max);

      expectVector3(clamped, -1, 5, 6);
    });

    test('creates a copy clamped between two vector bounds per axis', () {
      final vector = Vector3(0.5, 10, -3);
      final min = Vector3(-1, 0, 0);
      final max = Vector3(1, 5, 6);

      final clamped = vector.clampedBetween(min, max);

      expectVector3(clamped, 0.5, 5, 0);
    });

    test('takes the component-wise minimum of two vectors', () {
      final a = Vector3(1, 5, 3);
      final b = Vector3(3, 2, 4);

      expectVector3(Vector3.min(a, b), 1, 2, 3);
    });

    test('takes the component-wise maximum of two vectors', () {
      final a = Vector3(1, 5, 3);
      final b = Vector3(3, 2, 4);

      expectVector3(Vector3.max(a, b), 3, 5, 4);
    });

    test('combines mutable vectors without sharing storage', () {
      final a = MVector3(1, 5, 3);
      final b = MVector3(3, 2, 4);

      final minimum = Vector3.min(a, b);
      final maximum = Vector3.max(a, b);
      a.x = 100;

      expectVector3(minimum, 1, 2, 3);
      expectVector3(maximum, 3, 5, 4);
    });

    test('interpolates between two vectors', () {
      final a = Vector3(0, 10, 20);
      final b = Vector3(10, 20, 30);

      expectVector3(Vector3.mix(a, b, 0.25), 2.5, 12.5, 22.5);
      expectVector3(Vector3.mix(a, b, 0), 0, 10, 20);
      expectVector3(Vector3.mix(a, b, 1), 10, 20, 30);
    });

    test('creates a premultiplied copy', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final vector = Vector3(1, 1, 1);

      final premultiplied = vector.premultiplied(matrix);

      expectVector3(premultiplied, 12, 15, 18);
    });

    test('creates a premultiplied copy rotated by a rotation matrix', () {
      final matrix = Matrix3.rotationZ(math.pi / 2);
      final vector = Vector3(1, 0, 0);

      final premultiplied = vector.premultiplied(matrix);

      expect(premultiplied.x, closeTo(0, 0.0000001));
      expect(premultiplied.y, closeTo(1, 0.0000001));
      expect(premultiplied.z, closeTo(0, 0.0000001));
    });

    test('creates a postmultiplied copy', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final vector = Vector3(1, 1, 1);

      final postmultiplied = vector.postmultiplied(matrix);

      expectVector3(postmultiplied, 6, 15, 24);
    });

    test('creates a transformed copy', () {
      final matrix = Matrix4(
        // dart format off
        2,  0,  0,  0,
        0,  3,  0,  0,
        0,  0,  4,  0,
        10, 20, 30, 1,
        // dart format on
      );

      final point = Vector3(1, 1, 1);

      final transformed = point.transformed(matrix);

      expectVector3(transformed, 12, 23, 34);
    });

    test('creates a rotated copy ignoring translation', () {
      final matrix = Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      final vector = Vector3(1, 2, 3);

      final rotated = vector.rotated(matrix);

      expectVector3(rotated, 38, 44, 50);
    });

    test('negates', () {
      final vector = Vector3(1, -2, 3);

      expectVector3(-vector, -1, 2, -3);
    });

    test('performs arithmetic', () {
      final first = Vector3(8, 6, 4);
      final second = Vector3(2, 3, 1);

      expectVector3(first + second, 10, 9, 5);
      expectVector3(first - second, 6, 3, 3);
      expectVector3(first * 2.5, 20, 15, 10);
      expectVector3(first / 2, 4, 3, 2);
    });

    test('compares and hashes by component values across both forms', () {
      final immutable = Vector3(1, 2, 3);
      final mutable = MVector3(1, 2, 3);

      expect(immutable, mutable);
      expect(immutable.hashCode, mutable.hashCode);
      expect(immutable, isNot(Vector3(3, 2, 1)));
      expect(immutable, isNot(Object()));
    });

    test('formats all components', () {
      expect(Vector3(1, -2, 3).toString(), '(1.0, -2.0, 3.0)');
    });
  });

  group('MVector3', () {
    test('creates a zero vector', () {
      expectVector3(MVector3.zero(), 0, 0, 0);
    });

    test('creates a vector from doubles', () {
      expectVector3(MVector3(1.5, -2.5, 3.5), 1.5, -2.5, 3.5);
    });

    test('casts numeric values to doubles', () {
      expectVector3(MVector3.cast(1, 2.5, 3), 1, 2.5, 3);
    });

    test('converts between immutable and mutable forms via copy', () {
      final immutable = Vector3(1, 2, 3);
      final mutable = MVector3.copy(immutable);

      mutable.x = 4;
      expectVector3(immutable, 1, 2, 3);
      expectVector3(mutable, 4, 2, 3);

      final frozen = Vector3.copy(mutable);
      mutable.x = 99;

      expectVector3(frozen, 4, 2, 3);
    });

    test('fills all components with one value', () {
      expectVector3(MVector3.all(2.5), 2.5, 2.5, 2.5);
    });

    test('chains mutations via cascades', () {
      final vector = MVector3(1, 2, 3);

      vector
        ..add(Vector3(3, 4, 5))
        ..scale(2);

      expectVector3(vector, 8, 12, 16);
    });

    test('writes components by index and name', () {
      final vector = MVector3.zero();

      vector[0] = 1;
      vector[1] = 2;
      vector[2] = 3;

      expectVector3(vector, 1, 2, 3);
      expect(() => vector[3] = 4, throwsRangeError);

      vector.x = 4;
      vector.y = 5;
      vector.z = 6;

      expectVector3(vector, 4, 5, 6);
    });

    test('clones without sharing storage', () {
      final vector = MVector3(1, 2, 3);
      final clone = vector.clone();

      expectVector3(clone, 1, 2, 3);
      expect(clone, isNot(same(vector)));

      clone.x = 99;

      expectVector3(vector, 1, 2, 3);
    });

    test('reads through without changing the source', () {
      final vector = MVector3(2, 3, 6);

      expect(vector.length, 7);
      expect(vector.dot(Vector3(1, 1, 1)), 11);
      expectVector3(vector.scaled(2), 4, 6, 12);
      expectVector3(-vector, -2, -3, -6);
      expectVector3(vector, 2, 3, 6);
    });

    test('sets all components from another vector', () {
      final vector = MVector3.zero();

      vector.setFrom(Vector3(1, 2, 3));

      expectVector3(vector, 1, 2, 3);
    });

    test('sets all components from values', () {
      final vector = MVector3.zero();

      vector.setValues(1, 2, 3);

      expectVector3(vector, 1, 2, 3);
    });

    test('zeros all components in place', () {
      final vector = MVector3(1, 2, 3);

      vector.setZero();

      expectVector3(vector, 0, 0, 0);
    });

    test('splats one value across all components', () {
      final vector = MVector3.zero();

      vector.splat(2.5);

      expectVector3(vector, 2.5, 2.5, 2.5);
    });

    test('negates all components in place', () {
      final vector = MVector3(1, -2, 3);

      vector.negate();

      expectVector3(vector, -1, 2, -3);
    });

    test('takes the absolute value of all components in place', () {
      final vector = MVector3(-1.5, 2.5, -3.5);

      vector.absolute();

      expectVector3(vector, 1.5, 2.5, 3.5);
    });

    test('clamps all components to one range in place', () {
      final vector = MVector3(-2, 10, 7);

      vector.clamp(Vector2(1, 5));

      expectVector3(vector, 1, 5, 5);
    });

    test('clamps just the x component to a range in place', () {
      final vector = MVector3(-2, 10, 7);

      vector.clampX(Vector2(1, 5));

      expectVector3(vector, 1, 10, 7);
    });

    test('clamps just the y component to a range in place', () {
      final vector = MVector3(-2, 10, 7);

      vector.clampY(Vector2(1, 5));

      expectVector3(vector, -2, 5, 7);
    });

    test('clamps just the z component to a range in place', () {
      final vector = MVector3(-2, 10, 7);

      vector.clampZ(Vector2(1, 5));

      expectVector3(vector, -2, 10, 5);
    });

    test('clamps each axis to a different range in place', () {
      final vector = MVector3(0.5, 10, -3);
      final xRange = Vector2(-1, 1);
      final yRange = Vector2(0, 5);
      final zRange = Vector2(0, 2);

      vector
        ..clampX(xRange)
        ..clampY(yRange)
        ..clampZ(zRange);

      expectVector3(vector, 0.5, 5, 0);
    });

    test('clamps all components between scalar bounds in place', () {
      final vector = MVector3(-2, 10, 7);

      vector.clampTo(-1, 5);

      expectVector3(vector, -1, 5, 5);
    });

    test('clamps just the x component between scalar bounds in place', () {
      final vector = MVector3(-2, 10, 7);

      vector.clampToX(-1, 5);

      expectVector3(vector, -1, 10, 7);
    });

    test('clamps just the y component between scalar bounds in place', () {
      final vector = MVector3(-2, 10, 7);

      vector.clampToY(-1, 5);

      expectVector3(vector, -2, 5, 7);
    });

    test('clamps just the z component between scalar bounds in place', () {
      final vector = MVector3(-2, 10, 7);

      vector.clampToZ(-1, 5);

      expectVector3(vector, -2, 10, 5);
    });

    test('clamps all components between two vector bounds in place', () {
      final vector = MVector3(-2, 10, 7);

      vector.clampBetween(Vector3(-1, 0, 0), Vector3(1, 5, 6));

      expectVector3(vector, -1, 5, 6);
    });

    test('clamps each axis between two vector bounds in place', () {
      final vector = MVector3(0.5, 10, -3);

      vector.clampBetween(Vector3(-1, 0, 0), Vector3(1, 5, 6));

      expectVector3(vector, 0.5, 5, 0);
    });

    test('floors all components in place', () {
      final vector = MVector3(1.9, -1.1, 2.5);

      vector.floor();

      expectVector3(vector, 1, -2, 2);
    });

    test('ceils all components in place', () {
      final vector = MVector3(1.1, -1.9, 2.5);

      vector.ceil();

      expectVector3(vector, 2, -1, 3);
    });

    test('rounds all components in place', () {
      final vector = MVector3(1.6, -1.6, 2.5);

      vector.round();

      expectVector3(vector, 2, -2, 3);
    });

    test('rounds all components toward zero in place', () {
      final vector = MVector3(1.9, -1.9, 2.9);

      vector.roundToZero();

      expectVector3(vector, 1, -1, 2);
    });

    test('normalizes in place and returns the previous length', () {
      final vector = MVector3(2, 3, 6);

      final length = vector.normalize();

      expect(length, 7);
      expect(vector.x, closeTo(2 / 7, 0.0000001));
      expect(vector.y, closeTo(3 / 7, 0.0000001));
      expect(vector.z, closeTo(6 / 7, 0.0000001));
    });

    test('leaves a zero vector unchanged when normalized in place', () {
      final vector = MVector3.zero();

      final length = vector.normalize();

      expect(length, 0);
      expectVector3(vector, 0, 0, 0);
    });

    test('adds a vector in place', () {
      final vector = MVector3(1, 2, 3);

      vector.add(Vector3(3, 4, 5));

      expectVector3(vector, 4, 6, 8);
    });

    test('subtracts a vector in place', () {
      final vector = MVector3(5, 7, 9);

      vector.subtract(Vector3(2, 3, 4));

      expectVector3(vector, 3, 4, 5);
    });

    test('scales all components by one value in place', () {
      final vector = MVector3(2, 3, 4);

      vector.scale(4);

      expectVector3(vector, 8, 12, 16);
    });

    test('multiplies by a vector in place', () {
      final vector = MVector3(2, 3, 4);

      vector.multiply(Vector3(5, 6, 7));

      expectVector3(vector, 10, 18, 28);
    });

    test('divides by a vector in place', () {
      final vector = MVector3(8, 15, 24);

      vector.divide(Vector3(4, 5, 6));

      expectVector3(vector, 2, 3, 4);
    });

    test('sets to the component-wise maximum in place', () {
      final vector = MVector3(2, 5, 3);

      vector.max(Vector3(4, 3, 4));

      expectVector3(vector, 4, 5, 4);
    });

    test('sets to the component-wise minimum in place', () {
      final vector = MVector3(2, 5, 3);

      vector.min(Vector3(4, 3, 4));

      expectVector3(vector, 2, 3, 3);
    });

    test('interpolates towards a vector in place', () {
      final vector = MVector3(0, 10, 20);

      vector.mix(Vector3(10, 20, 30), 0.25);

      expectVector3(vector, 2.5, 12.5, 22.5);
    });

    test('adds a scaled vector in place', () {
      final vector = MVector3(1, 2, 3);

      vector.addScaled(Vector3(3, 4, 5), 2);

      expectVector3(vector, 7, 10, 13);
    });

    test('reflects in place', () {
      final vector = MVector3(1, -1, 2);
      final normal = Vector3(0, 1, 0);

      vector.reflect(normal);

      expectVector3(vector, 1, 1, 2);
    });

    test('premultiplies by a matrix in place', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final vector = MVector3(1, 1, 1);

      vector.premultiply(matrix);

      expectVector3(vector, 12, 15, 18);
    });

    test('postmultiplies by a matrix in place', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
      final vector = MVector3(1, 1, 1);

      vector.postmultiply(matrix);

      expectVector3(vector, 6, 15, 24);
    });

    test('transforms a point in place', () {
      final matrix = Matrix4(
        // dart format off
        2,  0,  0,  0,
        0,  3,  0,  0,
        0,  0,  4,  0,
        10, 20, 30, 1,
        // dart format on
      );

      final point = MVector3(1, 1, 1);

      point.transform(matrix);

      expectVector3(point, 12, 23, 34);
    });

    test('rotates in place ignoring translation', () {
      final matrix = Matrix4(
        // dart format off
        1,  2,  3,  4,
        5,  6,  7,  8,
        9,  10, 11, 12,
        13, 14, 15, 16,
        // dart format on
      );

      final vector = MVector3(1, 2, 3);

      vector.rotate(matrix);

      expectVector3(vector, 38, 44, 50);
    });
  });
}
