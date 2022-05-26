import 'package:app/src/blocs/reward_points_bloc.dart';
import 'package:app/src/functions.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/reward_points.dart';
import 'package:flutter/material.dart';

class RewardPoints extends StatefulWidget {
  final rewardPointsBloc = RewardPointsBloc();
  @override
  State<RewardPoints> createState() => _RewardPointsState();
}

class _RewardPointsState extends State<RewardPoints> {

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    widget.rewardPointsBloc.getRewardPoints();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.rewardPointsBloc.loadMoreRewardPoints();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RewardPointsModel>(
        stream: widget.rewardPointsBloc.RewardPointsData,
        builder: (context, AsyncSnapshot<RewardPointsModel> snapshot) {
          return snapshot.hasData && snapshot.data != null ? Scaffold(
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  snap: false,
                  floating: false,
                  expandedHeight: 120.0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(AppStateModel().blocks.localeText.total + ' ' + snapshot.data!.points.toString()),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return ListTile(
                      trailing:  Text(snapshot.data!.items[index].points, style: Theme.of(context).textTheme.headline6),
                      title: Text(parseHtmlString(snapshot.data!.items[index].description)),
                      subtitle: Text(snapshot.data!.items[index].dateDisplay),
                    );
                  },
                    childCount: snapshot.data!.items.length,
                  ),
                )
              ],
            ),
          ) : Scaffold(appBar: AppBar(), body: Center(child: CircularProgressIndicator()));
        }
    );
  }
}

