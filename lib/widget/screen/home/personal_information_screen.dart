import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/user_repository.dart';
import 'package:munch/service/profile/profile_bloc.dart';
import 'package:munch/service/profile/profile_event.dart';
import 'package:munch/service/profile/profile_state.dart';
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
import 'package:munch/widget/util/custom_form_field.dart';
import 'package:munch/widget/util/error_page_widget.dart';

class PersonalInformationScreen extends StatefulWidget {
  User user;

  PersonalInformationScreen({this.user});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final GlobalKey<FormState> _personalInformationFormKey = GlobalKey<FormState>();
  bool _personalInformationFormAutoValidate = false;
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _genderTextController = TextEditingController();
  FixedExtentScrollController _scrollController;
  Completer<bool> _popScopeCompleter;
  List<Gender> _genders = Gender.values;
  bool _nameChanged = false;
  bool _genderChanged = false;
  bool _munchNameFieldReadOnly = true;

  String _fullName;
  Gender _gender;
  String _birthday;
  ProfileBloc _profileBloc;

  @override
  void initState() {
    _initializeFormFields();
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
      NavigationHelper.navigateToHome(context, popAllRoutes: true);
      Utility.showErrorFlushbar(state.message, context);
    } else if (state is UpdatePersonalInformationState) {
      _updatePersonalInfoListener(state);
    }
  }

  void _updatePersonalInfoListener(UpdatePersonalInformationState state) {
    _nameChanged = false;
    _genderChanged = false;
    if (_popScopeCompleter != null) {
      _popScopeCompleter.complete(true);
    } else {
      _onWillPopScope(context);
    }
  }

  Widget _buildPersonalInformationScreen(BuildContext context, ProfileState state) {
    if (state.hasError) {
      return ErrorPageWidget();
    }

    bool showLoadingIndicator = false;
    if (state.loading) {
      showLoadingIndicator = true;

      if (state is UpdatePersonalInformationState) {
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
    return SingleChildScrollView(
      padding: AppDimensions.padding(AppPaddingType.screenWithAppBar).copyWith(top: 36.0, bottom: 24.0), // must be 36.0 because label is floating below
      child: Column(
        children: [
          SizedBox(height: 8.0),
          _fullNameRow(),
          Divider(height: 36.0, thickness: 1.5, color: Palette.secondaryLight.withOpacity(0.3)),
          SizedBox(height: 16.0),
          _genderRow(),
          Divider(height: 36.0, thickness: 1.5, color: Palette.secondaryLight.withOpacity(0.3)),
          SizedBox(height: 16.0),
          _birthdayRow()
        ]
      )
    );
  }

  Widget _fullNameRow() {
    return Form(
        key: _personalInformationFormKey,
        autovalidate: _personalInformationFormAutoValidate,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                        controller: _nameTextController,
                        onSaved: (value) => _fullName = value,
                        validator: (value) => _validateFullName(value),
                        errorHasBorders: false
                    )
                )
              ])
            ]
        )
    );
  }

  Widget _genderRow() {
    return Row(
    mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: CustomFormField(
              labelText: App.translate("personal_information_screen.gender_field.label.text"),
              labelStyle: AppTextStyle.style(AppTextStylePattern.heading6,  fontWeight: FontWeight.w500, color: Palette.primary.withOpacity(0.7)),
              textStyle: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, color: Palette.primary),
              fillColor: Palette.background,
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
              borderRadius: 0.0,
              borderColor: Palette.background,
              controller: _genderTextController,
              onSaved: (value) {
                print(value);
                _gender = value;
              },
              readOnly: true,
              onTap: (){},
            )
        ),
          SizedBox(width: 12.0),
          CustomButton(
              flat: true,
              // very important to set, otherwise title won't be aligned good
              padding: EdgeInsets.zero,
              color: Colors.transparent,
              content: _munchNameFieldReadOnly
                  ? Text(App.translate("personal_information_screen.readonly_state.text"), style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w400, color: Palette.hyperlink))
                  : FaIcon(FontAwesomeIcons.solidTimesCircle, size: 14.0, color: Palette.secondaryLight.withAlpha(150)),
              onPressedCallback: _onEditGenderTapped
          )
      ],
    );
  }

  Widget _birthdayRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: CustomFormField(
              labelText: App.translate("personal_information_screen.birthday_field.label.text"),
              labelStyle: AppTextStyle.style(AppTextStylePattern.heading6,  fontWeight: FontWeight.w500, color: Palette.primary.withOpacity(0.7)),
              textStyle: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, color: Palette.primary),
              fillColor: Palette.background,
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
              borderRadius: 0.0,
              borderColor: Palette.background,
              initialValue: _birthday,
              readOnly: true,
              onTap: (){},
            )
        ),
        SizedBox(width: 12.0),
        CustomButton(
            flat: true,
            // very important to set, otherwise title won't be aligned good
            padding: EdgeInsets.zero,
            color: Colors.transparent,
            content: _munchNameFieldReadOnly
                ? Text(App.translate("personal_information_screen.readonly_state.text"), style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w400, color: Palette.hyperlink))
                : FaIcon(FontAwesomeIcons.solidTimesCircle, size: 14.0, color: Palette.secondaryLight.withAlpha(150)),
            onPressedCallback: (){}
        )
      ],
    );
  }

  String _validateFullName(String name) {
    if (name.trim().isEmpty) {
      return App.translate("personal_information_screen.full_name_field.required.validation");
    }

    RegExp regex = new RegExp(r'^([A-Za-z\s])*$');

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
      title: Text(
        App.translate("personal_information_screen.app_bar.title"),
        style: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.normal),
        textAlign: TextAlign.center,
        overflow: TextOverflow.fade,
        maxLines: 1,
      ),
      centerTitle: false,
      leading: AppBarBackButton(),
      backgroundColor: Palette.background,
      actions: <Widget>[
        Padding(padding:
        EdgeInsets.only(right: 24.0),
            child:  CustomButton<ProfileState, UpdatePersonalInformationState>.bloc(
              cubit: _profileBloc,
              flat: true,
              // very important to set, otherwise title won't be aligned good
              padding: EdgeInsets.zero,
              color: Colors.transparent,
              textColor: Palette.primary.withOpacity(0.6),
              content: Text(App.translate("personal_information_screen.app_bar.action.text"),
                  style: AppTextStyle.style(AppTextStylePattern.heading6,
                      fontWeight: FontWeight.w600,
                      fontSizeOffset: 1.0,
                      color: Palette.primary.withOpacity(0.6))),
              onPressedCallback: _onSaveButtonTapped,
            )
        ),
      ],
    );
  }

  Future<bool> _onWillPopScope(BuildContext context) async {
    if (_changesMade()) {
      if (_popScopeCompleter != null) {
        _popScopeCompleter.complete(false);
      }

      _popScopeCompleter = Completer<bool>();

      CupertinoAlertDialogBuilder().showAlertDialogWidget(context,
          dialogTitle: App.translate("options_screen.save_changes_alert_dialog.title"),
          dialogDescription:App.translate("options_screen.save_changes_alert_dialog.description"),
          confirmText: App.translate("options_screen.save_changes_alert_dialog.confirm_button.text"),
          cancelText: App.translate("options_screen.save_changes_alert_dialog.cancel_button.text"),
          confirmCallback: _onSaveChangesDialogButtonTapped,
          cancelCallback: _onDiscardChangesDialogButtonTapped
      );

      // decision will be made after dialog tap
      bool shouldReturn = await _popScopeCompleter.future;

      if(!shouldReturn){
        // save button tapped and something is wrong
        return false;
      }
    }

    NavigationHelper.popRoute(context, result: UserRepo.getInstance().currentUser);

    return false;
  }

  void _initializeFormFields() {
    _nameTextController.text = widget.user.displayName;
    _genderTextController.text = User.genderToString(widget.user.gender);
    _scrollController = FixedExtentScrollController(initialItem: _genders.indexOf(widget.user.gender));
    _birthday = widget.user.birthday;
  }

  void _onEditGenderTapped() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 120,
                      child: CupertinoPicker(
                        scrollController: _scrollController,
                          diameterRatio: 1.0,
                          itemExtent: 40.0,
                          onSelectedItemChanged: (int index) {
                            _updateGender(index);
                          },
                          children: <Widget>[
                            Center(child: Text(App.translate("personal_information_screen.gender.no_answer.text"), style: AppTextStyle.style(AppTextStylePattern.body, fontSizeOffset: 12.0))),
                            Center(child: Text(App.translate("personal_information_screen.gender.male.text"), style: AppTextStyle.style(AppTextStylePattern.body, fontSizeOffset: 12.0))),
                            Center(child: Text(App.translate("personal_information_screen.gender.female.text"), style: AppTextStyle.style(AppTextStylePattern.body, fontSizeOffset: 12.0))),
                            Center(child: Text(App.translate("personal_information_screen.gender.other.text"), style: AppTextStyle.style(AppTextStylePattern.body, fontSizeOffset: 12.0)))
                          ]
                      )
                    )
                  )
                ]
              )
            ]
          )
        );
      }
    );
  }

  bool _changesMade() {
    return _nameChanged || widget.user.gender.toString().split(".").last != _genderTextController.text;
  }

  bool _onSaveButtonTapped() {
    bool validationSuccess = true;

    if (_personalInformationFormKey.currentState.validate()) {
      _personalInformationFormKey.currentState.save();

      // close keyboard by giving focus to unnamed node
      FocusScope.of(context).unfocus();

      if (_changesMade()) {
        User user = User(
          uid: widget.user.uid,
          email: widget.user.email,
          displayName: _fullName,
          gender: _gender,
          imageUrl: widget.user.imageUrl,
          accessToken: widget.user.accessToken
        );

        _profileBloc.add(UpdatePersonalInformationEvent(user: user));
      } else {
        _onWillPopScope(context);
      }
    } else {
      validationSuccess = false;

      _personalInformationFormAutoValidate = true;
    }

    return validationSuccess;
  }

  void _onSaveChangesDialogButtonTapped() {
    // close dialog
    NavigationHelper.popRoute(context);

    bool validationSuccess = _onSaveButtonTapped();

    if(!validationSuccess){
      _popScopeCompleter.complete(false);
    }
  }

  void _onDiscardChangesDialogButtonTapped() {
    // close dialog
    NavigationHelper.popRoute(context);

    _popScopeCompleter.complete(true);
  }

  void _updateGender(int index) async {
    _gender = _genders[index];
    setState(() {
      _genderTextController.text = User.genderToString(_genders[index]);
    });
  }
}