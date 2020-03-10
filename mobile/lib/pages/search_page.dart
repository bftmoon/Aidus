import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/search_bloc.dart';
import '../bloc/event/search_event.dart';
import '../bloc/state/search_state.dart';
import '../utils/enums.dart';
import '../widgets/request_widgets.dart';

class SearchPage extends StatelessWidget {
  final String id;
  final SearchType type;

  const SearchPage({Key key, this.id, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SearchBloc>(context);
    bloc.add(AddingParam(type, id));
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(type == SearchType.WORKER? 'Workers': 'Groups'),
          ),
          body: child(bloc, state),
        );
      },
    );
  }

  Widget child(bloc, state) {
    if (state is DataUninitialized) return RequestWidgets.loading();
    if (state is DataError) return RequestWidgets.error();
    return _list(state, bloc);
  }

  Widget _list(SearchDataUpdated state, bloc) {
    return Container(
        child: Column(children: <Widget>[
      TextField(
        onChanged: (search) => bloc.add(InputUpdate(search)),
        decoration: InputDecoration(
          labelText: 'Search',
          prefixIcon: Icon(Icons.search),
        ),
      ),
      Expanded(
          child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(state.data[index].name),
                  onTap: () => Navigator.pop(context, state.data[index]),
                );
              },
              itemCount: state.data.length))
    ]));
  }
}
