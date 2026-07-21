import 'dart:math';

import 'package:ivector_math/ivector_math.dart';
import 'package:test/test.dart';

import 'support/matchers.dart';

void main() {
  group('construction', () {
    test('creates a zero vector', () {
      expectVector2(Vector2.zero(), 0, 0);
    });

    test('creates a vector from doubles', () {
      expectVector2(Vector2(1.5, -2.5), 1.5, -2.5);
    });

    test('casts numeric values to doubles', () {
      expectVector2(Vector2.cast(1, 2.5), 1, 2.5);
    });

    test('copies without sharing storage', () {
      final original = Vector2(1, 2);
      final copy = Vector2.copy(original);

      original.mutate().x = 3;

      expectVector2(copy, 1, 2);
    });

    test('fills both components with one value', () {
      expectVector2(Vector2.all(2.5), 2.5, 2.5);
    });

    test('uses the supplied random source', () {
      final expected = Random(42);
      final expectedX = expected.nextDouble();
      final expectedY = expected.nextDouble();
      final vector = Vector2.random(Random(42));

      expect(vector.x, closeTo(expectedX, 0.0000001));
      expect(vector.y, closeTo(expectedY, 0.0000001));
    });
  });

  group('immutable view', () {
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

      vector.mutate().y = 3;

      expectVector2(clone, 1, 2);
    });

    test('detects zero vectors', () {
      expect(Vector2.zero().isZero, isTrue);
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
      expectVector2(vector, 3, 4);
    });

    test('computes distance and squared distance', () {
      final first = Vector2(1, 2);
      final second = Vector2(4, 6);

      expect(first.distance(second), 5);
      expect(first.distance2(second), 25);
      expect(second.distance(first), 5);
      expect(second.distance2(first), 25);
      expectVector2(first, 1, 2);
      expectVector2(second, 4, 6);
    });

    test('computes the unsigned angle between vectors', () {
      final right = Vector2(1, 0);
      final up = Vector2(0, 1);
      final left = Vector2(-1, 0);

      expect(right.angleTo(right), 0);
      expect(right.angleTo(up), closeTo(pi / 2, 0.0000001));
      expect(right.angleTo(left), closeTo(pi, 0.0000001));
      expectVector2(right, 1, 0);
      expectVector2(up, 0, 1);
      expectVector2(left, -1, 0);
    });

    test('computes the signed angle between vectors', () {
      final right = Vector2(1, 0);
      final up = Vector2(0, 1);

      expect(right.angleToSigned(right), 0);
      expect(right.angleToSigned(up), closeTo(pi / 2, 0.0000001));
      expect(up.angleToSigned(right), closeTo(-pi / 2, 0.0000001));
      expectVector2(right, 1, 0);
      expectVector2(up, 0, 1);
    });

    test('creates a normalized copy without changing the source', () {
      final vector = Vector2(3, 4);

      final normalized = vector.normalize();

      expect(normalized.x, closeTo(0.6, 0.0000001));
      expect(normalized.y, closeTo(0.8, 0.0000001));
      expectVector2(vector, 3, 4);
    });

    test('normalizes a zero vector to a separate zero vector', () {
      final vector = Vector2.zero();

      final normalized = vector.normalize();

      expect(normalized, isNot(same(vector)));
      expectVector2(normalized, 0, 0);
      expectVector2(vector, 0, 0);
    });

    test('computes dot and cross products without changing its sources', () {
      final first = Vector2(2, 3);
      final second = Vector2(4, 5);

      expect(first.dot(second), 23);
      expect(first.cross(second), -2);
      expect(second.cross(first), 2);
      expectVector2(first, 2, 3);
      expectVector2(second, 4, 5);
    });

    test('creates a scaled copy without changing the source', () {
      final vector = Vector2(2, 3);

      final scaled = vector.scale(4);

      expectVector2(scaled, 8, 12);
      expectVector2(vector, 2, 3);
    });

    test('creates a component-wise multiplied copy without changing its sources', () {
      final vector = Vector2(2, 3);
      final other = Vector2(4, 5);

      final multiplied = vector.multiply(other);

      expectVector2(multiplied, 8, 15);
      expectVector2(vector, 2, 3);
      expectVector2(other, 4, 5);
    });

    test('creates a reflected copy without changing its sources', () {
      final vector = Vector2(1, -1);
      final normal = Vector2(0, 1);

      final reflected = vector.reflect(normal);

      expectVector2(reflected, 1, 1);
      expectVector2(vector, 1, -1);
      expectVector2(normal, 0, 1);
    });

    test('creates a copy clamped to component ranges', () {
      final vector = Vector2(0.5, 10);
      final xRange = Vector2(-1, 1);
      final yRange = Vector2(0, 5);

      final clamped = vector.clamp(xRange, yRange);

      expectVector2(clamped, 0.5, 5);
      expectVector2(vector, 0.5, 10);
      expectVector2(xRange, -1, 1);
      expectVector2(yRange, 0, 5);
    });

    test('uses one range for both components when clamping a copy', () {
      final vector = Vector2(-2, 10);
      final range = Vector2(1, 5);

      final clamped = vector.clamp(range);

      expectVector2(clamped, 1, 5);
      expectVector2(vector, -2, 10);
      expectVector2(range, 1, 5);
    });

    test('creates a copy clamped between scalar bounds', () {
      final vector = Vector2(-2, 10);

      final clamped = vector.clampTo(-1, 5);

      expectVector2(clamped, -1, 5);
      expectVector2(vector, -2, 10);
    });

    test('negates without changing the source', () {
      final vector = Vector2(1, -2);

      expectVector2(-vector, -1, 2);
      expectVector2(vector, 1, -2);
    });

    test('performs arithmetic without changing its sources', () {
      final first = Vector2(8, 6);
      final second = Vector2(2, 3);

      expectVector2(first + second, 10, 9);
      expectVector2(first - second, 6, 3);
      expectVector2(first * 2.5, 20, 15);
      expectVector2(first / 2, 4, 3);
      expectVector2(first, 8, 6);
      expectVector2(second, 2, 3);
    });

    test('compares and hashes by component values', () {
      final first = Vector2(1, 2);
      final equal = Vector2(1, 2);

      expect(first, equal);
      expect(first.hashCode, equal.hashCode);
      expect(first, isNot(Vector2(2, 1)));
      expect(first, isNot(Object()));
    });

    test('formats both components', () {
      expect(Vector2(1, -2).toString(), '(1.0, -2.0)');
    });
  });

  group('mutable view', () {
    test('reads and computes without changing the source', () {
      final vector = Vector2(8, 6);
      final mutable = vector.mutate();

      expect(mutable[0], 8);
      expect(mutable[1], 6);
      expect(mutable.x, 8);
      expect(mutable.y, 6);
      expect(mutable.isZero, isFalse);
      expect(mutable.isInfinite, isFalse);
      expect(mutable.isNaN, isFalse);
      expect(mutable.dot(Vector2(2, 3)), 34);
      expect(mutable.cross(Vector2(2, 3)), 12);
      expectVector2(vector, 8, 6);
    });

    test('modifies through a closure', () {
      final vector = Vector2(1, 2);

      vector.modify((mutable) {
        mutable
          ..add(Vector2(3, 4))
          ..scale(2);
      });

      expectVector2(vector, 8, 12);
    });

    test('detects infinite and NaN components', () {
      final vector = Vector2(double.infinity, double.nan);
      final mutable = vector.mutate();

      expect(mutable.isInfinite, isTrue);
      expect(mutable.isNaN, isTrue);
      expect(vector.x, double.infinity);
      expect(vector.y, isNaN);
    });

    test('passes length and distance calculations through', () {
      final vector = Vector2(3, 4);
      final mutable = vector.mutate();
      final other = Vector2.zero();

      expect(mutable.length, 5);
      expect(mutable.length2, 25);
      expect(mutable.distance(other), 5);
      expect(mutable.distance2(other), 25);
      expectVector2(vector, 3, 4);
      expectVector2(other, 0, 0);
    });

    test('passes angle calculations through', () {
      final vector = Vector2(1, 0);
      final mutable = vector.mutate();
      final other = Vector2(0, 1);

      expect(mutable.angleTo(other), closeTo(pi / 2, 0.0000001));
      expect(mutable.angleToSigned(other), closeTo(pi / 2, 0.0000001));
      expectVector2(vector, 1, 0);
      expectVector2(other, 0, 1);
    });

    test('writes components by index and name', () {
      final vector = Vector2.zero();
      final mutable = vector.mutate();

      mutable[0] = 1;
      mutable.y = 2;
      mutable.x = 3;

      expectVector2(vector, 3, 2);
      expect(() => mutable[2] = 4, throwsRangeError);
    });

    test('sets both components from another vector', () {
      final vector = Vector2.zero();

      vector.mutate().set(Vector2(1, 2));

      expectVector2(vector, 1, 2);
    });

    test('splats one value across both components', () {
      final vector = Vector2.zero();

      vector.mutate().splat(2.5);

      expectVector2(vector, 2.5, 2.5);
    });

    test('negates both components in place', () {
      final vector = Vector2(1, -2);

      vector.mutate().negate();

      expectVector2(vector, -1, 2);
    });

    test('takes the absolute value of both components in place', () {
      final vector = Vector2(-1.5, 2.5);

      vector.mutate().absolute();

      expectVector2(vector, 1.5, 2.5);
    });

    test('clamps both components to their ranges in place', () {
      final vector = Vector2(0.5, 10);
      final xRange = Vector2(-1, 1);
      final yRange = Vector2(0, 5);

      vector.mutate().clamp(xRange, yRange);

      expectVector2(vector, 0.5, 5);
      expectVector2(xRange, -1, 1);
      expectVector2(yRange, 0, 5);
    });

    test('uses one range for both components when clamping in place', () {
      final vector = Vector2(-2, 10);
      final range = Vector2(1, 5);

      vector.mutate().clamp(range);

      expectVector2(vector, 1, 5);
      expectVector2(range, 1, 5);
    });

    test('clamps both components between scalar bounds in place', () {
      final vector = Vector2(-2, 10);

      vector.mutate().clampTo(-1, 5);

      expectVector2(vector, -1, 5);
    });

    test('floors both components in place', () {
      final vector = Vector2(1.9, -1.1);

      vector.mutate().floor();

      expectVector2(vector, 1, -2);
    });

    test('ceils both components in place', () {
      final vector = Vector2(1.1, -1.9);

      vector.mutate().ceil();

      expectVector2(vector, 2, -1);
    });

    test('rounds both components in place', () {
      final vector = Vector2(1.6, -1.6);

      vector.mutate().round();

      expectVector2(vector, 2, -2);
    });

    test('rounds both components toward zero in place', () {
      final vector = Vector2(1.9, -1.9);

      vector.mutate().roundToZero();

      expectVector2(vector, 1, -1);
    });

    test('normalizes in place and returns the previous length', () {
      final vector = Vector2(3, 4);

      final length = vector.mutate().normalize();

      expect(length, 5);
      expect(vector.x, closeTo(0.6, 0.0000001));
      expect(vector.y, closeTo(0.8, 0.0000001));
    });

    test('leaves a zero vector unchanged when normalized in place', () {
      final vector = Vector2.zero();

      final length = vector.mutate().normalize();

      expect(length, 0);
      expectVector2(vector, 0, 0);
    });

    test('passes dot and cross products through without changing the source', () {
      final vector = Vector2(2, 3);
      final mutable = vector.mutate();
      final other = Vector2(4, 5);

      expect(mutable.dot(other), 23);
      expect(mutable.cross(other), -2);
      expectVector2(vector, 2, 3);
      expectVector2(other, 4, 5);
    });

    test('adds a vector in place', () {
      final vector = Vector2(1, 2);

      vector.mutate().add(Vector2(3, 4));

      expectVector2(vector, 4, 6);
    });

    test('adds one value to both components in place', () {
      final vector = Vector2(1, 2);

      vector.mutate().addAll(3);

      expectVector2(vector, 4, 5);
    });

    test('subtracts a vector in place', () {
      final vector = Vector2(5, 7);

      vector.mutate().subtract(Vector2(2, 3));

      expectVector2(vector, 3, 4);
    });

    test('subtracts one value from both components in place', () {
      final vector = Vector2(5, 7);

      vector.mutate().subtractAll(2);

      expectVector2(vector, 3, 5);
    });

    test('scales both components by one value in place', () {
      final vector = Vector2(2, 3);

      vector.mutate().scale(4);

      expectVector2(vector, 8, 12);
    });

    test('multiplies by a vector in place', () {
      final vector = Vector2(2, 3);

      vector.mutate().multiply(Vector2(4, 5));

      expectVector2(vector, 8, 15);
    });

    test('adds a scaled vector in place', () {
      final vector = Vector2(1, 2);

      vector.mutate().addScaled(Vector2(3, 4), 2);

      expectVector2(vector, 7, 10);
    });

    test('reflects in place without changing the normal', () {
      final vector = Vector2(1, -1);
      final normal = Vector2(0, 1);

      vector.mutate().reflect(normal);

      expectVector2(vector, 1, 1);
      expectVector2(normal, 0, 1);
    });
  });
}
