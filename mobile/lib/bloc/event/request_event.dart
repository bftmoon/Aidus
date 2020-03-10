abstract class RequestEvent {}

class MakeRequestWithParam extends RequestEvent {
  final String id;

  MakeRequestWithParam(this.id);
}

class MakeRequest extends RequestEvent {}

class MakeRequestWithStatusChange extends RequestEvent {
  final String status;

  MakeRequestWithStatusChange(this.status);
}
