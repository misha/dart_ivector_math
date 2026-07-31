import 'package:ivector_math/ivector_math_dirty.dart';
import 'package:test/test.dart';

void expectVector2(Vector2 vector, double x, double y) {
  expect(vector.x, x);
  expect(vector.y, y);
}

void expectAabb2(Aabb2 aabb, double minX, double minY, double maxX, double maxY) {
  expect(aabb.minX, minX);
  expect(aabb.minY, minY);
  expect(aabb.maxX, maxX);
  expect(aabb.maxY, maxY);
}
