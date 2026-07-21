/// Interface for objects that are read-only by default, but offer a mutable
/// view via a special [mutate] method.
abstract class Mutable<T> {
  /// Returns the mutable view of this object.
  T mutate();
}
