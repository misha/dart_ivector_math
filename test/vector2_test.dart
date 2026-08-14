import 'dart:math';

import 'package:ivector_math/ivector_math.dart';
import 'package:test/test.dart';

import 'support/matchers.dart';

void main() {
  group('Vector2', () {
    test('creates a zero vector', () {
      expectVector2(Vector2.zero, 0, 0);
    });

    test('reuses a canonical zero instance', () {
      expect(identical(Vector2.zero, Vector2.zero), isTrue);
    });

    test('creates a vector from doubles', () {
      expectVector2(Vector2(1.5, -2.5), 1.5, -2.5);
    });

    test('is const-constructible', () {
      const vector = Vector2(1.5, -2.5);
      const zero = Vector2.zero;

      expectVector2(vector, 1.5, -2.5);
      expectVector2(zero, 0, 0);
    });

    test('casts numeric values to doubles', () {
      expectVector2(Vector2.cast(1, 2.5), 1, 2.5);
    });

    test('copies without sharing storage', () {
      final original = MVector2(1, 2);
      final copy = Vector2.copy(original);

      original.x = 3;

      expectVector2(copy, 1, 2);
    });

    test('fills both components with one value', () {
      expectVector2(Vector2.all(2.5), 2.5, 2.5);
    });

    test('reads components by index and name', () {
      final vector = Vector2(1, 2);

      expect(vector[0], 1);
      expect(vector[1], 2);
      expect(vector.x, 1);
      expect(vector.y, 2);
      expect(() => vector[2], throwsRangeError);
    });

    test('clones without sharing storage', () {
      final vector = Vector2(1, 2);
      final clone = vector.clone();

      expectVector2(clone, 1, 2);
      expect(clone, isNot(same(vector)));
    });

    test('detects zero vectors', () {
      expect(Vector2.zero.isZero, isTrue);
      expect(Vector2(-0.0, 0).isZero, isTrue);
      expect(Vector2(0, 1).isZero, isFalse);
    });

    test('detects infinite components', () {
      expect(Vector2(double.infinity, 0).isInfinite, isTrue);
      expect(Vector2(0, double.negativeInfinity).isInfinite, isTrue);
      expect(Vector2(1, 2).isInfinite, isFalse);
    });

    test('detects NaN components', () {
      expect(Vector2(double.nan, 0).isNaN, isTrue);
      expect(Vector2(0, double.nan).isNaN, isTrue);
      expect(Vector2(1, 2).isNaN, isFalse);
    });

    test('computes length and squared length', () {
      final vector = Vector2(3, 4);

      expect(vector.length, 5);
      expect(vector.length2, 25);
    });

    test('computes distance and squared distance', () {
      final first = Vector2(1, 2);
      final second = Vector2(4, 6);

      expect(first.distance(second), 5);
      expect(first.distance2(second), 25);
      expect(second.distance(first), 5);
      expect(second.distance2(first), 25);
    });

    test('computes the unsigned angle between vectors', () {
      final right = Vector2(1, 0);
      final up = Vector2(0, 1);
      final left = Vector2(-1, 0);

      expect(right.angleTo(right), 0);
      expect(right.angleTo(up), closeTo(pi / 2, 0.0000001));
      expect(right.angleTo(left), closeTo(pi, 0.0000001));
    });

    test('computes the signed angle between vectors', () {
      final right = Vector2(1, 0);
      final up = Vector2(0, 1);

      expect(right.angleToSigned(right), 0);
      expect(right.angleToSigned(up), closeTo(pi / 2, 0.0000001));
      expect(up.angleToSigned(right), closeTo(-pi / 2, 0.0000001));
    });

    test('creates a normalized copy', () {
      final vector = Vector2(3, 4);

      final normalized = vector.normalized();

      expect(normalized.x, closeTo(0.6, 0.0000001));
      expect(normalized.y, closeTo(0.8, 0.0000001));
    });

    test('normalizes a zero vector to a separate zero vector', () {
      final vector = Vector2.zero;

      final normalized = vector.normalized();

      expect(normalized, isNot(same(vector)));
      expectVector2(normalized, 0, 0);
    });

    test('creates floored, ceiled, rounded, and round-to-zero copies', () {
      final vector = Vector2(1.9, -1.1);

      expectVector2(vector.floored(), 1, -2);
      expectVector2(vector.ceiled(), 2, -1);
      expectVector2(Vector2(1.6, -1.6).rounded(), 2, -2);
      expectVector2(Vector2(1.9, -1.9).roundedToZero(), 1, -1);
    });

    test('computes dot and cross products', () {
      final first = Vector2(2, 3);
      final second = Vector2(4, 5);

      expect(first.dot(second), 23);
      expect(first.cross(second), -2);
      expect(second.cross(first), 2);
    });

    test('creates a scaled copy', () {
      final vector = Vector2(2, 3);

      final scaled = vector.scaled(4);

      expectVector2(scaled, 8, 12);
    });

    test('creates a component-wise multiplied copy', () {
      final vector = Vector2(2, 3);
      final other = Vector2(4, 5);

      final multiplied = vector.multiplied(other);

      expectVector2(multiplied, 8, 15);
    });

    test('creates a reflected copy', () {
      final vector = Vector2(1, -1);
      final normal = Vector2(0, 1);

      final reflected = vector.reflected(normal);

      expectVector2(reflected, 1, 1);
    });

    test('creates a copy clamped to one range on both components', () {
      final vector = Vector2(-2, 10);
      final range = Vector2(1, 5);

      final clamped = vector.clamped(range);

      expectVector2(clamped, 1, 5);
    });

    test('creates a copy clamped to a range on just the x component', () {
      final vector = Vector2(-2, 10);
      final range = Vector2(1, 5);

      final clamped = vector.clampedX(range);

      expectVector2(clamped, 1, 10);
    });

    test('creates a copy clamped to a range on just the y component', () {
      final vector = Vector2(-2, 10);
      final range = Vector2(1, 5);

      final clamped = vector.clampedY(range);

      expectVector2(clamped, -2, 5);
    });

    test('creates copies clamped per-axis to different ranges', () {
      final vector = Vector2(0.5, 10);
      final xRange = Vector2(-1, 1);
      final yRange = Vector2(0, 5);

      final clamped = vector.clampedX(xRange).clampedY(yRange);

      expectVector2(clamped, 0.5, 5);
    });

    test('creates a copy clamped between scalar bounds on both components', () {
      final vector = Vector2(-2, 10);

      final clamped = vector.clampedTo(-1, 5);

      expectVector2(clamped, -1, 5);
    });

    test(
      'creates a copy clamped between scalar bounds on just the x component',
      () {
        final vector = Vector2(-2, 10);

        final clamped = vector.clampedToX(-1, 5);

        expectVector2(clamped, -1, 10);
      },
    );

    test(
      'creates a copy clamped between scalar bounds on just the y component',
      () {
        final vector = Vector2(-2, 10);

        final clamped = vector.clampedToY(-1, 5);

        expectVector2(clamped, -2, 5);
      },
    );

    test('creates a transformed copy', () {
      final matrix = Matrix3(2, 0, 0, 0, 3, 0, 10, 20, 1);
      final point = Vector2(1, 1);

      final transformed = point.transformed(matrix);

      expectVector2(transformed, 12, 23);
    });

    test('negates', () {
      final vector = Vector2(1, -2);

      expectVector2(-vector, -1, 2);
    });

    test('performs arithmetic', () {
      final first = Vector2(8, 6);
      final second = Vector2(2, 3);

      expectVector2(first + second, 10, 9);
      expectVector2(first - second, 6, 3);
      expectVector2(first * 2.5, 20, 15);
      expectVector2(first / 2, 4, 3);
    });

    test('compares and hashes by component values across both forms', () {
      final immutable = Vector2(1, 2);
      final mutable = MVector2(1, 2);

      expect(immutable, mutable);
      expect(immutable.hashCode, mutable.hashCode);
      expect(immutable, isNot(Vector2(2, 1)));
      expect(immutable, isNot(Object()));
    });

    test('formats both components', () {
      expect(Vector2(1, -2).toString(), '(1.0, -2.0)');
    });
  });

  group('MVector2', () {
    test('creates a zero vector', () {
      expectVector2(MVector2.zero(), 0, 0);
    });

    test('creates a vector from doubles', () {
      expectVector2(MVector2(1.5, -2.5), 1.5, -2.5);
    });

    test('casts numeric values to doubles', () {
      expectVector2(MVector2.cast(1, 2.5), 1, 2.5);
    });

    test('converts between immutable and mutable forms via copy', () {
      final immutable = Vector2(1, 2);
      final mutable = MVector2.copy(immutable);

      mutable.x = 3;
      expectVector2(immutable, 1, 2);
      expectVector2(mutable, 3, 2);

      final frozen = Vector2.copy(mutable);
      mutable.x = 99;

      expectVector2(frozen, 3, 2);
    });

    test('fills both components with one value', () {
      expectVector2(MVector2.all(2.5), 2.5, 2.5);
    });

    test('chains mutations via cascades', () {
      final vector = MVector2(1, 2);

      vector
        ..add(Vector2(3, 4))
        ..scale(2);

      expectVector2(vector, 8, 12);
    });

    test('writes components by index and name', () {
      final vector = MVector2.zero();

      vector[0] = 1;
      vector[1] = 2;

      expectVector2(vector, 1, 2);
      expect(() => vector[2] = 4, throwsRangeError);

      vector.x = 3;
      vector.y = 4;

      expectVector2(vector, 3, 4);
    });

    test('clones without sharing storage', () {
      final vector = MVector2(1, 2);
      final clone = vector.clone();

      expectVector2(clone, 1, 2);
      expect(clone, isNot(same(vector)));

      clone.x = 99;

      expectVector2(vector, 1, 2);
    });

    test('sets both components from another vector', () {
      final vector = MVector2.zero();

      vector.setFrom(Vector2(1, 2));

      expectVector2(vector, 1, 2);
    });

    test('splats one value across both components', () {
      final vector = MVector2.zero();

      vector.splat(2.5);

      expectVector2(vector, 2.5, 2.5);
    });

    test('negates both components in place', () {
      final vector = MVector2(1, -2);

      vector.negate();

      expectVector2(vector, -1, 2);
    });

    test('takes the absolute value of both components in place', () {
      final vector = MVector2(-1.5, 2.5);

      vector.absolute();

      expectVector2(vector, 1.5, 2.5);
    });

    test('clamps both components to one range in place', () {
      final vector = MVector2(-2, 10);

      vector.clamp(Vector2(1, 5));

      expectVector2(vector, 1, 5);
    });

    test('clamps just the x component to a range in place', () {
      final vector = MVector2(-2, 10);

      vector.clampX(Vector2(1, 5));

      expectVector2(vector, 1, 10);
    });

    test('clamps just the y component to a range in place', () {
      final vector = MVector2(-2, 10);

      vector.clampY(Vector2(1, 5));

      expectVector2(vector, -2, 5);
    });

    test('clamps each axis to a different range in place', () {
      final vector = MVector2(0.5, 10);
      final xRange = Vector2(-1, 1);
      final yRange = Vector2(0, 5);

      vector
        ..clampX(xRange)
        ..clampY(yRange);

      expectVector2(vector, 0.5, 5);
    });

    test('clamps both components between scalar bounds in place', () {
      final vector = MVector2(-2, 10);

      vector.clampTo(-1, 5);

      expectVector2(vector, -1, 5);
    });

    test('clamps just the x component between scalar bounds in place', () {
      final vector = MVector2(-2, 10);

      vector.clampToX(-1, 5);

      expectVector2(vector, -1, 10);
    });

    test('clamps just the y component between scalar bounds in place', () {
      final vector = MVector2(-2, 10);

      vector.clampToY(-1, 5);

      expectVector2(vector, -2, 5);
    });

    test('floors both components in place', () {
      final vector = MVector2(1.9, -1.1);

      vector.floor();

      expectVector2(vector, 1, -2);
    });

    test('ceils both components in place', () {
      final vector = MVector2(1.1, -1.9);

      vector.ceil();

      expectVector2(vector, 2, -1);
    });

    test('rounds both components in place', () {
      final vector = MVector2(1.6, -1.6);

      vector.round();

      expectVector2(vector, 2, -2);
    });

    test('rounds both components toward zero in place', () {
      final vector = MVector2(1.9, -1.9);

      vector.roundToZero();

      expectVector2(vector, 1, -1);
    });

    test('normalizes in place and returns the previous length', () {
      final vector = MVector2(3, 4);

      final length = vector.normalize();

      expect(length, 5);
      expect(vector.x, closeTo(0.6, 0.0000001));
      expect(vector.y, closeTo(0.8, 0.0000001));
    });

    test('leaves a zero vector unchanged when normalized in place', () {
      final vector = MVector2.zero();

      final length = vector.normalize();

      expect(length, 0);
      expectVector2(vector, 0, 0);
    });

    test('adds a vector in place', () {
      final vector = MVector2(1, 2);

      vector.add(Vector2(3, 4));

      expectVector2(vector, 4, 6);
    });

    test('subtracts a vector in place', () {
      final vector = MVector2(5, 7);

      vector.subtract(Vector2(2, 3));

      expectVector2(vector, 3, 4);
    });

    test('scales both components by one value in place', () {
      final vector = MVector2(2, 3);

      vector.scale(4);

      expectVector2(vector, 8, 12);
    });

    test('multiplies by a vector in place', () {
      final vector = MVector2(2, 3);

      vector.multiply(Vector2(4, 5));

      expectVector2(vector, 8, 15);
    });

    test('sets to the component-wise maximum in place', () {
      final vector = MVector2(2, 5);

      vector.max(Vector2(4, 3));

      expectVector2(vector, 4, 5);
    });

    test('sets to the component-wise minimum in place', () {
      final vector = MVector2(2, 5);

      vector.min(Vector2(4, 3));

      expectVector2(vector, 2, 3);
    });

    test('adds a scaled vector in place', () {
      final vector = MVector2(1, 2);

      vector.addScaled(Vector2(3, 4), 2);

      expectVector2(vector, 7, 10);
    });

    test('reflects in place', () {
      final vector = MVector2(1, -1);
      final normal = Vector2(0, 1);

      vector.reflect(normal);

      expectVector2(vector, 1, 1);
    });

    test('transforms a point in place', () {
      final matrix = Matrix3(2, 0, 0, 0, 3, 0, 10, 20, 1);
      final point = MVector2(1, 1);

      point.transform(matrix);

      expectVector2(point, 12, 23);
    });

    test('rotates a point in place by the absolute rotation of a matrix', () {
      final matrix = Matrix3(0, 1, 0, -1, 0, 0, 5, 6, 1);
      final point = MVector2(2, 3);

      point.absoluteRotate2(matrix);

      expectVector2(point, 3, 2);
    });
  });
}
