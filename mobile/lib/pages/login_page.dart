import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/login_bloc.dart';
import '../bloc/event/login_event.dart';
import '../bloc/state/login_state.dart';
import '../exception.dart';
import '../models/token_data.dart';
import '../utils/jwt_util.dart';
import '../web/api_auth.dart';
import '../widgets/request_widgets.dart';
import 'issue_list_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  LoginBloc _bloc;

  String _login, _password;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<LoginBloc>(context);
    _bloc.add(StartEvent());
//    _checkIsLogged();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return _child(state, context);
    });
//    if(_showSignIn) return _showForm();
//    return RequestWidgets.loading();
  }

  Widget _showForm() {
    return Form(
        key: _formKey,
        child: Container(
            padding: EdgeInsets.all(30),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
              Icon(
                Icons.cloud_queue,
                size: 230,
                color: Theme.of(context).primaryColor,
              ),
              TextFormField(
                validator: (value) => value.isEmpty ? 'Login required' : null,
                onSaved: (value) => _login = value.trim(),
                decoration: InputDecoration(hintText: 'Login', icon: Icon(Icons.accessibility)),
              ),
              TextFormField(
                  obscureText: true,
                  validator: (value) => value.isEmpty ? 'Password required' : null,
                  onSaved: (value) => _password = value.trim(),
                  decoration: InputDecoration(
                      hintText: 'Password',
                      icon: Icon(
                        Icons.lock,
                      ))),
              RaisedButton(
                onPressed: signIn,
                child: Text('Sign In'),
              )
            ])));
  }

  void signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
      try {
        TokenData res = await ApiAuth.login(_login, _password, "fcmToken");
        await Jwt.saveTokens(res);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IssueListPage()),
        );
      } on AuthException catch (_) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Wrong login or password')));
      }
    }
  }

  Widget _child(LoginState state, BuildContext context) {
    if (state is SignInState) return _showForm();
    if (state is InitState) return RequestWidgets.loading();
    return RequestWidgets.error();
  }
}
