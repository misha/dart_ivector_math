import 'package:ivector_math/ivector_math.dart';
import 'package:test/test.dart';

import 'support/matchers.dart';

void main() {
  group('Aabb2', () {
    test('creates a zero AABB', () {
      expectAabb2(Aabb2.zero, 0, 0, 0, 0);
    });

    test('reuses a canonical zero instance', () {
      expect(identical(Aabb2.zero, Aabb2.zero), isTrue);
    });

    test('creates an AABB from min and max points', () {
      expectAabb2(Aabb2(.new(1, 2), .new(3, 4)), 1, 2, 3, 4);
    });

    test('supports a const primary constructor', () {
      const aabb = Aabb2(.zero, .zero);
      final min = Vector2(1, 2);
      final max = Vector2(3, 4);
      final aliased = Aabb2(min, max);

      expectAabb2(aabb, 0, 0, 0, 0);
      expect(identical(aliased.min, min), isTrue);
      expect(identical(aliased.max, max), isTrue);
    });

    test('rejects mutable corners', () {
      final mutable = MVector2.all(5);

      expect(() => Aabb2(mutable, .zero), throwsA(isA<AssertionError>()));
      expect(() => Aabb2(.zero, mutable), throwsA(isA<AssertionError>()));
    });

    test('creates an AABB from a center and half extents', () {
      expectAabb2(Aabb2.centerAndHalfExtents(.all(5), .new(2, 3)), 3, 2, 7, 8);
    });

    test('copies without sharing storage', () {
      final original = MAabb2(.new(1, 2), .new(3, 4));
      final copy = Aabb2.copy(original);

      original.setValues(9, 9, 9, 9);

      expectAabb2(copy, 1, 2, 3, 4);
    });

    test('clones without sharing storage', () {
      final aabb = Aabb2(.new(1, 2), .new(3, 4));
      final clone = aabb.clone();

      expectAabb2(clone, 1, 2, 3, 4);
      expect(clone, isNot(same(aabb)));
    });

    test('returns the same live min and max corners on every access', () {
      final aabb = Aabb2(.new(1, 2), .new(3, 4));

      expect(identical(aabb.min, aabb.min), isTrue);
      expect(identical(aabb.max, aabb.max), isTrue);
      expectVector2(aabb.min, 1, 2);
      expectVector2(aabb.max, 3, 4);
    });

    test('reads the center', () {
      final aabb = Aabb2(.all(0), .new(4, 2));

      expectVector2(aabb.center, 2, 1);
    });

    test('reads the width and height', () {
      final aabb = Aabb2(.all(0), .new(4, 2));

      expect(aabb.width, 4);
      expect(aabb.height, 2);
    });

    test('reads a positive width and height when min and max are inverted', () {
      final aabb = Aabb2(.new(4, 2), .all(0));

      expect(aabb.width, 4);
      expect(aabb.height, 2);
    });

    test('detects per-axis overlap independently', () {
      final a = Aabb2(.all(0), .all(2));
      final sameX = Aabb2(.new(1, 5), .new(3, 6));
      final sameY = Aabb2(.new(5, 1), .new(6, 3));
      final neither = Aabb2(.all(5), .all(6));

      expect(a.overlapsX(sameX), isTrue);
      expect(a.overlapsY(sameX), isFalse);
      expect(a.overlapsX(sameY), isFalse);
      expect(a.overlapsY(sameY), isTrue);
      expect(a.overlapsX(neither), isFalse);
      expect(a.overlapsY(neither), isFalse);
    });

    test('detects full containment', () {
      final outer = Aabb2(.all(0), .all(10));
      final inner = Aabb2(.all(2), .all(8));

      expect(outer.containsAabb2(inner), isTrue);
      expect(inner.containsAabb2(outer), isFalse);
    });

    test('detects point containment', () {
      final aabb = Aabb2(.all(0), .all(10));

      expect(aabb.containsVector2(.all(5)), isTrue);
      expect(aabb.containsVector2(.all(10)), isFalse);
    });

    test('detects intersection with another AABB', () {
      final a = Aabb2(.all(0), .all(2));
      final b = Aabb2(.all(1), .all(3));
      final c = Aabb2(.all(5), .all(6));

      expect(a.intersectsWithAabb2(b), isTrue);
      expect(a.intersectsWithAabb2(c), isFalse);
    });

    test('detects intersection with a point', () {
      final aabb = Aabb2(.all(0), .all(2));

      expect(aabb.intersectsWithVector2(.all(2)), isTrue);
      expect(aabb.intersectsWithVector2(.all(3)), isFalse);
    });

    test('compares and hashes by component values across both forms', () {
      final immutable = Aabb2(.new(1, 2), .new(3, 4));
      final mutable = MAabb2(.new(1, 2), .new(3, 4));

      expect(immutable, mutable);
      expect(immutable.hashCode, mutable.hashCode);
      expect(immutable, isNot(Aabb2(.new(0, 2), .new(3, 4))));
      expect(immutable, isNot(Object()));
    });

    test('formats both corners', () {
      expect(
        Aabb2(.new(1, 2), .new(3, 4)).toString(),
        '(1.0, 2.0) -> (3.0, 4.0)',
      );
    });
  });

  group('MAabb2', () {
    test('creates a zero AABB', () {
      expectAabb2(MAabb2.zero(), 0, 0, 0, 0);
    });

    test('creates an AABB from min and max points', () {
      expectAabb2(MAabb2(.new(1, 2), .new(3, 4)), 1, 2, 3, 4);
    });

    test('copies min/max passed to the primary constructor', () {
      final min = MVector2(1, 2);
      final max = MVector2(3, 4);
      final aabb = MAabb2(min, max);

      min.x = 99;
      max.y = 99;

      expectAabb2(aabb, 1, 2, 3, 4);
    });

    test('converts between immutable and mutable forms via copy', () {
      final immutable = Aabb2(.new(1, 2), .new(3, 4));
      final mutable = MAabb2.copy(immutable);

      mutable.setValues(9, 9, 9, 9);
      expectAabb2(immutable, 1, 2, 3, 4);
      expectAabb2(mutable, 9, 9, 9, 9);

      final frozen = Aabb2.copy(mutable);
      mutable.setValues(0, 0, 0, 0);

      expectAabb2(frozen, 9, 9, 9, 9);
    });

    test('creates an AABB from a center and half extents', () {
      expectAabb2(MAabb2.centerAndHalfExtents(.all(5), .new(2, 3)), 3, 2, 7, 8);
    });

    test('clones without sharing storage', () {
      final aabb = MAabb2(.new(1, 2), .new(3, 4));
      final clone = aabb.clone();

      expectAabb2(clone, 1, 2, 3, 4);
      expect(clone, isNot(same(aabb)));

      clone.setValues(99, 99, 99, 99);

      expectAabb2(aabb, 1, 2, 3, 4);
    });

    test('reads through without changing the source', () {
      final aabb = MAabb2(.new(1, 2), .new(3, 4));

      expect(aabb.containsVector2(.new(2, 3)), isTrue);
      expect(aabb.overlapsX(Aabb2(.new(2, 5), .new(4, 6))), isTrue);
      expect(aabb.overlapsY(Aabb2(.all(5), .all(6))), isFalse);
      expect(aabb.intersectsWithAabb2(Aabb2(.all(2), .all(5))), isTrue);
      expectAabb2(aabb, 1, 2, 3, 4);
    });

    test('chains mutations via cascades', () {
      final aabb = MAabb2.zero();

      aabb.setValues(1, 2, 3, 4);

      expectAabb2(aabb, 1, 2, 3, 4);
    });

    test('sets both corners from another AABB without sharing storage', () {
      final aabb = MAabb2.zero();
      final other = Aabb2(.new(1, 2), .new(3, 4));

      aabb.setFrom(other);
      aabb.min.x = 99;

      expectAabb2(aabb, 99, 2, 3, 4);
      expectAabb2(other, 1, 2, 3, 4);
    });

    test('sets both corners from raw components', () {
      final aabb = MAabb2.zero();

      aabb.setValues(1, 2, 3, 4);

      expectAabb2(aabb, 1, 2, 3, 4);
    });

    test('sets from a center and half extents in place', () {
      final aabb = MAabb2.zero();

      aabb.setCenterAndHalfExtents(.all(5), .new(2, 3));

      expectAabb2(aabb, 3, 2, 7, 8);
    });

    test('hulls with another AABB in place', () {
      final aabb = MAabb2(.all(0), .all(2));

      aabb.hull(Aabb2(.all(1), .all(3)));

      expectAabb2(aabb, 0, 0, 3, 3);
    });

    test('hulls with a point in place', () {
      final aabb = MAabb2(.all(0), .all(2));

      aabb.hullPoint(.new(5, -1));

      expectAabb2(aabb, 0, -1, 5, 2);
    });
  });
}
