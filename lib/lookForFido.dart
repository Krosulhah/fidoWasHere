import 'package:dimaWork/reportInfo.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'Statistics.dart';
import 'datepicker.dart';
import 'reportInfo.dart';

class LookForFido extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Look For Fido',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LookForFidoPage(title: 'Look For Fido'),
    );
  }
}

class LookForFidoPage extends StatefulWidget {
  LookForFidoPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LookForFidoPageState createState() => _LookForFidoPageState();
}

class _LookForFidoPageState extends State<LookForFidoPage> {
  List<String> listOfPets = ["Cat", "Dog"];
  List<String> dogBreed = ["Pitbull", "Bulldog"];
  List<String> catBreed = ["American Shorthair", "Bombay"];
  List<String> coatColour = ["White", "Black"];
  List<String> sexPet = ["f", "m"];
  String typeOfPet = "Dog";
  String breedOfPet = "Pitbull";
  String coatColorPet = "White";
  String sexOfPet = "f";
  DateTime _date = DateTime.now();

  void _updateBreedDropDown(String type, String firstBreed) {
    setState(() {
      typeOfPet = type;
      breedOfPet = firstBreed;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildSelectionPart(),
            _buildNameTextFields(),
            _buildDate(),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => new ReportInfo(
                        //replace by New Contact Screen
                        ),
                  )),
            )

            // This trailing comma makes auto-formatting nicer for build methods.
          ],
        ),
      ),

      /* floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.*/
    );
  }

  Widget _buildTypeOfPetDropDown(List<String> items) {
    return DropdownButton<String>(
      value: typeOfPet,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          typeOfPet = newValue;
          if (newValue == "Dog") {
            _updateBreedDropDown(newValue, "Pitbull");
          } else if (newValue == "Cat")
            _updateBreedDropDown(newValue, "American Shorthair");
        });
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildBreedDropDown(List<String> items) {
    return DropdownButton<String>(
      value: breedOfPet,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          breedOfPet = newValue;
        });
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildCoatDropDown(List<String> items) {
    return DropdownButton<String>(
      value: coatColorPet,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          coatColorPet = newValue;
        });
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildSexDropDown(List<String> items) {
    return DropdownButton<String>(
      value: sexOfPet,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          sexOfPet = newValue;
        });
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildSelectionPart() {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Type of Pet "),
        _buildTypeOfPetDropDown(listOfPets),
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Pet Breed   "),
        if (typeOfPet == "Dog")
          _buildBreedDropDown(dogBreed)
        else
          _buildBreedDropDown(catBreed)
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Colour Coat "),
        _buildCoatDropDown(coatColour),
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Sex         "),
        _buildSexDropDown(sexPet),
      ])
    ]);
  }

  Widget _buildNameTextFields() {
    return new Container(
      child: new Row(
        children: <Widget>[
          Text("Name        "),
          new Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.5,
            child: new TextField(
              decoration: new InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: "Pet's name",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDate() {
    return Row(
      children: [
        Text("Lost On  "),
        DatePicker(
            selectedDate: _date,
            onChanged: ((DateTime date) {
              setState(() {
                _date = date;
              });
            }))
      ],
    );
  }
}
