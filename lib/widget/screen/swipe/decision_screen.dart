import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:munch/api/api.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/service/munch/munch_event.dart';
import 'package:munch/service/munch/munch_state.dart';
import 'package:munch/service/notification/notifications_bloc.dart';
import 'package:munch/service/notification/notifications_state.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/notifications_handler.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/screen/home/include/review_munch_dialog.dart';
import 'package:munch/widget/util/app_circular_progress_indicator.dart';
import 'package:munch/widget/util/app_status_bar.dart';
import 'package:munch/widget/util/custom_button.dart';
import 'package:munch/widget/util/error_page_widget.dart';
import 'package:munch/widget/util/overlay_dialog_helper.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

import 'include/new_restaurant_alert_dialog.dart';

class DecisionScreen extends StatefulWidget{
  Munch munch;
  Restaurant restaurant;
  bool shouldFetchDetailedMunch;

  DecisionScreen({this.munch, this.shouldFetchDetailedMunch});

  @override
  State<DecisionScreen> createState() => _DecisionScreenState();
}

class _DecisionScreenState extends State<DecisionScreen>{
  int _currentCarouselPage = 0;

  CarouselController _carouselController = CarouselController();

  MunchBloc _munchBloc;

  @override
  void initState() {
    _munchBloc = MunchBloc();

    if(widget.shouldFetchDetailedMunch){
      _munchBloc.add(GetDetailedMunchEvent(widget.munch.id));
    } else{
      widget.restaurant = widget.munch.matchedRestaurant;

      // merge Munch with itself in order to update members array if it's empty to (1 member - current user)
      // edge case
      widget.munch.merge(widget.munch);
    }

    super.initState();
  }

  @override
  void dispose() {
    _munchBloc?.close();

    super.dispose();
  }

