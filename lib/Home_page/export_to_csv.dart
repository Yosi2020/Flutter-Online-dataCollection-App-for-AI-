import 'dart:async';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:eyu_data_collection/Home_page/homepage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class researchRequest extends StatefulWidget {
  final String eyu;
  researchRequest(@required this.eyu,{Key key}) : super(key: key);

  @override
  _researchRequestState createState() => _researchRequestState(eyu);
}

class _researchRequestState extends State<researchRequest> {

  final String eyu;
  _researchRequestState(@required this.eyu);

  @override

  List<List<dynamic>> CollectedData;
  List researchList =[];

  void initState(){
    getData();
    buildItems(researchList);
  }

  void getlist(){
    CollectedData  = List<List<dynamic>>.empty(growable: true);
    for (int i = 0; i <researchList.length; i++) {

//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List.empty(growable: true);
      row.add(researchList[i]["DateTime"]);
      row.add(researchList[i]["id"]);
      row.add(researchList[i]["Email"]);
      row.add(researchList[i]["Label Name"]);
      row.add(researchList[i]["Latitude"]);
      row.add(researchList[i]["Longitude"]);
      row.add(researchList[i]["fileUrl"]);
      CollectedData.add(row);
    }
  }

  getCsv() async {
    await getlist();

    if (await Permission.storage.request().isGranted) {

//store file in documents folder

      String dir = (await getExternalStorageDirectory()).path + "/mycsv.csv";
      String file = "$dir";

      print(dir);

      File f = new File(file);

// convert rows to String and write as csv file

      String csv = const ListToCsvConverter().convert(CollectedData);
      f.writeAsString(csv).then((value) => _showAlertDialog("Image Data Collection for AI",
          "Your request send Successfully. We can get csv file ${dir}"));
    }else{

      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
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
          getCsv();
        },
        label: const Text('Export to CSV'),
        icon: const Icon(Icons.cloud_download_outlined),
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

}
