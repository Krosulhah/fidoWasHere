
import 'package:dimaWork/graphicPatterns/colorManagement.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsUsage extends StatefulWidget {
  String userAddress;
  MapsUsage({this.userAddress});
  @override
  _MapsUsageState createState() => _MapsUsageState();
}

class _MapsUsageState extends State<MapsUsage> {
  GoogleMapController _controller;
  String address = "Milano";
  Position pos;
  MarkerId firstMarkerId;
  LatLng _center = new LatLng(0, 0);

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = (controller);
    });

    _fetchUserLocation();
    _fetchMarkerUserAddress();
    // _add();
  }

  Map<MarkerId, Marker> markers =
  <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  MarkerId _addPosition(var latitude, var longitude) {
    var markerIdVal = '#FIDOWASHERE';
    final MarkerId markerId = MarkerId(markerIdVal);
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        print('schiacciato un pin');
      },
    );

    setState(() {
      // adding a new marker to map
      markers.remove(markerId);
      markers[markerId] = marker;
    });
    return markerId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:setTitle(),
        backgroundColor: ColorManagement.setButtonColor(),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              color: ColorManagement.setTextColor(),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onTap: (LatLng latLng) {
              // you have latitude and longitude here
              var latitude = latLng.latitude;
              var longitude = latLng.longitude;
              firstMarkerId = _addPosition(latitude, longitude);
            },
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
          ),
          Align(
              alignment: Alignment.bottomCenter,
              // add your floating action button
              child: IconButton(
                  onPressed: () => _retreiveLocation(),
                  icon: Icon(Icons.done, color: Colors.blue, size: 30),
                  padding: EdgeInsets.all(8.0),
                  color: Colors.blue))
        ],
      ),
    );
  }

  _retreiveLocation() async {
    if (markers[firstMarkerId] == null) {
      Fluttertoast.showToast(
          msg: "Tap on the map in the location of the found Fido",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          fontSize: 16.0,
          textColor: Colors.red,
          backgroundColor: Colors.white);
    } else {
      var longitude = markers[firstMarkerId].position.longitude;
      var latitude = markers[firstMarkerId].position.latitude;
      print(longitude);
      print(latitude);

      List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
      String address =
          "${placemarks[0].street} ${placemarks[0].name} ${placemarks[0].locality} ${placemarks[0].country}";
      print(address);
      Navigator.pop(context, address);
    }
  }

  _fetchMarkerUserAddress() async {
    var latitude;
    var longitude;
    String address = widget.userAddress;
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
      }

      firstMarkerId = _addPosition(latitude, longitude);
    } else if (address == "") {
      Fluttertoast.showToast(
          msg: "Tap on the map to choose the location!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          fontSize: 16.0,
          textColor: Colors.green,
          backgroundColor: Colors.white);
    }
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
              }
            });
          },
        )
      ],
    );
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