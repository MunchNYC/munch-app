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

class MunchesTab extends StatefulWidget {
  @override
  _MunchesTabState createState() => _MunchesTabState();
}

class _MunchesTabState extends State<MunchesTab> {
  MunchBloc _munchBloc;

  int _currentTab = 0;

  List<Munch> _stillDecidingMunches;

  void _throwGetStillDecidingMunchesEvent(){
    _munchBloc.add(GetMunchesEvent());
  }

  @override
  void initState() {
    _munchBloc = MunchBloc();

    _throwGetStillDecidingMunchesEvent();

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

  Widget _tabsContent(){
    // IndexedStack must be used instead of TabBarView, because we need unbounded height
    return IndexedStack(
        index: _currentTab,
        children: <Widget>[
          _stillDecidingListView(),
          // TODO: Decided/Archived list view
          _stillDecidingListView(),
        ]
    );
  }

  void _stillDecidingMunchesListener(BuildContext context, MunchState state){
    if (state.hasError) {
      Utility.showErrorFlushbar(state.message, context);
    } else if(state is MunchesFetchingState){
      _stillDecidingMunches = state.data;
    } else if(state is MunchJoiningState){
      Munch joinedMunch = state.data;

      // refresh list view to show joined munch
      _throwGetStillDecidingMunchesEvent();
      
      Utility.showFlushbar(joinedMunch.name + " - " + App.translate("munches_tab.join_munch.successful.message"), context);
    }
  }

  Widget _stillDecidingListView(){
      return BlocConsumer<MunchBloc, MunchState>(
          bloc: _munchBloc,
          listenWhen: (MunchState previous, MunchState current) => current.hasError || current.ready,
          listener: (BuildContext context, MunchState state) => _stillDecidingMunchesListener(context, state),
          buildWhen: (MunchState previous, MunchState current) =>  current is MunchesFetchingState || (current is MunchJoiningState && current.ready),
          builder: (BuildContext context, MunchState state) => _buildStillDecidingListView(context, state)
      );
  }

  Widget _buildStillDecidingListView(BuildContext context, MunchState state){
    if (state.hasError) {
      return _renderStillDecidingListView(true);
    } else if (state.initial || state.loading)  {
      return Center(child: AppCircularProgressIndicator());
    } else {
      return _renderStillDecidingListView();
    }
  }

  Widget _renderStillDecidingListView([bool errorOccurred = false]){
    // RefreshIndicator must be placed above scroll view
    return RefreshIndicator(
        color: Palette.secondaryDark,
        onRefresh: () async {
          _throwGetStillDecidingMunchesEvent();
        },
        // SingleChildScrollView must exist because of RefreshIndicator, otherwise RefreshIndicator won't work if list is empty
        child: SingleChildScrollView(
          // must be set because of RefreshIndicator
            physics: AlwaysScrollableScrollPhysics(),
            child:
            errorOccurred ? ErrorPageWidget() :
            _stillDecidingMunches.length > 0 ?
            ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: _stillDecidingMunches.length,
                itemBuilder: (BuildContext context, int index){
                  return MunchListWidget(_stillDecidingMunches[index]);
                },
                padding: EdgeInsets.symmetric(vertical: 20.0),
                separatorBuilder: (BuildContext context, int index) {
                    return Divider(height: 40.0, thickness: 1.5, color: Palette.secondaryLight.withOpacity(0.5));
                },
            ) : EmptyListViewWidget(iconData: Icons.people, text: App.translate("munches_tab.still_deciding_list_view.empty.text"))
        )
    );
  }

  void _onPlusButtonClicked(BuildContext context){
    DialogHelper<MunchBloc>(dialogContent: CreateJoinDialog(), bloc: _munchBloc, showCloseIcon: false).show(context);
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