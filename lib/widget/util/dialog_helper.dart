import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munch/service/util/super_state.dart';
import 'package:munch/theme/palette.dart';

// Need template T, because in the root of dialog body we have to put bloc, because Dialog has different context
class DialogHelper<T extends Bloc<dynamic, SuperState>>{
  String dialogTitle;
  Widget dialogContent;
  Color dialogTitleColor;
  T bloc;
  bool showCloseIcon;

  DialogHelper({this.dialogTitle, this.dialogContent, this.bloc, this.dialogTitleColor = Palette.primary, this.showCloseIcon = true});

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
                          child: _dialogBody()
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
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Widget _dialogBody(){
    if (bloc != null) {
      return BlocProvider<T>(
        create: (context) => bloc,
        child: dialogContent,
      );
    }
    else {
      return dialogContent;
    }
  }

}