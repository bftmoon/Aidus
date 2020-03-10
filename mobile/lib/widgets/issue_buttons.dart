import 'package:flutter/material.dart';

import '../exception.dart';
import '../pages/description_page.dart';
import '../pages/fixes_page.dart';
import '../pages/redirect_page.dart';
import '../pages/story_page.dart';
import '../web/api_client.dart';

class IssueButtons {
  static FlatButton story(BuildContext context, String id) {
    return _buildButtonColumn(Theme.of(context).primaryColor, Icons.chrome_reader_mode, 'STORY',
        (context) => StoryPage(issueId: id), context);
  }

  static FlatButton fixes(BuildContext context, String id, String parentUri) {
    return _buildButtonColumn(
        Theme.of(context).primaryColor, Icons.build, 'FIXES', (context) => FixesPage(issueId: id, uri: parentUri), context);
  }

  static FlatButton redirect(BuildContext context, String id) {
    return _buildButtonColumn(Theme.of(context).primaryColor, Icons.perm_identity, 'REDIRECT',
        (context) => RedirectPage(issueId: id), context);
  }

  static FlatButton _buildButtonColumn(
      Color color, IconData icon, String label, WidgetBuilder builder, BuildContext context,
      {bool withAlert = false}) {
    return FlatButton(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        onPressed: () async {
          if (withAlert)
            await showDialog(context: context, builder: builder);
          else
            Navigator.push(context, MaterialPageRoute(builder: builder));
        });
  }

  static FlatButton accept(BuildContext context, String id, bool isRedirect) {
    return _buildButtonColumn(Theme.of(context).primaryColor, Icons.done, 'ACCEPT', (BuildContext context) {
      return SimpleDialog(
        title: const Text('Are you sure that you want accept this issue?'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () async {
              try {
                if (isRedirect)
                  await ApiClient.answerRedirect(id, null, true);
                else
                  await ApiClient.acceptIssue(id);
                Navigator.pop(context);
              } on LoadingException catch (_) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Request error'),
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: () => {Scaffold.of(context).removeCurrentSnackBar()},
                  ),
                ));
              }
            },
            child: const Text('Yes'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
        ],
      );
    }, context);
  }

  static FlatButton decline(BuildContext context, String id) {
    return _buildButtonColumn(
        Theme.of(context).primaryColor,
        Icons.clear,
        'DECLINE',
        (context) => DescriptionPage(
              issueId: id,
              type: IssueRequestType.DECLINE_REDIRECT,
            ),
        context);
  }

  static FlatButton done(BuildContext context, String id) {
    return _buildButtonColumn(
        Theme.of(context).primaryColor,
        Icons.done,
        'DONE',
        (context) => DescriptionPage(
              issueId: id,
              type: IssueRequestType.CLOSE,
            ),
        context);
  }
}
