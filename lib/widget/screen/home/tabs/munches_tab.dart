import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/response/get_munches_response.dart';
import 'package:munch/repository/munch_repository.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/service/munch/munch_event.dart';
import 'package:munch/service/munch/munch_state.dart';
import 'package:munch/service/notification/notifications_bloc.dart';
import 'package:munch/service/notification/notifications_state.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/notifications_handler.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/screen/home/include/create_join_dialog.dart';
import 'package:munch/widget/screen/home/include/empty_munches_list_widget.dart';
import 'package:munch/widget/screen/home/include/review_munch_dialog.dart';
import 'package:munch/widget/screen/home/tabs/munch_list_widget.dart';
import 'package:munch/widget/util/app_circular_progress_indicator.dart';
import 'package:munch/widget/util/custom_button.dart';
import 'package:munch/widget/util/dialog_helper.dart';
import 'package:munch/widget/util/error_list_widget.dart';
import 'package:munch/widget/util/overlay_dialog_helper.dart';

import 'munch_list_widget_skeleton.dart';

class MunchesTab extends StatefulWidget {
  MunchBloc munchBloc;

  MunchesTab({this.munchBloc});

  @override
  MunchesTabState createState() => MunchesTabState(munchBloc: munchBloc);
}

class MunchesTabState extends State<MunchesTab> {
  static const SKELETON_ITEMS_NUMBER = 15;

  // how many DECIDED and UNMODIFIABLE munches should be present to not trigger historical endpoint immediately after getMunches
  static const INITIAL_THRESHOLD_FOR_HISTORICAL_MUNCHES = 6;

  // FocusDetector will use this value to call getMunches again if more than 18 hours passed after last call
  static const GET_MUNCHES_REFRESH_HOURS = 18;

  MunchBloc munchBloc;

  // sent as an argument in order to be used in initState method, widget is null there
  MunchesTabState({this.munchBloc});

  int _currentTab = 0;

  List<Munch> _stillDecidingMunches;
  List<Munch> _decidedMunches;
  List<Munch> _unmodifiableMunches;
  List<Munch> _historicalMunches;

  MunchRepo _munchRepo = MunchRepo.getInstance();

  UniqueKey _focusDetectorKey = UniqueKey();

  bool _showDecidedNotification = false;

  bool _historicalPagesFinished = false;
  bool _getHistoricalPageRequestInProgress = false;

  List<RequestedReview> _requestedReviews;

  void _throwGetMunchesEvent() {
    munchBloc.add(GetMunchesEvent());
  }

  void _throwGetNextHistoricalPageEvent() {
    _getHistoricalPageRequestInProgress = true;

    munchBloc.add(GetHistoricalMunchesPageEvent());
  }

  @override
  void initState() {
    _throwGetMunchesEvent();

    super.initState();
  }

  void _checkMunchCacheRefresh() {
    if (_munchRepo.getMunchesCallLastUTC != null) {
      Duration differenceLastFetch = DateTime.now().toUtc().difference(_munchRepo.getMunchesCallLastUTC);

      if (differenceLastFetch.inHours >= GET_MUNCHES_REFRESH_HOURS) {
        _throwGetMunchesEvent();
      }
    } else {
      _throwGetMunchesEvent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
        key: _focusDetectorKey,
        onFocusGained: () {
          setState(() {
            _checkMunchCacheRefresh();
          }); // refresh data on the screen if screen comes up from background or from Navigator.pop
        },
        child: _buildNotificationsBloc());
  }

  void _munchStatusNotificationListener(BuildContext context, NotificationsState state) {
    if (state is DetailedMunchNotificationState) {
      Munch munch = state.data;

      if (munch.munchStatusChanged && munch.munchStatus == MunchStatus.DECIDED) {
        _showDecidedNotification = true;
      }
    }
    // if we have to listen for anything which will not be automatically done
  }

  Widget _buildNotificationsBloc() {
    return BlocConsumer<NotificationsBloc, NotificationsState>(
        cubit: NotificationsHandler.getInstance().notificationsBloc,
        listenWhen: (NotificationsState previous, NotificationsState current) =>
            (current is DetailedMunchNotificationState || current is CurrentUserKickedNotificationState) &&
            current.ready,
        listener: (BuildContext context, NotificationsState state) => _munchStatusNotificationListener(context, state),
        buildWhen: (NotificationsState previous, NotificationsState current) =>
            current is DetailedMunchNotificationState && current.ready,
        // in every other condition enter builder
        builder: (BuildContext context, NotificationsState state) => _buildMunchesTab());
  }

