extension CastExtension on Object? {
  @pragma("vm:prefer-inline")
  R cast<R>() => this as R;
}
