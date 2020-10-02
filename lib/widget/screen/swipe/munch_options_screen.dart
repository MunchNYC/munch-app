import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/user_repository.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/service/munch/munch_event.dart';
import 'package:munch/service/munch/munch_state.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/screen/swipe/include/kick_member_alert_dialog.dart';
import 'package:munch/widget/screen/swipe/include/leave_munch_alert_dialog.dart';
import 'package:munch/widget/util/app_bar_back_button.dart';
import 'package:munch/widget/util/app_circular_progress_indicator.dart';
import 'package:munch/widget/util/cupertion_alert_dialog_builder.dart';
import 'package:munch/widget/util/custom_button.dart';
import 'package:munch/widget/util/custom_form_field.dart';
import 'package:munch/widget/util/error_page_widget.dart';
import 'package:munch/widget/util/overlay_dialog_helper.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class MunchOptionsScreen extends StatefulWidget{
  Munch munch;

  MunchOptionsScreen({this.munch});

  @override
  State<MunchOptionsScreen> createState() => _MunchOptionsScreenState();
}

class _MunchOptionsScreenState extends State<MunchOptionsScreen>{
  final GlobalKey<FormState> _munchOptionsFormKey = GlobalKey<FormState>();
  bool _munchOptionsFormAutoValidate = false;

  bool _munchNameFieldReadOnly = true;

  FocusNode _munchNameFieldFocusNode = FocusNode();

  TextEditingController _munchNameTextController = TextEditingController();

  String _munchName;
  bool _pushNotificationsEnabled = true;

  Completer<bool> _popScopeCompleter;

  MunchBloc _munchBloc;

  @override
  void initState() {
    _initializeFormFields();

    _munchNameFieldFocusNode.addListener(_onMunchNameFieldFocusChange);

    _munchBloc = MunchBloc();

    super.initState();
  }

  void _initializeFormFields(){
    // cannot set initial value to the Form field if controller is supplied, so initialization must be done here
    _munchNameTextController.text = widget.munch.name;
    _pushNotificationsEnabled = widget.munch.receivePushNotifications;
  }

  @override
  void dispose() {
    _munchBloc?.close();

    _munchNameFieldFocusNode.dispose();

    super.dispose();
  }

  void _onMunchNameFieldFocusChange() {
    if (!_munchNameFieldFocusNode.hasFocus){
      setState(() {
        _munchNameFieldReadOnly = true;
      });
    }
  }

