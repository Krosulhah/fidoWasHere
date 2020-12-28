import 'dart:convert';
import 'dart:ui';

import 'package:dimaWork/Model/breed.dart';
import 'package:dimaWork/Model/colour.dart';
import 'package:dimaWork/Model/fido.dart';
import 'package:dimaWork/Model/user.dart';
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

class ReportController {
  ConnectionHandler connectionHandler = new ConnectionHandler();

  closeReport(Fido result) async {
    var connection = connectionHandler.createConnection();
    await connection.open();
    List<List<dynamic>> results = await connection.query(
        "UPDATE public.\"Fido\" SET isclosed=@c WHERE id=@i ",
        substitutionValues: {"c": true, "i": result.getId()});
    connection.close();
  }

  Future<List<Breed>> retrievePossibleBreed(String type) async {
    List<Breed> breeds = new List<Breed>();
    var connection = connectionHandler.createConnection();
    await connection.open();
    List<List<dynamic>> results = await connection.query(
        "SELECT * FROM public.\"Breed\" WHERE (typepet= @t OR  typepet= @b) ",
        substitutionValues: {"t": type, "b": 'cad'});
    connection.close();
    for (final row in results) {
      Breed breed = new Breed();
      breed.setBreedName(row[0]);
      breed.setFidoType(row[1]);
      breeds.add(breed);
    }
    return breeds;
  }

