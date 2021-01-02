import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:munch/analytics/analytics_repository.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/model/user.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/service/munch/munch_event.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/util/app_circular_progress_indicator.dart';

class RestaurantCard extends StatefulWidget {
  Restaurant restaurant;
  Munch munch;
  MunchBloc munchBloc;
  Function(double opacity) updateLikeIndicator;
  Function(double opacity) updateDislikeIndicator;

  Map<String, int> imageImpressions;

  RestaurantCard(this.restaurant, this.munch, {this.munchBloc}) : super(key: Key(restaurant.id));

  // must be saved here, because of Dragging purposes. Otherwise we cannot keep same image as it was when drag started
  int currentCarouselPage = 0;

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  static const double AVATAR_RADIUS = 12.0;
  static const double AVATAR_CONTAINER_PARENT_PERCENT = 0.5;
  static const double AVATAR_SPACING = 4.0;

  double _likeIndicatorOpacity = 0;
  double _dislikeIndicatorOpacity = 0;

  // avatar size calculations
  static final double _totalAvatarWidth = (AVATAR_RADIUS * 2 + AVATAR_SPACING);
  static final double _maxAvatarContainerWidth =
      (App.screenWidth - AppDimensions.padding(AppPaddingType.screenWithAppBar).horizontal) *
          AVATAR_CONTAINER_PARENT_PERCENT;
  static final int _maxAvatarsPerRow = (_maxAvatarContainerWidth / _totalAvatarWidth).floor();

  // Must be instantiated here to be always created again when drag starts, otherwise we'll get exceptions because carousel controller won't be instantiated again when we start dragging
  CarouselController _carouselController = CarouselController();

  @override
  void didChangeDependencies() {
    widget.restaurant.photoUrls.forEach((photo) {
      precacheImage(Image.network(photo).image, context);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    widget.updateLikeIndicator = (opacity) {
      _likeIndicatorOpacity = opacity;
      setState(() {});
    };
    widget.updateDislikeIndicator = (opacity) {
      _dislikeIndicatorOpacity = opacity;
      setState(() {});
    };
    return Material(
      elevation: 8.0,
      // must be transparent otherwise we'll have Z-axis fight below the image, slight colored line will be there if Material has defined color
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16.0),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[_titleSection(), Expanded(child: _imageCarousel())]),
    );
  }

  Widget _starsRating() {
    String afterDecimalPointValue =
        widget.restaurant.rating.toString().substring(widget.restaurant.rating.toString().indexOf(".") + 1);
    return Image(
        image: AssetImage("assets/images/yelp/stars/stars_regular_" +
            widget.restaurant.rating.floor().toString() +
            (afterDecimalPointValue == "0" ? "" : "_half") +
            ".png"),
        height: 16.0);
  }

