import 'package:eyu_data_collection/auth_page/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController controlFname = TextEditingController();
  TextEditingController controlLname = TextEditingController();
  TextEditingController controlEmail = TextEditingController();
  TextEditingController controlPassword = TextEditingController();
  TextEditingController controlConfPassword = TextEditingController();

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
                      Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 35.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Merriweather"
                        ),),
                      const SizedBox(height: 21.0,),
                buildTextField(
                    title: "FirstName",
                    controller: controlFname,
                    autoHint: "First Name",
                    size: MediaQuery.of(context).size.width/1.4,
                    match: r'^[a-z, A-Z]+$',
                    Eicon: Icon(Icons.person)
                ),
                SizedBox(height: 10.0,),
                buildTextField(
                    title: "LastName",
                    controller: controlLname,
                    autoHint: "Last Name",
                    size: MediaQuery.of(context).size.width/1.4,
                    match: r'^[a-z, A-Z]+$',
                    Eicon: Icon(Icons.person)),
                SizedBox(height: 10.0,),
                buildTextField(
                    title: "Email",
                    controller: controlEmail,
                    autoHint: "test@gmail.com",
                    size: MediaQuery.of(context).size.width/1.4,
                    match: r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}',
                    Eicon: Icon(Icons.email)),
                SizedBox(height: 10.0,),
                buildTextFieldPassword(
                    title: "Password",
                    controller: controlPassword,
                    autoHint: "*******",
                    size: MediaQuery.of(context).size.width/1.4),
                SizedBox(height: 10.0,),
                buildTextFieldConfPassword(
                    title: "Conform password",
                    controller: controlConfPassword,
                    autoHint: "*******",
                    size: MediaQuery.of(context).size.width/1.4),

                SizedBox(height: 20.0,),

                Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //SizedBox(width: 140,),
                    FlatButton(
                        color: Colors.lightBlue,
                        onPressed: (){
                          final isValid = formKey.currentState.validate();

                          if (isValid) {
                            create();
                          }
                        },
                        child: Text("Create Account",
                          style: TextStyle(color: Colors.white),)),
                    SizedBox(height: 12.0,),
                    FlatButton(
                        color: Colors.grey[200],
                        onPressed: (){
                          Navigator.pop(context);
                          //Navigator.of(context).push(MaterialPageRoute(builder: (context) =>AdminPage()))
                        },
                        child: Text("Cancel")),
                    ],
                  ),
                ]),
              ),
            ]
                )
              )
            )
    )
    );
  }
  Widget buildTextField({
    @required title,
    @required TextEditingController controller,
    int maxLines=1,
    @required String autoHint,
    @required size,
    @required match,
    @required Eicon,
  }) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size,
            child: TextFormField(
                controller: controller,
                maxLines: maxLines,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: autoHint,
                  prefixIcon: Eicon,
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

  bool isHiddenPassword1 = true;
  Widget buildTextFieldConfPassword({
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
              obscureText: isHiddenPassword1,
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: autoHint,
                prefixIcon: Icon(Icons.security),
                suffixIcon: InkWell(
                  onTap: _togglePasswordconf,
                  child:isHiddenPassword1 ? Icon(
                    Icons.visibility,
                  ): Icon(Icons.visibility_off),
                ),),
              validator: (value) {
                if (value.length <= 7 && value == controlPassword.text)
                  return "Your password didn't match together";
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
  void _togglePasswordconf(){
    if(isHiddenPassword1 == true){
      isHiddenPassword1 = false;
    }
    else isHiddenPassword1 = true;
    setState(() {
      isHiddenPassword1 = isHiddenPassword1;
    });
  }

  void create() {
    String FirstName = controlFname.text.trim();
    String LastName = controlLname.text.trim();
    String Email = controlEmail.text.trim();
    String Password = controlPassword.text.trim();
    register(FirstName, LastName, Email, Password);
  }
  final CollectionReference collectionRef =
  FirebaseFirestore.instance.collection("Create_Account");

  Future<void> register(String FirstName, LastName, Email, Password) async {
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: Email, password: Password)
        .then((value) => {
      postDetialToFirebase(FirstName, LastName, Email, Password)})
        .catchError((error) =>print(error));
        //_showAlertDialog("Image Data Collection for AI",
          //  "Problem on sending Your request, please try again."));
  }

  postDetialToFirebase(FirstName, LastName, Email, Password) async{
    await printDocID();
    return collectionRef.add(
      {'First Name': FirstName,
        "Last Name": LastName,
        "Email": Email,
        "Password": Password,},
    ).then((eyu) =>  _showAlertDialog("Image Data Collection for AI",
        "Your request send Successfully. You can login"))
        .catchError((error) =>
        _showAlertDialog("Image Data Collection for AI",
            "Problem on sending Your request, please try again."));
  }

  printDocID() async {
    var querySnapshots = await collectionRef.get();
    for (var snapshot in querySnapshots.docs) {
      var documentID = snapshot.id;
      debugPrint(documentID);
    }
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