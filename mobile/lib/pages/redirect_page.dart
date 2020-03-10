import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/redirect_bloc.dart';
import '../bloc/event/redirect_event.dart';
import '../bloc/state/redirect_state.dart';
import '../utils/enums.dart';
import '../models/id-name-pair.dart';
import 'search_page.dart';

class RedirectPage extends StatefulWidget {
  final String issueId;

  const RedirectPage({Key key, this.issueId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RedirectPageState(issueId);
}

class _RedirectPageState extends State<RedirectPage> {
  final String issueId;
  RedirectBloc _bloc;
  final TextEditingController _controller = new TextEditingController();

  _RedirectPageState(this.issueId);

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<RedirectBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RedirectBloc, RedirectState>(builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Redirect'),
          ),
          body: _child(state, context));
    });
  }

  Widget _child(RedirectState state, BuildContext context) {
    if (state is DataModifying) {
      return Container(
          padding: EdgeInsets.all(5),
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[
                Text('Group: ' + (state.group == null ? 'All' : state.group.name)),
                FlatButton(child: Text('...'), onPressed: () => _chooseGroup())
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Row(
              children: <Widget>[
                Text('Worker: ' + (state.user == null ? 'None' : state.user.name)),
                FlatButton(child: Text('...'), onPressed: () => _chooseUser(state.group?.id))
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Expanded(
              child: TextField(
                maxLines: null,
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ),
            RaisedButton(
                child: Text('Submit'),
                onPressed: () {
                  if (state.user == null)
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Worker required'),
                      action: SnackBarAction(
                        label: 'OK',
                        onPressed: () => {Scaffold.of(context).removeCurrentSnackBar()},
                      ),
                    ));
                  else {
                    _bloc.add(RedirectSubmitted(issueId, _controller.text));
                  }
                }),
          ]));
    }
    if (state is RequestSuccess) {
      Navigator.pop(context);
    }
    return Center(
      child: state is RequestSending ? CircularProgressIndicator() : Text('Request error'),
    );
  }

  Future<void> _chooseGroup() async {
    final IdNamePair result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage(type: SearchType.GROUP)),
    );
    if (result != null) _bloc.add(GroupAdding(result));
  }

  Future<void> _chooseUser(String groupId) async {
    final IdNamePair result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage(id: groupId, type: SearchType.WORKER)),
    );
    if (result != null) _bloc.add(UserAdding(result));
  }
}
