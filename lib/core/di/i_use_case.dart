abstract class UseCase<T> {
  Future<T> call();
}

abstract class UseCaseWithParams<T, P> {
  Future<T> call({P params});
}
