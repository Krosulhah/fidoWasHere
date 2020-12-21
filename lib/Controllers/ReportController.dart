import 'dart:convert';
import 'dart:ui';



import 'package:dimaWork/Model/breed.dart';
import 'package:dimaWork/Model/colour.dart';
import 'package:dimaWork/Model/fido.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:postgres/postgres.dart';
import 'package:postgres/postgres.dart';
import 'package:postgres/postgres.dart';
import 'package:postgres/postgres.dart';

import '../connectionHandler.dart';

class ReportController{
  ConnectionHandler connectionHandler = new ConnectionHandler();

  Future<List<Breed>> retrievePossibleBreed(String type) async {
    List<Breed> breeds=new List<Breed>();
    var connection = connectionHandler.createConnection();
    await connection.open();
    List<List<dynamic>> results = await connection.query(
        "SELECT * FROM public.\"Breed\" WHERE (typepet= @t OR  typepet= @b) ",
        substitutionValues: {"t": type, "b":'cad'});
    connection.close();
    for(final row in results){
      Breed breed=new Breed();
      breed.setBreedName(row[0]);
      breed.setFidoType(row[1]);
      breeds.add(breed);
    }
    return breeds;
  }

  List<String> returnAllBreedsName(List<Breed>breeds){
    List<String> breedsName=new List<String>();
    for(Breed b in breeds){
      breedsName.add(b.getBreedName());
    }

    return breedsName;
  }

  Future<List<String>> updateBreeds(String typeOfPet) async {
    return returnAllBreedsName(await retrievePossibleBreed(typeOfPet));

  }

  Future<bool> _checkUserAddress(String address) async {
    var latitude;
    var longitude;
    if (address != "") {
      try {
        List<Location> locations = await locationFromAddress(address);
        latitude = locations[0].latitude;
        longitude = locations[0].longitude;
      } catch (e) {
        print(e);
        Fluttertoast.showToast(
            msg: "This address does not exit. Try putting another!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            fontSize: 16.0,
            textColor: Colors.red,
            backgroundColor: Colors.white);
        return false;
      }

      return true;
    } else if (address == "") {
      Fluttertoast.showToast(
          msg:
          "Tap on the map icon to choose the location, or write a regular address!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          fontSize: 16.0,
          textColor: Colors.green,
          backgroundColor: Colors.white);
      return false;
    }
    return false;
  }

  toast(String msg){
    return  Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        fontSize: 16.0,
        textColor: Colors.red,
        backgroundColor: Colors.white);
  }


  checkAndSend(String name, String broughtTo, String foundOn,List<int> image,bool moved, String sexOfPet, String breedOfPet, String typeOfPet, String colorOfCoat) async {
    bool checkUserAddress ;
    if(name==null||name.isEmpty)
      name=" ";
    if(foundOn==null||foundOn.isEmpty)
      return toast("Please add where you've found the Fido");
    if(moved&&(broughtTo==null||broughtTo.isEmpty))
      return toast("Please add the last know position of the Fido");
    checkUserAddress= await _checkUserAddress(foundOn);
    if (checkUserAddress == false)
      return toast("please add a valid location");
    if(broughtTo!=null&&broughtTo.isNotEmpty)
    {
      checkUserAddress= await _checkUserAddress(broughtTo);
      if (checkUserAddress == false)
        return toast("please add a valid location");}
    if(image==null)
      return toast("please add a Picture of the Fido");
    if(sexOfPet==null||sexOfPet.isEmpty)
      return toast("please select a sex value");
    if(breedOfPet==null||breedOfPet.isEmpty)
      return toast("please select a breed value");
    if(typeOfPet==null||typeOfPet.isEmpty)
      return toast("please select Fido's type");
    if(colorOfCoat==null||colorOfCoat.isEmpty)
      return toast("please select Fido's coat color");

    var session = FlutterSession();

    var connection = connectionHandler.createConnection();
    await connection.open();
    String user= await session.get("user");

    //image=FileImage(image(image.path));


    await connection.query(
        "INSERT INTO public.\"Fido\" "
            "(name,sex,breed,colour,type,isclosed,foundhere,broughthere,broughthome,photo,date,reporter) "
            "VALUES (@n,@s,@b,@c,@t,@closed,@fh,@bh,@bhm,@p,@d,@r)",
        substitutionValues: {
          "n": name, "s": sexOfPet.toUpperCase(),"b":breedOfPet,"c":colorOfCoat,"t":typeOfPet,"closed":false,"fh":foundOn,
          "bh":broughtTo,"bhm":!moved,"p":base64Encode(image),"d":DateTime.now().toString(),"r":user
        });

    connection.close();



  }

  retrieveReports(String name,DateTime date,String sexOfPet, String breedOfPet, String typeOfPet, String colorOfCoat) async {
    if(name==null||name.isEmpty)
      return toast("please insert Fido's name");
    if(sexOfPet==null||sexOfPet.isEmpty)
      return toast("please select a sex value");
    if(breedOfPet==null||breedOfPet.isEmpty)
      return toast("please select a breed value");
    if(typeOfPet==null||typeOfPet.isEmpty)
      return toast("please select Fido's type");
    if(colorOfCoat==null||colorOfCoat.isEmpty)
      return toast("please select Fido's coat color");
    if(date.isAfter(DateTime.now()))
      return toast("please select a valid date");

    var connection = connectionHandler.createConnection();

    await connection.open();
    List<List<dynamic>> results= await connection.query(
        "SELECT * FROM public.\"Fido\" WHERE (name=@n OR name=@e) AND (sex= @s OR sex= @sex) AND (breed=@b or breed=@breed) AND colour=@c AND type=@t AND isclosed=@closed AND (date>=@d) ORDER BY date DESC",
        substitutionValues: {
          "n": name,"e": " ","s": sexOfPet.toUpperCase(),"sex":"U","b":breedOfPet,"breed":"UNKNOWN" ,"c":colorOfCoat,"t":typeOfPet,"closed":false ,
          "d":date.toString()
        });

    List<Fido> availableReports= new List<Fido>();

    connection.close();
    if(results==null||results.isEmpty)
      return toast ("no Fidos found");
    var directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    // open a new file in the application directory


    for(List<dynamic> d in results){
      Fido r=new Fido();
      r.setId(d[0]);
      r.setName(d[1]);
      r.setSex(d[2]);
      r.setBreed(d[3]);
      r.setColour(d[4]);
      r.setFoundHere(d[7]);
      r.setBrouthto(d[8]);
      r.setBroughtHome(d[9].toString());
      r.setPhoto(d[12]);
      r.setDate(d[10]);
      r.setReporter(d[11]);
      availableReports.add(r);
    }

    return availableReports;
  }




}