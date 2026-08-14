import 'package:ivector_math/ivector_math.dart';
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
  List<double> row0,
  List<double> row1,
  List<double> row2,
) {
  final values = [...row0, ...row1, ...row2];

  for (var i = 0; i < 9; i += 1) {
    expect(matrix[i], closeTo(values[i], 0.0000001));
  }
}
