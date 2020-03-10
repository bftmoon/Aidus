import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../exception.dart';
import '../../web/api_client.dart';
import '../event/request_event.dart';
import '../state/issues_list_state.dart';

class IssueListBloc extends Bloc<RequestEvent, IssuesListState> {
  @override
  Stream<IssuesListState> transformEvents(
    Stream<RequestEvent> events,
    Stream<IssuesListState> Function(RequestEvent event) next,
  ) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  get initialState => IssuesListUninitialized();

  @override
  Stream<IssuesListState> mapEventToState(RequestEvent event) async* {
    final currentState = state;
    if (event is MakeRequest && !_hasReachedMax(currentState)) {
      try {
        if (currentState is IssuesListUninitialized) {
          final posts = await ApiClient.getIssues(0, 20);
          yield IssuesListLoaded(posts: posts, hasReachedMax: false);
          return;
        }
        if (currentState is IssuesListLoaded) {
          final posts = await ApiClient.getIssues(currentState.posts.length, 20);
          yield posts.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : IssuesListLoaded(
                  posts: currentState.posts + posts,
                  hasReachedMax: false,
                );
        }
      } on LoadingException catch (_) {
        yield IssuesListError();
      }
    }
    if (event is MakeRequestWithStatusChange) {
      try {
        final posts = await ApiClient.getIssues(0, 20, event.status);
        yield IssuesListLoaded(posts: posts, hasReachedMax: false);
      } on LoadingException catch (_) {
        yield IssuesListError();
      }
    }
  }

  bool _hasReachedMax(IssuesListState state) => state is IssuesListLoaded && state.hasReachedMax;
}
