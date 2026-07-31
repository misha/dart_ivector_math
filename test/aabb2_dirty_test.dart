import 'package:ivector_math/ivector_math_dirty.dart';
import 'package:test/test.dart';

void main() {
  group('dirty tracking', () {
    test('starts clean', () {
      expect(Aabb2.zero().dirty, 0);
    });

    test('mutate sets every bit', () {
      final aabb = Aabb2.zero();

      aabb.mutate().minX = 3;

      expect(aabb.dirty, -1);
    });

    test('leaves the value unchanged by itself', () {
      final aabb = Aabb2(Vector2(1, 2), Vector2(3, 4));

      aabb.dirty = -1;

      expect(aabb.minX, 1);
      expect(aabb.minY, 2);
      expect(aabb.maxX, 3);
      expect(aabb.maxY, 4);
    });

    test('supports independent consumers clearing their own bit', () {
      const first = 1 << 0;
      const second = 1 << 1;
      final aabb = Aabb2.zero();

      aabb.mutate().minX = 3;
      aabb.dirty &= ~first;

      expect(aabb.dirty & first, 0);
      expect(aabb.dirty & second, isNot(0));

      aabb.dirty &= ~second;

      expect(aabb.dirty & second, 0);
    });

    test('a later mutation re-dirties a bit a consumer already cleared', () {
      const bit = 1 << 0;
      final aabb = Aabb2.zero();

      aabb.mutate().minX = 3;
      aabb.dirty &= ~bit;
      aabb.mutate().minY = 4;

      expect(aabb.dirty & bit, isNot(0));
    });
  });
}
