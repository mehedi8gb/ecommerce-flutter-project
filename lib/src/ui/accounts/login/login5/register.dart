import 'package:app/src/ui/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './../../../../models/app_state_model.dart';
import './../../../../ui/accounts/login/login5/clipper.dart';
import './../../../../ui/color_override.dart';

import 'theme_override.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();
  final appStateModel = AppStateModel();
  var formData = new Map<String, dynamic>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ThemeOverride(
      child: Builder(
        builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Builder(
              builder: (context) => Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: CustomPaint(
                      painter: CurvePainter2(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: CustomPaint(
                      painter: CurvePainter(color: Theme.of(context).backgroundColor),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: height * 0.10,
                          ),
                          Text('Hearty Welcome !', style: Theme.of(context).textTheme.headline6!.copyWith(
                            //color: Colors.white,
                              fontSize: 32
                          )),
                          Text('Sign up to create an account', style: Theme.of(context).textTheme.caption!.copyWith(
                            //color: Colors.white,
                              fontSize: 14
                          )),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          PrimaryColorOverride(
                            child: TextFormField(
                              onSaved: (value) => setState(() => formData['first_name'] = value),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return appStateModel.blocks.localeText.pleaseEnterFirstName;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                labelText: appStateModel.blocks.localeText.firstName ,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,),
                          PrimaryColorOverride(
                            child: TextFormField(
                              onSaved: (value) => setState(() => formData['last_name'] = value),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return appStateModel.blocks.localeText.pleaseEnterLastName;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                labelText: appStateModel.blocks.localeText.lastName ,
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,),
                          PrimaryColorOverride(
                            child: TextFormField(
                              onSaved: (value) => setState(() => formData['email'] = value),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return appStateModel.blocks.localeText.pleaseEnterValidEmail;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                labelText: appStateModel.blocks.localeText.email ,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,),
                          PrimaryColorOverride(
                            child: TextFormField(
                              onSaved: (value) => setState(() => formData['password'] = value),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return appStateModel.blocks.localeText.pleaseEnterPassword;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                labelText: appStateModel.blocks.localeText.password ,
                              ),
                              obscureText: true,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,),
                          AccentButton(
                            onPressed: () => _submit(context),
                            text: appStateModel.blocks.localeText.signUp,
                            showProgress: isLoading,
                          ),
                          SizedBox(height: 10.0),
                          FlatButton(
                              padding: EdgeInsets.all(16.0),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      'Already registered?',
                                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                          fontSize: 15,
                                        color: Colors.white,
                                      )),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                        'Sign In',
                                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              )),],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 36,
                      left: 16,
                      child: IconButton(
                          icon: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                //color: Colors.grey.withOpacity(0.5),
                              ),
                              width: 35,
                              height: 35,
                              child: Icon(Icons.arrow_back, size: 18,)
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _submit(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    bool status = await appStateModel.register(formData, context);
    if (status) {
      Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
    }
    setState(() {
      isLoading = false;
    });
  }

  onSaved(String value, String field) {
    formData[field] = value;
  }

  onValidate(String value, String label) {
    if (value == null || value.isEmpty) {
      return label + ' ' + appStateModel.blocks.localeText.isRequired;
    }
    return null;
  }
}



