import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/issues_list_bloc.dart';
import '../bloc/event/request_event.dart';
import '../bloc/state/issues_list_state.dart';
import '../utils/enums.dart';
import '../models/issue_for_list.dart';
import '../utils/jwt_util.dart';
import '../widgets/request_widgets.dart';
import 'issue_info_page.dart';

class IssueListPage extends StatefulWidget {
  @override
  _IssueListPageState createState() => _IssueListPageState();
}

class _IssueListPageState extends State<IssueListPage> {
  final _scrollController = ScrollController();
  IssueListBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _postBloc = BlocProvider.of<IssueListBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IssueListBloc, IssuesListState>(builder: (context, state) {
      return Scaffold(
        body: _child(state),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showModalBottomSheet(context: context, builder: _buildBottomSheet),
          child: Icon(Icons.navigation),
        ),
      );
    });
  }

  Widget _child(IssuesListState state) {
    if (state is IssuesListError) return RequestWidgets.error();
    if (state is IssuesListLoaded) {
      if (state.posts.isEmpty) {
        return Center(
          child: Text('no posts'),
        );
      }
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return index >= state.posts.length ? _bottomLoader() : _listItem(state.posts[index]);
        },
        itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
        controller: _scrollController,
      );
    }
    _postBloc.add(MakeRequest());
    return RequestWidgets.loading();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _listItem(IssueForList issue) {
    return ListTile(
      title: Text(issue.title),
      trailing: Icon(Icons.grade, color: getPriorityColor(issue.priority)),
      subtitle: Text(issue.date + '\n' + issue.status),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IssueInfoPage(id: issue.id)),
        );
      },
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= 200.0) {
      _postBloc.add(MakeRequest());
    }
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        ListTile(
          title: Text('All'),
          onTap: () => _postBloc.add(MakeRequestWithStatusChange(null)),
        ),
        ListTile(
          title: Text('Opened'),
          onTap: () => _postBloc.add(MakeRequestWithStatusChange('opened')),
        ),
        ListTile(
          title: Text('In Process'),
          onTap: () => _postBloc.add(MakeRequestWithStatusChange('in process')),
        ),
        ListTile(
          title: Text('Redirects'),
          onTap: () => _postBloc.add(MakeRequestWithStatusChange('redirect')),
        ),
        ListTile(
          title: Text('Closed'),
          onTap: () => _postBloc.add(MakeRequestWithStatusChange('closed')),
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Log Out'),
          onTap: () {
            Jwt.delete();
            Navigator.popUntil(context, (r) => r.isFirst);
          },
        ),
      ]),
      height: 350,
    );
  }

  Widget _bottomLoader() {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