  Widget _yelpStatsRow() {
    return GestureDetector(
        onTap: () {
          Utility.launchUrl(context, widget.restaurant.url);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image(image: AssetImage("assets/images/yelp/yelp-burst.png"), height: 16.0),
            SizedBox(width: 8.0),
            _starsRating(),
            SizedBox(width: 8.0),
            Text(
                widget.restaurant.reviewsNumber.toString() +
                    ' ' +
                    App.translate('restaurant_swipe_screen.restaurant_card.yelp.reviews.text'),
                style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)),
          ],
        ));
  }

  Widget _titleSection() {
    // Just check does this restaurant has info for current day, otherwise we'll not show them below
    bool hasCurrentWorkingHours = widget.restaurant.workingHours != null && widget.restaurant.workingHours.length > 0;

    return Container(
        padding: EdgeInsets.only(top: 24.0, bottom: 16.0, left: 16.0, right: 16.0),
        decoration: BoxDecoration(
            color: Palette.background,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.restaurant.name,
                style: AppTextStyle.style(AppTextStylePattern.heading3, fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            SizedBox(height: 8.0),
            _yelpStatsRow(),
            SizedBox(height: 8.0),
            Text(
                (widget.restaurant.priceSymbol != null ? widget.restaurant.priceSymbol + ' • ' : "") +
                    widget.restaurant.categoryTitles,
                style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.primary.withOpacity(0.7))),
            if (hasCurrentWorkingHours) SizedBox(height: 8.0),
            if (hasCurrentWorkingHours)
              Text(widget.restaurant.getWorkingHoursCurrentStatus(),
                  style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)),
          ],
        ));
  }

  Widget _imageCarousel() {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Palette.background,
            // this is duplicated in order to show background while we're  waiting for image to be rendered
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0))),
        child: ClipRRect(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),
            child: Stack(children: [
              CarouselSlider(
                items: widget.restaurant.photoUrls
                    .map((photoUrl) => SizedBox(
                        width: double.infinity,
                        child: Image.network(
                          photoUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: AppCircularProgressIndicator(),
                              );
                            }
                          },
                        )))
                    .toList(),
                options: CarouselOptions(
                    height: double.infinity,
                    autoPlay: false,
                    enlargeCenterPage: false,
                    viewportFraction: 1.0,
                    scrollPhysics: NeverScrollableScrollPhysics(),
                    initialPage: widget.currentCarouselPage,
                    enableInfiniteScroll: false),
                carouselController: _carouselController,
              ),
              _carouselControlsRow(),
              if (widget.restaurant.usersWhoLiked.isNotEmpty) _userWhoLiked(),
              _likeIndicator(),
              _dislikeIndicator()
            ])));
  }

  Widget _likeIndicator() {
    return Opacity(
        opacity: _likeIndicatorOpacity,
        child: Padding(
          padding: EdgeInsets.only(top: 48.0, left: 36.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Icon(
              Icons.check_circle_outline,
              color: Colors.lightGreen,
              size: 72.0
            )
          )
      )
    );
  }

  Widget _dislikeIndicator() {
    return Opacity(
      opacity: _dislikeIndicatorOpacity,
      child: Padding(
        padding: EdgeInsets.only(top: 48.0, right: 36.0),
        child: Align(
          alignment: Alignment.topRight,
          child: Icon(
            Icons.cancel_outlined,
            color: Colors.red,
            size: 72.0
          )
        )
      )
    );
  }

  Widget _userWhoLiked() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Align(
          alignment: Alignment.topRight,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            ClipRRect(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
                child: Container(
                  padding: EdgeInsets.all(3),
                  alignment: Alignment.topRight,
                  color: Colors.white70,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _userAvatars(widget.restaurant.usersWhoLiked),
                      SizedBox(width: 4.0),
                      Icon(
                        Icons.check_circle_outline,
                        size: 24.0,
                        color: Colors.green
                      )
                    ],
                  ),
                ))
          ]))
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

  Widget _userAvatars(List<String> userIds) {
    List<Widget> _avatarList = List<Widget>();

    // flag if members array has partial response - that means only auth user is in array
    bool munchMembersNotAvailable = false;

    for (int i = 0; i < userIds.length; i++) {
      if (i + 1 == _maxAvatarsPerRow && _maxAvatarsPerRow < userIds.length) {
        int avatarsLeft = userIds.length - i;
        _avatarList.add(_circleAvatar(avatarsLeft));

        break;
      } else {
        User user = widget.munch.getMunchMember(userIds[i]);

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

      int avatarsLeft = userIds.length - 1;

      if (avatarsLeft > 0) {
        _avatarList.add(_circleAvatar(avatarsLeft));
      }
    } else {
      if (_maxAvatarsPerRow < userIds.length) {
        avatarContainerWidth = _maxAvatarContainerWidth;
      } else {
        avatarContainerWidth = userIds.length * _totalAvatarWidth;
      }
    }

    return SizedBox(
        width: avatarContainerWidth,
        child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end, children: _avatarList));
  }

  void _onCarouselLeftSideTapped() {
    if (widget.currentCarouselPage - 1 >= 0) {
      widget.currentCarouselPage--;
      _carouselController.jumpToPage(widget.currentCarouselPage);
      _incrementImpression(ImpressionDirection.PREVIOUS);
    } else {
      widget.munchBloc.add(NoMoreImagesCarouselEvent(isLeftSideTapped: true));
      _incrementImpression(ImpressionDirection.DEADEND);
    }
  }

  void _onCarouselRightHalfTapped() {
    if (widget.currentCarouselPage + 1 < widget.restaurant.photoUrls.length) {
      widget.currentCarouselPage++;
      _carouselController.jumpToPage(widget.currentCarouselPage);
      _incrementImpression(ImpressionDirection.NEXT);
    } else {
      widget.munchBloc.add(NoMoreImagesCarouselEvent(isLeftSideTapped: false));
      _incrementImpression(ImpressionDirection.DEADEND);
    }
  }

  Widget _carouselControlsRow() {
    return Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Expanded(child: GestureDetector(child: Container(color: Colors.transparent), onTap: _onCarouselLeftSideTapped)),
      Expanded(child: GestureDetector(child: Container(color: Colors.transparent), onTap: _onCarouselRightHalfTapped)),
    ]);
  }

  void _incrementImpression(ImpressionDirection direction) {
    print(widget.imageImpressions);
    String key = Utility.convertEnumValueToString(direction);
    if (widget.imageImpressions[key] == null) widget.imageImpressions[key] = 0;
    widget.imageImpressions[key] += 1;
  }
}
