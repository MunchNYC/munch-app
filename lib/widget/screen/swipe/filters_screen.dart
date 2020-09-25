import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munch/model/filter.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/repository/filters_repository.dart';
import 'package:munch/service/munch/filter/filters_bloc.dart';
import 'package:munch/service/munch/filter/filters_event.dart';
import 'package:munch/service/munch/filter/filters_state.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/util/app_bar_back_button.dart';
import 'package:munch/widget/util/app_circular_progress_indicator.dart';
import 'package:munch/widget/util/cupertion_alert_dialog_builder.dart';
import 'package:munch/widget/util/custom_button.dart';
import 'package:munch/widget/util/error_page_widget.dart';

class FiltersScreen extends StatefulWidget{
  Munch munch;

  FiltersScreen({this.munch});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen>{
  Completer<bool> _popScopeCompleter;

  List<Filter> _whitelistFilters;
  List<Filter> _blacklistFilters;
  
  List<Filter> _allFilters;
  List<Filter> _topFilters;

  Map<String, Filter> _filtersMap;

  final List<Widget> _filtersStatusTexts = [
    Text(App.translate("filters_screen.filter_controls.filter_status.blacklisted.text"), style: AppTextStyle.style(AppTextStylePattern.body3, color: Palette.error)),
    Text(App.translate("filters_screen.filter_controls.filter_status.neutral.text"), style: AppTextStyle.style(AppTextStylePattern.body3, color: Palette.secondaryLight)),
    Text(App.translate("filters_screen.filter_controls.filter_status.whitelisted.text"), style: AppTextStyle.style(AppTextStylePattern.body3, color: Palette.hyperlink))
  ];

  FiltersRepo _filtersRepo = FiltersRepo.getInstance();
  FiltersBloc _filtersBloc;

  bool _whitelistContainerReadonly = true;
  bool _blacklistContainerReadonly = true;

  bool _allCuisinesMode = false;

  int _currentTab = 0;

  @override
  void initState() {
    _filtersBloc = FiltersBloc();

    if(_filtersRepo.allFilters == null || _filtersRepo.topFilters == null){
      _filtersBloc.add(GetFiltersEvent());
    } else{
      _initializeFilters();
    }

    super.initState();
  }

  @override
  void dispose() {
    _filtersBloc?.close();

    super.dispose();
  }


  void _addFilterToWhitelist(String filterKey){
    Filter filter = _filtersMap[filterKey];

    filter.filterStatus = FilterStatus.WHITELISTED;
    _whitelistFilters.add(filter);
  }

  void _addFilterToBlacklist(String filterKey){
    Filter filter = _filtersMap[filterKey];

    filter.filterStatus = FilterStatus.BLACKLISTED;
    _blacklistFilters.add(filter);
  }

  void _setFilterStatus(Filter filter, FilterStatus filterStatus){
    if(filter.filterStatus == FilterStatus.WHITELISTED) {
      _whitelistFilters.removeWhere((Filter f) => f.key == filter.key);
    } else if(filter.filterStatus == FilterStatus.BLACKLISTED) {
      _blacklistFilters.removeWhere((Filter f) => f.key == filter.key);
    }

    if(filterStatus == FilterStatus.WHITELISTED){
      _addFilterToWhitelist(filter.key);
    } else if(filterStatus == FilterStatus.BLACKLISTED){
      _addFilterToBlacklist(filter.key);
    } else if(filterStatus == FilterStatus.NEUTRAL) {
      filter.filterStatus = filterStatus;
    }
  }

  void _initializeFilters(){
    _whitelistFilters = List<Filter>();
    _blacklistFilters = List<Filter>();
    _allFilters = List<Filter>();
    _topFilters = List<Filter>();
    
    _filtersMap = Map<String, Filter>();

    for(int i = 0; i < _filtersRepo.allFilters.length; i++){
      Filter clonedFilter = _filtersRepo.allFilters[i].cloneWithStatus(FilterStatus.NEUTRAL);
      // clone filter from Repo, don't need to make dirty objects that will be always alive
      _filtersMap[_filtersRepo.allFilters[i].key] = clonedFilter;
      _allFilters.add(clonedFilter);
    }

    for(int i = 0; i < _filtersRepo.topFilters.length; i++){
      _topFilters.add(_filtersMap[_filtersRepo.topFilters[i].key]);
    }

    for(int i = 0; i < widget.munch.whitelistFiltersKeys.length; i++){
      _addFilterToWhitelist(widget.munch.whitelistFiltersKeys[i]);
    }

    for(int i = 0; i < widget.munch.blacklistFiltersKeys.length; i++){
      _addFilterToBlacklist(widget.munch.blacklistFiltersKeys[i]);
    }
  }

  Widget _appBar(BuildContext context){
    return AppBar(
      elevation: 0.0,
      automaticallyImplyLeading: false,
      leading: AppBarBackButton(),
      title: Text(App.translate("filters_screen.app_bar.title"), style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500)),
      backgroundColor: Palette.background,
      actions: <Widget>[
        Padding(padding:
        EdgeInsets.only(right: 24.0),
            child:  CustomButton.bloc(
              cubit: _filtersBloc,
              flat: true,
              // very important to set, otherwise title won't be aligned good
              padding: EdgeInsets.zero,
              color: Colors.transparent,
              textColor: Palette.primary.withOpacity(0.6),
              content: Text(App.translate("filters_screen.app_bar.action.text"),
                  style: AppTextStyle.style(AppTextStylePattern.heading6,
                      fontWeight: FontWeight.w600,
                      fontSizeOffset: 1.0,
                      color: Palette.primary.withOpacity(0.6))),
              onPressedCallback: _onSaveButtonClicked,
            )
        ),
      ],
    );
  }

