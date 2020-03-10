import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exception.dart';
import '../../models/issue.dart';
import '../../web/api_client.dart';
import '../event/request_event.dart';
import '../state/request_state.dart';

class IssueInfoBloc extends Bloc<RequestEvent, RequestState> {
  @override
  RequestState get initialState => BeforeResponse();

  @override
  Stream<RequestState> mapEventToState(RequestEvent event) async* {
    try {
      final issue = await ApiClient.getIssue((event as MakeRequestWithParam).id);
      yield RequestDone<Issue>(issue);
    } on LoadingException catch (_) {
      yield RequestError();
    }
    return;
  }
}
