import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';

class EmptyMunchesListWidget extends StatelessWidget {
  MunchBloc munchBloc;

  EmptyMunchesListWidget({this.munchBloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 12.0, left: 24.0, right: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 74.0),
            Container(
              child: Image(image: AssetImage('assets/images/homeScreenLogo.png'), height: 144, width: 144),
            ),
            SizedBox(height: 28.0),
            Text(
                App.translate("empty_munches_list_widget.screen_title.text"),
                style: AppTextStyle.style(AppTextStylePattern.heading2, fontWeight: FontWeight.w500, color: Palette.secondaryDark.withOpacity(0.5))
            ),
            SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(App.translate("empty_munches_list_widget.screen_body_instructions_prefix.text"), strutStyle: StrutStyle(fontSize: 16)),
                Text(" + ", style: TextStyle(color: Palette.secondaryDark)),
                Text(App.translate("empty_munches_list_widget.screen_body_instructions_suffix.text"), strutStyle: StrutStyle(fontSize: 16)),
              ],
            )
          ],
        ));
  }
}
