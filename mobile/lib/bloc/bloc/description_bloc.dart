import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exception.dart';
import '../../pages/description_page.dart';
import '../../web/api_client.dart';
import '../event/description_event.dart';
import '../state/description_state.dart';

class DescriptionBloc extends Bloc<DescriptionEvent, DescriptionState> {
  @override
  DescriptionState get initialState => InitState();

  @override
  Stream<DescriptionState> mapEventToState(DescriptionEvent event) async* {
    DescriptionSubmitted ev = event;
    try {
      switch ((event as DescriptionSubmitted).type) {
        case IssueRequestType.CLOSE:
          await ApiClient.closeIssue(ev.issueId, ev.description);
          break;
        case IssueRequestType.DECLINE_REDIRECT:
          await ApiClient.answerRedirect(ev.issueId, ev.description, false);
          break;
      }
      Navigator.of(ev.context).popUntil((route) => route.isFirst);
    } on LoadingException catch (_) {
      yield DescriptionError();
    }
  }
}
