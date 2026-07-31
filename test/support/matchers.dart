import 'package:ivector_math/ivector_math_dirty.dart';
import 'package:test/test.dart';

void expectVector2(Vector2 vector, double x, double y) {
  expect(vector.x, x);
  expect(vector.y, y);
}

void expectAabb2(
  Aabb2 aabb,
  double minX,
  double minY,
  double maxX,
  double maxY,
) {
  expect(aabb.min.x, minX);
  expect(aabb.min.y, minY);
  expect(aabb.max.x, maxX);
  expect(aabb.max.y, maxY);
}

void expectMatrix3(
  Matrix3 matrix,
  double arg0,
  double arg1,
  double arg2,
  double arg3,
  double arg4,
  double arg5,
  double arg6,
  double arg7,
  double arg8,
) {
  final expected = [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8];
  for (var i = 0; i < 9; i += 1) {
    expect(matrix[i], closeTo(expected[i], 0.0000001));
  }
}
