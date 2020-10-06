import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/service/munch/munch_event.dart';
import 'package:munch/service/munch/munch_state.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/screen/home/include/create_join_dialog.dart';
import 'package:munch/widget/screen/home/tabs/munch_list_widget.dart';
import 'package:munch/widget/util/app_circular_progress_indicator.dart';
import 'package:munch/widget/util/custom_button.dart';
import 'package:munch/widget/util/dialog_helper.dart';
import 'package:munch/widget/util/empty_list_view_widget.dart';
import 'package:munch/widget/util/error_page_widget.dart';

import 'munch_list_widget_skeleton.dart';

class MunchesTab extends StatefulWidget {
  @override
  MunchesTabState createState() => MunchesTabState();
}

class MunchesTabState extends State<MunchesTab> {
  MunchBloc _munchBloc;

  int _currentTab = 0;

  List<Munch> _stillDecidingMunches;
  List<Munch> _decidedMunches;
  List<Munch> _archivedMunches;

  void _throwGetMunchesEvent(){
    _munchBloc.add(GetMunchesEvent());
  }

  @override
  void initState() {
    _munchBloc = MunchBloc();

    _throwGetMunchesEvent();

    super.initState();
  }

  @override
  void dispose() {
    _munchBloc?.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // top and bottom already set in home screen
      padding: AppDimensions.padding(AppPaddingType.screenOnly),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
           _headerBar(),
           _tabHeaders(),
           Expanded(child: _tabsContent())
        ]
      )
    );
  }

  Widget _headerBar(){
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(App.translate("munches_tab.title"), style: AppTextStyle.style(AppTextStylePattern.heading2)),
          _plusButton(context)
        ],
      );
  }

  Widget _tabHeaders(){
    return Align(
        alignment: Alignment.centerLeft,
        child:  DefaultTabController(
            length: 2,
            child: TabBar(
              onTap: (int index){
                setState(() {
                  _currentTab = index;
                });
              },
              isScrollable: true, // needs to be set to true in order to make Align widget workable
              labelColor: Palette.primary,
              unselectedLabelColor: Palette.secondaryLight,
              indicatorColor: Palette.primary,
              indicatorPadding: EdgeInsets.only(left: 0.0, right: 15.0),
              labelPadding: EdgeInsets.only(left: 0.0, right: 15.0),
              labelStyle: AppTextStyle.style(AppTextStylePattern.body3, fontWeight: FontWeight.w600),
              tabs: [
                Tab(text: App.translate("munches_tab.deciding_tab.title")),
                Tab(text: App.translate("munches_tab.decided_tab.title")),
              ],
            )
        )
    );
  }

  void _listViewsListener(BuildContext context, MunchState state){
    if (state.hasError) {
      Utility.showErrorFlushbar(state.message, context);
    } else if(state is MunchesFetchingState){
      Map<MunchStatus, List<Munch>> munchesStatusMap = state.data;

      _stillDecidingMunches = munchesStatusMap[MunchStatus.UNDECIDED];
      _decidedMunches = munchesStatusMap[MunchStatus.DECIDED];
      _archivedMunches = munchesStatusMap[MunchStatus.ARCHIVED];
    } else if(state is MunchJoiningState){
      Munch joinedMunch = state.data;

      // pop create join dialog
      NavigationHelper.popRoute(context);

      NavigationHelper.navigateToRestaurantSwipeScreen(context, munch: joinedMunch).then((value){
        if(value != null) {
          // refresh list when user comes back to this screen
          _throwGetMunchesEvent();
        }
      });
    }
  }

  Widget _tabsContent(){
    return BlocConsumer<MunchBloc, MunchState>(
        cubit: _munchBloc,
        listenWhen: (MunchState previous, MunchState current) => current.hasError || current.ready,
        listener: (BuildContext context, MunchState state) => _listViewsListener(context, state),
        buildWhen: (MunchState previous, MunchState current) =>  current is MunchesFetchingState || (current is MunchJoiningState && current.ready),
        builder: (BuildContext context, MunchState state) => _buildListViews(context, state)
    );
  }

  Widget _buildListViews(BuildContext context, MunchState state){
    if (state.hasError) {
      return _renderListViews(errorOccurred: true);
    } else if (state.initial || state.loading)  {
      return _renderListViews(loading: true);
    } else {
      return _renderListViews();
    }
  }

  Widget _renderListViews({bool errorOccurred = false, bool loading = false}){
    // IndexedStack must be used instead of TabBarView, because we need unbounded height
    return IndexedStack(
        index: _currentTab,
        children: <Widget>[
          _renderStillDecidingListView(errorOccurred: errorOccurred, loading: loading),
          _renderDecidedArchivedListView(errorOccurred: errorOccurred, loading: loading)
        ]
    );
  }

  Widget _renderStillDecidingListView({bool errorOccurred = false, bool loading = false}){
    // RefreshIndicator must be placed above scroll view
    return RefreshIndicator(
        color: Palette.secondaryDark,
        onRefresh: () async {
          _throwGetMunchesEvent();
        },
        // SingleChildScrollView must exist because of RefreshIndicator, otherwise RefreshIndicator won't work if list is empty
        child: SingleChildScrollView(
          // must be set because of RefreshIndicator
            physics: AlwaysScrollableScrollPhysics(),
            child:
            errorOccurred ? ErrorPageWidget() :
            loading || _stillDecidingMunches.length > 0 ?
            ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: loading ? 15 : _stillDecidingMunches.length,
                itemBuilder: (BuildContext context, int index){
                  if(loading) return MunchListWidgetSkeleton(index: index);

                  return InkWell(
                      onTap: (){
                        NavigationHelper.navigateToRestaurantSwipeScreen(context, munch: _stillDecidingMunches[index], shouldFetchDetailedMunch: true).then((value){
                          _throwGetMunchesEvent();
                        });
                      },
                      child: MunchListWidget(munch: _stillDecidingMunches[index])
                  );
                },
                padding: EdgeInsets.symmetric(vertical: 20.0),
                separatorBuilder: (BuildContext context, int index) {
                    return Divider(height: 40.0, thickness: 1.5, color: Palette.secondaryLight.withOpacity(0.5));
                },
            ) : EmptyListViewWidget(iconData: Icons.people, text: App.translate("munches_tab.still_deciding_list_view.empty.text"))
        )
    );
  }

  Widget _renderDecidedArchivedListView({bool errorOccurred = false, bool loading = false}){
    // RefreshIndicator must be placed above scroll view
    return RefreshIndicator(
        color: Palette.secondaryDark,
        onRefresh: () async {
          _throwGetMunchesEvent();
        },
        // SingleChildScrollView must exist because of RefreshIndicator, otherwise RefreshIndicator won't work if list is empty
        child: SingleChildScrollView(
          // must be set because of RefreshIndicator
            physics: AlwaysScrollableScrollPhysics(),
            child:
            errorOccurred ? ErrorPageWidget() :
            loading || _decidedMunches.length + _archivedMunches.length > 0 ?
            ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: loading ? 15 : _decidedMunches.length + _archivedMunches.length,
              itemBuilder: (BuildContext context, int index){
                if(loading) return MunchListWidgetSkeleton(index: index);

                // InkWell is making empty space clickable also
                return InkWell(
                    onTap: (){
                      NavigationHelper.navigateToDecisionScreen(context, munch: index < _decidedMunches.length ? _decidedMunches[index] : _archivedMunches[index], shouldFetchDetailedMunch: true).then((value){
                        _throwGetMunchesEvent();
                      });
                    },
                    child: MunchListWidget(munch: index < _decidedMunches.length ? _decidedMunches[index] : _archivedMunches[index])
                );
              },
              padding: EdgeInsets.symmetric(vertical: 20.0),
              separatorBuilder: (BuildContext context, int index) {
                return Divider(height: 40.0, thickness: 1.5, color: Palette.secondaryLight.withOpacity(0.5));
              },
            ) : EmptyListViewWidget(iconData: Icons.people, text: App.translate("munches_tab.decided_list_view.empty.text"))
        )
    );
  }

  void _onPlusButtonClicked(BuildContext context){
    DialogHelper(dialogContent: CreateJoinDialog(munchBloc: _munchBloc)).show(context);
  }

  Widget _plusButton(BuildContext context){
    return CustomButton(
      color: Palette.background,
      content: Icon(
        Icons.add,
        size: 30,
        color: Palette.secondaryDark,
      ),
      flat: true,
      onPressedCallback: () => _onPlusButtonClicked(context),
    );
  }

}