import 'dart:async';

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:munch/api/api.dart';
import 'package:munch/model/filter.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/secondary_filters.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/filters_repository.dart';
import 'package:munch/service/munch/filter/filters_bloc.dart';
import 'package:munch/service/munch/filter/filters_event.dart';
import 'package:munch/service/munch/filter/filters_state.dart';
import 'package:munch/service/notification/notifications_bloc.dart';
import 'package:munch/service/notification/notifications_state.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/notifications_handler.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/screen/swipe/include/filters_info_dialog.dart';
import 'package:munch/widget/util/app_bar_back_button.dart';
import 'package:munch/widget/util/app_circular_progress_indicator.dart';
import 'package:munch/widget/util/cupertion_alert_dialog_builder.dart';
import 'package:munch/widget/util/custom_button.dart';
import 'package:munch/widget/util/dialog_helper.dart';
import 'package:munch/widget/util/error_page_widget.dart';

class FiltersScreen extends StatefulWidget {
  Munch munch;

  FiltersScreen({this.munch});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> with TickerProviderStateMixin {
  static const double AVATAR_RADIUS = 12.0;
  static const double AVATAR_CONTAINER_PARENT_PERCENT = 0.5;
  static const double AVATAR_SPACING = 4.0;

  // avatar size calculations
  static final double _totalAvatarWidth = (AVATAR_RADIUS * 2 + AVATAR_SPACING);
  static final double _maxAvatarContainerWidth =
      (App.screenWidth - AppDimensions.padding(AppPaddingType.screenWithAppBar).horizontal) *
          AVATAR_CONTAINER_PARENT_PERCENT;
  static final int _maxAvatarsPerRow = (_maxAvatarContainerWidth / _totalAvatarWidth).floor();

  Completer<bool> _popScopeCompleter;

  List<Filter> _whitelistFilters;
  List<Filter> _blacklistFilters;

  List<Filter> _allFilters;
  List<Filter> _topFilters;
  Map<String, Filter> _filtersMap;

  // secondary filters
  String _openTimeButtonLabel = App.translate("filters_screen.secondary_filters.open_now_button_label");
  String _priceFilterButtonLabel = App.translate("filters_screen.secondary_filters.price_button_label");
  DateTime _openTimeFilterSelectedTime;
  bool _openTimeSetToNow = false;
  bool _deliveryOn = false;
  Map<PriceFilter, int> _priceFilters = {};
  Color _deliveryFilterBorderColor = Colors.grey;
  Color _openTimeFilterBorderColor = Colors.grey;
  Color _priceFilterBorderColor = Colors.grey;
  Map<PriceFilter, Color> _priceFilterBorderColors = {};
  double _priceOptionsRowHeight = 0.0;

  // Don't refresh anything on swipe screen if filters are not saved once, return value for a route
  bool _filtersSaved = false;

  final List<Widget> _filtersStatusTexts = [
    Text(App.translate("filters_screen.filter_controls.filter_status.blacklisted.text"),
        style: AppTextStyle.style(AppTextStylePattern.body3, color: Palette.error)),
    Text(App.translate("filters_screen.filter_controls.filter_status.neutral.text"),
        style: AppTextStyle.style(AppTextStylePattern.body3, color: Palette.secondaryLight)),
    Text(App.translate("filters_screen.filter_controls.filter_status.whitelisted.text"),
        style: AppTextStyle.style(AppTextStylePattern.body3, color: Palette.hyperlink))
  ];

  FiltersRepo _filtersRepo = FiltersRepo.getInstance();
  FiltersBloc _filtersBloc;

  bool _selectedFiltersContainerReadonly = true;

  bool _allCuisinesMode = false;

  ScrollController _personalTabScrollController = ScrollController();

  int _currentTab = 0;

  @override
  void initState() {
    _filtersBloc = FiltersBloc();
    _setupSecondaryFilters();

    if (_filtersRepo.allFilters == null || _filtersRepo.topFilters == null) {
      _filtersBloc.add(GetFiltersEvent());
    } else {
      _initializeFilters();
    }

    super.initState();
  }

  @override
  void dispose() {
    _filtersBloc?.close();

    super.dispose();
  }

  void _addFilterToWhitelist(String filterKey) {
    Filter filter = _filtersMap[filterKey];

    filter.filterStatus = FilterStatus.WHITELISTED;
    _whitelistFilters.add(filter);
  }

  void _addFilterToBlacklist(String filterKey) {
    Filter filter = _filtersMap[filterKey];

    filter.filterStatus = FilterStatus.BLACKLISTED;
    _blacklistFilters.add(filter);
  }

  void _setFilterStatus(Filter filter, FilterStatus filterStatus) {
    if (filter.filterStatus == FilterStatus.WHITELISTED) {
      _whitelistFilters.removeWhere((Filter f) => f.key == filter.key);
    } else if (filter.filterStatus == FilterStatus.BLACKLISTED) {
      _blacklistFilters.removeWhere((Filter f) => f.key == filter.key);
    }

    if (filterStatus == FilterStatus.WHITELISTED) {
      _addFilterToWhitelist(filter.key);
    } else if (filterStatus == FilterStatus.BLACKLISTED) {
      _addFilterToBlacklist(filter.key);
    } else if (filterStatus == FilterStatus.NEUTRAL) {
      filter.filterStatus = filterStatus;
    }
  }

  void _initializeFilters() {
    _whitelistFilters = List<Filter>();
    _blacklistFilters = List<Filter>();
    _allFilters = List<Filter>();
    _topFilters = List<Filter>();

    _filtersMap = Map<String, Filter>();

    for (int i = 0; i < _filtersRepo.allFilters.length; i++) {
      Filter clonedFilter = _filtersRepo.allFilters[i].cloneWithStatus(FilterStatus.NEUTRAL);
      // clone filter from Repo, don't need to make dirty objects that will be always alive
      _filtersMap[_filtersRepo.allFilters[i].key] = clonedFilter;
      _allFilters.add(clonedFilter);
    }

    for (int i = 0; i < _filtersRepo.topFilters.length; i++) {
      _topFilters.add(_filtersMap[_filtersRepo.topFilters[i].key]);
    }

    for (int i = 0; i < widget.munch.munchMemberFilters.whitelistFiltersKeys.length; i++) {
      _addFilterToWhitelist(widget.munch.munchMemberFilters.whitelistFiltersKeys[i]);
    }

    for (int i = 0; i < widget.munch.munchMemberFilters.blacklistFiltersKeys.length; i++) {
      _addFilterToBlacklist(widget.munch.munchMemberFilters.blacklistFiltersKeys[i]);
    }
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      automaticallyImplyLeading: false,
      leading: AppBarBackButton(),
      title: Text(App.translate("filters_screen.app_bar.title"),
          style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, fontSizeOffset: 1.0)),
      centerTitle: true,
      backgroundColor: Palette.background,
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 24.0),
            child: CustomButton<FiltersState, FiltersUpdatingState>.bloc(
              cubit: _filtersBloc,
              flat: true,
              // very important to set, otherwise title won't be aligned good
              padding: EdgeInsets.zero,
              color: Colors.transparent,
              textColor: Palette.primary.withOpacity(0.6),
              content: Text(App.translate("filters_screen.app_bar.action.text"),
                  style: AppTextStyle.style(AppTextStylePattern.heading6,
                      fontWeight: FontWeight.w600, fontSizeOffset: 1.0, color: Palette.primary.withOpacity(0.6))),
              onPressedCallback: _onSaveButtonClicked,
            )),
      ],
    );
  }

  bool _checkFiltersChangesMade() {
    List<String> munchWhitelistFiltersKeys = widget.munch.munchMemberFilters.whitelistFiltersKeys;
    List<String> munchBlacklistFiltersKeys = widget.munch.munchMemberFilters.blacklistFiltersKeys;

    bool changesMade = false;

    if ((munchWhitelistFiltersKeys.length + munchBlacklistFiltersKeys.length) ==
        (_whitelistFilters.length + _blacklistFilters.length)) {
      // every single filter should match with _filtersMap statuses, otherwise changes are made
      for (int i = 0; i < munchWhitelistFiltersKeys.length; i++) {
        if (_filtersMap[munchWhitelistFiltersKeys[i]].filterStatus != FilterStatus.WHITELISTED) {
          changesMade = true;
          break;
        }
      }

      // every single filter should match with _filtersMap statuses, otherwise changes are made
      for (int i = 0; i < munchBlacklistFiltersKeys.length; i++) {
        if (_filtersMap[munchBlacklistFiltersKeys[i]].filterStatus != FilterStatus.BLACKLISTED) {
          changesMade = true;
          break;
        }
      }
    } else {
      changesMade = true;
    }

    if (!_getCurrentSecondaryFilters().equals(widget.munch.secondaryFilters)) changesMade = true;

    return changesMade;
  }

  Future<bool> _onWillPopScope(BuildContext context) async {
    if (_checkFiltersChangesMade()) {
      _popScopeCompleter = Completer<bool>();

      CupertinoAlertDialogBuilder().showAlertDialogWidget(context,
          dialogTitle: App.translate("filters_screen.save_changes_alert_dialog.title"),
          dialogDescription: App.translate("filters_screen.save_changes_alert_dialog.description"),
          confirmText: App.translate("filters_screen.save_changes_alert_dialog.confirm_button.text"),
          cancelText: App.translate("filters_screen.save_changes_alert_dialog.cancel_button.text"),
          confirmCallback: _onSaveChangesDialogButtonClicked,
          cancelCallback: _onDiscardChangesDialogButtonClicked);

      // decision will be made after dialog clicking
      bool shouldReturn = await _popScopeCompleter.future;

      if (!shouldReturn) {
        // save button clicked and something is wrong
        return false;
      }
    }

    NavigationHelper.popRoute(context, result: _filtersSaved);

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onWillPopScope(context),
        child:
            Scaffold(appBar: _appBar(context), backgroundColor: Palette.background, body: _buildNotificationsBloc()));
  }

  void _munchStatusNotificationListener(BuildContext context, NotificationsState state) {
    if (state is CurrentUserKickedNotificationState) {
      String munchId = state.data;

      if (widget.munch.id == munchId) {
        NavigationHelper.navigateToHome(context, popAllRoutes: true);
      }
    }
  }

  Widget _buildNotificationsBloc() {
    return BlocConsumer<NotificationsBloc, NotificationsState>(
        cubit: NotificationsHandler.getInstance().notificationsBloc,
        listenWhen: (NotificationsState previous, NotificationsState current) =>
            (current is CurrentUserKickedNotificationState) && current.ready,
        listener: (BuildContext context, NotificationsState state) => _munchStatusNotificationListener(context, state),
        buildWhen: (NotificationsState previous, NotificationsState current) =>
            current is DetailedMunchNotificationState && current.ready,
        // in every other condition enter builder
        builder: (BuildContext context, NotificationsState state) => _buildFiltersBloc());
  }

  void _filtersUpdatingStateListener(FiltersState state) {
    if (state.loading) {
      _selectedFiltersContainerReadonly = true;
    } else {
      _filtersSaved = true;

      // ready
      if (_popScopeCompleter != null) {
        _popScopeCompleter.complete(true);
      } else {
        if (widget.munch.updateSecondaryFiltersFailed) {
          Utility.showFlushbar(App.translate("filters_screen.secondary_filters.update_failed"), context);
        } else {
          Utility.showFlushbar(App.translate("filters_screen.save.successful.message"), context);
        }
      }
    }
  }

  void _forceNavigationToHomeScreen() {
    NavigationHelper.navigateToHome(context, popAllRoutes: true);
  }

  void _filtersScreenListener(BuildContext context, FiltersState state) {
    if (state.hasError) {
      if (state.exception is AccessDeniedException) {
        _forceNavigationToHomeScreen();
      } else {
        if (_popScopeCompleter != null && !_popScopeCompleter.isCompleted) {
          _popScopeCompleter.complete(false);
        }
      }

      Utility.showErrorFlushbar(state.message, context);
    } else if (state is FiltersFetchingState) {
      _initializeFilters();
    } else if (state is FiltersUpdatingState) {
      _filtersUpdatingStateListener(state);
    }
  }

  Widget _buildFiltersBloc() {
    return BlocConsumer<FiltersBloc, FiltersState>(
        cubit: _filtersBloc,
        listenWhen: (FiltersState previous, FiltersState current) =>
            current.hasError || current.ready || (current.loading && current is FiltersUpdatingState),
        listener: (BuildContext context, FiltersState state) => _filtersScreenListener(context, state),
        buildWhen: (FiltersState previous, FiltersState current) => current.loading || current.ready,
        builder: (BuildContext context, FiltersState state) => _buildFiltersScreen(context, state));
  }

  Widget _buildFiltersScreen(BuildContext context, FiltersState state) {
    if (state.hasError) {
      return ErrorPageWidget();
    }

    bool showLoadingIndicator = false;

    if ((state.initial && (_allFilters == null || _topFilters == null)) || state.loading) {
      showLoadingIndicator = true;

      if (state is FiltersUpdatingState) {
        showLoadingIndicator = false;
      }
    }

    if (showLoadingIndicator) {
      return AppCircularProgressIndicator();
    } else {
      return _renderScreen(context);
    }
  }

  Widget _renderScreen(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 12.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          _additionalFiltersRow(),
          Divider(height: 16.0, color: Palette.secondaryLight),
          _priceFilterOptions(),
          _tabHeaders(),
          Expanded(child: _tabsContent())
        ]));
  }

  void _showInfoDialog() {
    DialogHelper(dialogContent: FiltersInfoDialog()).show(context);
  }

  Widget _additionalFiltersRow() {
    return Row(children: [
      Padding(
          child: SingleChildScrollView(
              child: Row(children: [
                SizedBox(width: 18.0),
                _openTimeFilter(),
                SizedBox(width: 16.0),
                _deliveryFilter(),
                SizedBox(width: 16.0),
                _priceFilter(),
                SizedBox(width: 18.0)
              ]),
              scrollDirection: Axis.horizontal),
          padding: EdgeInsets.only(top: 0, bottom: 16.0)),
    ]);
  }

  Widget _openTimeFilter() {
    return OutlineButton(
        onPressed: () {
          _openTimeFilterTapped();
        },
        child: Row(children: [
          Text(_openTimeButtonLabel),
          SizedBox(width: 8.0),
          ImageIcon(AssetImage("assets/icons/arrowDown.png"), size: 16.0)
        ]),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        borderSide: BorderSide(color: _openTimeFilterBorderColor, width: 1),
        padding: EdgeInsets.all(8));
  }

  Widget _deliveryFilter() {
    return OutlineButton(
        onPressed: () => setState(() => _toggleDelivery()),
        child: Row(children: [Text(App.translate("filters_screen.secondary_filters.delivery_button_label"))]),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        borderSide: BorderSide(color: _deliveryFilterBorderColor, width: 1),
        padding: EdgeInsets.all(8));
  }

  Widget _priceFilterOptions() {
    return AnimatedContainer(
      height: _priceOptionsRowHeight,
      child: _priceOptionsRow(),
      duration: Duration(milliseconds: 250),
    );
  }

  Widget _priceOptionsRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _priceFilterOption(PriceFilter.ONE),
      SizedBox(width: 16.0),
      _priceFilterOption(PriceFilter.TWO),
      SizedBox(width: 16.0),
      _priceFilterOption(PriceFilter.THREE),
      SizedBox(width: 16.0),
      _priceFilterOption(PriceFilter.FOUR),
    ]);
  }

  void _togglePrice(PriceFilter price) {
    _priceFilters[price] = _priceFilters[price] == 0 ? 1 : 0;

    setState(() {
      _priceFilterBorderColors[price] = _priceFilters[price] == 1 ? Colors.redAccent : Colors.grey;
      _priceFilterButtonLabel = _priceFiltersToDisplay();
      _priceFilterBorderColor =
          (_priceFilterButtonLabel == App.translate("filters_screen.secondary_filters.price_button_label"))
              ? Colors.grey
              : Colors.redAccent;
    });
  }

  Widget _priceFilterOption(PriceFilter price) {
    return Material(
        type: MaterialType.transparency,
        child: Ink(
          decoration: BoxDecoration(
              border: Border.all(color: _priceFilterBorderColors[price], width: 1.0),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(7)),
          child: InkWell(
            onTap: () => _togglePrice(price),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(_priceFilterAsString(price))),
          ),
        ));
  }

  Widget _priceFilter() {
    return OutlineButton(
        onPressed: () {
          setState(() => _priceOptionsRowHeight = _priceOptionsRowHeight < 50 ? 50 : 0);
        },
        child: Row(children: [
          Text(_priceFilterButtonLabel),
          SizedBox(width: 8.0),
          ImageIcon(AssetImage("assets/icons/arrowDown.png"), size: 16.0)
        ]),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        borderSide: BorderSide(color: _priceFilterBorderColor, width: 1),
        padding: EdgeInsets.all(8));
  }

  void _openTimeFilterTapped() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text(App.translate("filters_screen.secondary_filters.clear_button_label")),
                      onPressed: () {
                        _openNowButtonTapped(context);
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 24.0,
                      ),
                    ),
                    CupertinoButton(
                      child: Text(App.translate("filters_screen.secondary_filters.done_button_label")),
                      onPressed: () {
                        _updateSelectedTime(_openTimeFilterSelectedTime);
                        Navigator.of(context).pop();
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 24.0,
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                  child: CupertinoDatePicker(
                onDateTimeChanged: (value) {
                  _updateSelectedTime(value);
                },
                minimumDate: DateTime.now().subtract(Duration(minutes: 15)),
                minuteInterval: 15,
                initialDateTime: _calculateInitialOpenTime(),
              ))
            ],
          );
        });
  }

  void _toggleDelivery() {
    _deliveryOn = !_deliveryOn;
    _deliveryFilterBorderColor = _deliveryOn ? Colors.redAccent : Colors.grey;
  }

  void _updateSelectedTime(DateTime time) {
    String _displayString;
    if (time.day == DateTime.now().day) {
      _displayString = "Today";
    } else if (time.day == DateTime.now().day + 1) {
      _displayString = "Tomorrow";
    } else {
      final DateFormat dayFormatter = DateFormat('E MMM d');
      _displayString = dayFormatter.format(time);
    }

    final DateFormat timeFormatter = DateFormat('jm');
    final String displayTime = timeFormatter.format(time);

    _openTimeFilterSelectedTime = time;
    _openTimeSetToNow = false;

    setState(() {
      _openTimeFilterBorderColor = Colors.redAccent;
      _openTimeButtonLabel = "Open: " + _displayString + ", " + displayTime;
    });
  }

  Widget _tabHeaders() {
    return Padding(
        padding: AppDimensions.padding(AppPaddingType.screenWithAppBar).copyWith(top: 0.0, bottom: 0.0),
        child: Align(
            alignment: Alignment.centerLeft,
            child: DefaultTabController(
                length: 2,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  TabBar(
                      onTap: (int index) {
                        setState(() {
                          _currentTab = index;
                        });
                      },
                      isScrollable: true,
                      // needs to be set to true in order to make Align widget workable
                      labelColor: Palette.primary,
                      unselectedLabelColor: Palette.secondaryLight,
                      indicatorColor: Palette.primary,
                      indicatorPadding: EdgeInsets.only(left: 0.0, right: 15.0),
                      labelPadding: EdgeInsets.only(left: 0.0, right: 15.0),
                      labelStyle: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.w600),
                      tabs: [
                        Tab(text: App.translate("filters_screen.personal_tab.title")),
                        Tab(text: App.translate("filters_screen.group_tab.title")),
                      ]),
                  GestureDetector(
                    onTap: _showInfoDialog,
                    child: ImageIcon(AssetImage("assets/icons/info.png"), size: 18.0, color: Palette.primary),
                  )
                ]))));
  }

  Widget _tabsContent() {
    return IndexedStack(index: _currentTab, children: <Widget>[_renderPersonalTab(), _renderGroupTab()]);
  }

  Widget _animatedSizeWrapper(Widget child) {
    return AnimatedSize(
        duration: Duration(milliseconds: 1000),
        vsync: this,
        curve: Curves.easeInOut,
        alignment: Alignment(0.0, -1.0),
        // -1.0 means top side will be fixed, bottom is expandable
        child: child);
  }

  Widget _renderPersonalTab() {
    return SingleChildScrollView(
        padding: AppDimensions.padding(AppPaddingType.screenWithAppBar).copyWith(top: 0.0, bottom: 0.0),
        controller: _personalTabScrollController,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _animatedSizeWrapper(_whitelistContainerArea()),
                SizedBox(height: 24.0),
                _animatedSizeWrapper(_blacklistContainerArea()),
                SizedBox(height: 24.0),
                _filtersControlArea()
              ],
            )));
  }

  Widget _renderGroupTab() {
    return SingleChildScrollView(
        padding: AppDimensions.padding(AppPaddingType.screenWithAppBar).copyWith(top: 0.0, bottom: 0.0),
        child: Container(
            padding: EdgeInsets.only(top: 24.0, bottom: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _groupWhitelistCuisines(),
                SizedBox(height: 24.0),
                _groupBlacklistCuisines(),
                SizedBox(height: 12.0),
                Text(App.translate("filters_screen.group_tab.description1.text"),
                    style: AppTextStyle.style(AppTextStylePattern.body2,
                        fontSizeOffset: 2.0, color: Palette.primary.withOpacity(0.5))),
                SizedBox(height: 12.0),
                Text(App.translate("filters_screen.group_tab.description2.text"),
                    style: AppTextStyle.style(AppTextStylePattern.body2,
                        fontSizeOffset: 2.0, color: Palette.primary.withOpacity(0.5)))
              ],
            )));
  }

  Widget _whitelistContainerHeader() {
    return Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(App.translate("filters_screen.whitelist_container.subtitle"),
          style: AppTextStyle.style(AppTextStylePattern.body2,
              fontSizeOffset: 2.0, color: Palette.secondaryLight, fontWeight: FontWeight.w600)),
      CustomButton(
        flat: true,
        // very important to set, otherwise title won't be aligned good
        padding: EdgeInsets.zero,
        color: Colors.transparent,
        content: Text(
            _selectedFiltersContainerReadonly
                ? App.translate("filters_screen.whitelist_container.readonly_state.text")
                : App.translate("filters_screen.whitelist_container.edit_state.text"),
            style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 2.0, color: Palette.hyperlink)),
        onPressedCallback: () {
          setState(() {
            _selectedFiltersContainerReadonly = !_selectedFiltersContainerReadonly;
          });
        },
      )
    ]);
  }

  Widget _fractionallyClickableAreaFiltersContainer(Filter filter) {
    return FractionallySizedBox(
      widthFactor: 0.45,
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          if (!_selectedFiltersContainerReadonly) {
            setState(() {
              _setFilterStatus(filter, FilterStatus.NEUTRAL);
            });
          }
        },
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _selectedFiltersContainer(List<Filter> filters, Color color) {
    return Wrap(
        spacing: 16.0,
        runSpacing: 16.0,
        children: filters
            .map((Filter filter) => ShakeAnimatedWidget(
                enabled: !_selectedFiltersContainerReadonly,
                duration: Duration(milliseconds: 750),
                shakeAngle: Rotation.deg(z: 1),
                curve: Curves.linear,
                child: Stack(children: [
                  Container(
                    padding: EdgeInsets.only(left: 4.0, right: 8.0, top: 2.0, bottom: 2.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0), border: Border.all(width: 1.0, color: color)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!_selectedFiltersContainerReadonly) Icon(Icons.close, color: Palette.error, size: 12.0),
                        SizedBox(width: 4.0),
                        Flexible(
                            fit: FlexFit.loose,
                            child: Text(filter.label,
                                style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500)))
                      ],
                    ),
                  ),
                  // fill will be same size with container below, and we'll take 0.33 from its fractional width to make area clickable
                  // must be define below widget Container widget to be clickable
                  Positioned.fill(child: _fractionallyClickableAreaFiltersContainer(filter)),
                ])))
            .toList());
  }

  Widget _whitelistContainerArea() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _whitelistContainerHeader(),
        SizedBox(height: 24.0),
        _selectedFiltersContainer(_whitelistFilters, Palette.hyperlink)
      ],
    );
  }

  Widget _blacklistContainerHeader() {
    return Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(App.translate("filters_screen.blacklist_container.subtitle"),
          style: AppTextStyle.style(AppTextStylePattern.body2,
              fontSizeOffset: 2.0, color: Palette.secondaryLight, fontWeight: FontWeight.w600)),
      CustomButton(
        flat: true,
        // very important to set, otherwise title won't be aligned good
        padding: EdgeInsets.zero,
        color: Colors.transparent,
        content: Text(
            _selectedFiltersContainerReadonly
                ? App.translate("filters_screen.blacklist_container.readonly_state.text")
                : App.translate("filters_screen.blacklist_container.edit_state.text"),
            style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 2.0, color: Palette.hyperlink)),
        onPressedCallback: () {
          setState(() {
            _selectedFiltersContainerReadonly = !_selectedFiltersContainerReadonly;
          });
        },
      )
    ]);
  }

  Widget _blacklistContainerArea() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _blacklistContainerHeader(),
        SizedBox(height: 24.0),
        _selectedFiltersContainer(_blacklistFilters, Palette.secondaryDark)
      ],
    );
  }

  Widget _previousFilterStatusButton(Filter filter) {
    // InkWell used to force white space to be clickable
    return InkWell(
        onTap: () {
          int filterStatusIndex = filter.filterStatus.index - 1;

          if (filterStatusIndex < 0) {
            filterStatusIndex = FilterStatus.values.length - 1;
          }

          setState(() {
            _setFilterStatus(filter, FilterStatus.values[filterStatusIndex]);
          });
        },
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.arrow_back_ios, color: Palette.secondaryLight, size: 16.0))));
  }

  Widget _nextFilterStatusButton(Filter filter) {
    // InkWell used to force white space to be clickable
    return InkWell(
        onTap: () {
          int filterStatusIndex = filter.filterStatus.index + 1;

          if (filterStatusIndex == FilterStatus.values.length) {
            filterStatusIndex = 0;
          }

          setState(() {
            _setFilterStatus(filter, FilterStatus.values[filterStatusIndex]);
          });
        },
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_forward_ios, color: Palette.secondaryLight, size: 16.0))));
  }

  /*
    Padding are added to all components in the row just to be able to increase clickable area of the arrows
   */
  Widget _filterControlRow(Filter filter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
            fit: FlexFit.loose,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(filter.label,
                    style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500)))),
        SizedBox(width: 4.0),
        Container(
            width: App.REF_DEVICE_WIDTH * 0.4,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // wrapped into expanded to increase tapable area
                Expanded(child: _previousFilterStatusButton(filter)),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: _filtersStatusTexts[_filtersMap[filter.key].filterStatus.index],
                ),
                // wrapped into expanded to increase tapable area
                Expanded(child: _nextFilterStatusButton(filter)),
              ],
            ))
      ],
    );
  }

  Widget _allCuisinesModeLink() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _allCuisinesMode = !_allCuisinesMode;
        });

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (_allCuisinesMode) {
            _personalTabScrollController.animateTo(_personalTabScrollController.offset + App.screenHeight / 2,
                curve: Curves.easeInOut, duration: Duration(milliseconds: 2000));
          } else {
            _personalTabScrollController.animateTo(0.0, curve: Curves.ease, duration: Duration(milliseconds: 1000));
          }
        });
      },
      child: Text(
          _allCuisinesMode
              ? App.translate("filters_screen.filter_controls.all_cuisines_mode.link.text")
              : App.translate("filters_screen.filter_controls.top_cuisines_mode.link.text"),
          style: AppTextStyle.style(AppTextStylePattern.body2,
              fontSizeOffset: 2.0, fontWeight: FontWeight.w600, textDecoration: TextDecoration.underline)),
    );
  }

  Widget _filtersControlArea() {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(App.translate("filters_screen.filters_control.subtitle"),
          style: AppTextStyle.style(AppTextStylePattern.body2,
              fontSizeOffset: 2.0, color: Palette.secondaryLight, fontWeight: FontWeight.w600)),
      SizedBox(height: 20.0),
      ListView(
        padding: EdgeInsets.zero, // must be set because of iOS devices, they will auto-add padding if not set
        primary: false,
        shrinkWrap: true,
        children: [
          for (Filter filter in (_allCuisinesMode ? _allFilters : _topFilters))
            Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              _filterControlRow(filter),
              Divider(thickness: 1.5, color: Palette.secondaryLight.withOpacity(0.3)),
            ])
        ],
      ),
      SafeArea(top: false, right: false, left: false, child: _allCuisinesModeLink())
    ]);
  }

  Widget _userAvatar(User user) {
    return Padding(
      padding: EdgeInsets.only(left: AVATAR_SPACING),
      child: CircleAvatar(backgroundImage: NetworkImage(user.imageUrl), radius: AVATAR_RADIUS),
    );
  }

  Widget _circleAvatar(int number) {
    return Padding(
      padding: EdgeInsets.only(left: AVATAR_SPACING),
      child: CircleAvatar(
          backgroundColor: Palette.secondaryLight,
          child: Text(number.toString() + "+", style: AppTextStyle.style(AppTextStylePattern.body2Inverse)),
          radius: AVATAR_RADIUS),
    );
  }

  Widget _userAvatars(MunchGroupFilter munchGroupFilter) {
    List<Widget> _avatarList = List<Widget>();

    // flag if members array has partial response - that means only auth user is in array
    bool munchMembersNotAvailable = false;

    for (int i = 0; i < munchGroupFilter.userIds.length; i++) {
      if (i + 1 == _maxAvatarsPerRow && _maxAvatarsPerRow < munchGroupFilter.userIds.length) {
        int avatarsLeft = munchGroupFilter.userIds.length - i;
        _avatarList.add(_circleAvatar(avatarsLeft));

        break;
      } else {
        User user = widget.munch.getMunchMember(munchGroupFilter.userIds[i]);

        // if user is not in members array, response is partial
        if (user == null) {
          munchMembersNotAvailable = true;
          break;
        }

        _avatarList.add(_userAvatar(user));
      }
    }

    double avatarContainerWidth;

    // in case members array is partial (just auth user in array), maximum two circles should be returned (one for auth user and rest for other users)
    if (munchMembersNotAvailable) {
      avatarContainerWidth = 2 * _totalAvatarWidth;

      _avatarList.clear();

      _avatarList.add(_userAvatar(widget.munch.members[0]));

      int avatarsLeft = munchGroupFilter.userIds.length - 1;

      if (avatarsLeft > 0) {
        _avatarList.add(_circleAvatar(avatarsLeft));
      }
    } else {
      if (_maxAvatarsPerRow < munchGroupFilter.userIds.length) {
        avatarContainerWidth = _maxAvatarContainerWidth;
      } else {
        avatarContainerWidth = munchGroupFilter.userIds.length * _totalAvatarWidth;
      }
    }

    return SizedBox(
        width: avatarContainerWidth,
        child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end, children: _avatarList));
  }

  Widget _groupCuisinesListItem(MunchGroupFilter munchGroupFilter) {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(_filtersMap[munchGroupFilter.key].label,
                  style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500))),
          SizedBox(width: 4.0),
          _userAvatars(munchGroupFilter)
        ],
      ),
      Divider(height: 24.0, thickness: 1.5, color: Palette.secondaryLight.withOpacity(0.3)),
    ]);
  }

  Widget _groupWhitelistCuisines() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(App.translate("filters_screen.group_tab.whitelist_container.subtitle"),
            style: AppTextStyle.style(AppTextStylePattern.body2,
                fontSizeOffset: 2.0, color: Palette.secondaryLight, fontWeight: FontWeight.w600)),
        SizedBox(height: 24.0),
        ListView(
          padding: EdgeInsets.zero, // must be set because of iOS devices, they will auto-add padding if not set
          primary: false,
          shrinkWrap: true,
          children: [
            for (MunchGroupFilter munchGroupFilter in widget.munch.munchFilters.whitelist)
              _groupCuisinesListItem(munchGroupFilter)
          ],
        )
      ],
    );
  }

  Widget _groupBlacklistCuisines() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(App.translate("filters_screen.group_tab.blacklist_container.subtitle"),
            style: AppTextStyle.style(AppTextStylePattern.body2,
                fontSizeOffset: 2.0, color: Palette.secondaryLight, fontWeight: FontWeight.w600)),
        SizedBox(height: 24.0),
        ListView(
          padding: EdgeInsets.zero, // must be set because of iOS devices, they will auto-add padding if not set
          primary: false,
          shrinkWrap: true,
          children: [
            for (MunchGroupFilter munchGroupFilter in widget.munch.munchFilters.blacklist)
              _groupCuisinesListItem(munchGroupFilter)
          ],
        )
      ],
    );
  }

  void _onSaveButtonClicked() {
    _filtersBloc.add(UpdateAllFiltersEvent(
        oldFilters: widget.munch.secondaryFilters,
        newFilters: _getCurrentSecondaryFilters(),
        whitelistFilters: _whitelistFilters,
        blacklistFilters: _blacklistFilters,
        munchId: widget.munch.id));
  }

  void _onSaveChangesDialogButtonClicked() {
    // close dialog
    NavigationHelper.popRoute(context);

    _onSaveButtonClicked();
  }

  void _onDiscardChangesDialogButtonClicked() {
    // close dialog
    NavigationHelper.popRoute(context);

    _popScopeCompleter.complete(true);
  }

  void _openNowButtonTapped(BuildContext context) {
    _openTimeSetToNow = true;

    setState(() {
      _openTimeButtonLabel = App.translate("filters_screen.secondary_filters.open_now_button_label");
      _openTimeFilterBorderColor = Colors.grey;
    });
    Navigator.of(context).pop();
  }

  DateTime _calculateInitialOpenTime() {
    int interval = 15;
    int factor = (DateTime.now().minute / interval).round();
    int earliestInitialMinute = factor * interval;

    DateTime earliestInitialTime = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, earliestInitialMinute);

    if (_openTimeFilterSelectedTime != null && !_openTimeFilterSelectedTime.isBefore(earliestInitialTime))
      return _openTimeFilterSelectedTime;

    return earliestInitialTime;
  }

  String _priceFiltersToDisplay() {
    List<String> _filtersOn = [];
    _priceFilters.forEach((key, value) {
      if (value == 1) _filtersOn.add(_priceFilterAsString(key));
    });

    if (_filtersOn.isEmpty) {
      return App.translate("filters_screen.secondary_filters.price_button_label");
    } else {
      return _filtersOn.join(", ");
    }
  }

  String _priceFilterAsString(PriceFilter price) {
    switch (price) {
      case PriceFilter.ONE:
        return "\$";
        break;
      case PriceFilter.TWO:
        return "\$\$";
        break;
      case PriceFilter.THREE:
        return "\$\$\$";
        break;
      case PriceFilter.FOUR:
        return "\$\$\$\$";
        break;
    }
    return App.translate("filters_screen.secondary_filters.price_button_label");
  }

  SecondaryFilters _getCurrentSecondaryFilters() {
    SecondaryFilters _currentSecondaryFilters = SecondaryFilters(price: [], openTime: null, transactionTypes: []);
    if (_deliveryOn) _currentSecondaryFilters.transactionTypes.add(FilterTransactionTypes.DELIVERY);

    if (_openTimeFilterSelectedTime != null && !_openTimeSetToNow)
      _currentSecondaryFilters.openTime = _openTimeFilterSelectedTime.toUtc().millisecondsSinceEpoch;

    _priceFilters.forEach((key, value) {
      if (value == 1) _currentSecondaryFilters.price.add(key);
    });

    return _currentSecondaryFilters;
  }

  void _setupSecondaryFilters() {
    if (widget.munch.secondaryFilters.openTime != null) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(widget.munch.secondaryFilters.openTime);
      String _displayString;
      if (time.day == DateTime.now().day) {
        _displayString = "Today";
      } else if (time.day == DateTime.now().day + 1) {
        _displayString = "Tomorrow";
      } else {
        final DateFormat dayFormatter = DateFormat('E MMM d');
        _displayString = dayFormatter.format(time);
      }

      final DateFormat timeFormatter = DateFormat('jm');
      final String displayTime = timeFormatter.format(time);

      _openTimeFilterSelectedTime = time;

      _openTimeFilterBorderColor = Colors.redAccent;
      _openTimeButtonLabel = "Open: " + _displayString + ", " + displayTime;
    } else{
      _openTimeFilterSelectedTime = _calculateInitialOpenTime();
    }

    if (widget.munch.secondaryFilters.transactionTypes.isNotEmpty) {
      _deliveryFilterBorderColor =
          (widget.munch.secondaryFilters.transactionTypes.contains(FilterTransactionTypes.DELIVERY)
              ? Colors.redAccent
              : Colors.grey);
      _deliveryOn =
          widget.munch.secondaryFilters.transactionTypes.contains(FilterTransactionTypes.DELIVERY) ? true : false;
    } else {
      _deliveryFilterBorderColor = Colors.grey;
      _deliveryOn = false;
    }

    if (widget.munch.secondaryFilters.price != null) {
      PriceFilter.values.forEach((price) {
        bool _priceOn = (widget.munch.secondaryFilters.price.contains(price));
        _priceFilters[price] = _priceOn ? 1 : 0;
        _priceFilterBorderColors[price] = _priceOn ? Colors.redAccent : Colors.grey;
      });

      _priceFilterButtonLabel = _priceFiltersToDisplay();
      _priceFilterBorderColor =
          (_priceFilterButtonLabel == App.translate("filters_screen.secondary_filters.price_button_label"))
              ? Colors.grey
              : Colors.redAccent;
    }
  }
}