  Widget _appBar(BuildContext context){
    return AppBar(
      elevation: 0.0,
      automaticallyImplyLeading: false,
      leading: AppBarBackButton(),
      backgroundColor: Palette.background,
      actions: <Widget>[
        Padding(padding:
          EdgeInsets.only(right: 24.0),
            child:  CustomButton<MunchState, MunchPreferencesSavingState>.bloc(
              cubit: _munchBloc,
              flat: true,
              // very important to set, otherwise title won't be aligned good
              padding: EdgeInsets.zero,
              color: Colors.transparent,
              textColor: Palette.primary.withOpacity(0.6),
              content: Text(App.translate("options_screen.app_bar.action.text"),
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
    if(widget.munch.name != _munchNameTextController.text || widget.munch.receivePushNotifications != _pushNotificationsEnabled) {
      if(_popScopeCompleter != null){
        _popScopeCompleter.complete(false);
      }

      _popScopeCompleter = Completer<bool>();

      CupertinoAlertDialogBuilder().showAlertDialogWidget(context,
        dialogTitle: App.translate("options_screen.save_changes_alert_dialog.title"),
        dialogDescription:App.translate("options_screen.save_changes_alert_dialog.description"),
        confirmText: App.translate("options_screen.save_changes_alert_dialog.confirm_button.text"),
        cancelText: App.translate("options_screen.save_changes_alert_dialog.cancel_button.text"),
        confirmCallback: _onSaveChangesDialogButtonClicked,
        cancelCallback: _onDiscardChangesDialogButtonClicked
      );

      // decision will be made after dialog clicking
      bool shouldReturn = await _popScopeCompleter.future;

      if(!shouldReturn){
        // save button clicked and something is wrong
        return false;
      }
    }

    NavigationHelper.popRoute(context, rootNavigator: true, result: widget.munch);

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onWillPopScope(context),
        child: Scaffold(
            appBar: _appBar(context),
            backgroundColor: Palette.background,
            body: _buildMunchBloc()
        )
    );
  }

  void _updateMunchWithDetailedData(Munch detailedMunch){
    /*
      Take old data from munch which can be missing from detailedMunch response
      (part of data can be from compactMunch and part of data can be missing because of 206 partial content)
    */
    detailedMunch.merge(widget.munch);

    widget.munch = detailedMunch;
  }

  void _preferencesListener(MunchPreferencesSavingState state){
    _updateMunchWithDetailedData(state.data);

    if(_popScopeCompleter != null){
      _popScopeCompleter.complete(true);
    } else{
      _onWillPopScope(context);
    }
  }

  void _kickMemberListener(KickingMemberState state){
    Munch detailedMunch = state.data['detailedMunch'];

    // if response munch has empty members array (partial result 206)
    if(detailedMunch.members.length == 0){
      String kickedUserId = state.data['kickedUserId'];

      // manually remove user from members list, after that we can merge munches
      widget.munch.members.removeWhere((User user)=> user.uid == kickedUserId);
      widget.munch.numberOfMembers--;
    }

    _updateMunchWithDetailedData(detailedMunch);

    Utility.showFlushbar(App.translate("options_screen.kick_member.successful"), context);
  }

  void _optionsScreenListener(BuildContext context, MunchState state){
    if (state.hasError) {
      Utility.showErrorFlushbar(state.message, context);

      if(_popScopeCompleter != null && !_popScopeCompleter.isCompleted){
        _popScopeCompleter.complete(false);
      }
    } else if(state is MunchPreferencesSavingState){
      _preferencesListener(state);
    } else if(state is KickingMemberState){
      _kickMemberListener(state);
    } else if(state is MunchLeavingState){
      NavigationHelper.navigateToHome(context);
    }
  }

  Widget _buildMunchBloc(){
    return BlocConsumer<MunchBloc, MunchState>(
        cubit: _munchBloc,
        listenWhen: (MunchState previous, MunchState current) => current.hasError || current.ready,
        listener: (BuildContext context, MunchState state) => _optionsScreenListener(context, state),
        buildWhen: (MunchState previous, MunchState current) => current.loading || current.ready,
        builder: (BuildContext context, MunchState state) => _buildOptionsScreen(context, state)
    );
  }

  Widget _buildOptionsScreen(BuildContext context, MunchState state){
    if (state.hasError) {
      return ErrorPageWidget();
    }

    bool showLoadingIndicator = false;

    if (state.loading){
      showLoadingIndicator = true;

      if(state is MunchPreferencesSavingState || state is KickingMemberState){
        showLoadingIndicator = false;
      }
    }

    if(showLoadingIndicator){
      return AppCircularProgressIndicator();
    } else {
      return _renderScreen(context);
    }
  }

  Widget _renderScreen(BuildContext context){
    return SingleChildScrollView(
      padding: AppDimensions.padding(AppPaddingType.screenWithAppBar).copyWith(top: 36.0), // must be 36.0 because label is floating below
      child: Form(
        key: _munchOptionsFormKey,
        autovalidate: _munchOptionsFormAutoValidate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _munchNameRow(),
            Divider(height: 36.0, thickness: 1.0, color: Palette.secondaryLight.withOpacity(0.5)),
            SizedBox(height: 16.0),
            _inviteFriendRow(),
            Divider(height: 36.0, thickness: 1.0, color: Palette.secondaryLight.withOpacity(0.5)),
            SizedBox(height: 16.0),
            _pushNotificationsRow(),
            Divider(height: 36.0, thickness: 1.0, color: Palette.secondaryLight.withOpacity(0.5)),
            SizedBox(height: 4.0),
            _membersList(),
            Divider(height: 36.0, thickness: 1.0, color: Palette.secondaryLight.withOpacity(0.5)),
            SizedBox(height: 4.0),
            _leaveMunchRow(),
          ]
        )
      )
    );
  }

  Widget _munchNameRow(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: CustomFormField(
              labelText: App.translate("options_screen.munch_name_field.label.text"),
              labelStyle: AppTextStyle.style(AppTextStylePattern.heading6,  fontWeight: FontWeight.w500, color: Palette.primary.withOpacity(0.7)),
              textStyle: AppTextStyle.style(
                  AppTextStylePattern.heading6,
                  fontWeight: FontWeight.w500,
                  color: Palette.primary
              ),
              fillColor: Palette.background,
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
              borderRadius: 0.0,
              borderColor: Palette.background,
              readOnly: _munchNameFieldReadOnly,
              focusNode: _munchNameFieldFocusNode,
              controller: _munchNameTextController,
              onSaved: (value) => _munchName = value,
              validator: (value) => _validateMunchName(value),
              errorHasBorders: false
            )
        ),
        SizedBox(width: 12.0),
        CustomButton(
          flat: true,
          // very important to set, otherwise title won't be aligned good
          padding: EdgeInsets.zero,
          color: Colors.transparent,
          content: _munchNameFieldReadOnly
              ? Text(App.translate("options_screen.munch_name_field.readonly_state.text"), style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w400, color: Palette.hyperlink))
              : FaIcon(FontAwesomeIcons.solidTimesCircle, size: 14.0, color: Palette.secondaryLight.withAlpha(150)),
          onPressedCallback: (){
            if(_munchNameFieldReadOnly) {
              setState(() {
                _munchNameFieldReadOnly = false;
                _munchNameFieldFocusNode.requestFocus();
              });
            } else{
              _munchNameTextController.clear();
            }
          },
        )
      ],
    );
  }

  Widget _inviteFriendRow(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: CustomFormField(
              labelText: App.translate("options_screen.munch_link_field.label.text"),
              labelStyle: AppTextStyle.style(AppTextStylePattern.heading6,  fontWeight: FontWeight.w500, color: Palette.primary.withOpacity(0.7)),
              textStyle: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, color: Palette.primary),
              fillColor: Palette.background,
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
              borderRadius: 0.0,
              borderColor: Palette.background,
              initialValue: widget.munch.link,
              readOnly: true,
              onTap: _onMunchLinkClicked,
            )
        ),
        SizedBox(width: 12.0),
        CustomButton(
          flat: true,
          // very important to set, otherwise title won't be aligned good
          padding: EdgeInsets.zero,
          color: Colors.transparent,
          content: Text("Share", style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w400, color: Palette.hyperlink)),
          onPressedCallback: _onShareButtonClicked,
        )
      ],
    );
  }

  Widget _pushNotificationsRow(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: CustomFormField(
              labelText: App.translate("options_screen.push_notifications_field.label.text"),
              labelStyle: AppTextStyle.style(AppTextStylePattern.heading6,  fontWeight: FontWeight.w500, color: Palette.primary.withOpacity(0.7)),
              textStyle: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, color: Palette.primary),
              fillColor: Palette.background,
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
              borderRadius: 0.0,
              borderColor: Palette.background,
              initialValue: App.translate("options_screen.push_notifications_field.value.text"),
              readOnly: true,
              maxLines: 2,
            )
        ),
        SizedBox(width: 12.0),
        CupertinoSwitch(
          value: _pushNotificationsEnabled,
          onChanged: (bool value) {
            setState(()
            {
              _pushNotificationsEnabled = value;
            });
          },
        ),
      ],
    );
  }

  Widget _membersListTrailing(User user){
    if(user.uid == widget.munch.hostUserId){
      return Text(App.translate("options_screen.member_list.host.text"), style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, color: Palette.primary));
    } else if(widget.munch.munchStatus != MunchStatus.ARCHIVED && widget.munch.hostUserId == UserRepo.getInstance().currentUser.uid){
      return CustomButton<MunchState, KickingMemberState>.bloc(
          cubit: _munchBloc,
          flat: true,
          // very important to set, otherwise title won't be aligned good
          padding: EdgeInsets.zero,
          color: Colors.transparent,
          textColor: Palette.error,
          content: Text(App.translate("options_screen.member_list.kick_button.text"), style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, color: Palette.error)),
          onPressedCallback: () => _onKickButtonClicked(user)
      );
    } else {
      return null;
    }
  }

  Widget _membersList(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(App.translate("options_screen.members.title"), style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 1.0, fontWeight: FontWeight.w500, color: Palette.primary.withOpacity(0.7))),
        SizedBox(height: 8.0),
        Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.munch.members.map((User user) =>
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(backgroundImage: NetworkImage(user.photoUrl), radius: 20.0),
                  title: Text(user.displayName, style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, color: Palette.primary), maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: _membersListTrailing(user),
                )
            ).toList()
        )
      ]
    );
  }

  Widget _leaveMunchRow(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(App.translate("options_screen.leave_munch.label.text"), style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, color: Palette.primary)),
        CustomButton<MunchState, MunchLeavingState>.bloc(
          cubit: _munchBloc,
          flat: true,
          // very important to set, otherwise title won't be aligned good
          padding: EdgeInsets.zero,
          color: Colors.transparent,
          content: Text(App.translate("options_screen.leave_munch_button.text"), style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, color: Palette.error)),
          onPressedCallback: _onLeaveButtonClicked
        )
      ],
    );
  }

  String _validateMunchName(String munchName){
    if(munchName.trim().isEmpty){
      return App.translate("options_screen.preferences_form.name_field.required.validation");
    }

    Pattern pattern = r'^([A-Za-z0-9\s]|\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])*$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(munchName)) {
      return App.translate("options_screen.preferences_form.name_field.regex.validation");
    } else{
      return null;
    }
  }

  bool _onSaveButtonClicked(){
    bool validationSuccess = true;

    if (_munchOptionsFormKey.currentState.validate()) {
      _munchOptionsFormKey.currentState.save();

      // close keyboard by giving focus to unnamed node
      FocusScope.of(context).unfocus();

      _munchBloc.add(SaveMunchPreferencesEvent(munchId: widget.munch.id, munchName: _munchName, notificationsEnabled: _pushNotificationsEnabled));
    } else {
      validationSuccess = false;

      _munchOptionsFormAutoValidate = true;
    }

    return validationSuccess;
  }

  void _onMunchLinkClicked(){
    Clipboard.setData(ClipboardData(text: widget.munch.link));

    Utility.showFlushbar(App.translate("options_screen.copy_action.successful"), context, duration: Duration(seconds: 1));
  }

  void _onShareButtonClicked() async{
    await WcFlutterShare.share(
        sharePopupTitle: App.translate("options_screen.share_button.popup.title"),
        text: App.translate("options_screen.share_action.text") + ":\n" + widget.munch.link,
        mimeType: "text/plain"
    );
  }

  void _onKickButtonClicked(User user){
    OverlayDialogHelper(widget: KickMemberAlertDialog(user: user, munchId: widget.munch.id, munchBloc: _munchBloc)).show(context);
  }

  void _onLeaveButtonClicked(){
    OverlayDialogHelper(widget: LeaveMunchAlertDialog(munchId: widget.munch.id, munchBloc: _munchBloc)).show(context);
  }

  void _onSaveChangesDialogButtonClicked(){
    // close dialog
    NavigationHelper.popRoute(context, rootNavigator: true);

    bool validationSuccess = _onSaveButtonClicked();

    if(!validationSuccess){
      _popScopeCompleter.complete(false);
    }
  }

  void _onDiscardChangesDialogButtonClicked(){
    // close dialog
    NavigationHelper.popRoute(context, rootNavigator: true);

    _popScopeCompleter.complete(true);
  }
}


