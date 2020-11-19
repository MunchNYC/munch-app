import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:munch/config/constants.dart';
import 'package:munch/service/auth/authentication_bloc.dart';
import 'package:munch/service/auth/authentication_event.dart';
import 'package:munch/service/auth/authentication_state.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/util/app_circular_progress_indicator.dart';
import 'package:munch/widget/util/app_status_bar.dart';
import 'package:munch/widget/util/custom_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatefulWidget {
  bool fromSplashScreen;

  LoginScreen({this.fromSplashScreen});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthenticationBloc _authenticationBloc;

  double _screenOpacity = 0;

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc();

    if(widget.fromSplashScreen){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          _screenOpacity = 1;
        });
      });
    } else{
      _screenOpacity = 1;
    }

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
    } else if(state is LoginWithGoogleState || state is LoginWithFacebookState || state is LoginWithAppleState){
      NavigationHelper.navigateToHome(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppStatusBar.getAppStatusBar(iconBrightness: Brightness.dark),
        body: Container(
        color: Palette.background,
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
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
      return AppCircularProgressIndicator();
    }

    // if state is initial or hasError render view
    return _renderView(context);
  }

  Widget _renderView(BuildContext context){
    // AnimatedOpacity will make animation if _splashOpacity is zero at first frame, and 1 at some of the next frames, just if we come from splash screen
    return  AnimatedOpacity(
        opacity: _screenOpacity,
        curve: Curves.ease,
        duration: Duration(milliseconds: 3000),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 48.0, right: 48.0, top: 64.0),
                  // can be double.infinity but this is more scalable for bigger screens
                  width: App.REF_DEVICE_WIDTH,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: _appBrandArea()),
                      Expanded(child: _loginButtons())
                     ]
                    )
                 ),
              ),
              _footerText()
            ]
        )
    );
  }

  Widget _appBrandArea(){
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(App.translate("login_screen.title"), style: AppTextStyle.style(AppTextStylePattern.heading1SecondaryDark, fontSizeOffset: 32.0, fontWeight: FontWeight.w600)),
          SizedBox(height: 24.0),
          Expanded(
              child: Hero(
                tag: WidgetKeys.SPLASH_LOGO_HERO_TAG,
                child: Image(
                    image: AssetImage("assets/images/logo/logo_NoBG_Black_outline.png"),
                    color: Palette.secondaryDark
                )
              )
          ),
        ]
    );
  }
  
  Widget _loginButtons(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: _googleButton(),
        ),
        SizedBox(height: 16.0),
        SizedBox(
          width: double.infinity,
          child: _facebookButton(),
        ),
        SizedBox(height: 16.0),
        SizedBox(
          width: double.infinity,
          child: _buildAppleButton(),
        ),
      ],
    );
  }
  
  Widget _footerText(){
    return Container(
        padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 36.0, bottom: 24.0),
        child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
                text: App.translate("login_screen.footer.text"),
                style: AppTextStyle.style(AppTextStylePattern.body),
                children: [
                  TextSpan(
                      text: " "
                  ),
                  TextSpan(
                      text: App.translate("login_screen.footer.terms_of_service.text"),
                      style: AppTextStyle.style(AppTextStylePattern.hyperlink),
                      recognizer: TapGestureRecognizer()..onTap = (){
                          NavigationHelper.navigateToTermsOfServiceScreen(context);
                      }
                  ),
                  TextSpan(
                      text: " " + App.translate("login_screen.footer.conjunction") + " "
                  ),
                  TextSpan(
                      text: App.translate("login_screen.footer.privacy_policy.text"),
                      style: AppTextStyle.style(AppTextStylePattern.hyperlink),
                      recognizer: TapGestureRecognizer()..onTap = (){
                        NavigationHelper.navigateToPrivacyPolicyScreen(context);
                      }
                  ),
                  TextSpan(
                      text: "."
                  ),
                ]
            )
        )
    );
  }
  
  Widget _googleButton() {
    return CustomButton<AuthenticationState, LoginWithGoogleState>.bloc(
      cubit: _authenticationBloc,
      elevation: 4.0,
      color: Palette.background,
      textColor: Palette.primary,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      borderRadius: 28.0,
      content: Row(
        children: [
          // cannot use ImageIcon because it will be re-colored
          Image(
            image: AssetImage("assets/icons/googleLogo.png"),
            width: 24.0,
            height: 24.0,
          ),
          SizedBox(width: 20.0),
          Text(App.translate("login_screen.google_button.text"), style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500))
        ],
      ),
      onPressedCallback: () async{
        _authenticationBloc.add(LoginWithGoogleEvent());
      },
    );
  }

  Widget _facebookButton() {
    return CustomButton<AuthenticationState, LoginWithFacebookState>.bloc(
      cubit: _authenticationBloc,
      elevation: 4.0,
      color: Palette.background,
      textColor: Palette.primary,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      borderRadius: 28.0,
      content: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.facebook,
            size: 24.0,
            color: Color(0xFF4267B2),
          ),
          SizedBox(width: 20.0),
          Text(App.translate("login_screen.facebook_button.text"), style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500))
        ],
      ),
      onPressedCallback: () async{
        _authenticationBloc.add(LoginWithFacebookEvent());
      },
    );
  }

  Widget _buildAppleButton() {
    return FutureBuilder<bool>(
      future: SignInWithApple.isAvailable(), // render button if apple sign in is available for device
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return CustomButton<AuthenticationState, LoginWithAppleState>.bloc(
              cubit: _authenticationBloc,
              elevation: 4.0,
              color: Palette.background,
              textColor: Palette.primary,
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              borderRadius: 28.0,
              content: Row(
                children: [
                  // cannot use ImageIcon because it will be re-colored
                  Image(
                    image: AssetImage("assets/icons/appleLogo.png"),
                    width: 24.0,
                    height: 24.0,
                  ),
                  SizedBox(width: 20.0),
                  Text(App.translate("login_screen.apple_button.text"), style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500))
                ],
              ),
              onPressedCallback: () async{
                _authenticationBloc.add(LoginWithAppleEvent());
              },
            );
        }

        return Container();
    });
  }

}
