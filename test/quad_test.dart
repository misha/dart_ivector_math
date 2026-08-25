import 'package:ivector_math/ivector_math.dart';
import 'package:test/test.dart';

import 'support/matchers.dart';

void main() {
  group('Quad', () {
    test('creates a zero quad', () {
      expectQuad(Quad.zero, .zero, .zero, .zero, .zero);
    });

    test('reuses a canonical zero instance', () {
      expect(identical(Quad.zero, Quad.zero), isTrue);
    });

    test('creates a quad from four points', () {
      final quad = Quad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      expectQuad(
        quad,
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );
    });

    test('supports a const primary constructor', () {
      const quad = Quad(.zero, .zero, .zero, .zero);
      final point0 = Vector3(0, 0, 0);
      final point1 = Vector3(1, 0, 0);
      final point2 = Vector3(1, 1, 0);
      final point3 = Vector3(0, 1, 0);
      final aliased = Quad(point0, point1, point2, point3);

      expectQuad(quad, .zero, .zero, .zero, .zero);
      expect(identical(aliased.point0, point0), isTrue);
      expect(identical(aliased.point1, point1), isTrue);
      expect(identical(aliased.point2, point2), isTrue);
      expect(identical(aliased.point3, point3), isTrue);
    });

    test('rejects mutable points', () {
      final mutable = MVector3.all(5);

      expect(
        () => Quad(mutable, .zero, .zero, .zero),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => Quad(.zero, mutable, .zero, .zero),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => Quad(.zero, .zero, mutable, .zero),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => Quad(.zero, .zero, .zero, mutable),
        throwsA(isA<AssertionError>()),
      );
    });

    test('copies without sharing storage', () {
      final original = MQuad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      final copy = Quad.copy(original);
      original.point0.x = 99;

      expectQuad(
        copy,
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );
    });

    test('clones without sharing storage', () {
      final quad = Quad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      final clone = quad.clone();

      expectQuad(
        clone,
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );
      expect(clone, isNot(same(quad)));
    });

    test('returns the same live points on every access', () {
      final quad = Quad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      expect(identical(quad.point0, quad.point0), isTrue);
      expect(identical(quad.point1, quad.point1), isTrue);
      expect(identical(quad.point2, quad.point2), isTrue);
      expect(identical(quad.point3, quad.point3), isTrue);
    });

    test('computes the normal of a counter-clockwise quad', () {
      final quad = Quad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      expectVector3(quad.normal, 0, 0, 1);
    });

    test('flips the normal of a clockwise quad', () {
      final quad = Quad(
        .new(0, 0, 0),
        .new(0, 1, 0),
        .new(1, 1, 0),
        .new(1, 0, 0),
      );

      expectVector3(quad.normal, 0, 0, -1);
    });

    test('normalizes the normal', () {
      final quad = Quad(
        .new(0, 0, 0),
        .new(2, 0, 0),
        .new(2, 2, 0),
        .new(0, 2, 0),
      );

      expectVector3(quad.normal, 0, 0, 1);
    });

    test('allocates a new normal on every access', () {
      final quad = Quad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      expect(quad.normal, isNot(same(quad.normal)));
    });

    test('creates a transformed copy', () {
      final matrix = Matrix4(
        // dart format off
        2, 0, 0, 0,
        0, 3, 0, 0,
        0, 0, 4, 0,
        1, 2, 3, 1,
        // dart format on
      );

      final quad = Quad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      final transformed = quad.transformed(matrix);

      expectQuad(
        transformed,
        .new(1, 2, 3),
        .new(3, 2, 3),
        .new(3, 5, 3),
        .new(1, 5, 3),
      );

      expectQuad(
        quad,
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );
    });

    test('creates a translated copy', () {
      final quad = Quad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      final translated = quad.translated(.new(1, 2, 3));

      expectQuad(
        translated,
        .new(1, 2, 3),
        .new(2, 2, 3),
        .new(2, 3, 3),
        .new(1, 3, 3),
      );

      expectQuad(
        quad,
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );
    });

    test('compares and hashes by component values across both forms', () {
      final immutable = Quad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      final mutable = MQuad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      expect(immutable, mutable);
      expect(immutable.hashCode, mutable.hashCode);

      expect(
        immutable,
        isNot(
          Quad(
            .new(0, 0, 0), //
            .new(1, 0, 0),
            .new(1, 1, 0),
            .new(0, 1, 1),
          ),
        ),
      );

      expect(immutable, isNot(Object()));
    });

    test('formats every point', () {
      expect(
        Quad(
          .new(0, 0, 0),
          .new(1, 0, 0),
          .new(1, 1, 0),
          .new(0, 1, 0),
        ).toString(),
        '[0] (0.0, 0.0, 0.0)\n'
        '[1] (1.0, 0.0, 0.0)\n'
        '[2] (1.0, 1.0, 0.0)\n'
        '[3] (0.0, 1.0, 0.0)',
      );
    });
  });

  group('MQuad', () {
    test('creates a zero quad', () {
      expectQuad(MQuad.zero(), .zero, .zero, .zero, .zero);
    });

    test('creates a quad from four points', () {
      final quad = MQuad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      expectQuad(
        quad,
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );
    });

    test('copies points passed to the primary constructor', () {
      final point0 = MVector3(0, 0, 0);
      final point1 = MVector3(1, 0, 0);
      final point2 = MVector3(1, 1, 0);
      final point3 = MVector3(0, 1, 0);
      final quad = MQuad(point0, point1, point2, point3);

      point0.x = 99;
      point1.y = 99;
      point2.z = 99;
      point3.x = 99;

      expectQuad(
        quad,
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );
    });

    test('converts between immutable and mutable forms via copy', () {
      final immutable = Quad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      final mutable = MQuad.copy(immutable);
      mutable.point0.x = 9;

      expectQuad(
        immutable,
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      expectQuad(
        mutable,
        .new(9, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      final frozen = Quad.copy(mutable);
      mutable.point0.x = 0;

      expectQuad(
        frozen,
        .new(9, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );
    });

    test('clones without sharing storage', () {
      final quad = MQuad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );
      final clone = quad.clone();

      expectQuad(
        clone,
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );
      expect(clone, isNot(same(quad)));

      clone.point0.x = 99;

      expectQuad(
        quad,
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );
    });

    test('reads through without changing the source', () {
      final quad = MQuad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      expectVector3(quad.normal, 0, 0, 1);
      expect(quad.transformed(Matrix4.identity), quad);
      expect(quad.translated(.all(1)), isNot(quad));
      expectQuad(
        quad,
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );
    });

    test('chains mutations via cascades', () {
      final quad = MQuad.zero();

      quad
        ..translate(.all(1))
        ..transform(Matrix4.diagonal3Values(2, 2, 2));

      expectQuad(quad, .all(2), .all(2), .all(2), .all(2));
    });

    test('sets all points from another quad without sharing storage', () {
      final quad = MQuad.zero();
      final other = Quad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      quad.setFrom(other);
      quad.point0.x = 99;

      expectQuad(
        quad,
        .new(99, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );
      expectQuad(
        other,
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );
    });

    test('transforms in place', () {
      final matrix = Matrix4(
        // dart format off
        2, 0, 0, 0,
        0, 3, 0, 0,
        0, 0, 4, 0,
        1, 2, 3, 1,
        // dart format on
      );

      final quad = MQuad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      quad.transform(matrix);

      expectQuad(
        quad,
        .new(1, 2, 3),
        .new(3, 2, 3),
        .new(3, 5, 3),
        .new(1, 5, 3),
      );
    });

    test('translates in place', () {
      final quad = MQuad(
        .new(0, 0, 0),
        .new(1, 0, 0),
        .new(1, 1, 0),
        .new(0, 1, 0),
      );

      quad.translate(.new(1, 2, 3));

      expectQuad(
        quad,
        .new(1, 2, 3),
        .new(2, 2, 3),
        .new(2, 3, 3),
        .new(1, 3, 3),
      );
    });
  });
}
