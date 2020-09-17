import 'package:flutter/material.dart';
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
import 'package:munch/widget/util/custom_button.dart';

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
      Utility.showErrorFlushbar(state.message, context);
    } else if(state is LoginWithGoogleState){
      NavigationHelper.navigateToHome(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: AppDimensions.padding(AppPaddingType.screenOnly),
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            cubit: _authenticationBloc,
            listenWhen: (AuthenticationState previous, AuthenticationState current) => current.hasError || current.ready,
            listener: (BuildContext context, AuthenticationState state) => _loginListener(context, state),
            buildWhen: (AuthenticationState previous, AuthenticationState current) => current is LoginWithGoogleState || current.ready,
            builder: (BuildContext context, AuthenticationState state) => _buildLoginView(context, state)
        )
      )
    );
  }

  Widget _buildLoginView(BuildContext context, AuthenticationState state){
    /*
      (state is LoginWithGoogleState && state.ready) is added in order to prevent rendering login page again,
       while we're waiting for _loginListener to navigate to home page (about 1 sec of delay)
     */
    if(state.loading || (state is LoginWithGoogleState && state.ready)){
      return AppCircularProgressIndicator();
    }

    return _renderView(context);
  }

  Widget _renderView(BuildContext context){
    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _signInButton(),
          ],
        )
    );
  }

  Widget _signInButton() {
   return CustomButton<AuthenticationState, LoginWithGoogleState>.bloc(
        cubit: _authenticationBloc,
        onPressedCallback: _onSignInButtonTapped,
        color: Palette.background,
        borderColor: Palette.secondaryLight,
        borderWidth: 1.0,
        borderRadius: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(App.translate("login_screen.google_button.text"),
                  style: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.bold, color: Palette.secondaryLight)
              )
            )
          ],
        )
    );
  }

  void _onSignInButtonTapped() {
      _authenticationBloc.add(LoginWithGoogleEvent());
  }
}
