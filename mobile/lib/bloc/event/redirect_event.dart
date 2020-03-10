import '../../models/id-name-pair.dart';

abstract class RedirectEvent {}

class RedirectSubmitted extends RedirectEvent {
  final issueId;
  final String description;

  RedirectSubmitted(this.description, this.issueId);
}

class GroupAdding extends RedirectEvent {
  final IdNamePair group;

  GroupAdding(this.group);
}

class UserAdding extends RedirectEvent {
  final IdNamePair user;

  UserAdding(this.user);
}
