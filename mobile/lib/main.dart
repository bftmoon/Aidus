import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc/description_bloc.dart';
import 'bloc/bloc/fixes_bloc.dart';
import 'bloc/bloc/issue_info_bloc.dart';
import 'bloc/bloc/issues_list_bloc.dart';
import 'bloc/bloc/login_bloc.dart';
import 'bloc/bloc/redirect_bloc.dart';
import 'bloc/bloc/search_bloc.dart';
import 'bloc/bloc/story_bloc.dart';
import 'bloc/simple_bloc_delegate.dart';
import 'pages/login_page.dart';
import 'utils/navigator.dart';

Future<void> main() async {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  // final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    // prepareFirebase();

    return MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(),
          ),
          BlocProvider<IssueListBloc>(
            create: (BuildContext context) => IssueListBloc(),
          ),
          BlocProvider<IssueInfoBloc>(
            create: (BuildContext context) => IssueInfoBloc(),
          ),
          BlocProvider<FixesBloc>(
            create: (BuildContext context) => FixesBloc(),
          ),
          BlocProvider<RedirectBloc>(
            create: (BuildContext context) => RedirectBloc(),
          ),
          BlocProvider<SearchBloc>(
            create: (BuildContext context) => SearchBloc(),
          ),
          BlocProvider<StoryBloc>(
            create: (BuildContext context) => StoryBloc(),
          ),
          BlocProvider<DescriptionBloc>(
            create: (BuildContext context) => DescriptionBloc(),
          ),
        ],
        child: MaterialApp(
            title: 'Flutter Infinite Scroll',
            navigatorKey: NavKey.navigatorKey,
            home: Scaffold(
                appBar: AppBar(
                  title: Text('Aidus'),
                ),
                body: LoginPage())));
  }

//  Widget selectPage() async {
//
//    return LoginPage();
//
//  }

// void prepareFirebase() {
//   _firebaseMessaging.configure(
//     // onMessage: (Map<String, dynamic> message) {
//     //   print('on message $message');

//     // onResume: (Map<String, dynamic> message) {
//     //   print('on resume $message');

//     // },
//     onLaunch: (Map<String, dynamic> message) {
//       print('on launch $message');
//     },
//   );
//   _firebaseMessaging.requestNotificationPermissions(
//       const IosNotificationSettings(sound: true, badge: true, alert: true));
//   _firebaseMessaging.getToken().then((token) {
//     print(token);
//   }).catchError((err) {
//     print(err);
//   });
// }
}
