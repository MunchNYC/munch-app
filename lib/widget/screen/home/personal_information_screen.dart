import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munch/model/user.dart';
import 'package:munch/service/profile/profile_bloc.dart';
import 'package:munch/service/profile/profile_state.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/notifications_handler.dart';
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
import 'package:munch/util/utility.dart';

class PersonalInformationScreen extends StatefulWidget {
  User user;

  PersonalInformationScreen({this.user});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final GlobalKey<FormState> _personalInformationFormKey = GlobalKey<FormState>();
  bool _personalInformationFormAutoValidate = false;
  FocusNode _nameFieldFocusNode = FocusNode();
  String _fullName;

  TextEditingController _nameTextController = TextEditingController();

  ProfileBloc _profileBloc;

  @override
  void initState() {
    _initializeFormFields();
    _nameFieldFocusNode.addListener(_onFirstNameFieldFocusChange);
    _profileBloc = ProfileBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPopScope(context),
      child: Scaffold(
        appBar: _appBar(context),
        backgroundColor: Palette.background,
        body: _buildPersonalInformationBloc()
      )
    );
  }

  @override
  void dispose() {
    _profileBloc?.close();
    _nameFieldFocusNode.dispose();
    super.dispose();
  }

  Widget _buildPersonalInformationBloc() {
    return BlocConsumer<ProfileBloc, ProfileState>(
        cubit: _profileBloc,
        listenWhen: (ProfileState previous, ProfileState current) => current.hasError || current.ready,
        listener: (BuildContext context, ProfileState state) => _personalInformationScreenListener(context, state),
        buildWhen: (ProfileState previous, ProfileState current) => current.loading || current.ready,
        builder: (BuildContext context, ProfileState state) => _buildPersonalInformationScreen(context, state)
    );
  }

  void _personalInformationScreenListener(BuildContext context, ProfileState state) {
    if (state.hasError) {
      _forceNavigationToHomeScreen();
      Utility.showErrorFlushbar(state.message, context);
    }
  }

  Widget _buildPersonalInformationScreen(BuildContext context, ProfileState state) {
    if (state.hasError) {
      return ErrorPageWidget();
    }

    bool showLoadingIndicator = false;
    if (state.loading) {
      showLoadingIndicator = true;
    }

    if (showLoadingIndicator) {
      return AppCircularProgressIndicator();
    } else {
      return _renderScreen(context);
    }
  }

  Widget _renderScreen(BuildContext context) {
    return SingleChildScrollView(
      padding: AppDimensions.padding(AppPaddingType.screenWithAppBar).copyWith(top: 36.0, bottom: 24.0), // must be 36.0 because label is floating below
    child: Form(
      key: _personalInformationFormKey,
      autovalidate: _personalInformationFormAutoValidate,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_fullNameRow()]
      )
    )
    );
  }

  Widget _fullNameRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: CustomFormField(
                labelText: App.translate("personal_information_screen.full_name_field.label.text"),
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
                focusNode: _nameFieldFocusNode,
                controller: _nameTextController,
                onSaved: (value) => _fullName = value,
                validator: (value) => _validateFullName(value),
                errorHasBorders: false
            )
        )
      ]
    );
  }

  void _forceNavigationToHomeScreen(){
    NavigationHelper.navigateToHome(context, popAllRoutes: true);
  }

  String _validateFullName(String name) {
    if (name.trim().isEmpty) {
      return App.translate("personal_information_screen.full_name_field.required.validation");
    }

    RegExp regex = new RegExp(r'\p{L}');

    if (!regex.hasMatch(name)) {
      return App.translate("personal_information_screen.name_field.regex.validation");
    } else {
      return null;
    }
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      automaticallyImplyLeading: false,
      leading: AppBarBackButton(),
      backgroundColor: Palette.background,
      actions: <Widget>[
//        if(widget.munch.isModifiable)
//          Padding(padding:
//          EdgeInsets.only(right: 24.0),
//              child:  CustomButton<MunchState, MunchPreferencesSavingState>.bloc(
//                cubit: _munchBloc,
//                flat: true,
//                // very important to set, otherwise title won't be aligned good
//                padding: EdgeInsets.zero,
//                color: Colors.transparent,
//                textColor: Palette.primary.withOpacity(0.6),
//                content: Text(App.translate("options_screen.app_bar.action.text"),
//                    style: AppTextStyle.style(AppTextStylePattern.heading6,
//                        fontWeight: FontWeight.w600,
//                        fontSizeOffset: 1.0,
//                        color: Palette.primary.withOpacity(0.6))),
//                onPressedCallback: _onSaveButtonClicked,
//              )
//          ),
      ],
    );
  }

  Future<bool> _onWillPopScope(BuildContext context) async {
//    if (_nameChanged()) {
//      if (_popScopeCompleter != null) {
//        _popScopeCompleter.complete(false);
//      }
//
//      _popScopeCompleter = Completer<bool>();
//
//      CupertinoAlertDialogBuilder().showAlertDialogWidget(context,
//          dialogTitle: App.translate("options_screen.save_changes_alert_dialog.title"),
//          dialogDescription:App.translate("options_screen.save_changes_alert_dialog.description"),
//          confirmText: App.translate("options_screen.save_changes_alert_dialog.confirm_button.text"),
//          cancelText: App.translate("options_screen.save_changes_alert_dialog.cancel_button.text"),
//          confirmCallback: _onSaveChangesDialogButtonClicked,
//          cancelCallback: _onDiscardChangesDialogButtonClicked
//      );
//
//      // decision will be made after dialog tap
//      bool shouldReturn = await _popScopeCompleter.future;
//
//      if(!shouldReturn){
//        // save button clicked and something is wrong
//        return false;
//      }
//    }
//
//    NavigationHelper.popRoute(context, result: _locationChangedReturnValue);
//
//    return false;
  }

  void _initializeFormFields() {
    _nameTextController.text = widget.user.displayName;
  }

  void _onFirstNameFieldFocusChange() {

  }
}