import '../../models/story_item.dart';

abstract class StoryState {}

class StoryLoading extends StoryState {}

class StoryList extends StoryState {
  final List<StoryItem> story;

  StoryList(this.story);

  StoryList copyWithExpand(int index, bool isExpanded) {
    return StoryList(this.story)..story[index].isExpanded = isExpanded;
  }
}

class StoryError extends StoryState {}
