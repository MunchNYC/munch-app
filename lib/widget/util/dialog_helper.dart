import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munch/service/util/super_state.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/util/navigation_helper.dart';

// DON'T EVER PUT BlocProvider in Context tree of widget which will be disposes (like dialog), because Flutter will disable bloc provided into this BlocProvider
// Always parametrize dialogContent with required bloc outside of this widget
class DialogHelper{
  String dialogTitle;
  Widget dialogContent;
  Color dialogTitleColor;
  bool showCloseIcon;

  DialogHelper({this.dialogTitle, this.dialogContent, this.dialogTitleColor = Palette.primary, this.showCloseIcon = true});

  void show(BuildContext context){
    showDialog(
        context: context,
        useRootNavigator: false,
        builder: (BuildContext ctx) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if(dialogTitle != null) _dialogHeader(ctx),
                        if(dialogTitle != null) Divider(thickness: 1, color: Palette.secondaryLight),
                        if(dialogTitle != null) SizedBox(height: 5.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: dialogContent
                        )
                      ]
                  )
              )
          );
        }
    );
  }

  Widget _dialogHeader(BuildContext context){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child:Text(dialogTitle, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600), textAlign: TextAlign.center)
        ),
        if(showCloseIcon)
        GestureDetector(
          child: Icon(Icons.close, size: 18.0),
          onTap: (){
            NavigationHelper.popRoute(context);
          },
        )
      ],
    );
  }
}