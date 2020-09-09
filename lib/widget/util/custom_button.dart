import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munch/service/util/super_state.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/util/app.dart';

import 'alert_dialog_builder.dart';

class CustomButton<T extends SuperState, V extends T> extends StatelessWidget {
  Widget content;
  Color color;
  Color textColor;
  Color splashColor;
  Function onPressedCallback;
  Function onActionDoneCallback;
  bool openDialog = false;
  String dialogText;
  String dialogTitle;
  bool disabled = false;
  Bloc<dynamic, T> bloc;
  State widgetState;
  bool flat = false;
  double minWidth = 0.0;
  double height = 0.0;
  EdgeInsetsGeometry padding = EdgeInsets.all(8.0);
  double borderRadius = 0.0;
  double borderWidth = 0.0;
  Color borderColor;

  CustomButton.disabled(this.content) {
    this.disabled = true;
  }

  CustomButton(
      {this.content,
        this.color = Palette.secondaryDark,
        this.textColor = Palette.background,
        this.splashColor = Palette.secondaryLight,
        this.onPressedCallback,
        this.onActionDoneCallback,
        this.minWidth = 0.0,
        this.height = 0.0,
        this.padding = const EdgeInsets.all(8.0),
        this.flat = false,
        this.borderRadius = 0,
        this.borderWidth = 0.0,
        this.borderColor
      });

  CustomButton.bloc(
      {this.bloc,
      this.content,
      this.color = Palette.secondaryDark,
      this.textColor = Palette.background,
      this.splashColor = Palette.secondaryLight,
      this.onPressedCallback,
      this.onActionDoneCallback,
      this.minWidth = 0.0,
      this.height = 0.0,
      this.padding = const EdgeInsets.all(8.0),
      this.flat = false,
      this.borderRadius = 0,
      this.borderWidth = 0.0,
      this.borderColor});

  CustomButton.blocWithDialog(
      {this.bloc,
      this.content,
      this.color = Palette.secondaryDark,
      this.textColor = Palette.background,
      this.splashColor = Palette.secondaryLight,
      this.onPressedCallback,
      this.onActionDoneCallback,
      this.dialogText,
      this.dialogTitle,
      this.minWidth = 0.0,
      this.height = 0.0,
      this.padding = const EdgeInsets.all(8.0),
      this.flat = false,
      this.borderRadius = 0.0,
      this.borderWidth = 0.0,
      this.borderColor}) {
    this.openDialog = true;
  }

  void _buttonPressed(BuildContext context) {
    if (openDialog) {
      AlertDialogBuilder().showAlertDialogWidget(context, dialogTitle, dialogText, onPressedCallback);
    } else {
      onPressedCallback();
    }
  }

  Widget _renderButton(BuildContext context) {
    return ButtonTheme(
        padding: padding,
        //adds padding inside the button
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //limits the touch area to the button area
        minWidth: minWidth,
        //wraps child's width
        height: height,
        // splash color on button tap
        splashColor: splashColor,
        // shape with border color
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(width: borderWidth, color: borderColor ?? color)
        ),
        //wraps child's height
        child: (flat)
            ? FlatButton(
                child: content,
                color: color,
                textColor: textColor,
                onPressed: disabled ? null : () => _buttonPressed(context))
            : RaisedButton(
                child: content,
                color: color,
                textColor: textColor,
                elevation: 4.0,
                onPressed: disabled ? null : () => _buttonPressed(context)));
  }

  Widget _renderBlocButton(BuildContext context) {
    return BlocConsumer<Bloc<dynamic, T>, T>(
      bloc: bloc,
      listenWhen: (T previous, T current) => current.ready && current is V,
      listener: (BuildContext context, T state) {
        if (onActionDoneCallback != null) {
          if (state.data != null) {
            onActionDoneCallback(state.data);
          } else {
            onActionDoneCallback();
          }
        }
      },
      buildWhen: (T previous, T current) => current is V,
      builder: (context, state) {
        return _buildButton(context, state);
      },
    );
  }

  Widget _buildButton(BuildContext context, SuperState state) {
    // Important condition, first time when BlocBuilder is called, condition isn't checked, so state can be different than Initial state
    if (state.loading && state is V) {
      return Center(child: CircularProgressIndicator());
    } else {
      return _renderButton(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bloc != null && !disabled) {
      return _renderBlocButton(context);
    } else {
      return _renderButton(context);
    }
  }
}