  Future<bool> _onWillPopScope() async {
    NavigationHelper.popRoute(context, checkLastRoute: true);

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: _onWillPopScope,
      child: Scaffold(
          backgroundColor: Palette.background,
          extendBodyBehindAppBar: true,
          appBar: AppStatusBar.getAppStatusBar(iconBrightness: Brightness.light),
          body: _buildNotificationsBloc()
      )
    );
  }

  void _munchStatusNotificationListener(BuildContext context, NotificationsState state){
    if(state is DetailedMunchNotificationState){
      Munch munch = state.data;

      if(munch.id == widget.munch.id) {
        _checkNavigationToSwipeScreen();
      }
    } else if(state is CurrentUserKickedNotificationState){
      String munchId = state.data;

      if(widget.munch.id == munchId){
        _forceNavigationToHomeScreen();
      }
    }
  }

  Widget _buildNotificationsBloc(){
    return BlocConsumer<NotificationsBloc, NotificationsState>(
        cubit: NotificationsHandler.getInstance().notificationsBloc,
        listenWhen: (NotificationsState previous, NotificationsState current) => (current is DetailedMunchNotificationState || current is CurrentUserKickedNotificationState) && current.ready,
        listener: (BuildContext context, NotificationsState state) => _munchStatusNotificationListener(context, state),
        buildWhen: (NotificationsState previous, NotificationsState current) => current is DetailedMunchNotificationState && current.ready, // in every other condition enter builder
        builder: (BuildContext context, NotificationsState state) => _buildMunchBloc()
    );
  }

  void _navigateToSwipeScreen(){
    NavigationHelper.navigateToRestaurantSwipeScreen(context, munch: widget.munch, addToBackStack: false);
  }

  void _checkNavigationToSwipeScreen(){
    if(widget.munch.munchStatus != MunchStatus.UNDECIDED){
      widget.restaurant = widget.munch.matchedRestaurant;
    }

    if(widget.munch.munchStatusChanged){
      widget.munch.munchStatusChanged = false;

      if(widget.munch.munchStatus == MunchStatus.UNDECIDED){
        _navigateToSwipeScreen();
      }
    }
  }

  void _forceNavigationToHomeScreen(){
    NavigationHelper.navigateToHome(context, popAllRoutes: true);
  }

  void _decisionScreenListener(BuildContext context, MunchState state){
    if (state.hasError) {
      if(state.exception is AccessDeniedException){
        _forceNavigationToHomeScreen();
      }

      Utility.showErrorFlushbar(state.message, context);
    } else if(state.loading && state is ReviewMunchState){
      // close review dialog immediately on button click
      NavigationHelper.popRoute(context);
    } else if(state is DetailedMunchFetchingState){
      _checkNavigationToSwipeScreen();
    } else if(state is CancellingMunchDecisionState){
      _checkNavigationToSwipeScreen();
    } else if(state is ReviewMunchState){
      Utility.showFlushbar(App.translate("decision_screen.review_munch.successful.text"), context);
    }
  }


  Widget _buildMunchBloc(){
    return BlocConsumer<MunchBloc, MunchState>(
        cubit: _munchBloc,
        listenWhen: (MunchState previous, MunchState current) => current.hasError || current.ready || (current.loading && current is ReviewMunchState),
        listener: (BuildContext context, MunchState state) => _decisionScreenListener(context, state),
        buildWhen: (MunchState previous, MunchState current) => current.loading || current.ready,
        builder: (BuildContext context, MunchState state) => _buildDecisionScreen(context, state)
    );
  }

  Widget _buildDecisionScreen(BuildContext context, MunchState state){
    if (state.hasError) {
      return ErrorPageWidget();
    } else if((state.initial && widget.shouldFetchDetailedMunch) || (state.loading && state is DetailedMunchFetchingState) || (state.ready && widget.restaurant == null)){
      // state.ready && widget.restaurant == null means we already started navigation to SwipeScreen, because matchedRestaurant is cleared
      return AppCircularProgressIndicator();
    }

    return _renderScreen(context);
  }

  Widget _renderScreen(BuildContext context){
    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 24.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _coverImageArea(),
              SizedBox(height: 12.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if(!widget.munch.isModifiable)
                    _unmodifiableInfoRow(),
                    if(!widget.munch.isModifiable)
                    Divider(thickness: 2.0, height: 32.0, color: Palette.secondaryLight.withOpacity(0.2)),

                    _restaurantDetails(),

                    if(widget.munch.isModifiable)
                    SizedBox(height: 16.0),
                    if(widget.munch.isModifiable)
                    _buttonControls()
                  ],
                )
              )
            ]
        )
    );
  }

  Widget _coverImageArea(){
    return Container(
      height: App.screenHeight * 0.4,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          _imageCarousel(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 36.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _closeIcon(),
                _moreIcon()
              ],
            )
          ),
          Positioned(
            right: 12.0,
            bottom: 4.0,
            child: Text((_currentCarouselPage + 1).toString() + "/" + widget.restaurant.photoUrls.length.toString(), 
              style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.background),
            ),
          )
        ],
      )
    );
  }

  Widget _closeIcon(){
    return InkWell(
      onTap: _onWillPopScope,
      child: Container(
        decoration: BoxDecoration(
          color: Palette.background,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Palette.primary.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3
            ),
          ],
        ),
        padding: EdgeInsets.all(4.0),
        child: Icon(Icons.clear, size: 20.0)
      )
    );
  }

  Widget _moreIcon(){
    return InkWell(
        onTap: (){
          NavigationHelper.navigateToMunchOptionsScreen(context, munch: widget.munch).then(
                  (value) => setState(() {})  //refresh the data on page
          );
        },
        child: Container(
            decoration: BoxDecoration(
              color: Palette.background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Palette.primary.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3
                ),
              ],
            ),
            padding: EdgeInsets.all(4.0),
            child: ImageIcon(
              AssetImage("assets/icons/more.png"),
              color: Palette.primary,
              size: 20.0,
            )
        )
    );
  }

  Widget _imageCarousel(){
    return Container(
        width: double.infinity,
        child: Stack(
            children: [
            ShaderMask(
               shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    stops: [
                      0.05, 0.2, 0.92, 0.95, 1.0
                    ],
                    colors: [Palette.primary.withOpacity(0.4), Palette.primary.withOpacity(0.15), Colors.transparent, Palette.primary.withOpacity(0.1), Palette.primary.withOpacity(0.25)],
                  ).createShader(
                      Rect.fromLTRB(0, 0, 0, rect.height),
                  );
               },
               blendMode: BlendMode.darken,
               child:  CarouselSlider(
                    items: widget.restaurant.photoUrls.map((photoUrl) =>
                        SizedBox(
                          width: double.infinity,
                          child: Image(image: NetworkImage(photoUrl), fit: BoxFit.cover),
                        )
                    ).toList(),
                    options: CarouselOptions(
                        height: double.infinity,
                        autoPlay: false,
                        enlargeCenterPage: false,
                        viewportFraction: 1.0,
                        scrollPhysics: NeverScrollableScrollPhysics(),
                        enableInfiniteScroll: false
                    ),
                    carouselController: _carouselController,
                  )
              ),
              _carouselControlsRow()
          ]
        )
    );
  }

  Widget _carouselControlsRow(){
    return Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: GestureDetector(
              child: Container(color: Colors.transparent),
              onTap: _onCarouselLeftSideTapped
          )
          ),
          Expanded(child: GestureDetector(
              child: Container(color: Colors.transparent),
              onTap: _onCarouselRightHalfTapped
          )
          ),
        ]
    );
  }

  Widget _unmodifiableInfoRow(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        ImageIcon(
          AssetImage("assets/icons/starFilled.png"),
          color: Color(0xFFFBB25B),
          size: 24.0,
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(App.translate("decision_screen.munch_unmodifiable.description") + " " + widget.munch.matchedRestaurant.name + "!",
                  style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 1.0)),
              SizedBox(height: 8.0),
              CustomButton(
                padding: EdgeInsets.all(8.0),
                elevation: 2.0,
                borderRadius: 4.0,
                color: Palette.secondaryDark,
                textColor: Palette.background,
                content: Text(App.translate("decision_screen.munch_unmodifiable.feedback_button.text"),
                    style: AppTextStyle.style(AppTextStylePattern.body2Inverse, fontSizeOffset: 1.0)),
                onPressedCallback: (){
                  // We'll not have here nested navigators, because we are outside its context, so specifying root navigator to true/false will be same
                  OverlayDialogHelper(widget: ReviewMunchDialog(munchBloc: _munchBloc, munch: widget.munch)).show(context);
                },
              )
            ],
          ),
        )
      ]
    );
  }

  Widget _restaurantDetails(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.restaurant.name, style: AppTextStyle.style(AppTextStylePattern.heading2, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
          SizedBox(height: 8.0),
          _yelpStatsRow(),
          SizedBox(height: 8.0),
          Text((widget.restaurant.priceSymbol != null ? widget.restaurant.priceSymbol + ' • ' : "" ) + widget.restaurant.categoryTitles, style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.primary.withOpacity(0.7))),
          SizedBox(height: 8.0),
          _linkIconsRow(),
          SizedBox(height: 8.0),
          if(widget.restaurant.workingHours != null)
          _workingHours(),
        ],
    );
  }

  Widget _workingHours(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(App.translate("decision_screen.restaurant.hours.subtitle"), style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.primary.withOpacity(0.7), fontWeight: FontWeight.w600)),
        SizedBox(height: 8.0),
        for(WorkingHours workingHours in widget.restaurant.workingHours)
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                  width: 100.0,
                  child: Text("${workingHours.dayOfWeek[0]}${workingHours.dayOfWeek.substring(1).toLowerCase()}",
                      style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.primary.withOpacity(0.6))
                  )
              ),
              Flexible(child: Text(workingHours.getWorkingTimesFormatted(), maxLines: 2, style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.primary.withOpacity(0.6)))),
            ],
          )
      ],
    );
  }

  Widget _linkIconsRow(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        if(widget.restaurant.phoneNumber != null)
        Expanded(
          child: _callButton()
        ),
        Expanded(
          child: _mapButton()
        ),
        Expanded(
            child: _yelpButton()
        ),
        Expanded(
          child: _shareButton()
        ),
      ],
    );
  }

  Widget _callButton(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CustomButton(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0),
            flat: true,
            color: Palette.background,
            textColor: Palette.primary,
            content: ImageIcon(
              AssetImage("assets/icons/phone.png"),
              color: Palette.primary,
              size: 24.0,
            ),
            onPressedCallback: (){
              Utility.launchUrl(context, "tel://" + widget.restaurant.phoneNumber);
            },
        ),
        Text(App.translate("decision_screen.call_button.label.text"), style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.primary)),
      ],
    );
  }

  Widget _mapButton(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CustomButton(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            flat: true,
            color: Palette.background,
            textColor: Palette.primary,
            content: ImageIcon(
              AssetImage("assets/icons/map.png"),
              color: Palette.primary,
              size: 28.0,
            ),
          onPressedCallback: (){
            MapsLauncher.launchCoordinates(widget.restaurant.coordinates.latitude, widget.restaurant.coordinates.longitude, widget.restaurant.name);
          },
        ),
        Text(App.translate("decision_screen.map_button.label.text"), style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.primary)),
      ],
    );
  }

  Widget _yelpButton(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CustomButton(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            flat: true,
            color: Palette.background,
            textColor: Palette.primary,
            content: ImageIcon(
              AssetImage("assets/icons/yelp.png"),
              color: Palette.primary,
              size: 32.0,
            ),
            onPressedCallback: (){
              Utility.launchUrl(context, widget.restaurant.url);
            },
        ),
        Text(App.translate("decision_screen.yelp_button.label.text"), style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.primary)),
      ],
    );
  }

  Widget _shareButton(){
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomButton(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0),
              flat: true,
              color: Palette.background,
              textColor: Palette.primary,
              content: ImageIcon(
                AssetImage("assets/icons/share.png"),
                color: Palette.primary,
                size: 24.0,
              ),
              onPressedCallback: () async{
                await WcFlutterShare.share(
                    sharePopupTitle: App.translate("decision_screen.share_button.popup.title"),
                    text: App.translate("decision_screen.share_action.text") + "\n" + widget.restaurant.url,
                    mimeType: "text/plain"
                );
              },
          ),
          Text(App.translate("decision_screen.share_button.label.text"), style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.primary)),
        ]
    );
  }

  Widget _yelpStatsRow(){
    return GestureDetector(
        onTap: (){
          Utility.launchUrl(context, widget.restaurant.url);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image(image: AssetImage("assets/images/yelp/yelp-burst.png"), height: 16.0),
            SizedBox(width: 8.0),
            _starsRating(),
            SizedBox(width: 8.0),
            Text(widget.restaurant.reviewsNumber.toString() + " " + App.translate('decision_screen.yelp.reviews.text'), style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)),
          ],
        )
    );
  }

  Widget _starsRating(){
    String afterDecimalPointValue = widget.restaurant.rating.toString().substring(widget.restaurant.rating.toString().indexOf(".") + 1);
    return Image(image: AssetImage("assets/images/yelp/stars/stars_regular_" + widget.restaurant.rating.floor().toString() + (afterDecimalPointValue == "0" ? "" : "_half") + ".png"), height: 16.0);
  }

  Widget _buttonControls(){
    return Row(
      children: <Widget>[
        Expanded(
          child:  CustomButton(
            flat: true,
            color: Colors.transparent,
            borderRadius: 8.0,
            borderWidth: 1.0,
            borderColor: Palette.secondaryDark,
            textColor: Palette.secondaryDark,
            padding: EdgeInsets.symmetric(vertical: 12.0),
            content: Text(App.translate("decision_screen.continue_exploring_button.text"), style: AppTextStyle.style(AppTextStylePattern.body2SecondaryDark)),
            onPressedCallback: _navigateToSwipeScreen,
          )
        ),
        SizedBox(width:32.0),
        Expanded(
          child:  CustomButton<MunchState, CancellingMunchDecisionState>.bloc(
            cubit: _munchBloc,
            flat: true,
            color: Colors.transparent,
            borderRadius: 8.0,
            borderWidth: 1.0,
            borderColor: Palette.secondaryDark,
            textColor: Palette.secondaryDark,
            padding: EdgeInsets.symmetric(vertical: 12.0),
            content: Text(App.translate("decision_screen.new_restaurant_button.text"), style: AppTextStyle.style(AppTextStylePattern.body2SecondaryDark)),
            onPressedCallback: (){
              OverlayDialogHelper(widget: NewRestaurantAlertDialog(munchId: widget.munch.id, munchBloc: _munchBloc)).show(context);
            },
          )
        ),
      ],
    );
  }

  void _onCarouselLeftSideTapped(){
    if(_currentCarouselPage - 1 >= 0){
      setState(() {
        _currentCarouselPage--;
      });

      _carouselController.previousPage();
    } else{
      setState(() {
        _currentCarouselPage = widget.restaurant.photoUrls.length - 1;
      });

      _carouselController.animateToPage(_currentCarouselPage, duration: Duration(milliseconds: 500));
    }
  }

  void _onCarouselRightHalfTapped(){
    if(_currentCarouselPage + 1 < widget.restaurant.photoUrls.length){
      setState(() {
        _currentCarouselPage++;
      });

      _carouselController.nextPage();
    } else{
      setState(() {
        _currentCarouselPage = 0;
      });

      _carouselController.animateToPage(_currentCarouselPage, duration: Duration(milliseconds: 500));
    }
  }

}