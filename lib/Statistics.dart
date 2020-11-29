
import 'dart:async';




import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


import 'package:google_maps_flutter/google_maps_flutter.dart';



class Statistics extends StatefulWidget {
  @override
  _MyAppState createState()=> _MyAppState();
}

class _MyAppState extends State<Statistics> {
  GoogleMapController _controller  ;
  String address = "Milano";
Position pos;



  LatLng _center =new LatLng(0,0);
  bool _dog=false;
  bool _cat=false;

  void _onMapCreated(GoogleMapController controller) {

    setState(() {
      _controller=(controller);

    });

    _fetchUserLocation();
    _add();//todo passa lista marker da costruire ed inserire + tipo fido


  }




  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  void _add() {
    var markerIdVal = '#FIDOWASHERE';
    final MarkerId markerId = MarkerId(markerIdVal);    //todo prendere coordinate da db + filtrare su tipo fido

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
          45.521563, -122.677433
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
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
            child: ListView(

                children: <Widget>[
                  Text('What are you looking for?'),
                  checkbox("dog", _dog),
                  checkbox("cat", _cat),
                  Text('STATISTICS PLACE HOLDER') //TODO calcola statistiche
                ]
            )

        ),
        body: Stack(
          children: <Widget>[GoogleMap(
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
                    borderRadius: BorderRadius.circular(10.0), color: Colors.white),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter Address',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed:() =>  _fetchLocation(address),
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



  _fetchUserLocation()async{
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
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
              target:
              LatLng(pos.latitude, pos.longitude),
              zoom: 10.0)));
    } catch (e) {
      print(e);
    }
  }
  _fetchLocation(String address) async {
    List<Location> locations = await locationFromAddress(address);




    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
        LatLng(locations[0].latitude, locations[0].longitude),
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
                case "dog":
                  _dog = value;
                  break;
                case "cat":
                  _cat = value;
                  break;

              }
            });
          },
        )
      ],
    );
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
