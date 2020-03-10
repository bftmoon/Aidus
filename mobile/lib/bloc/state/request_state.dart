abstract class RequestState {
  const RequestState();
}

class BeforeResponse extends RequestState {}

class RequestError extends RequestState {}

class RequestDone<T> extends RequestState {
  final T data;

  RequestDone(this.data);
}
