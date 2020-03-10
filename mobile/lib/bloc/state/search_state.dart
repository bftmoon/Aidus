import '../../models/id-name-pair.dart';

abstract class SearchState {
  const SearchState();
}

//class InitState extends SearchState{}
class DataUninitialized extends SearchState {}

class DataError extends SearchState {}

class SearchDataUpdated extends SearchState {
  final List<IdNamePair> data;

  SearchDataUpdated(this.data);
}
