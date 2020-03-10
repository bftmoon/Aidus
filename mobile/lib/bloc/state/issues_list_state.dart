import '../../models/issue_for_list.dart';

abstract class IssuesListState {
  const IssuesListState();
}

class IssuesListUninitialized extends IssuesListState {}

class IssuesListError extends IssuesListState {}

class IssuesListLoaded extends IssuesListState {
  final List<IssueForList> posts;
  final bool hasReachedMax;

  const IssuesListLoaded({
    this.posts,
    this.hasReachedMax,
  });

  IssuesListLoaded copyWith({
    List<IssueForList> posts,
    bool hasReachedMax,
  }) {
    return IssuesListLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() => 'IssuesListLoaded { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}
