import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/widget/util/custom_button.dart';
import 'package:munch/widget/util/custom_form_field.dart';

class CreateJoinDialog extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => CreateJoinDialogState();
}

class CreateJoinDialogState extends State<CreateJoinDialog>{
  @override
  Widget build(BuildContext context) {
      return Container(
          child: Column(
              children: <Widget>[
                _joinMunchForm(),
                SizedBox(height: 12.0),
                _dividerRow(),
                SizedBox(height: 12.0),
                _createMunchForm()
              ]
          ),
      );
  }

  Widget _joinMunchForm(){
      return Form(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
                child: CustomFormField(
                  textStyle: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.primary),
                  hintText: App.translate("create_join_dialog.join_textfield.hint"),
                  hintStyle: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight),
                )
            ),
            SizedBox(width: 12.0),
            CustomButton(
              minWidth: 72.0,
              borderRadius: 4.0,
              content: Text(App.translate("create_join_dialog.join_button.text"), style: AppTextStyle.style(AppTextStylePattern.body3Inverse)),
              onPressedCallback: (){},
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

  Widget _createMunchForm(){
    return Form(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: CustomFormField(
                textStyle: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.primary),
                hintText: "Sushi Samurais",
                hintStyle: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight),
              )
          ),
          SizedBox(width: 12.0),
          CustomButton(
            minWidth: 72.0,
            borderRadius: 4.0,
            content: Text(App.translate("create_join_dialog.create_button.text"), style: AppTextStyle.style(AppTextStylePattern.body3Inverse)),
            onPressedCallback: (){},
          )
        ],
      ),
    );
  }

}