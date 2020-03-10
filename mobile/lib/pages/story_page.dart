import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/story_bloc.dart';
import '../bloc/event/stoty_event.dart';
import '../bloc/state/story_state.dart';
import '../models/story_item.dart';
import '../widgets/request_widgets.dart';

class StoryPage extends StatelessWidget {
  final String issueId;

  const StoryPage({Key key, this.issueId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<StoryBloc>(context);
    bloc.add(GetStoryList(issueId));
    return BlocBuilder<StoryBloc, StoryState>(builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Story'),
          ),
          body: _body(bloc, context));
    });
  }

  Widget _body(StoryBloc bloc, BuildContext context) {
    StoryState state = bloc.state;
    if (state is StoryLoading) return RequestWidgets.loading();
    if (state is StoryError) return RequestWidgets.error();

    return SingleChildScrollView(
        child: ExpansionPanelList(
            expansionCallback: (index, isExpanded) => bloc.add(ExpandItem(index, !isExpanded)),
            children: (state as StoryList)
                .story
                .map<ExpansionPanel>((StoryItem info) => ExpansionPanel(
                    headerBuilder: (context, isExpanded) => ListTile(title: Text(info.event)),
                    body: ListTile(
                      title: Column(children: <Widget>[
                        Padding(padding: EdgeInsets.only(bottom: 5), child: Text('Date: ' + info.date)),
                        Text(
                          info.description,
                          softWrap: true,
                        ),
                      ], crossAxisAlignment: CrossAxisAlignment.start),
                    ),
                    isExpanded: info.isExpanded))
                .toList()));
  }
}
