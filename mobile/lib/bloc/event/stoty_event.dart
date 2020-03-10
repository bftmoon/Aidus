abstract class StoryEvent {}

class GetStoryList extends StoryEvent {
  final String id;

  GetStoryList(this.id);
}

class ExpandItem extends StoryEvent {
  final int index;
  final bool isExpanded;

  ExpandItem(this.index, this.isExpanded);
}
