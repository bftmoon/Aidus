import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exception.dart';
import '../../web/api_client.dart';
import '../event/fixes_event.dart';
import '../state/fixes_state.dart';

class FixesBloc extends Bloc<FixEvent, FixesState> {
  @override
  FixesState get initialState => FixesLoading();

  @override
  Stream<FixesState> mapEventToState(FixEvent event) async* {
    if (event is ExpandList) {
      yield (state as FixesList).copyWithExpand(event.index, event.isExpanded);
      return;
    }
    if (event is GetFixList) {
      try {
        yield FixesList(await ApiClient.getFixes(event.id, event.parentUrl));
      } on LoadingException catch (_) {
        yield FixError();
      }
      return;
    }
    yield FixesLoading();
    if (event is SelectFix) {
      try {
        yield FixDone(await ApiClient.postFix(event.fixId, event.issueId, event.parentUrl));
      } on LoadingException catch (_) {
        yield FixError();
      }
    }
  }
}
