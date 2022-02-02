import 'package:eyu_data_collection/Home_page/homepage.dart';
import 'package:eyu_data_collection/auth_page/forget_password.dart';
import 'package:eyu_data_collection/auth_page/signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  final formKey = GlobalKey<FormState>();

  TextEditingController controlEmail = TextEditingController();
  TextEditingController controlPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Center(
              child: Column(
                children: [
                  Image.asset(
                    MediaQuery.of(context).platformBrightness ==
                        Brightness.light ? "assets/images/1.jpeg"
                        : 'assets/images/4.jpg',
                    height: 300,
                  ),
                Container(
            padding: EdgeInsets.only(
                top: 10.0, right: 50.0,
                left: 50.0, bottom: 10.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 5.0,),
                Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 35.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Merriweather"
                  ),),
                const SizedBox(height: 21.0,),
                buildTextField(
                    title: "Email",
                    controller: controlEmail,
                    autoHint: "test@gmail.com",
                    size: MediaQuery.of(context).size.width/1.4,
                    match: r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}'),
                SizedBox(height: 20.0,),
                buildTextFieldPassword(
                    title: "Password",
                    controller: controlPassword,
                    autoHint: "*******",
                    size: MediaQuery.of(context).size.width/1.4),
                SizedBox(height: 20.0,),

                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(width: 30,),
                    FlatButton(
                        color: Colors.grey[200],
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>ForgetPassword()));
                        },
                        child: Text("Forget Password")),
                    SizedBox(width: 5.0,),
                    FlatButton(
                        color: Colors.lightBlue,
                        onPressed: (){
                          // you must remove this one when i apply flutter database
                          final isValid = formKey.currentState.validate();

                          if (isValid) {
                            create();
                            debugPrint("i AM HERE");
                          }
                        },
                        child: Text("LogIn",
                          style: TextStyle(color: Colors.white),)),
                  ],),
                FlatButton(
                    color: Colors.grey[200],
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>SignInPage()));
                    },
                    child: Text("Create Account")),
              ],
            ),
          ),
                ],
              )),
      ))
    );
  }
  Widget buildTextField({
    @required title,
    @required TextEditingController controller,
    int maxLines=1,
    @required String autoHint,
    @required size,
    @required match,
  }) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size, child: TextFormField(
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: autoHint,
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value.isEmpty || !RegExp(match).hasMatch(value))
                  return "Enter a correct " + title;
                else
                  return null;
              }
          ),
          )

        ],
      );
  bool isHiddenPassword = true;

  Widget buildTextFieldPassword({
    @required title,
    @required TextEditingController controller,
    int maxLines =1,
    @required String autoHint,
    @required size,
    @required match
  }) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size, child: TextFormField(
              obscureText: isHiddenPassword,
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: autoHint,
                prefixIcon: Icon(Icons.security),
                suffixIcon: InkWell(
                  onTap: _togglePassword,
                  child:isHiddenPassword ? Icon(
                    Icons.visibility,
                  ): Icon(Icons.visibility_off),
                ),),
              validator: (value) {
                if (value.length <= 7)
                  return "Your password must be >= 7 digit";
                else
                  return null;
              }
          ),
          )

        ],
      );
  void _togglePassword(){
    if(isHiddenPassword == true){
      isHiddenPassword = false;
    }
    else isHiddenPassword = true;
    setState(() {
      isHiddenPassword = isHiddenPassword;
    });
  }

  void create() {
    String eyu = controlEmail.text;
    String Email = controlEmail.text.trim();
    String Password = controlPassword.text.trim();
    login(Email, Password, eyu);
  }

  Future<void> login(String Email, Password, eyu) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: Email, password: Password)
        .then((value) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=>HomePage(eyu))
    ))
        .catchError((error) =>
        _showAlertDialog("Image Data Collection for AI",
            "Problem on sending Your request, please try again."));
  }

  void _showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
        title: Text(title),
        content: Text(message),
        backgroundColor: Colors.deepPurpleAccent,
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
        actions: <Widget>[
          new FlatButton(
            child: Text('Exit'),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LogInPage())
              );
            },
          ),
        ]
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog);
  }

}


