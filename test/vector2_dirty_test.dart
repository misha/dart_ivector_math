import 'package:ivector_math/ivector_math_dirty.dart';
import 'package:test/test.dart';

void main() {
  group('dirty tracking', () {
    test('starts clean', () {
      expect(Vector2(1, 2).dirty, 0);
    });

    test('mutate sets every bit', () {
      final vector = Vector2(1, 2);

      vector.mutate().x = 3;

      expect(vector.dirty, -1);
    });

    test('leaves the value unchanged by itself', () {
      final vector = Vector2(1, 2);

      vector.dirty = -1;

      expect(vector.x, 1);
      expect(vector.y, 2);
    });

    test('supports independent consumers clearing their own bit', () {
      const first = 1 << 0;
      const second = 1 << 1;
      final vector = Vector2(1, 2);

      vector.mutate().x = 3;
      vector.dirty &= ~first;

      expect(vector.dirty & first, 0);
      expect(vector.dirty & second, isNot(0));

      vector.dirty &= ~second;

      expect(vector.dirty & second, 0);
    });

    test('a later mutation re-dirties a bit a consumer already cleared', () {
      const bit = 1 << 0;
      final vector = Vector2(1, 2);

      vector.mutate().x = 3;
      vector.dirty &= ~bit;
      vector.mutate().y = 4;

      expect(vector.dirty & bit, isNot(0));
    });
  });
}
