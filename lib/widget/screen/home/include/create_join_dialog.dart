import 'dart:math';

import 'package:flutter/material.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/service/munch/munch_event.dart';
import 'package:munch/service/munch/munch_state.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/widget/screen/home/home_screen.dart';
import 'package:munch/widget/screen/map/map_screen.dart';
import 'package:munch/widget/util/custom_button.dart';
import 'package:munch/widget/util/custom_form_field.dart';

class CreateJoinDialog extends StatefulWidget{
  MunchBloc munchBloc;

  CreateJoinDialog({this.munchBloc});

  @override
  State<StatefulWidget> createState() => CreateJoinDialogState();
}

class CreateJoinDialogState extends State<CreateJoinDialog>{
  final GlobalKey<FormState> _joinFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _createFormKey = GlobalKey<FormState>();

  bool _joinFormAutoValidate = false;
  bool _createFormAutoValidate = false;

  String _joinCode;
  String _munchName;

  static const TOTAL_MUNCH_NAME_PLACEHOLDERS = 21;
  String _munchNamePlaceholder;

  final List<String> _munchNamePlaceholders = List<String>();

  CreateJoinDialogState(){
    for(int i = 0; i < TOTAL_MUNCH_NAME_PLACEHOLDERS; i++){
        _munchNamePlaceholders.add(App.translate("create_join_dialog_create_form.name_field.placeholder${i + 1}.value"));
    }

    _munchNamePlaceholder = _munchNamePlaceholders[Random().nextInt(TOTAL_MUNCH_NAME_PLACEHOLDERS)];
  }

  final TextEditingController _joinTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
      return Container(
          child: Column(
              children: <Widget>[
                _joinMunchForm(context),
                SizedBox(height: 12.0),
                _dividerRow(),
                SizedBox(height: 12.0),
                _createMunchForm(context)
              ]
          ),
      );
  }

  String _validateJoinForm(String value) {
    Pattern pattern = r'^[A-Z0-9]{6}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return App.translate("create_join_dialog.join_form.code_field.regex.validation");
    } else{
      return null;
    }

  }

  String _validateCreateForm(String value) {
    if(value.trim().isEmpty){
      return null; // validation passed, placeholder will be used
    }

    Pattern pattern = r'^([A-Za-z0-9\s]|\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])*$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return App.translate("create_join_dialog.create_form.name_field.regex.validation");
    } else{
      return null;
    }
  }

  Widget _joinMunchForm(BuildContext context){
      return Form(
        key: _joinFormKey,
        autovalidate: _joinFormAutoValidate,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
                child: CustomFormField(
                  textStyle: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.primary),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  hintText: App.translate("create_join_dialog.join_form.code_field.hint"),
                  hintStyle: AppTextStyle.style(AppTextStylePattern.body2,
                      color: Palette.secondaryLight,
                  ),
                  validator: (String value) => _validateJoinForm(value),
                  onSaved: (String value) => _joinCode = value,
                  textCapitalization: TextCapitalization.characters,
                  controller: _joinTextEditingController,
                  onChanged: (value) {
                    _joinTextEditingController.value = TextEditingValue(
                        text: value.toUpperCase(),
                        selection: _joinTextEditingController.selection);
                  },
                )
            ),
            SizedBox(width: 12.0),
            CustomButton<MunchState, MunchJoiningState>.bloc(
              cubit: widget.munchBloc,
              minWidth: 72.0,
              borderRadius: 4.0,
              color: Palette.secondaryDark,
              textColor: Palette.background,
              content: Text(App.translate("create_join_dialog.join_button.text"), style: AppTextStyle.style(AppTextStylePattern.body3Inverse)),
              onPressedCallback: (){
                _onJoinButtonClicked(context);
              },
            )
          ],
        ),
      );
  }

  Widget _dividerRow(){
    return  Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
            Expanded(child: Divider(thickness: 1.0, color: Palette.secondaryLight)),
            SizedBox(width: 12.0),
            Text(App.translate("create_join_dialog.divider.text").toUpperCase(), style: AppTextStyle.style(AppTextStylePattern.body3, color: Palette.secondaryLight)),
            SizedBox(width: 12.0),
            Expanded(child: Divider(thickness: 1.0, color: Palette.secondaryLight))
        ]
    );
  }

  Widget _createMunchForm(BuildContext context){
    return Form(
      key: _createFormKey,
      autovalidate: _createFormAutoValidate,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: CustomFormField(
                textStyle: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.primary),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                hintText: _munchNamePlaceholder,
                hintStyle: AppTextStyle.style(AppTextStylePattern.body2,
                    color: Palette.secondaryLight,
                ),
                validator: (String value) => _validateCreateForm(value),
                onSaved: (String value) {
                  if(value.trim().isEmpty){
                    _munchName = _munchNamePlaceholder;
                  } else{
                    _munchName = value;
                  }
                },
              )
          ),
          SizedBox(width: 12.0),
          CustomButton(
            minWidth: 72.0,
            borderRadius: 4.0,
            content: Text(App.translate("create_join_dialog.create_button.text"), style: AppTextStyle.style(AppTextStylePattern.body3Inverse)),
            onPressedCallback: (){
              _onCreateButtonClicked(context);
            }
          )
        ],
      ),
    );
  }

  void _onJoinButtonClicked(BuildContext context){
    if (_joinFormKey.currentState.validate()) {
      _joinFormKey.currentState.save();

      // close keyboard by giving focus to unnamed node
      FocusScope.of(context).unfocus();

      widget.munchBloc.add(JoinMunchEvent(_joinCode));
    } else {
      _joinFormAutoValidate = true;
    }
  }

  void _onCreateButtonClicked(BuildContext context){
    if (_createFormKey.currentState.validate()) {

      // pop create join dialog
      // If there is no nested navigator, because we are outside its context, it will pop dialog from root navigator automatically
      NavigationHelper.popRoute(context, rootNavigator: false);

        _createFormKey.currentState.save();

        // close keyboard by giving focus to unnamed node
        FocusScope.of(context).unfocus();

        // in the case we're not on Home screen
        NavigationHelper.popUntilLastRoute(context, rootNavigator: true);

        NavigationHelper.navigateToMapScreen(
            null,
            munchName: _munchName,
            addToBackStack: true,
            navigatorState: HomeScreen.munchesTabNavigator.currentState,
        );
    } else {
      _createFormAutoValidate = true;
    }
  }
}