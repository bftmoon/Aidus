import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/description_bloc.dart';
import '../bloc/event/description_event.dart';
import '../bloc/state/description_state.dart';
import '../widgets/request_widgets.dart';

enum IssueRequestType { CLOSE, DECLINE_REDIRECT }

class DescriptionPage extends StatefulWidget {
  final String issueId;
  final IssueRequestType type;

  const DescriptionPage({Key key, this.issueId, this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DescriptionPageState(issueId, type);
}

class _DescriptionPageState extends State<DescriptionPage> {
  final String issueId;
  final IssueRequestType type;

  DescriptionBloc _bloc;
  final TextEditingController _controller = new TextEditingController();

  _DescriptionPageState(this.issueId, this.type);

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<DescriptionBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DescriptionBloc, DescriptionState>(builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: Text(_getText()),
          ),
          body: _child(state, context));
    });
  }

  Widget _child(DescriptionState state, BuildContext context) {
    if (state is InitState) {
      return Container(
          padding: EdgeInsets.all(5),
          child: Column(children: <Widget>[
            Expanded(
              child: TextField(
                maxLines: null,
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                expands: true,
              ),
            ),
            RaisedButton(
                child: Text('Confirm'),
                onPressed: () {
                  _bloc.add(DescriptionSubmitted(issueId, _controller.text, type, context));
                }),
          ]));
    }
    if (state is DescriptionSuccess) {
      Navigator.pop(context);
    }
    if (state is DescriptionSending) return RequestWidgets.loading();
    return RequestWidgets.error();
  }

  String _getText() {
    switch (type) {
      case IssueRequestType.CLOSE:
        return 'Close Issue';
      case IssueRequestType.DECLINE_REDIRECT:
        return 'Decline Description';
    }
    return '';
  }
}