  Future<bool> _onWillPopScope(BuildContext context) async {
    // TODO: put condition are changes dirty
   /* if(widget.munch.name != _munchNameTextController.text || widget.munch.receivePushNotifications != _pushNotificationsEnabled) {*/
      _popScopeCompleter = Completer<bool>();

      CupertinoAlertDialogBuilder().showAlertDialogWidget(context,
          dialogTitle: App.translate("filters_screen.save_changes_alert_dialog.title"),
          dialogDescription:App.translate("filters_screen.save_changes_alert_dialog.description"),
          confirmText: App.translate("filters_screen.save_changes_alert_dialog.confirm_button.text"),
          cancelText: App.translate("filters_screen.save_changes_alert_dialog.cancel_button.text"),
          confirmCallback: _onSaveChangesDialogButtonClicked,
          cancelCallback: _onDiscardChangesDialogButtonClicked
      );

      // decision will be made after dialog clicking
      bool shouldReturn = await _popScopeCompleter.future;

      if(!shouldReturn){
        // save button clicked and something is wrong
        return false;
      }
    /*}*/

    NavigationHelper.popRoute(context, rootNavigator: true);

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onWillPopScope(context),
        child: Scaffold(
            appBar: _appBar(context),
            backgroundColor: Palette.background,
            body: _buildFiltersBloc()
        )
    );
  }

  void _filtersScreenListener(BuildContext context, FiltersState state){
    if (state.hasError) {
      Utility.showErrorFlushbar(state.message, context);
    } else if(state is FiltersFetchingState){
      _initializeFilters();
    }
  }

  Widget _buildFiltersBloc(){
    return BlocConsumer<FiltersBloc, FiltersState>(
        cubit: _filtersBloc,
        listenWhen: (FiltersState previous, FiltersState current) => current.hasError || current.ready,
        listener: (BuildContext context, FiltersState state) => _filtersScreenListener(context, state),
        buildWhen: (FiltersState previous, FiltersState current) => current.loading || current.ready,
        builder: (BuildContext context, FiltersState state) => _buildFiltersScreen(context, state)
    );
  }

  Widget _buildFiltersScreen(BuildContext context, FiltersState state){
    if (state.hasError) {
      return ErrorPageWidget();
    }

    bool showLoadingIndicator = false;

    if ((state.initial && (_allFilters == null || _topFilters == null))|| state.loading){
      showLoadingIndicator = true;
    }

    if(showLoadingIndicator){
      return AppCircularProgressIndicator();
    } else {
      return _renderScreen(context);
    }
  }

  Widget _renderScreen(BuildContext context){
    return SingleChildScrollView(
        padding: AppDimensions.padding(AppPaddingType.screenWithAppBar).copyWith(top: 12.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _tabHeaders(),
              _tabsContent()
            ]
        )
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
              labelStyle: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.w600),
              tabs: [
                Tab(text: App.translate("filters_screen.personal_tab.title")),
                Tab(text: App.translate("filters_screen.group_tab.title")),
              ]
            )
        )
    );
  }

  Widget _tabsContent(){
    return IndexedStack(
        index: _currentTab,
        children: <Widget>[
          _renderPersonalTab(),
          _renderGroupTab()
        ]
    );
  }

  Widget _renderPersonalTab(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _whitelistContainerArea(),
          SizedBox(height: 24.0),
          _blacklistContainerArea(),
          SizedBox(height: 24.0),
          _filtersControlArea()
        ],
      )
    );
  }

  Widget _whitelistContainerHeader(){
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Text(App.translate("filters_screen.whitelist_container.subtitle"), style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 2.0, color: Palette.secondaryLight, fontWeight: FontWeight.w600)),
          CustomButton(
            flat: true,
            // very important to set, otherwise title won't be aligned good
            padding: EdgeInsets.zero,
            color: Colors.transparent,
            content: Text(_whitelistContainerReadonly ?
            App.translate("filters_screen.whitelist_container.readonly_state.text")
                : App.translate("filters_screen.whitelist_container.edit_state.text"),
                style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 2.0, color: Palette.hyperlink)),
            onPressedCallback: (){
              setState(() {
                _whitelistContainerReadonly = !_whitelistContainerReadonly;
              });
            },
          )
        ]
    );
  }

  Widget _filterRemoveIcon(Filter filter){
    return GestureDetector(
      onTap: (){
        setState(() {
          _setFilterStatus(filter, FilterStatus.NEUTRAL);
        });
      },
      child: Icon(Icons.close, color: Palette.error, size: 12.0),
    );
  }

  Widget _whitelistContainerFilters(){
    return Wrap(
        spacing: 16.0,
        runSpacing: 16.0,
        children: _whitelistFilters.map((Filter filter) =>
            Container(
              padding: EdgeInsets.only(left: 4.0, right: 8.0, top: 2.0, bottom: 2.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                      width: 1.0,
                      color: Palette.hyperlink
                  )
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(!_whitelistContainerReadonly)
                    _filterRemoveIcon(filter),
                  SizedBox(width: 4.0),
                  Flexible(
                      fit: FlexFit.loose,
                      child: Text(filter.label, style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500))
                  )
                ],
              ),
            )
        ).toList()
    );
  }

  Widget _whitelistContainerArea(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _whitelistContainerHeader(),
        SizedBox(height: 24.0),
        _whitelistContainerFilters()
      ],
    );
  }


  Widget _blacklistContainerHeader(){
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Text(App.translate("filters_screen.blacklist_container.subtitle"), style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 2.0, color: Palette.secondaryLight, fontWeight: FontWeight.w600)),
          CustomButton(
            flat: true,
            // very important to set, otherwise title won't be aligned good
            padding: EdgeInsets.zero,
            color: Colors.transparent,
            content: Text(_blacklistContainerReadonly ?
            App.translate("filters_screen.blacklist_container.readonly_state.text")
                : App.translate("filters_screen.blacklist_container.edit_state.text"),
                style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 2.0, color: Palette.hyperlink)),
            onPressedCallback: (){
              setState(() {
                _blacklistContainerReadonly = !_blacklistContainerReadonly;
              });
            },
          )
        ]
    );
  }

  Widget _blacklistContainerFilters(){
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: _blacklistFilters.map((Filter filter) =>
          Container(
            padding: EdgeInsets.only(left: 4.0, right: 8.0, top: 2.0, bottom: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                    width: 1.0,
                    color: Palette.secondaryDark
                )
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(!_blacklistContainerReadonly)
                  _filterRemoveIcon(filter),
                SizedBox(width: 4.0),
                Flexible(
                    fit: FlexFit.loose,
                    child: Text(filter.label, style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500))
                )
              ],
            ),
          )
      ).toList()
    );
  }

  Widget _blacklistContainerArea(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _blacklistContainerHeader(),
        SizedBox(height: 24.0),
        _blacklistContainerFilters()
      ],
    );
  }

  Widget _previousFilterStatusButton(Filter filter){
    return GestureDetector(
      onTap: (){
        int filterStatusIndex = filter.filterStatus.index - 1;

        if(filterStatusIndex < 0){
          filterStatusIndex = FilterStatus.values.length - 1;
        }

        setState(() {
          _setFilterStatus(filter, FilterStatus.values[filterStatusIndex]);
        });
      },
      child: Icon(Icons.arrow_back_ios, color: Palette.secondaryLight, size: 16.0),
    );
  }

  Widget _nextFilterStatusButton(Filter filter){
    return GestureDetector(
      onTap: (){
        int filterStatusIndex = filter.filterStatus.index + 1;

        if(filterStatusIndex == FilterStatus.values.length){
          filterStatusIndex = 0;
        }

        setState(() {
          _setFilterStatus(filter, FilterStatus.values[filterStatusIndex]);
        });
      },
      child: Icon(Icons.arrow_forward_ios, color: Palette.secondaryLight, size: 16.0),
    );
  }
  
  Widget _filterControlRow(Filter filter){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
            fit: FlexFit.loose,
            child:Text(filter.label, style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500))
        ),
        SizedBox(width: 4.0),
        Container(
            width: App.REF_DEVICE_WIDTH * 0.4,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _previousFilterStatusButton(filter),
                _filtersStatusTexts[_filtersMap[filter.key].filterStatus.index],
                _nextFilterStatusButton(filter),
              ],
            )
        )

      ],
    );
  }

  Widget _allCuisinesModeLink(){
    return GestureDetector(
      onTap: (){
        setState(() {
          _allCuisinesMode = !_allCuisinesMode;
        });
      },
      child: Text(_allCuisinesMode ?
      App.translate("filters_screen.filter_controls.all_cuisines_mode.link.text")
          : App.translate("filters_screen.filter_controls.top_cuisines_mode.link.text"),
          style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 2.0, fontWeight: FontWeight.w600,
              textDecoration: TextDecoration.underline)),
    );
  }

  Widget _filtersControlArea(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(App.translate("filters_screen.filters_control.subtitle"), style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 2.0, color: Palette.secondaryLight, fontWeight: FontWeight.w600)),
        SizedBox(height: 20.0),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           for(Filter filter in (_allCuisinesMode ? _allFilters : _topFilters))
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 _filterControlRow(filter),
                 Divider(height: 32.0, thickness: 2.0, color: Palette.secondaryLight.withOpacity(0.3)),
              ]
             )
          ],
        ),
        _allCuisinesModeLink()
      ]
    );
  }

  Widget _renderGroupTab(){
    return Container();
  }

  void _onSaveButtonClicked(){

  }

  void _onSaveChangesDialogButtonClicked(){
    // close dialog
    NavigationHelper.popRoute(context, rootNavigator: true);

    _onSaveButtonClicked();

    _popScopeCompleter.complete(false);
  }

  void _onDiscardChangesDialogButtonClicked(){
    // close dialog
    NavigationHelper.popRoute(context, rootNavigator: true);

    _popScopeCompleter.complete(true);
  }
}