  Widget _buildMunchesTab() {
    return Padding(
        // top and bottom already set in home screen
        padding: AppDimensions.padding(AppPaddingType.screenOnly).copyWith(left: 0.0, right: 0.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(horizontal: 24.0), child: _headerBar()),
          Padding(padding: EdgeInsets.symmetric(horizontal: 24.0), child: _tabHeaders()),
          Expanded(child: _tabsContent())
        ]));
  }

  Widget _headerBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(App.translate("munches_tab.title"),
            style: AppTextStyle.style(AppTextStylePattern.heading2, fontWeight: FontWeight.w500)),
        _joinButton()
      ],
    );
  }

  Widget _tabHeaders() {
    return Align(
        alignment: Alignment.centerLeft,
        child: DefaultTabController(
            length: 2,
            child: TabBar(
              onTap: (int index) {
                setState(() {
                  _currentTab = index;

                  if (_currentTab == 1) {
                    _showDecidedNotification = false;
                  }
                });
              },
              isScrollable: true,
              // needs to be set to true in order to make Align widget workable
              labelColor: Palette.primary,
              unselectedLabelColor: Palette.secondaryLight,
              indicatorColor: Palette.primary,
              indicatorPadding: EdgeInsets.only(left: 0.0, right: 15.0),
              labelPadding: EdgeInsets.only(left: 0.0, right: 15.0),
              labelStyle: AppTextStyle.style(AppTextStylePattern.body3, fontWeight: FontWeight.w600),
              tabs: [
                Tab(text: App.translate("munches_tab.deciding_tab.title")),
                Tab(
                    child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(App.translate("munches_tab.decided_tab.title")),
                    if (_showDecidedNotification)
                      Padding(
                          padding: EdgeInsets.only(bottom: AppDimensions.scaleSizeToScreen(16.0)),
                          child:
                              Icon(Icons.circle, color: Color(0xFFE60000), size: AppDimensions.scaleSizeToScreen(10.0)))
                  ],
                )),
              ],
            )));
  }

  void _initHistoricalPaginationData() {
    _munchRepo.resetHistoricalMunchesPagination();
    _historicalPagesFinished = false;
  }

  void _openReviewMunchDialog({Munch munch, String imageUrl, bool forcedReview = false}) {
    OverlayDialogHelper(
            widget:
                ReviewMunchDialog(munchBloc: munchBloc, munch: munch, imageUrl: imageUrl, forcedReview: forcedReview),
            isModal: forcedReview)
        .show(context);
  }

  void _showRequestedReviewIfExists() {
    RequestedReview requestedReview;

    if (_requestedReviews.isNotEmpty) {
      requestedReview = _requestedReviews[0];

      _requestedReviews.removeAt(0);

      // for safety reasons
      if (_munchRepo.munchMap.containsKey(requestedReview.munchId)) {
        _openReviewMunchDialog(
            munch: _munchRepo.munchMap[requestedReview.munchId],
            imageUrl: requestedReview.imageUrl,
            forcedReview: true);
      }
    }
  }

  void _getMunchesListener(GetMunchesResponse getMunchesResponse) {
    _stillDecidingMunches = _munchRepo.munchStatusLists[MunchStatus.UNDECIDED];
    _decidedMunches = _munchRepo.munchStatusLists[MunchStatus.DECIDED];
    _unmodifiableMunches = _munchRepo.munchStatusLists[MunchStatus.UNMODIFIABLE];
    _historicalMunches = _munchRepo.munchStatusLists[MunchStatus.HISTORICAL];

    _showDecidedNotification = false;

    _initHistoricalPaginationData();

    if (_decidedMunches.length + _unmodifiableMunches.length < INITIAL_THRESHOLD_FOR_HISTORICAL_MUNCHES) {
      _throwGetNextHistoricalPageEvent();
    }

    _requestedReviews = getMunchesResponse.requestedReviews;

    _showRequestedReviewIfExists();
  }

  void _historicalMunchesPageListener(List<Munch> historicalMunchesPageList) {
    if (historicalMunchesPageList.isEmpty) {
      _historicalPagesFinished = true;
    }

    _getHistoricalPageRequestInProgress = false;
  }

  void _joinMunchListener(Munch joinedMunch) {
    // pop create join dialog
    NavigationHelper.popRoute(context);

    NavigationHelper.navigateToRestaurantSwipeScreen(context, munch: joinedMunch);
  }

  void _reviewMunchListener(data) {
    bool forcedReview = data["forcedReview"];

    if (!forcedReview) {
      Utility.showFlushbar(App.translate("decision_screen.review_munch.successful.text"), context);
    }
  }

  void _listViewsListener(BuildContext context, MunchState state) {
    if (state.hasError) {
      Utility.showErrorFlushbar(state.message, context);
    } else if (state.loading && state is ReviewMunchState) {
      // close review dialog immediately on button click
      NavigationHelper.popRoute(context);

      _showRequestedReviewIfExists();
    } else if (state is MunchesFetchingState) {
      _getMunchesListener(state.data);
    } else if (state is HistoricalMunchesPageFetchingState) {
      _historicalMunchesPageListener(state.data);
    } else if (state is MunchJoiningState) {
      _joinMunchListener(state.data);
    } else if (state is ReviewMunchState) {
      _reviewMunchListener(state.data);
    }
  }

  Widget _tabsContent() {
    return BlocConsumer<MunchBloc, MunchState>(
        cubit: munchBloc,
        listenWhen: (MunchState previous, MunchState current) =>
            current.hasError || current.ready || (current.loading && current is ReviewMunchState),
        listener: (BuildContext context, MunchState state) => _listViewsListener(context, state),
        buildWhen: (MunchState previous, MunchState current) =>
            current is MunchesFetchingState ||
            current is HistoricalMunchesPageFetchingState ||
            (current is MunchJoiningState || current is ReviewMunchState && current.ready),
        builder: (BuildContext context, MunchState state) => _buildListViews(context, state));
  }

  Widget _joinButton() {
    return InkWell(
      child: Text("Join Code", style: TextStyle(color: Colors.grey)),//Text(App.translate("munches_tab.join_button.title")),
      onTap: () {
        DialogHelper(dialogContent: CreateJoinDialog(munchBloc: munchBloc), rootNavigator: true).show(context);
      }
    );
  }

  Widget _buildListViews(BuildContext context, MunchState state) {
    if (state.hasError) {
      return _renderListViews(errorOccurred: true);
    } else if ((state.initial || state.loading) && !(state is HistoricalMunchesPageFetchingState)) {
      return _renderListViews(loading: true);
    } else {
      return _renderListViews();
    }
  }

  Widget _renderListViews({bool errorOccurred = false, bool loading = false}) {
    // IndexedStack must be used instead of TabBarView, because we need unbounded height
    return IndexedStack(index: _currentTab, children: <Widget>[
      _renderStillDecidingTabContent(errorOccurred: errorOccurred, loading: loading),
      _renderDecidedTabContent(errorOccurred: errorOccurred, loading: loading),
    ]);
  }

  Future _refreshListView() async {
    _throwGetMunchesEvent();
  }

  Widget _renderSkeletonWidget(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20.0),
        MunchListWidgetSkeleton(index: index),
        SizedBox(height: 20.0),
      ],
    );
  }

  Widget _listViewSeparator(int index, int length) {
    return Padding(
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      child: Divider(height: 0.0, thickness: 1.5, color: Palette.secondaryLight.withOpacity(0.5)),
    );
  }

  Widget _renderEmptyMunchesListWidget() {
    // Refresh indicator must be placed above scroll view
    return RefreshIndicator(
        color: Palette.secondaryDark,
        onRefresh: _refreshListView,
        // SingleChildScrollView must exist because of RefreshIndicator, otherwise RefreshIndicator won't work if list is empty
        child: CustomScrollView(
            // must be set because of RefreshIndicator
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(hasScrollBody: true, child: EmptyMunchesListWidget(munchBloc: munchBloc)),
            ]));
  }

  Widget _renderErrorMunchesListWidget() {
    // Refresh indicator must be placed above scroll view
    return RefreshIndicator(
        color: Palette.secondaryDark,
        onRefresh: _refreshListView,
        // SingleChildScrollView must exist because of RefreshIndicator, otherwise RefreshIndicator won't work if list is empty
        child: CustomScrollView(
            // must be set because of RefreshIndicator
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(hasScrollBody: true, child: ErrorListWidget(actionCallback: _refreshListView)),
            ]));
  }

  Widget _renderStillDecidingListWidget(bool loading) {
    return RefreshIndicator(
        color: Palette.secondaryDark,
        onRefresh: _refreshListView,
        // SingleChildScrollView must exist because of RefreshIndicator, otherwise RefreshIndicator won't work if list is empty
        child: ListView.separated(
          primary: true,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: loading ? SKELETON_ITEMS_NUMBER : _stillDecidingMunches.length,
          separatorBuilder: (BuildContext context, int index) {
            return _listViewSeparator(index, loading ? SKELETON_ITEMS_NUMBER : _stillDecidingMunches.length);
          },
          itemBuilder: (BuildContext context, int index) {
            if (loading) return _renderSkeletonWidget(index);

            return InkWell(
                onTap: () {
                  NavigationHelper.navigateToRestaurantSwipeScreen(context,
                      munch: _stillDecidingMunches[index], shouldFetchDetailedMunch: true);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: MunchListWidget(munch: _stillDecidingMunches[index]),
                ));
          },
        ));
  }

  Widget _renderStillDecidingTabContent({bool errorOccurred = false, bool loading = false}) {
    if (errorOccurred) {
      return _renderErrorMunchesListWidget();
    } else if (loading || _stillDecidingMunches.length > 0) {
      return _renderStillDecidingListWidget(loading);
    } else {
      return _renderEmptyMunchesListWidget();
    }
  }

  Widget _decidedMunchListItem(Munch munch, int index) {
    return InkWell(
        onTap: () {
          NavigationHelper.navigateToDecisionScreen(context, munch: munch, shouldFetchDetailedMunch: true);
        },
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 24.0, right: 24.0),
            child: MunchListWidget(munch: munch),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
                color: Color(0xFFFBB25B),
                iconWidget: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child:
                            ImageIcon(AssetImage("assets/icons/leaveReview.png"), color: Palette.primary, size: 28.0)),
                  ],
                ),
                onTap: () => _openReviewMunchDialog(munch: munch)),
          ],
        ));
  }

  bool _decidedListViewScrollNotificationHandler(ScrollNotification scrollNotification) {
    if (!_historicalPagesFinished && !_getHistoricalPageRequestInProgress) {
      if (scrollNotification is ScrollEndNotification) {
        if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
          _throwGetNextHistoricalPageEvent();
        }
      }
    }

    return false;
  }

  Widget _renderDecidedListWidget(bool loading) {
    // RefreshIndicator must be placed above scroll view
    return RefreshIndicator(
        color: Palette.secondaryDark,
        onRefresh: _refreshListView,
        // SingleChildScrollView must exist because of RefreshIndicator
        child: NotificationListener<ScrollNotification>(
            onNotification: _decidedListViewScrollNotificationHandler,
            child: SingleChildScrollView(
                // must be set because of RefreshIndicator
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: loading
                        ? SKELETON_ITEMS_NUMBER
                        : _decidedMunches.length + _unmodifiableMunches.length + _historicalMunches.length,
                    padding: EdgeInsets.zero,
                    separatorBuilder: (BuildContext context, int index) {
                      return _listViewSeparator(
                          index,
                          loading
                              ? SKELETON_ITEMS_NUMBER
                              : _decidedMunches.length + _unmodifiableMunches.length + _historicalMunches.length);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      if (loading) return _renderSkeletonWidget(index);

                      Munch munch;

                      if (index < _decidedMunches.length) {
                        munch = _decidedMunches[index];
                      } else if (index < _decidedMunches.length + _unmodifiableMunches.length) {
                        munch = _unmodifiableMunches[index - _decidedMunches.length];
                      } else {
                        munch = _historicalMunches[index - _decidedMunches.length - _unmodifiableMunches.length];
                      }

                      return _decidedMunchListItem(munch, index);
                    },
                  ),
                  if (_getHistoricalPageRequestInProgress)
                    Padding(
                        padding: EdgeInsets.only(
                            top: _decidedMunches.length + _unmodifiableMunches.length + _historicalMunches.length == 0
                                ? 24.0
                                : 0.0,
                            bottom: 24.0),
                        child: AppCircularProgressIndicator())
                ]))));
  }

  /*
    Decided munches are sorted, then unmodifiable munches are rendered sorted
   */
  Widget _renderDecidedTabContent({bool errorOccurred = false, bool loading = false}) {
    if (errorOccurred) {
      return _renderErrorMunchesListWidget();
    } else if (loading ||
        !_historicalPagesFinished ||
        _decidedMunches.length + _unmodifiableMunches.length + _historicalMunches.length > 0) {
      return _renderDecidedListWidget(loading);
    } else {
      return _renderEmptyMunchesListWidget();
    }
  }
}
