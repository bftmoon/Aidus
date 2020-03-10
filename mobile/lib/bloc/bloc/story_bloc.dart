import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exception.dart';
import '../../web/api_client.dart';
import '../event/stoty_event.dart';
import '../state/story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  @override
  StoryState get initialState => StoryLoading();

  @override
  Stream<StoryState> mapEventToState(StoryEvent event) async* {
    if (event is ExpandItem) {
      yield (state as StoryList).copyWithExpand(event.index, event.isExpanded);
      return;
    }
    if (event is GetStoryList) {
      try {
        yield StoryList(await ApiClient.getStory(event.id));
      } on LoadingException catch (_) {
        yield StoryError();
      }
      return;
    }
  }
}
