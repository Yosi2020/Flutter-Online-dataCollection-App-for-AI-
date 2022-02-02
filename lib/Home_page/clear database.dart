import 'dart:async';
import 'package:eyu_data_collection/Home_page/homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class clearData extends StatefulWidget {
  final String eyu;
  clearData(@required this.eyu,{Key key}) : super(key: key);

  @override
  _clearDataState createState() => _clearDataState(eyu);
}

class _clearDataState extends State<clearData> {

  final String eyu;
  _clearDataState(@required this.eyu);

  @override

  List<List<dynamic>> CollectedData;
  List researchList =[];

  void initState(){
    getData();
    buildItems(researchList);
  }

  DeleteData() async{
    for (int i =0; i < researchList.length; i++)
    if(researchList[i]["Email"] == eyu.toString().trim()){
      if(researchList[i]['fileUrl'] != null){
        firebase_storage.Reference ref1 =
        firebase_storage.FirebaseStorage.instance
            .refFromURL(researchList[i]['fileUrl'].toString().trim());
        ref1.delete();
        print('image deleted');
      }
      await FirebaseFirestore.instance
          .collection("datacollected")
          .where("Email", isEqualTo : eyu.toString().trim())
          .get().then((value){
        value.docs.forEach((element) {
          FirebaseFirestore.instance.collection("datacollected").doc(element.id).delete().then((value){
            print("Success!");
            _showAlertDialog("Image Data Collection for AI",
                "Your request send Successfully. Thanks For using our App");
          });
        });
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Datas of Collected"),
        centerTitle: true,
      ),
      body:Padding(
        padding: EdgeInsets.only(
            top: 10, bottom: 10, left: 5, right: 5
        ),
        child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
            elevation: 5,
            child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      "Something went wrong",
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    researchList = snapshot.data as List;
                    return buildItems(researchList);
                  }
                  return const Center(child: CircularProgressIndicator());
                })),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          _showAlertDialog1("Image Data Collection for AI",
              "Are you sure to deleted your files");
        },
        label: const Text('Clear Your Data'),
        icon: const Icon(Icons.delete_forever),
        backgroundColor: Colors.pink,),
    );
  }

  Widget buildItems(researchList) => ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: researchList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        for(int k = 0; k<researchList.length; k++){
        if(researchList[k]["Email"] == "eyosimar524@gmail.com") {
          TextStyle titleStyle = Theme
              .of(context)
              .textTheme
              .subtitle1;
          return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.person),
              ),
              title: Text("${researchList[k]["Email"]}", style: titleStyle,),
              subtitle: Text(researchList[k]["DateTime"]),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
              onTap: () {}
          );
        }}});


  int count =0;

  List libraryResearchList =[];

  final CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection("datacollected");

  Future getData() async{
    try{
      await _collectionRef.get().then((querySnapshot){
        for (var result in querySnapshot.docs){
          libraryResearchList.add(result.data());
        }
      });
      return libraryResearchList;
    } catch (e){
      debugPrint("Error -$e");
      return null;
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

  void _showAlertDialog1(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
        title: Text(title),
        content: Text(message),
        backgroundColor: Colors.deepPurpleAccent,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(15)),
        actions: <Widget>[
          new FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          new FlatButton(
            child: Text('yes'),
            onPressed: () {
              DeleteData();
            },
          ),

        ]
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog);
  }

}
