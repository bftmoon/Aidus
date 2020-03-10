import '../../models/id-name-pair.dart';

abstract class RedirectState {}

class DataModifying extends RedirectState {
  final IdNamePair group;
  final IdNamePair user;

  DataModifying({this.group, this.user});
}

class RequestSending extends RedirectState {}

class RequestError extends RedirectState {}

class RequestSuccess extends RedirectState {}
