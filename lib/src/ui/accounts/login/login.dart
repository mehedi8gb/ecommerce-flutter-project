import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './../../../models/app_state_model.dart';
import 'login1/login.dart';
import 'login5/login.dart';
import 'login11/login.dart';
import 'login7/login.dart';
import 'otp_login/phone_number.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          //return Login11();
          if (model.blocks.settings.pageLayout.login == 'layout1') {
            return Login1();
          } else if (model.blocks.settings.pageLayout.login == 'layout2') {
            return PhoneLogin();
          } else if (model.blocks.settings.pageLayout.login == 'layout4') {
            return Login1();
          } else if (model.blocks.settings.pageLayout.login == 'layout5') {
            return Login5();
          } else if (model.blocks.settings.pageLayout.login == 'layout7') {
            return Login7();
          } else {
            return Login1();
          }
        });
  }
}


