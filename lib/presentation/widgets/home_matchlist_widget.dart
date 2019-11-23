import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:squazzle/data/models/models.dart';
import 'package:squazzle/domain/domain.dart';
import 'matchlist_item.dart';

class HomeMatchListWidget extends StatefulWidget {
  HomeMatchListWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeMatchListWidgetState();
  }
}

class _HomeMatchListWidgetState extends State<HomeMatchListWidget>
    with AutomaticKeepAliveClientMixin<HomeMatchListWidget> {
  HomeMatchListBloc bloc;

  @override
  void initState() {
    bloc = BlocProvider.of<HomeMatchListBloc>(context);
    bloc.setup();
    bloc.emitEvent(HomeMatchListEvent.start());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocEventStateBuilder<HomeMatchListEvent, HomeMatchListState>(
          bloc: bloc,
          builder: (context, state) {
            switch (state.type) {
              case HomeMatchListStateType.init:
                return init(state.activeMatches, state.pastMatches, state.user);
                break;
              case HomeMatchListStateType.fetching:
                return fetching();
                break;
              case HomeMatchListStateType.empty:
                return showMessage('no active nor past matches stored');
                break;
              case HomeMatchListStateType.error:
                return showMessage(state.message);
                break;
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  Future<Null> _onRefresh() async {
    bloc.emitEvent(HomeMatchListEvent.updateMatches());
  }

  Widget init(
      List<ActiveMatch> activeMatches, List<PastMatch> pastMatches, User user) {
    return ListView.builder(
      itemCount: activeMatches.length + pastMatches.length,
      itemBuilder: (context, index) {
        return index < activeMatches.length
            ? activeItem(activeMatches[index], user)
            : PastMatchItem(
                pastMatch: pastMatches[index - activeMatches.length],
                user: user);
      },
    );
  }

  Widget activeItem(ActiveMatch activeMatch, User user) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: bloc.connChange,
      builder: (context, snapshot) {
        return ActiveMatchItem(
          activeMatch: activeMatch,
          isOnline: snapshot.data,
          user: user,
        );
      },
    );
  }

  Widget fetching() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitRotatingPlain(
            color: Colors.blue[100],
            size: 60.0,
          ),
          SizedBox(height: 40),
          Text(
            'retrieving matches...',
            style: TextStyle(
                color: Colors.blue[300],
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: 2.0),
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget showMessage(String message) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return index == 0
            ? SizedBox(height: 160)
            : Center(
                child: Text(
                  message,
                  style: TextStyle(
                      color: Colors.blue[300],
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2.0),
                ),
              );
      },
    );
  }

  Widget empty() {
    return Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'no active nor past matches stored',
              style: TextStyle(
                  color: Colors.blue[300],
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.0),
            ),
            SizedBox(height: 60),
          ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
