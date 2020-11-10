import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_demo/resources/repository.dart';
import 'package:my_demo/screens/invite.dart';
import 'package:my_demo/screens/emptyFeedback.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:my_demo/screens/invite_without_gift.dart';
import 'package:my_demo/viewmodel/login_viewmodel.dart';
import 'blocs/login_event.dart';
import 'blocs/login_state.dart';
import 'model/myfeedback.dart';
import 'package:my_demo/blocs/login_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Feedback.vn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  LoginBloc loginBloc;
  TextEditingController codeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  double _topPadding = 0;
  ScrollController scrollController;
  final GlobalKey<FormState> formLogin = GlobalKey<FormState>();
  ProgressDialog progressDialog;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginBloc = LoginBloc(repository: Repository());
    scrollController = ScrollController();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);
        setState(() {
          if (visible) {
            _topPadding = MediaQuery.of(context).size.height*0.5;
            scrollController.animateTo(MediaQuery.of(context).size.height * 0.1,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
//            print(MediaQuery.of(context).viewInsets.bottom);
          } else {
            _topPadding = 0.0;
            scrollController.animateTo(0,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          }
        });
      },
    );
    navigateToInvite(true);
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    progressDialog.style(message: "Vui lòng chờ giây lát ...", progressWidget: CircularProgressIndicator(), padding: EdgeInsets.all(20));
    AssetImage feedbackImage = AssetImage('assets/ic_feedback.png');
    Image icon = Image(
      image: feedbackImage,
      height: MediaQuery.of(context).size.height * 0.1,
    );
    return BlocListener<LoginBloc, LoginState>(
        bloc: loginBloc,
        listener: (context, state) {
          if (state is LoginFailure) {
            Fluttertoast.showToast(
                msg: state.error,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: MediaQuery.of(context).size.height * 0.033);
            progressDialog.hide();
          } else if (state is LoginSuccess) {
            MyFeedback myFeedback = state.myFeedback;
            LoginViewModel loginViewModel = state.loginViewModel;
            progressDialog.hide();
            if(myFeedback.description!=null){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) => Invite(
                    myFeedback: myFeedback,
                    loginViewModel: loginViewModel)), (route) => false);
            }else{
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) => InviteWithoutGift(
                    myFeedback: myFeedback,
                    loginViewModel: loginViewModel)), (route) => false);
            }
          } else if (state is LoginSuccessWithoutFeedback){
            progressDialog.hide();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) => EmptyFeedback()), (route) => false);
          }
        },
        child:
            Scaffold(
                resizeToAvoidBottomInset: true,
                body: Builder(
                    builder: (context) => ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: SingleChildScrollView(
                            controller: scrollController,
                            child: Form(
                              key: formLogin,
                              child: Column(children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.height *0.18),
                                    child: Center(
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            icon,
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.01,
                                              height: MediaQuery.of(context).size.height *0.01,
                                            ),
                                            Text(
                                              "Feedback.vn",
                                              style: TextStyle(
                                                  color: Colors.lightBlue,
                                                  fontSize: MediaQuery.of(context).size.height *0.1,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        alignment: Alignment.topCenter,
                                      ),
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.05),
                                    child: Center(
                                        child: Container(
                                      child: TextFormField(
                                        style: TextStyle(fontSize: MediaQuery.of(context).size.height *0.05),
                                        controller: codeController,
                                        decoration: InputDecoration(
                                            errorStyle:
                                                TextStyle(fontSize: MediaQuery.of(context).size.height *0.04),
                                            labelText: "Mã thiết bị",
                                            labelStyle:
                                                TextStyle(fontSize: MediaQuery.of(context).size.height *0.05)),
                                        validator: (String value) {
                                          if (value.trim().isEmpty) {
                                            return 'Mã thiết bị không được để trống';
                                          }
                                          return null;
                                        },
                                      ),
                                      alignment: Alignment.topCenter,
                                      width: MediaQuery.of(context).size.width *0.6,
                                      height: MediaQuery.of(context).size.width *0.11,
                                    ))),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                    child: Center(
                                        child: Container(
                                      child: TextFormField(
                                        validator: (String value) {
                                          if (value.trim().isEmpty) {
                                            return 'Mật khẩu không được để trống';
                                          }
                                          return null;
                                        },
                                        obscureText: true,
                                        style: TextStyle(fontSize: MediaQuery.of(context).size.height *0.05),
                                        controller: passwordController,
                                        decoration: InputDecoration(
                                            errorStyle: TextStyle(fontSize: MediaQuery.of(context).size.height *0.04),
                                            labelText: "Mật khẩu",
                                            labelStyle:
                                                TextStyle(fontSize: MediaQuery.of(context).size.height *0.05)),
                                      ),
                                      alignment: Alignment.topCenter,
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      height: MediaQuery.of(context).size.width *0.11,
                                    ))),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.08),
                                  child: Center(
                                    child: Container(
                                      child: RaisedButton(
                                        child: Text(
                                          "Đăng nhập",
                                          style: TextStyle(fontSize: MediaQuery.of(context).size.height *0.04),
                                        ),
                                        color: Colors.lightBlue,
                                        textColor: Colors.white,
                                        onPressed: () {
                                          if (formLogin.currentState
                                              .validate()) {
                                            progressDialog.show();
                                            navigateToInvite(false);
                                          }
                                        },
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: _topPadding,
                                  width: MediaQuery.of(context).size.width,
                                )
                              ]),
                            ))))));
  }

  void navigateToInvite(bool isAlreadyLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginBloc.add(LoginButtonPressed(
        loginViewModel: LoginViewModel.withParams(
            codeController.text.trim(),
            passwordController.text.trim(),
            isAlreadyLogin)));
  }
}
