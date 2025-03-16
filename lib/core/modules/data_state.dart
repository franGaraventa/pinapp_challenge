abstract class DataState<T> {
  const DataState({
    this.data,
    this.error,
    this.retryable,
  });

  final T? data;
  final String? error;
  final bool? retryable;
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  DataFailed(String error, {bool retryable = false})
      : super(
          error: error,
          retryable: retryable,
        );
}

class DataLoading<T> extends DataState<T> {
  const DataLoading() : super();
}
