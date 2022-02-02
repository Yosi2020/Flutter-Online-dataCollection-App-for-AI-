import 'package:eyu_data_collection/Home_page/background.dart';
import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

  launchurl1() async{
    final url = "https://gunbul.com/";
    if(await canLaunch(url)){
      await launch(url);
    }
    else{
      throw "Could not launch the url";
    }
  }

  launchurl2() async{
    final url = "https://deboengineering.com/";
    if(await canLaunch(url)){
      await launch(url);
    }
    else{
      throw "Could not launch the url";
    }
  }
  launchurl3() async{
    final url = "mailto:aschalew38@gmail.com";
    if(await canLaunch(url)){
      await launch(url);
    }
    else{
      throw "Could not launch the url";
    }
  }
  launchurl4() async{
    final url = "mailto:boazict@gmail.com";
    if(await canLaunch(url)){
      await launch(url);
    }
    else{
      throw "Could not launch the url";
    }
  }
  launchurl5() async{
    final url = "mailto:eyosimar524@gmail.com";
    if(await canLaunch(url)){
      await launch(url);
    }
    else{
      throw "Could not launch the url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Background(),
      Scaffold(
      appBar: AppBar(
        title: Text("BZ apps"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: Column(
        children: [
          Text(
            "Image Data  Collection for AI",
            style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 25.0,
                fontWeight: FontWeight.w600,
                fontFamily: "Merriweather"
            ),),
          SizedBox(height: 16,),
          Text("Developed by:-", style: TextStyle(
              color: Colors.lightBlue,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              fontFamily: "Merriweather")),
          SizedBox(height: 16,),
          Text("Debo Engineering and Wala ICT",
            style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                fontFamily: "Merriweather")),

          SizedBox(height: 25,),
          Divider(color: Colors.blueGrey.shade400,
            thickness: 1,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("App Name"),
              Text("Bz App")
            ],
          ),
          Divider(color: Colors.blueGrey.shade400,
            thickness: 0.5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("App version"),
              Text("3.1")
            ],
          ),
          Divider(color: Colors.blueGrey.shade400,
            thickness: 0.5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Email"),
              Column(
                children: [
                  TextButton(onPressed: ()=>launchurl4(), child: Text("Debo Engineering Email"),),
                  TextButton(onPressed: ()=>launchurl3(), child: Text("Wale ICT Email"),),
                  TextButton(onPressed: ()=>launchurl5(), child: Text("Eyosiyas Tibebu"),)
                ],
              )
            ],
          ),
          Divider(color: Colors.blueGrey.shade400,
            thickness: 0.5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Website"),
              Column(
                children: [
                  TextButton(onPressed: ()=>launchurl1(), child: Text("Debo Engineering"),),
                  TextButton(onPressed: ()=>launchurl2(), child: Text("Wale ICT"),)
                ],
              )
            ],
          ),
          Divider(color: Colors.blueGrey.shade400,
            thickness: 0.5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Phone Number"),
              Column(
                children: [
                  Text("+251911086178"),
                  Text("+25197118898 | +251905556045"),
                  Text("+251913135813")
                ],
              )
            ],
          ),
          Divider(color: Colors.blueGrey.shade400,
            thickness: 1,),
        ],
      ),)
    )],);
  }
}
