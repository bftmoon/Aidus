import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/issue_info_bloc.dart';
import '../bloc/event/request_event.dart';
import '../bloc/state/request_state.dart';
import '../utils/enums.dart';
import '../models/issue.dart';
import '../widgets/issue_buttons.dart';
import '../widgets/request_widgets.dart';

class IssueInfoPage extends StatelessWidget {
  final String id;

  const IssueInfoPage({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<IssueInfoBloc>(context);
    bloc.add(MakeRequestWithParam(id));
    return BlocBuilder<IssueInfoBloc, RequestState>(
        bloc: bloc,
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Issue'),
              ),
              body: _child(bloc, context));
        });
  }

  Widget _child(IssueInfoBloc bloc, BuildContext context) {
    if (bloc.state is BeforeResponse) {
      return RequestWidgets.loading();
    }
    if (bloc.state is RequestError) {
      return RequestWidgets.error();
    }
    Color color = Theme.of(context).primaryColor;
    EdgeInsets cardPadding = EdgeInsets.all(5);
    double maxWidth = MediaQuery.of(context).size.width;
    Issue issue = (bloc.state as RequestDone).data;
    return SingleChildScrollView(
        child: Container(
            child: Column(children: <Widget>[
      Card(
          child: Container(
              padding: cardPadding,
              child: Column(
                children: <Widget>[
                  Text(issue.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  Row(children: [
                    Row(children: [
                      Chip(
                        backgroundColor: getPriorityColor(issue.priority),
                        label: Text(issue.priority.toString()),
                      )
                    ]),
                    Text(issue.status.toString())
                  ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                ],
              ))),
      Card(child: Container(padding: cardPadding, width: maxWidth, child: Text(issue.datesString()))),
      Card(child: Container(padding: cardPadding, width: maxWidth, child: Text(issue.labelsString()))),
      Card(child: Container(padding: cardPadding, width: maxWidth, child: Text(issue.description, softWrap: true))),
      Card(
          child: Container(
        child: _buildButtons(issue, color, context),
        padding: cardPadding,
      ))
    ])));
  }

  Widget _buildButtons(Issue issue, Color color, BuildContext context) {
    List<FlatButton> buttons = new List<FlatButton>();
    switch (issue.status) {
      case 'OPENED':
        buttons.add(IssueButtons.accept(context, id, false));
        break;
      case 'IN PROCESS':
        if (issue.parentUrl != null && issue.parentUrl != '') buttons.add(IssueButtons.fixes(context, id, issue.parentUrl));
        buttons.addAll([
          IssueButtons.story(context, id),
          IssueButtons.redirect(context, id),
          IssueButtons.done(context, id),
        ]);
        break;
      case 'REDIRECT':
        buttons.addAll([
          IssueButtons.story(context, id),
          IssueButtons.accept(context, id, true),
          IssueButtons.decline(context, id)
        ]);
        break;
      case 'CLOSED':
        buttons.add(IssueButtons.story(context, id));
        break;
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: buttons);
  }
}
