import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exception.dart';
import '../../utils/enums.dart';
import '../../models/id-name-pair.dart';
import '../../web/api_client.dart';
import '../event/search_event.dart';
import '../state/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  List<IdNamePair> fullSearchList;

  @override
  SearchState get initialState => DataUninitialized();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is AddingParam) {
      try {
        fullSearchList =
            event.type == SearchType.GROUP ? await ApiClient.getGroups() : await ApiClient.getWorkers(event.groupId);
        yield SearchDataUpdated(fullSearchList);
      } on LoadingException catch (_) {
        yield DataError();
      } on Error catch (e) {
        throw e;
      }
      return;
    }
    if (event is InputUpdate)
      yield SearchDataUpdated(fullSearchList.where((el) => el.name.contains(event.search)).toList());
  }
}
