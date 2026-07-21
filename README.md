## Immutable Vector Math

`ivector_math` is a reimplementation of a subset of `vector_math` with controlled mutability.

Each type is externally immutable by default. Only by calling `mutate()` is the mutation API exposed. This subtle distinction prevents accidental modification while preserving efficient in-place operations when they are explicitly needed.

The library stays as close as practical to the original `vector_math` API, with a small number of additions and adjustments to support the controlled-mutation model.

## Example

```dart
import 'package:ivector_math/ivector_math.dart';

void main() {
  final position = Vector2.zero();
  position.x = 5; // Compile-time error.
  position.mutate().x = 5; // Sets x to 5.
}
```

## Progress

The following classes from `vector_math` are planned. The subset was selected on the basis of my personal usage of `vector_math` for 2D game development in Dart.

- [x] `Vector2`
- [ ] `Vector3`
- [ ] `Matrix2`
- [ ] `Matrix3`
- [ ] `Aabb2`
- [ ] `Aabb3`
- [ ] `Quad`
- [ ] `Ray`
- [ ] Intersections
- [ ] Benchmarks

## Contributing

If you find a bug or urgently need a particular unimplemented class, please make an issue.

## AI Usage

Some code in this library was generated with AI, while much of the implementation is adapted directly from `vector_math`. As a result, I have a high degree of confidence in its correctness.

External contributions containing AI-generated code are not accepted. Any use of AI in this project is limited to work produced and reviewed by the maintainer.
