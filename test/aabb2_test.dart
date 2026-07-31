import 'package:ivector_math/ivector_math_dirty.dart';
import 'package:test/test.dart';

import 'support/matchers.dart';

void main() {
  group('construction', () {
    test('creates a zero AABB', () {
      expectAabb2(Aabb2.zero(), 0, 0, 0, 0);
    });

    test('creates an AABB from min and max points', () {
      expectAabb2(Aabb2(Vector2(1, 2), Vector2(3, 4)), 1, 2, 3, 4);
    });

    test('copies without sharing storage', () {
      final original = Aabb2(Vector2(1, 2), Vector2(3, 4));
      final copy = Aabb2.copy(original);

      original.mutate().maxX = 10;

      expectAabb2(copy, 1, 2, 3, 4);
    });

    test('creates an AABB from a center and half extents', () {
      final aabb = Aabb2.centerAndHalfExtents(Vector2(5, 5), Vector2(2, 3));

      expectAabb2(aabb, 3, 2, 7, 8);
    });
  });

  group('immutable view', () {
    test('reads components by index', () {
      final aabb = Aabb2(Vector2(1, 2), Vector2(3, 4));

      expect(aabb[0], 1);
      expect(aabb[1], 2);
      expect(aabb[2], 3);
      expect(aabb[3], 4);
      expect(() => aabb[4], throwsRangeError);
    });

    test('reads min, max, center, and half extents', () {
      final aabb = Aabb2(Vector2(0, 0), Vector2(4, 2));

      expectVector2(aabb.min, 0, 0);
      expectVector2(aabb.max, 4, 2);
      expectVector2(aabb.center, 2, 1);
      expectVector2(aabb.halfExtents, 2, 1);
    });

    test('clones without sharing storage', () {
      final aabb = Aabb2(Vector2(1, 2), Vector2(3, 4));
      final clone = aabb.clone();

      aabb.mutate().minX = 10;

      expectAabb2(clone, 1, 2, 3, 4);
    });

    test('creates a hulled copy without changing its sources', () {
      final a = Aabb2(Vector2(0, 0), Vector2(2, 2));
      final b = Aabb2(Vector2(1, 1), Vector2(3, 3));

      final hulled = a.hull(b);

      expectAabb2(hulled, 0, 0, 3, 3);
      expectAabb2(a, 0, 0, 2, 2);
      expectAabb2(b, 1, 1, 3, 3);
    });

    test('creates a copy hulled with a point without changing its sources', () {
      final a = Aabb2(Vector2(0, 0), Vector2(2, 2));
      final point = Vector2(5, -1);

      final hulled = a.hullPoint(point);

      expectAabb2(hulled, 0, -1, 5, 2);
      expectAabb2(a, 0, 0, 2, 2);
      expectVector2(point, 5, -1);
    });

    test('detects full containment', () {
      final outer = Aabb2(Vector2(0, 0), Vector2(10, 10));
      final inner = Aabb2(Vector2(2, 2), Vector2(8, 8));

      expect(outer.containsAabb2(inner), isTrue);
      expect(inner.containsAabb2(outer), isFalse);
    });

    test('detects point containment', () {
      final aabb = Aabb2(Vector2(0, 0), Vector2(10, 10));

      expect(aabb.containsVector2(Vector2(5, 5)), isTrue);
      expect(aabb.containsVector2(Vector2(10, 10)), isFalse);
    });

    test('detects per-axis overlap independently', () {
      final a = Aabb2(Vector2(0, 0), Vector2(2, 2));
      final sameX = Aabb2(Vector2(1, 5), Vector2(3, 6));
      final sameY = Aabb2(Vector2(5, 1), Vector2(6, 3));
      final neither = Aabb2(Vector2(5, 5), Vector2(6, 6));

      expect(a.overlapsX(sameX), isTrue);
      expect(a.overlapsY(sameX), isFalse);
      expect(a.overlapsX(sameY), isFalse);
      expect(a.overlapsY(sameY), isTrue);
      expect(a.overlapsX(neither), isFalse);
      expect(a.overlapsY(neither), isFalse);
    });

    test('detects intersection with another AABB', () {
      final a = Aabb2(Vector2(0, 0), Vector2(2, 2));
      final b = Aabb2(Vector2(1, 1), Vector2(3, 3));
      final c = Aabb2(Vector2(5, 5), Vector2(6, 6));

      expect(a.intersectsWithAabb2(b), isTrue);
      expect(a.intersectsWithAabb2(c), isFalse);
    });

    test('detects intersection with a point', () {
      final aabb = Aabb2(Vector2(0, 0), Vector2(2, 2));

      expect(aabb.intersectsWithVector2(Vector2(2, 2)), isTrue);
      expect(aabb.intersectsWithVector2(Vector2(3, 3)), isFalse);
    });

    test('compares and hashes by component values', () {
      final first = Aabb2(Vector2(1, 2), Vector2(3, 4));
      final equal = Aabb2(Vector2(1, 2), Vector2(3, 4));

      expect(first, equal);
      expect(first.hashCode, equal.hashCode);
      expect(first, isNot(Aabb2(Vector2(0, 2), Vector2(3, 4))));
      expect(first, isNot(Object()));
    });

    test('formats both corners', () {
      expect(
        Aabb2(Vector2(1, 2), Vector2(3, 4)).toString(),
        '(1.0, 2.0) -> (3.0, 4.0)',
      );
    });
  });

  group('mutable view', () {
    test('reads through without changing the source', () {
      final aabb = Aabb2(Vector2(1, 2), Vector2(3, 4));
      final mutable = aabb.mutate();

      expect(mutable[0], 1);
      expect(mutable[1], 2);
      expect(mutable[2], 3);
      expect(mutable[3], 4);
      expect(mutable.minX, 1);
      expect(mutable.minY, 2);
      expect(mutable.maxX, 3);
      expect(mutable.maxY, 4);
      expect(mutable.containsVector2(Vector2(2, 3)), isTrue);
      expect(mutable.overlapsX(Aabb2(Vector2(2, 5), Vector2(4, 6))), isTrue);
      expect(mutable.overlapsY(Aabb2(Vector2(5, 5), Vector2(6, 6))), isFalse);
      expect(
        mutable.intersectsWithAabb2(Aabb2(Vector2(2, 2), Vector2(5, 5))),
        isTrue,
      );
      expectAabb2(aabb, 1, 2, 3, 4);
    });

    test('modifies through a closure', () {
      final aabb = Aabb2.zero();

      aabb.modify((mutable) => mutable.setMinMax(1, 2, 3, 4));

      expectAabb2(aabb, 1, 2, 3, 4);
    });

    test('writes components by index', () {
      final aabb = Aabb2.zero();
      final mutable = aabb.mutate();

      mutable[0] = 1;
      mutable[1] = 2;
      mutable[2] = 3;
      mutable[3] = 4;

      expectAabb2(aabb, 1, 2, 3, 4);
      expect(() => mutable[4] = 5, throwsRangeError);
    });

    test('writes corners by name', () {
      final aabb = Aabb2.zero();
      final mutable = aabb.mutate();

      mutable.minX = 1;
      mutable.minY = 2;
      mutable.maxX = 3;
      mutable.maxY = 4;

      expectAabb2(aabb, 1, 2, 3, 4);
    });

    test('sets both corners from another AABB', () {
      final aabb = Aabb2.zero();

      aabb.mutate().set(Aabb2(Vector2(1, 2), Vector2(3, 4)));

      expectAabb2(aabb, 1, 2, 3, 4);
    });

    test('sets both corners from raw components', () {
      final aabb = Aabb2.zero();

      aabb.mutate().setMinMax(1, 2, 3, 4);

      expectAabb2(aabb, 1, 2, 3, 4);
    });

    test('sets from a center and half extents in place', () {
      final aabb = Aabb2.zero();

      aabb.mutate().setCenterAndHalfExtents(Vector2(5, 5), Vector2(2, 3));

      expectAabb2(aabb, 3, 2, 7, 8);
    });

    test('hulls with another AABB in place', () {
      final aabb = Aabb2(Vector2(0, 0), Vector2(2, 2));

      aabb.mutate().hull(Aabb2(Vector2(1, 1), Vector2(3, 3)));

      expectAabb2(aabb, 0, 0, 3, 3);
    });

    test('hulls with a point in place', () {
      final aabb = Aabb2(Vector2(0, 0), Vector2(2, 2));

      aabb.mutate().hullPoint(Vector2(5, -1));

      expectAabb2(aabb, 0, -1, 5, 2);
    });
  });
}
