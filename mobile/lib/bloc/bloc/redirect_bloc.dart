import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exception.dart';
import '../../web/api_client.dart';
import '../event/redirect_event.dart';
import '../state/redirect_state.dart';

class RedirectBloc extends Bloc<RedirectEvent, RedirectState> {
  @override
  RedirectState get initialState => DataModifying();

  @override
  Stream<RedirectState> mapEventToState(RedirectEvent event) async* {
    if (event is GroupAdding) {
      yield DataModifying(group: event.group);
      return;
    }
    if (event is UserAdding) {
      yield DataModifying(group: (state as DataModifying).group, user: event.user);
      return;
    }
    if (event is RedirectSubmitted) {
      try {
        await ApiClient.postRedirect(event.issueId, (state as DataModifying).user.id);
        yield RequestSuccess();
      } on LoadingException catch (_) {
        yield RequestError();
      }
    }
    return;
  }
}
