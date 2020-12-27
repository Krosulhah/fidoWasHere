import 'dart:async';

import 'package:dimaWork/Controllers/ReportController.dart';
import 'package:dimaWork/Model/fido.dart';
import 'package:dimaWork/graphicPatterns/TextPatterns.dart';
import 'package:dimaWork/graphicPatterns/colorManagement.dart';
import 'package:dimaWork/graphicPatterns/infoBuilder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Statistics extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Statistics> {
  final df = new DateFormat('dd/MM/yyyy');
  BitmapDescriptor dogLocationIcon;
  BitmapDescriptor catLocationIcon;
  ReportController reportController;
  GoogleMapController _controller;
  String address = "Milano";
  Position pos;
  LatLng _center = new LatLng(0, 0);
  bool _dog = false;
  bool _cat = false;
  int counterClosed = 0;
  int counterOpen = 0;
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      counterClosed = 0;
      counterOpen = 0;
      reportController = new ReportController();
      _controller = (controller);
      BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
              'assets/images/catMarker.png')
          .then((onValue) {
        catLocationIcon = onValue;
      });
      BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
              'assets/images/dogMarker.png')
          .then((onValue) {
        dogLocationIcon = onValue;
      });
    });

    _fetchUserLocation();
    statisticsFido();
    statisticsClosedNumbers();
    statisticsOpenNumbers();
  }

  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  void _addDog(LatLng coordinates, int id, String breedOfPet, DateTime date) {
    var markerIdVal = id.toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    String newDateVersion = df.format(date).toString();
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: coordinates,
      infoWindow: InfoWindow(title: breedOfPet, snippet: newDateVersion),
      icon: dogLocationIcon,
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  void _addCat(LatLng coordinates, int id, String breedOfPet, DateTime date) {
    var markerIdVal = id.toString();
    final MarkerId markerId = MarkerId(
        markerIdVal);
    String newDateVersion = df.format(date).toString();
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: coordinates,
      infoWindow: InfoWindow(title: breedOfPet, snippet: newDateVersion),
      icon: catLocationIcon,
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

Column buildText(){
    String type;
    if(_dog&&_cat||!_dog && !_cat)
      type="Fidos";
    else if(_dog)
      type="Dogs";
    else
      type="Cats";

  return Column( children:[InfoBuilder.addSpace(),
  InfoBuilder.buildNiceText(type+" returned home:", context),
  InfoBuilder.addSpace(),
  InfoBuilder.buildNiceText(counterClosed.toString()+"/"+(counterClosed+counterOpen).toString(), context),
  InfoBuilder.addSpace(),
  InfoBuilder.buildNiceText("Reported "+type+" still looking for their home", context),
  InfoBuilder.addSpace(),
  InfoBuilder.buildNiceText(counterOpen.toString()+"/"+(counterClosed+counterOpen).toString(), context),]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorManagement.setBackGroundColor(),
        appBar: AppBar(
          centerTitle: true,
          title: setTitle(),
          backgroundColor: ColorManagement.setButtonColor(),

        ),

        drawer: Drawer(
            child: ListView(children: <Widget>[
              InfoBuilder.addSpace(),
              InfoBuilder.buildNiceText("What are you looking for?", context),
              InfoBuilder.addSpace(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                checkbox("Lost dogs", _dog),
                checkbox("Lost cats", _cat),
              ],),
              buildText(),

        ])),

        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: Set<Marker>.of(markers.values), // YOUR MARKS IN MAP
            ),
            Align(
              alignment: Alignment.centerRight,
              // add your floating action button
              child: FloatingActionButton(
                onPressed: () => _fetchUserLocation(),
                child: Icon(Icons.my_location),
              ),
            ),
            Positioned(
              top: 30.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter Address',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () => _fetchLocation(address),
                          iconSize: 30.0)),
                  onChanged: (val) {
                    setState(() {
                      address = val;
                    });
                  },
                ),
              ),
            )],
        ),
      );
  }

  _fetchUserLocation() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        pos = position;

      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(pos.latitude, pos.longitude), zoom: 10.0)));
    } catch (e) {
      print(e);
    }
  }

  _fetchLocation(String address) async {
    List<Location> locations = await locationFromAddress(address);

    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(locations[0].latitude, locations[0].longitude),
        zoom: 10.0)));
  }

  Widget checkbox(String title, bool boolValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title),
        Checkbox(
          value: boolValue,
          onChanged: (bool value) {
            /// manage the state of each value
            setState(() {
              switch (title) {
                case "Lost dogs":
                  _dog = value;
                  break;
                case "Lost cats":
                  _cat = value;
                  break;
              }
              statisticsClosedNumbers();
              statisticsOpenNumbers();
              statisticsFido();
            });
          },
        )
      ],
    );
  }

  statisticsFido() async {
    if (_cat == true && _dog == false) {
      markers.clear();
      List<Fido> results = await reportController.retrieveAllOpenOfType("cat");
      print(results.length);

      for (Fido f in results) {
        print(f.getFoundHere());
        LatLng coordinates = await getUserCoordinates(f.getFoundHere());
        print(f.getFoundHere());
        _addCat(coordinates, f.getId(), f.getBreed(), f.getDate());
      }
    } else if (_dog == true && _cat == false) {
      markers.clear();
      List<Fido> results = await reportController.retrieveAllOpenOfType("dog");
      print(results.length);

      for (Fido f in results) {
        print(f.getFoundHere());
        LatLng coordinates = await getUserCoordinates(f.getFoundHere());
        print(f.getFoundHere());
        _addDog(coordinates, f.getId(), f.getBreed(), f.getDate());
      }
    } else if (_dog == true && _cat == true||_dog==false && _cat==false) {
      markers.clear();
      List<Fido> dogResults = await reportController.retrieveAllOpenOfType("dog");
      List<Fido> catResults=await reportController.retrieveAllOpenOfType("cat");
      for (Fido f in catResults) {
        print(f.getFoundHere());
        LatLng coordinates = await getUserCoordinates(f.getFoundHere());
        print(f.getFoundHere());
        _addCat(coordinates, f.getId(), f.getBreed(), f.getDate());
      }
      for (Fido f in dogResults) {
        print(f.getFoundHere());
        LatLng coordinates = await getUserCoordinates(f.getFoundHere());
        print(f.getFoundHere());
        _addDog(coordinates, f.getId(), f.getBreed(), f.getDate());
      }
    }
  }

  Future<LatLng> getUserCoordinates(String address) async {
    var latitude;
    var longitude;
    List<Location> locations = await locationFromAddress(address);
    latitude = locations[0].latitude;
    longitude = locations[0].longitude;

    return LatLng(latitude, longitude);
  }

  statisticsClosedNumbers() async {
    int resultClosed;
    if(_dog&&_cat||!_dog&&!_cat)
      resultClosed = await reportController.countAllClosedReports("fidos");
    else if(_dog)
      resultClosed = await reportController.countAllClosedReports("dog");
    else
      resultClosed = await reportController.countAllClosedReports("cat");
    setState(() {
      counterClosed = resultClosed;
    });
  }

  statisticsOpenNumbers() async {
    int resultOpen;
    if(_dog&&_cat||!_dog&&!_cat)
      resultOpen = await reportController.countAllOpenReports("fidos");
    else if(_dog)
      resultOpen = await reportController.countAllOpenReports("dog");
    else
      resultOpen = await reportController.countAllOpenReports("cat");
    print("OPEN: "+resultOpen.toString()+" vs"+ resultOpen.toString());
    setState(() {
      counterOpen = resultOpen;
    });
  }


}

FittedBox setTitle(){
  return FittedBox(
      fit:BoxFit.fitWidth,
      child:Text(
        'FIDO WAS HERE',
        style:   TextStyle(
          color:ColorManagement.setTextColor(),
        ),
      )
  );
}