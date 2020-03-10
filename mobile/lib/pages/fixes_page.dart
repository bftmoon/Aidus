import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/fixes_bloc.dart';
import '../bloc/event/fixes_event.dart';
import '../bloc/state/fixes_state.dart';
import '../models/fix_info.dart';
import '../widgets/request_widgets.dart';

class FixesPage extends StatelessWidget {
  final String issueId;
  final String uri;

  const FixesPage({Key key, this.issueId, this.uri}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FixesBloc>(context);
    bloc.add(GetFixList(issueId, uri));
    return BlocBuilder<FixesBloc, FixesState>(builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Fixes'),
          ),
          body: _body(bloc, context));
    });
  }

  Widget _body(FixesBloc bloc, BuildContext context) {
    FixesState state = bloc.state;
    if (state is FixesLoading) return RequestWidgets.loading();
    if (state is FixError) return RequestWidgets.error();
    if (state is FixesList)
      return SingleChildScrollView(
          child: ExpansionPanelList(
              expansionCallback: (index, isExpanded) => bloc.add(ExpandList(index, !isExpanded)),
              children: state.fixes
                  .map<ExpansionPanel>((FixInfo info) => ExpansionPanel(
                      headerBuilder: (context, isExpanded) => ListTile(title: Text(info.name)),
                      body: ListTile(
                          title: Column(children: <Widget>[
                        Text(info.description),
                        RaisedButton(child: Text('Run'), onPressed: () => bloc.add(SelectFix(info.id, issueId, uri)))
                      ])),
                      isExpanded: info.isExpanded))
                  .toList()));
    return Center(child: Text((state as FixDone).message));
  }
}
