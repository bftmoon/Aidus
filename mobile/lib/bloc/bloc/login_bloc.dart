import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exception.dart';
import '../../pages/issue_list_page.dart';
import '../../utils/jwt_util.dart';
import '../../utils/navigator.dart';
import '../../web/webservice.dart';
import '../event/login_event.dart';
import '../state/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  get initialState => InitState();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is StartEvent) {
      String token = await Jwt.getRefreshToken();
      if (token == null || Jwt.checkIsExpired(token)) {
        yield SignInState();
      } else {
        try {
          WebService.updateAuthToken();
          NavKey.push(
            MaterialPageRoute(builder: (context) => IssueListPage()),
          );
        } on LoadingException catch (_) {
          yield ErrorState();
        }
      }
    }
  }
}
