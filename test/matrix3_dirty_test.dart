import 'package:ivector_math/ivector_math_dirty.dart';
import 'package:test/test.dart';

void main() {
  group('dirty tracking', () {
    test('starts clean', () {
      // Matrix3.identity() itself goes through mutate() internally, so use
      // the bare zero() constructor to observe a truly never-mutated value.
      expect(Matrix3.zero().dirty, 0);
    });

    test('mutate sets every bit', () {
      final matrix = Matrix3.identity();

      matrix.mutate()[0] = 3;

      expect(matrix.dirty, -1);
    });

    test('leaves the value unchanged by itself', () {
      final matrix = Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);

      matrix.dirty = -1;

      expect(matrix[0], 1);
      expect(matrix[8], 9);
    });

    test('supports independent consumers clearing their own bit', () {
      const first = 1 << 0;
      const second = 1 << 1;
      final matrix = Matrix3.identity();

      matrix.mutate()[0] = 3;
      matrix.dirty &= ~first;

      expect(matrix.dirty & first, 0);
      expect(matrix.dirty & second, isNot(0));

      matrix.dirty &= ~second;

      expect(matrix.dirty & second, 0);
    });

    test('a later mutation re-dirties a bit a consumer already cleared', () {
      const bit = 1 << 0;
      final matrix = Matrix3.identity();

      matrix.mutate()[0] = 3;
      matrix.dirty &= ~bit;
      matrix.mutate()[1] = 4;

      expect(matrix.dirty & bit, isNot(0));
    });
  });
}
