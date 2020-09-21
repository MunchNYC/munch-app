import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:munch/service/util/super_state.dart';
import 'package:munch/theme/palette.dart';

class CustomButton<T extends SuperState, V extends T> extends StatelessWidget {
  Widget content;
  Color color;
  Color textColor;
  Color splashColor;
  Function onPressedCallback;
  Function onActionDoneCallback;
  bool disabled = false;
  Bloc<dynamic, T> cubit;
  State widgetState;
  bool flat = false;
  double minWidth = 0.0;
  double height = 0.0;
  EdgeInsetsGeometry padding = EdgeInsets.all(8.0);
  double borderRadius = 0.0;
  double borderWidth = 0.0;
  Color borderColor;
  double elevation;

  GlobalKey _buttonKey = GlobalKey();
  double initialWidth;
  double initialHeight;

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
        this.borderColor,
        this.elevation = 8.0
      });

  CustomButton.bloc(
      {this.cubit,
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
      this.borderColor,
      this.elevation = 8.0});

  void _buttonPressed(BuildContext context) {
    // store initialHeight and width of the button to keep button same size when it's content is loading animation
    if(initialWidth == null){
      initialWidth = _buttonKey.currentContext.size.width - padding.horizontal * 2;

      // for some strange reason paddingVertical shouldn't be multiplied by 2
      initialHeight = _buttonKey.currentContext.size.height - padding.vertical;
    }

    onPressedCallback();
  }

  Widget _loadingAnimation(){
    // use initialHeight and width of the button to keep button same size when it's content is loading animation, otherwise button will resize
    return SizedBox(
      width: initialWidth,
      height: initialHeight,
      child: SpinKitThreeBounce(
        color: textColor,
        size: 20.0,
      )
    );
  }

  Widget _renderButton(BuildContext context, {bool isLoading = false}) {
    return ButtonTheme(
        key: _buttonKey,
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
        disabledColor: !isLoading ? Palette.secondaryLight : color,
        //wraps child's height
        child: (flat)
            ? FlatButton(
                child: !isLoading ? content : _loadingAnimation(),
                color: color,
                textColor: textColor,
                onPressed: (disabled || isLoading) ? null : () => _buttonPressed(context))
            : RaisedButton(
                child: !isLoading ? content : _loadingAnimation(),
                color: color,
                textColor: textColor,
                elevation: elevation,
                onPressed: (disabled || isLoading) ? null : () => _buttonPressed(context)));
  }

  Widget _renderBlocButton(BuildContext context) {
    return BlocConsumer<Bloc<dynamic, T>, T>(
      cubit: cubit,
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
    bool isLoading = false;

    // Important condition, first time when BlocBuilder is called, condition isn't checked, so state can be different than Initial state
    if (state.loading && state is V) {
      isLoading = true;
    }

    return _renderButton(context, isLoading: isLoading);
  }

  @override
  Widget build(BuildContext context) {
    if (cubit != null && !disabled) {
      return _renderBlocButton(context);
    } else {
      return _renderButton(context);
    }
  }
}
