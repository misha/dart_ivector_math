## Immutable Vector Math

`ivector_math` is a reimplementation of a subset of `vector_math` in which the mutability of an object is explicitly documented by its type.

Each type in `ivector_math` is immutable by default, but an additional mutable implementation is available with an `M` prefix. For example, `Vector2` is immutable, while `MVector2` is mutable and implements `Vector2`.

Since the mutable type always implements the immutable type, you may use the prefix-free version throughout your code by default. When mutation is required, that requirement will now be documented explicitly through a type signature.

The library stays as close as practical to the original `vector_math` API, with a small number of additions and adjustments to support the immutable/mutable split.

## Example

```dart
import 'package:ivector_math/ivector_math.dart';

void main() {
  final position = Vector2(1, 2);
  position.x = 3; // Compile-time error: `x` is final.

  final velocity = MVector2(1, 2);
  velocity.x = 3; // Sets x to 5.
}
```

## Progress

The following classes from `vector_math` are planned. The subset was selected on the basis of my personal usage of `vector_math` for 2D game development in Dart.

- [x] `Vector2`/`MVector2`
- [ ] `Vector3`/`MVector3`
- [x] `Matrix3`/`MMatrix3`
- [x] `Aabb2`/`MAabb2`
- [ ] `Quad`/`MQuad`
- [ ] `Ray`/`MRay`
- [ ] Intersections
- [ ] Benchmarks/Optimizations

Until these items are complete, the package will remain below version 1.0, and all APIs are subject to drastic and potentially uncomfortable change.

After version 1.0, the library will follow semantic versioning and preserve backwards compatibility whenever practical.

## Contributing

If you find a bug or urgently need a particular unimplemented class, please make an issue.

## AI Usage

Some code in this library was generated with AI, while much of the implementation is adapted directly from `vector_math`. As a result, I have a high degree of confidence in its correctness.

External contributions containing AI-generated code are not accepted. Any use of AI in this project is limited to work produced and reviewed by the maintainer.
