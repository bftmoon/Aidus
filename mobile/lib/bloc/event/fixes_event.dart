abstract class FixEvent {}

class GetFixList extends FixEvent {
  final String id, parentUrl;

  GetFixList(this.id, this.parentUrl);
}

class SelectFix extends FixEvent {
  final String fixId, issueId, parentUrl;

  SelectFix(this.fixId, this.issueId, this.parentUrl);
}

class ExpandList extends FixEvent {
  final int index;
  final bool isExpanded;

  ExpandList(this.index, this.isExpanded);
}
