import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart' as auth_buttons;
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munch/service/auth/authentication_bloc.dart';
import 'package:munch/service/auth/authentication_event.dart';
import 'package:munch/service/auth/authentication_state.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/util/app_circular_progress_indicator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc();
    super.initState();
  }

  @override
  void dispose() {
    _authenticationBloc?.close();
    super.dispose();
  }

  void _loginListener(BuildContext context, AuthenticationState state){
    if (state.hasError) {
      Utility.showErrorFlushbar(state.message, context, color: Palette.background, textColor: Palette.error);
    } else if(state is LoginWithGoogleState || state is LoginWithFacebookState || state is LoginWithAppleState){
      NavigationHelper.navigateToHome(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: App.screenWidth/6),
        color: Palette.ternaryDark,
        child:BlocConsumer<AuthenticationBloc, AuthenticationState>(
          cubit: _authenticationBloc,
          listenWhen: (AuthenticationState previous, AuthenticationState current) => current.hasError || current.ready,
          listener: (BuildContext context, AuthenticationState state) => _loginListener(context, state),
          builder: (BuildContext context, AuthenticationState state) => _buildLoginView(context, state)
        )
      )
    );
  }

  Widget _buildLoginView(BuildContext context, AuthenticationState state){
    /*
      (state.ready) is added in order to prevent rendering login page again,
       while we're waiting for _loginListener to navigate to home page (about 1 sec of delay)
     */
    if(state.loading || state.ready){
      return AppCircularProgressIndicator(color: Palette.background);
    }

    // if state is initial or hasError render view
    return _renderView(context);
  }

  Widget _renderView(BuildContext context){
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: App.screenWidth/8),
              child: Image(
                image: AssetImage("assets/images/logo/logo_NoBG_Red.png"),
                color: Palette.background
              )
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: _googleButton(),
                ),
                SizedBox(height: 12.0),
                SizedBox(
                  width: double.infinity,
                  child: _facebookButton(),
                ),
                SizedBox(height: 12.0),
                SizedBox(
                  width: double.infinity,
                  child: _buildAppleButton(),
                )
              ],
            )
          )
        ],
    );
  }

  Widget _googleButton() {
    return auth_buttons.GoogleSignInButton(
      darkMode: false,
      textStyle: AppTextStyle.style(AppTextStylePattern.body3,
          fontWeight: FontWeight.w600,
      ),
      text: App.translate("login_screen.google_button.text"),
      onPressed: (){
        _authenticationBloc.add(LoginWithGoogleEvent());
      },
    );
  }

  Widget _facebookButton() {
    return auth_buttons.FacebookSignInButton(
      textStyle: AppTextStyle.style(AppTextStylePattern.body3Inverse,
          fontWeight: FontWeight.w600
      ),
      text: " " +  App.translate("login_screen.facebook_button.text"),
      onPressed: (){
        _authenticationBloc.add(LoginWithFacebookEvent());
      },
    );
  }

  Widget _buildAppleButton() {
    return FutureBuilder<bool>(
      future: AppleSignIn.isAvailable(), // render button if apple sign in is available for device
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return auth_buttons.AppleSignInButton(
            textStyle: AppTextStyle.style(AppTextStylePattern.body3,
                fontWeight: FontWeight.w600,
            ),
            text: App.translate("login_screen.apple_button.text"),
            style: AppleButtonStyle.white,
            onPressed: (){
              _authenticationBloc.add(LoginWithAppleEvent());
            },
          );
        }

        return Container();
    });
  }

}
