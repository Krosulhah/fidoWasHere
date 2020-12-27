import 'dart:async';

import 'package:dimaWork/Controllers/ReportController.dart';
import 'package:dimaWork/Model/fido.dart';
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
  String counterClosed = "0";
  String counterOpen = "0";
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
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
    final MarkerId markerId = MarkerId(
        markerIdVal); //todo prendere coordinate da db + filtrare su tipo fido
    String newDateVersion = df.format(date).toString();
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: coordinates,
      infoWindow: InfoWindow(title: breedOfPet, snippet: newDateVersion),
      onTap: () {
        print('schiacciato un pin');
      },
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
        markerIdVal); //todo prendere coordinate da db + filtrare su tipo fido
    String newDateVersion = df.format(date).toString();
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: coordinates,
      infoWindow: InfoWindow(title: breedOfPet, snippet: newDateVersion),
      onTap: () {
        print('schiacciato un pin');
      },
      icon: catLocationIcon,
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  void _addFoundFidos(
      LatLng coordinates, int id, String breedOfPet, DateTime date) {
    var markerIdVal = id.toString();
    String newDateVersion = df.format(date).toString();
    final MarkerId markerId = MarkerId(
        markerIdVal); //todo prendere coordinate da db + filtrare su tipo fido

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: coordinates,
      infoWindow: InfoWindow(title: breedOfPet, snippet: newDateVersion),
      onTap: () {
        print('schiacciato un pin');
      },
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('FidoWasHere'),
          backgroundColor: Colors.green[700],
        ),
        drawer: Drawer(
            //qui mettiamo opzioni cane gatto + stat
            child: ListView(children: <Widget>[
          Text('What are you looking for?'),
          checkbox("Lost dogs", _dog),
          checkbox("Lost cats", _cat),
          Text('STATISTICS PLACE HOLDER'),
          Text("Number of all Fidos returned to their Family:"),
          Text(counterClosed),
          Text("Number of all Fidos lost and not found:"),
          Text(counterOpen),
          // statisticsOpenNumbers()

          //TODO calcola statistiche
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
            )
          ],
        ),
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
      List<Fido> results = await reportController.retrieveAllOpenCatsReports();
      print(results.length);

      for (Fido f in results) {
        print(f.getFoundHere());
        LatLng coordinates = await getUserCoordinates(f.getFoundHere());
        print(f.getFoundHere());
        _addCat(coordinates, f.getId(), f.getBreed(), f.getDate());
      }
    } else if (_dog == true && _cat == false) {
      markers.clear();
      List<Fido> results = await reportController.retrieveAllOpenCatsReports();
      print(results.length);

      for (Fido f in results) {
        print(f.getFoundHere());
        LatLng coordinates = await getUserCoordinates(f.getFoundHere());
        print(f.getFoundHere());
        _addDog(coordinates, f.getId(), f.getBreed(), f.getDate());
      }
    } else if (_dog == true && _cat == true) {
      markers.clear();
      List<Fido> results = await reportController.retrieveAllOpenCatsReports();
      print(results.length);

      for (Fido f in results) {
        print(f.getFoundHere());
        LatLng coordinates = await getUserCoordinates(f.getFoundHere());
        print(f.getFoundHere());
        _addCat(coordinates, f.getId(), f.getBreed(), f.getDate());
      }
      results = await reportController.retrieveAllOpenDogsReports();
      for (Fido f in results) {
        print(f.getFoundHere());
        LatLng coordinates = await getUserCoordinates(f.getFoundHere());
        print(f.getFoundHere());
        _addDog(coordinates, f.getId(), f.getBreed(), f.getDate());
      }
    }
    //markers.clear();
    else {
      markers.clear();
      List<Fido> results = await reportController.retrieveAllClosedReports();
      print(results.length);

      for (Fido f in results) {
        print(f.getFoundHere());
        LatLng coordinates = await getUserCoordinates(f.getFoundHere());
        print(f.getFoundHere());
        _addFoundFidos(coordinates, f.getId(), f.getBreed(), f.getDate());
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
    String resultClosed = await reportController.countAllClosedReports();
    setState(() {
      counterClosed = resultClosed;
    });
  }

  statisticsOpenNumbers() async {
    String resultClosed = await reportController.countAllOpenReports();
    setState(() {
      counterOpen = resultClosed;
    });
  }

//List<Location> locations = await locationFromAddress("Gronausestraat 710, Enschede");

}

//https://pub.dev/documentation/map_view/latest/ guida flutter
/*
* void _onAddMarkerButtonPressed() {
setState(() {
_markers.add(Marker(
// This marker id can be anything that uniquely identifies each marker.
markerId: MarkerId(_lastMapPosition.toString()),
position: _lastMapPosition,
infoWindow: InfoWindow(
title: ‘Really cool place’,
snippet: ‘5 Star Rating’,
),
icon: BitmapDescriptor.defaultMarker,
));
});
}
*
* https://medium.com/@rajesh.muthyala/flutter-with-google-maps-and-google-place-85ccee3f0371
* https://github.com/rajayogan/flutter-googlemapaddresses/blob/master/lib/main.dart#L73
*/
