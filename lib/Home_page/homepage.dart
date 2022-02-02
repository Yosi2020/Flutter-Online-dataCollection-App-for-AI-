import 'dart:io';
import 'dart:io' as io;
import 'package:eyu_data_collection/Home_page/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eyu_data_collection/Home_page/menu_drawer.dart';
import 'package:eyu_data_collection/model/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final String eyu;
  HomePage(@required this.eyu, {Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(eyu);
}

class _HomePageState extends State<HomePage> {
  final String eyu;
  _HomePageState(@required this.eyu);

  File imageFile;
  var locationMessage = "";
  String value;
  var position;

  void initState(){
    getCurrentLocation();

}
  Future pickImage() async{
    try{
      final image = await ImagePicker().pickImage(source:  ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.imageFile = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: ');
    }

  }

  Future pickCamera() async{
    try{
      final image = await ImagePicker().pickImage(source:  ImageSource.camera);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.imageFile = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: ');
    }
  }

  void getCurrentLocation() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator().getLastKnownPosition();
    print(lastPosition);

    setState(() {
      locationMessage = "Latitude : ${position.latitude}, Longitude :${position.longitude}";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget> [
      Background(),
      Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
           elevation: 0,
            title: Text(
            'Image Data Collection for AI',
            style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            ),
            ),
            centerTitle: true,
    ),
        drawer: Drawer(
            child: MainDrawer(eyu)),
      body: SingleChildScrollView(child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imageFile != null ? Image.file(
              imageFile, width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/3,
            ) : Image.asset("assets/images/4.jpg",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/3,),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildButton(
                    title: 'Pick Gallery',
                    icon: Icons.image_outlined,
                    onClicked: ()=> pickImage(),
                  ),
                  const SizedBox(width: 15,),
                  buildButton(
                    title: 'Pick Camera',
                    icon: Icons.camera_alt_outlined,
                    onClicked: ()=>pickCamera(),
                  ),
                ],
              ),
            SizedBox(height: 20,),
            Center(
              child: DropdownButton(
                items: items.map((itemsname){
                  return DropdownMenuItem(
                      value: itemsname,
                       child: Text(itemsname),
                  );
                }).toList(),
                onChanged: (String newValue){
                  setState(() {
                    this.value = newValue;
                  });
                },
                hint: Text("Label Names"),
                value: value,
              ),
            ),
            SizedBox(height: 15,),
            Icon(Icons.location_on,
            size: 46.0,
            color: Colors.blue,),
            Text("Your Location", style: TextStyle(fontSize: 26.0,
                fontWeight: FontWeight.bold),),
            SizedBox(height: 15.0,),
            Text("Position : "),
            Text("${locationMessage}"),
          ],
        ),
      ),),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Stack(
            fit: StackFit.expand,
            children : [
              Positioned(
                right: 20,
                bottom: 13,
                child: FloatingActionButton.extended(
                  onPressed: (){
                    submit();
                  },
                  label: const Text('Save'),
                  icon: const Icon(Icons.thumb_up),
                  backgroundColor: Colors.pink,),
              ),
              Positioned(
                left: 20,
                bottom: 13,
                child: FloatingActionButton.extended(
                  onPressed: (){
                    setState(() {
                      imageFile = null;
                    });
                  },
                  label: const Text('Delete'),
                  icon: const Icon(Icons.delete),
                  backgroundColor: Colors.pink,),
              ),
            ]
            ),

    )
    ],);
  }
  Widget buildButton({
    @required String title,
    @required IconData icon,
    @required VoidCallback onClicked,
}) => FloatingActionButton(
    onPressed: onClicked,
    tooltip: title,
    child: new Icon(icon),
    backgroundColor: Colors.lightGreen,
  );

  List DataCollection = [];

  final CollectionReference collectionRef =
  FirebaseFirestore.instance.collection("datacollected");

  DateTime currentTime = DateTime.now();
  var url;

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = path.basename(imageFile.path);
    firebase_storage.Reference ref =
    firebase_storage.FirebaseStorage.instance
        .ref().child('uploads').child('/$fileName');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});
    firebase_storage.UploadTask uploadTask;
    //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask = ref.putFile(io.File(imageFile.path), metadata);

    firebase_storage.UploadTask task = await Future.value(uploadTask);

    Future.value(uploadTask).then((value) =>
    {
      print("Upload file path ${value.ref.fullPath}")
    }).onError((error, stackTrace) =>
    {
      print("Upload file path error ${error.toString()} ")
    });

    firebase_storage.TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();
  }

    Future<void> submit() async {
      // uploading file to firebase

      uploadImageToFirebase(context);
      await printDocID();

      // upload url to cloud firebase
      await FirebaseFirestore.instance.collection("datacollected").doc().set(
          {
            "DateTime": DateFormat.yMd().add_jm().format(currentTime).trim(),
            'Latitude': position.latitude.toString().trim(),
            "Longitude": position.longitude.toString().trim(),
            "Label Name": value.trim(),
            "fileUrl": url.trim(),
            "Email":eyu.trim(),
            "id": printDocID.toString().trim()
          }).then((eyu) =>
          _showAlertDialog("JIT Library Request",
              "Your request send Successfully. We will reach you soon"))
          .catchError((error) =>
          _showAlertDialog("JIT Library Request",
              "Problem on sending your request, please try again."));
    }

  printDocID() async {
    var querySnapshots = await collectionRef.get();
    for (var snapshot in querySnapshots.docs) {
      var documentID = snapshot.id;
      debugPrint(documentID);
    }
  }

    void _showAlertDialog(String title, String message) {
      AlertDialog alertDialog = AlertDialog(
          title: Text(title),
          content: Text(message),
          backgroundColor: Colors.deepPurpleAccent,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15)),
          actions: <Widget>[
            new FlatButton(
              child: Text('Exit'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute
                  (builder: (context) => HomePage(eyu)));
              },
            ),
          ]
      );
      showDialog(
          context: context,
          builder: (_) => alertDialog);
    }

}
