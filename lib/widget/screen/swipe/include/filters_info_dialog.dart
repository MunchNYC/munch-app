import 'package:flutter/cupertino.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/widget/util/custom_button.dart';

class FiltersInfoDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Personal Filters", style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: 20.0),
          Text("Only These", style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 1.0, color: Palette.hyperlink, fontWeight: FontWeight.w600)),
          Text("Restaurant you see will have at least one of these cuisines types.", style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 1.0,color: Palette.primary)),
          SizedBox(height: 16.0),
          Text("Definitely No", style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryDark, fontSizeOffset: 1.0, fontWeight: FontWeight.w600)),
          Text("Restaurant you see will not include these cuisine types.", style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 1.0,color: Palette.primary)),
          SizedBox(height: 16.0),
          Text("I'm Okay With", style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight, fontSizeOffset: 1.0, fontWeight: FontWeight.w600)),
          Text("Restaurant you see may or may not include these cuisine types.", style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 1.0, color: Palette.primary)),
          SizedBox(height: 16.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Group Filters", style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: 16.0),
          Text("A smart combination of all personal filters within this Munch. Restaurants shown to everyone will be based on these filters.", style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 1.0, color: Palette.primary)),
          SizedBox(height: 16.0),
          Text("You can change your votes in Personal tab.", style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 1.0, color: Palette.primary)),
          SizedBox(height: 20.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomButton(
                minWidth: 140.0,
                borderRadius: 8.0,
                borderWidth: 1.0,
                flat: true,
                borderColor: Palette.secondaryDark,
                padding: EdgeInsets.symmetric(vertical: 10.0),
                color: Palette.background,
                textColor: Palette.secondaryDark.withOpacity(0.8),
                content: Text("Close", style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w600, color: Palette.secondaryDark.withOpacity(0.8))),
                onPressedCallback: (){
                  // close dialog
                  NavigationHelper.popRoute(context, rootNavigator: true);
                },
              )
            ],
          ),
        ],
      )
    );
  }

}