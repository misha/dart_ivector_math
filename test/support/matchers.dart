import 'package:ivector_math/ivector_math.dart';
import 'package:test/test.dart';

void expectVector2(Vector2 vector, double x, double y) {
  expect(vector.x, x);
  expect(vector.y, y);
}

void expectVector3(Vector3 vector, double x, double y, double z) {
  expect(vector.x, x);
  expect(vector.y, y);
  expect(vector.z, z);
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

void expectQuad(
  Quad quad,
  Vector3 point0,
  Vector3 point1,
  Vector3 point2,
  Vector3 point3,
) {
  expectVector3(quad.point0, point0.x, point0.y, point0.z);
  expectVector3(quad.point1, point1.x, point1.y, point1.z);
  expectVector3(quad.point2, point2.x, point2.y, point2.z);
  expectVector3(quad.point3, point3.x, point3.y, point3.z);
}

void expectMatrix3(
  Matrix3 matrix,
  List<double> column0,
  List<double> column1,
  List<double> column2,
) {
  final values = [...column0, ...column1, ...column2];

  for (var i = 0; i < 9; i += 1) {
    expect(matrix[i], closeTo(values[i], 0.0000001));
  }
}

void expectMatrix4(
  Matrix4 matrix,
  List<double> column0,
  List<double> column1,
  List<double> column2,
  List<double> column3,
) {
  final values = [...column0, ...column1, ...column2, ...column3];

  for (var i = 0; i < 16; i += 1) {
    expect(matrix[i], closeTo(values[i], 0.0000001));
  }
}