  List<String> returnAllBreedsName(List<Breed> breeds) {
    List<String> breedsName = new List<String>();
    for (Breed b in breeds) {
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

  toast(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        fontSize: 16.0,
        textColor: Colors.red,
        backgroundColor: Colors.white);
  }

  Future<String> checkFieldsReport(String name,
      String broughtTo,
      String foundOn,
      List<int> image,
      bool moved,
      String sexOfPet,
      String breedOfPet,
      String typeOfPet,
      String colorOfCoat) async {
    bool checkUserAddress;
    if (name == null || name.isEmpty) name = null;
    if (typeOfPet == null || typeOfPet.isEmpty) {
      return("please select Fido's type");

    }
    if (breedOfPet == null ||
        breedOfPet.isEmpty ||
        breedOfPet == "Select Fido's type") {
      return("please select a breed value");

    }
    if (sexOfPet == null || sexOfPet.isEmpty) {
      return("please select a sex value");

    }
    if (foundOn == null || foundOn.isEmpty) {
      return ("Please add where you've found the Fido");
    }
    if (moved && (broughtTo == null || broughtTo.isEmpty)) {
      return("Please add the last know position of the Fido");

    }
    checkUserAddress = await _checkUserAddress(foundOn);
    if (checkUserAddress == false) {
      return("please add a valid location");

    }
    if (broughtTo != null && broughtTo.isNotEmpty) {
      checkUserAddress = await _checkUserAddress(broughtTo);
      if (checkUserAddress == false) {
        return("please add a valid location");

      }
    }

    if (image == null) {
      return  ("please add a Picture of the Fido");

    }

    if (colorOfCoat == null || colorOfCoat.isEmpty) {
      return("please select Fido's coat color");

    }
    return "";
  }

  Future<bool> checkAndSend(
      String name,
      String broughtTo,
      String foundOn,
      List<int> image,
      bool moved,
      String sexOfPet,
      String breedOfPet,
      String typeOfPet,
      String colorOfCoat) async {


    var session = FlutterSession();

    var connection = connectionHandler.createConnection();
    await connection.open();
    String user = await session.get("user");

    //image=FileImage(image(image.path));

    await connection.query(
        "INSERT INTO public.\"Fido\" "
        "(name,sex,breed,colour,type,isclosed,foundhere,broughthere,moved,photo,date,reporter) "
        "VALUES (@n,@s,@b,@c,@t,@closed,@fh,@bh,@bhm,@p,@d,@r)",
        substitutionValues: {
          "n": name,
          "s": sexOfPet.toUpperCase(),
          "b": breedOfPet,
          "c": colorOfCoat,
          "t": typeOfPet,
          "closed": false,
          "fh": foundOn,
          "bh": broughtTo,
          "bhm": !moved,
          "p": base64Encode(image),
          "d": DateTime.now().toString(),
          "r": user
        });

    connection.close();
    return true;
  }

  retrieveMyReports() async {
    var connection = connectionHandler.createConnection();

    String user = await FlutterSession().get("user");
    await connection.open();
    List<List<dynamic>> results = await connection.query(
        "SELECT * FROM public.\"Fido\" WHERE (reporter=@n)AND isclosed=@f ORDER BY date DESC",
        substitutionValues: {"n": user, "f": false});

    List<Fido> availableReports = new List<Fido>();

    connection.close();
    if (results == null || results.isEmpty)
      return toast("no reported Fidos found");
    var directory = await getApplicationDocumentsDirectory();

    for (List<dynamic> d in results) {
      Fido r = new Fido();
      r.setId(d[0]);
      r.setName(d[1]);
      r.setSex(d[2]);
      r.setBreed(d[3]);
      r.setColour(d[4]);
      r.setFoundHere(d[7]);
      r.setBrouthto(d[8]);
      r.setMoved(d[9].toString());
      r.setPhoto(d[12]);
      r.setDate(d[10]);
      r.setReporter(d[11]);
      availableReports.add(r);
    }

    return availableReports;
  }

  Future<List<Fido>> retrieveAllClosedReports() async {
    var connection = connectionHandler.createConnection();
    await connection.open();
    List<List<dynamic>> results = await connection.query(
        "SELECT * FROM public.\"Fido\" WHERE  isclosed=@f ",
        substitutionValues: {"f": true});

    List<Fido> availableReports = new List<Fido>();

    connection.close();
    if (results == null || results.isEmpty)
      return toast("no matched Fidos and Owners found");
    var directory = await getApplicationDocumentsDirectory();

    for (List<dynamic> d in results) {
      Fido r = new Fido();
      r.setId(d[0]);
      r.setName(d[1]);
      r.setSex(d[2]);
      r.setBreed(d[3]);
      r.setColour(d[4]);
      r.setFoundHere(d[7]);
      r.setBrouthto(d[8]);
      r.setMoved(d[9].toString());
      r.setPhoto(d[12]);
      r.setDate(d[10]);
      r.setReporter(d[11]);
      availableReports.add(r);
    }

    return availableReports;
  }





  Future<List<Fido>> retrieveAllOpenOfType(String type) async {
    var connection = connectionHandler.createConnection();
    await connection.open();
    List<List<dynamic>> results = await connection.query(
        "SELECT * FROM public.\"Fido\" WHERE  (type=@n) AND isclosed=@t",
        substitutionValues: {'n': type, "t": false});

    List<Fido> availableReports = new List<Fido>();

    connection.close();
    if (results == null || results.isEmpty)
      return availableReports;

    for (List<dynamic> d in results) {
      Fido r = new Fido();
      r.setId(d[0]);
      r.setName(d[1]);
      r.setSex(d[2]);
      r.setBreed(d[3]);
      r.setColour(d[4]);
      r.setFoundHere(d[7]);
      r.setBrouthto(d[8]);
      r.setMoved(d[9].toString());
      r.setPhoto(d[12]);
      r.setDate(d[10]);
      r.setReporter(d[11]);
      availableReports.add(r);
    }

    return availableReports;
  }

  Future<int> countAllClosedReports(String type) async {
    int numberClosedReports = 0;
    var connection = connectionHandler.createConnection();
    await connection.open();
    List<List<dynamic>> results;
    if(type=="fidos")
      results = await connection.query("SELECT * FROM public.\"Fido\" WHERE  isclosed=@f ",
        substitutionValues: {"f": true});
    else
      results = await connection.query(
          "SELECT * FROM public.\"Fido\" WHERE  (type=@n) AND isclosed=@t",
          substitutionValues: {'n': type, "t": true});
    connection.close();
    if (results == null || results.isEmpty)
      return 0;
    numberClosedReports=results.length;

    return numberClosedReports;
  }

  Future<int> countAllOpenReports(String type) async {
    var connection = connectionHandler.createConnection();
    await connection.open();
    List<List<dynamic>> results;
    if(type=="fidos")
      results = await connection.query("SELECT * FROM public.\"Fido\" WHERE  isclosed=@f ",
          substitutionValues: {"f": false});
    else
      results = await connection.query(
          "SELECT * FROM public.\"Fido\" WHERE  (type=@n) AND isclosed=@t",
          substitutionValues: {'n': type, "t": false});
    connection.close();
    if (results == null || results.isEmpty)
      return 0;
    return results.length;
  }

  checkField(String name, DateTime date, String sexOfPet,
      String breedOfPet, String typeOfPet, String colorOfCoat){
    if (name == null || name.isEmpty) return ("please insert Fido's name");
    if (sexOfPet == null || sexOfPet.isEmpty)
      return ("please select a sex value");
    if (breedOfPet == null ||
        breedOfPet.isEmpty ||
        breedOfPet == "Select Fido's type")
      return ("please select a breed value");
    if (typeOfPet == null || typeOfPet.isEmpty)
      return ("please select Fido's type");
    if (colorOfCoat == null || colorOfCoat.isEmpty)
      return ("please select Fido's coat color");
    if (date.isAfter(DateTime.now()))
      return ("please select a valid date");
    return null;
  }

  retrieveReports(String name, DateTime date, String sexOfPet,
      String breedOfPet, String typeOfPet, String colorOfCoat) async {


    var connection = connectionHandler.createConnection();

    await connection.open();
    List<List<dynamic>> results = await connection.query(
        "SELECT * FROM public.\"Fido\" WHERE (name=@n OR name=@e) AND (sex= @s OR sex= @sex) AND (breed=@b or breed=@breed) AND colour=@c AND type=@t AND isclosed=@closed AND (date>=@d) ORDER BY date DESC",
        substitutionValues: {
          "n": name,
          "e": " ",
          "s": sexOfPet.toUpperCase(),
          "sex": "U",
          "b": breedOfPet,
          "breed": "UNKNOWN",
          "c": colorOfCoat,
          "t": typeOfPet,
          "closed": false,
          "d": date.toString()
        });

    List<Fido> availableReports = new List<Fido>();

    connection.close();
    if (results == null || results.isEmpty) return toast("no Fidos found");
    var directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    // open a new file in the application directory

    for (List<dynamic> d in results) {
      Fido r = new Fido();
      r.setId(d[0]);
      r.setName(d[1]);
      r.setSex(d[2]);
      r.setBreed(d[3]);
      r.setColour(d[4]);
      r.setFoundHere(d[7]);
      r.setBrouthto(d[8]);
      r.setMoved(d[9].toString());
      r.setPhoto(d[12]);
      r.setDate(d[10]);
      r.setReporter(d[11]);
      availableReports.add(r);
    }

    return availableReports;
  }

  Future<bool> canClose(String reporter) async {
    var session = FlutterSession();
    String user = await session.get("user");
    bool resp = false;
    if (user == reporter) {
      return !resp;
    }
    return resp;
  }
}
