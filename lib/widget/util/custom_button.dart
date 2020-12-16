import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:munch/service/util/super_state.dart';
import 'package:munch/theme/palette.dart';

class CustomButton<T extends SuperState, V extends T> extends StatefulWidget {
  Widget content;
  Color color;
  Color textColor;
  Color splashColor;
  Function onPressedCallback;
  Function onActionDoneCallback;
  bool disabled = false;
  Bloc<dynamic, T> cubit;
  bool listenToBloc;
  State widgetState;
  bool flat = false;
  double minWidth = 0.0;
  double height = 0.0;
  EdgeInsetsGeometry padding = EdgeInsets.all(8.0);
  double borderRadius = 0.0;
  double borderWidth = 0.0;
  Color borderColor;
  double elevation;
  bool Function(SuperState superState) additionalLoadingConditionCallback;

  CustomButton.disabled(this.content) {
    this.disabled = true;
    this.listenToBloc = false;
  }

  CustomButton(
      {this.content,
      this.cubit,
      this.listenToBloc = false,
      this.color = Palette.secondaryDark,
      this.textColor = Palette.background,
      this.splashColor = Colors.transparent,
      this.onPressedCallback,
      this.onActionDoneCallback,
      this.minWidth = 0.0,
      this.height = 0.0,
      this.padding = const EdgeInsets.all(8.0),
      this.flat = false,
      this.borderRadius = 0,
      this.borderWidth = 0.0,
      this.borderColor,
      this.elevation = 4.0,
      this.disabled = false});

  CustomButton.bloc({
    this.cubit,
    this.content,
    this.listenToBloc = true,
    this.color = Palette.secondaryDark,
    this.textColor = Palette.background,
    this.splashColor = Colors.transparent,
    this.onPressedCallback,
    this.onActionDoneCallback,
    this.minWidth = 0.0,
    this.height = 0.0,
    this.padding = const EdgeInsets.all(8.0),
    this.flat = false,
    this.borderRadius = 0,
    this.borderWidth = 0.0,
    this.borderColor,
    this.elevation = 4.0,
    this.additionalLoadingConditionCallback,
    this.disabled = false,
  }) {
    if (this.additionalLoadingConditionCallback == null) {
      this.additionalLoadingConditionCallback = (SuperState superState) {
        return true;
      };
    }
  }

  @override
  State<CustomButton> createState() => _CustomButtonState<T, V>();
}

class _CustomButtonState<T extends SuperState, V extends T> extends State<CustomButton> {
  GlobalKey _buttonKey = GlobalKey();
  double initialWidth;
  double initialHeight;

  @override
  void initState() {
    // CustomButton is stateless widget in order to calculate initial sizes of it, to be possible to print _loadingAnimation without resizing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // after render is done, button size is calculated to be used in loading animation if necessary (bloc called)
      _calculateInitialSizes();
    });

    super.initState();
  }

  // store initialHeight and width of the button to keep button same size when it's content is loading animation
  void _calculateInitialSizes() {
    if (initialWidth == null) {
      initialWidth = _buttonKey.currentContext.size.width - widget.padding.horizontal * 2;
      // for some strange reason paddingVertical shouldn't be multiplied by 2
      initialHeight = _buttonKey.currentContext.size.height - widget.padding.vertical;
    }
  }

  void _buttonPressed(BuildContext context) {
    widget.onPressedCallback();
  }

  Widget _loadingAnimation() {
    // use initialHeight and width of the button to keep button same size when it's content is loading animation, otherwise button will resize
    return SizedBox(
        width: initialWidth,
        height: initialHeight,
        child: SpinKitThreeBounce(
          color: widget.textColor,
          // condition in case button is very small
          size: initialWidth < 30.0 ? initialWidth * 0.5 : 20.0,
        ));
  }

  Widget _renderButton(BuildContext context, {bool isLoading = false}) {
    return ButtonTheme(
        key: _buttonKey,
        padding: widget.padding,
        //adds padding inside the button
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //limits the touch area to the button area
        minWidth: widget.minWidth,
        //wraps child's width
        height: widget.height,
        // splash color on button tap
        splashColor: widget.splashColor,
        highlightColor: widget.splashColor,
        // shape with border color
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            side: BorderSide(
                width: widget.borderWidth,
                color: widget.disabled ? Palette.disabledColor : widget.borderColor ?? widget.color)),
        disabledColor: widget.disabled ? Palette.disabledColor : widget.color,
        //wraps child's height
        child: (widget.flat)
            ? FlatButton(
                child: !isLoading ? widget.content : _loadingAnimation(),
                color: widget.color,
                textColor: widget.textColor,
                onPressed: (widget.disabled || isLoading) ? null : () => _buttonPressed(context))
            : RaisedButton(
                child: !isLoading ? widget.content : _loadingAnimation(),
                color: widget.color,
                textColor: widget.textColor,
                elevation: widget.elevation,
                onPressed: (widget.disabled || isLoading) ? null : () => _buttonPressed(context)));
  }

  Widget _renderBlocButton(BuildContext context) {
    return BlocConsumer<Bloc<dynamic, T>, T>(
      cubit: widget.cubit,
      listenWhen: (T previous, T current) => current is V && current.ready,
      listener: (BuildContext context, T state) {
        if (widget.onActionDoneCallback != null) {
          widget.onActionDoneCallback(state);
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
    if (state.loading && state is V && widget.additionalLoadingConditionCallback(state)) {
      isLoading = true;
    }

    return _renderButton(context, isLoading: isLoading);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listenToBloc) {
      return _renderBlocButton(context);
    } else {
      return _renderButton(context);
    }
  }
}
