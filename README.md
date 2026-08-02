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

## Principle

In `ivector_math`, the mutation of objects and parameters is explicitly documented by the presence of `mutate()`.

To accomplish this, every class in the library has two forms, immutable and mutable. These forms always have distinct types, such as `Vector2` and `MutableVector2`. `mutate()` transforms the immutable to the mutable. The immutable is then retrieved with `source`.

The goal of the immutable form is to make allocation the default and mutation difficult.

```dart
final size = Vector2(1, 2);
final result = size.scale(2); // Allocates a vector with (2, 4).
```

The goal of the mutable form is to make mutation the default and allocation difficult.

```dart
final size = Vector2(1, 2);
size.mutate().scale(2); // Mutates `size` to (2, 4).
```

## Progress

The following classes from `vector_math` are planned. The subset was selected on the basis of my personal usage of `vector_math` for 2D game development in Dart.

- [x] `Vector2`
- [ ] `Vector3`
- [x] `Matrix3`
- [x] `Aabb2`
- [ ] `Aabb3`
- [ ] `Quad`
- [ ] `Ray`
- [ ] Intersections
- [ ] Benchmarks

Until these items are complete, the package will remain below version 1.0, and all APIs are subject to drastic and potentially uncomfortable change.

After version 1.0, the library will follow semantic versioning and preserve backwards compatibility whenever practical.

## Contributing

If you find a bug or urgently need a particular unimplemented class, please make an issue.

## AI Usage

Some code in this library was generated with AI, while much of the implementation is adapted directly from `vector_math`. As a result, I have a high degree of confidence in its correctness.

External contributions containing AI-generated code are not accepted. Any use of AI in this project is limited to work produced and reviewed by the maintainer.
