import 'package:munch/model/user.dart';
import 'package:flutter/cupertino.dart';

class PersonalInformationScreen extends StatefulWidget {
  User user;

  PersonalInformationScreen({this.user});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {

  FocusNode _nameFieldFocusNode = FocusNode();

  TextEditingController _nameTextController = TextEditingController();

  @override
  void initState() {
    _initializeFormFields();
    _nameFieldFocusNode.addListener(_onFirstNameFieldFocusChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  void dispose() {
    _nameFieldFocusNode.dispose();
    super.dispose();
  }

  void _initializeFormFields() {
    _nameTextController.text = widget.user.displayName;
  }

  void _onFirstNameFieldFocusChange() {

  }
}