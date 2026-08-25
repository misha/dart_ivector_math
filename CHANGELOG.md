## 0.2.0

- Implement `Vector3` and `MVector3`.
- Implement `Matrix4` and `MMatrix4`.
- Implement `Quad` and `MQuad`.
- Fix various inconsistencies in style, API, and `vector_math` adaptations.

## 0.1.1

- Implement `clampBetween`/`clampedBetween` for `Vector2`.
- Implement static `Vector2.min`/`Vector2.max` as the allocating counterparts to `min`/`max` on `MVector2`.
- Implement a canonical `infinity` member for `Vector2`.

## 0.1.0

- Rewrite pretty much the entire package. As promised, before 1.0.0 things are changing dramatically.
- The new premise is significantly more straightforward: two types, `Vector2` and `MVector2`, with the mutable type implementing the immutable one.
- Update all implementations, tests, and documentation.
- Bring in comments from `vector_math`, supplemented with additional documentation for additions/deviations from their API.

## 0.0.5

- Implement `min`/`max` for `Vector2`.

## 0.0.4

- Improve the README.
- Implement `Matrix3` and `Aabb2`.
- Rename the type extension base to `source` on all mutable types.

## 0.0.3

- Improve the README.

## 0.0.2

- Improve the README.

## 0.0.1

- Write initial README.
- Implement `Vector2`.
