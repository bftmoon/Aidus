import '../../utils/enums.dart';

abstract class SearchEvent {}

class AddingParam extends SearchEvent {
  final SearchType type;
  final String groupId;

  AddingParam(this.type, this.groupId);
}

class FetchData extends SearchEvent {}

class InputUpdate extends SearchEvent {
  final String search;

  InputUpdate(this.search);
}
