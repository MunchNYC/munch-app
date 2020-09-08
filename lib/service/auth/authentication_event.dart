import 'package:flutter/material.dart';

abstract class AuthenticationEvent {}

class LoginWithGoogleEvent extends AuthenticationEvent {}
class LogoutEvent extends AuthenticationEvent {}