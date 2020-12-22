import 'package:dimaWork/Controllers/DateController.dart';
import 'package:dimaWork/reportInfo.dart';
import 'package:dimaWork/reportSearch.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'Controllers/ReportController.dart';
import 'Model/fido.dart';
import 'Statistics.dart';
import 'checkers/loginValidityChecker.dart';
import 'Model/datepicker.dart';
import 'reportInfo.dart';
import 'Controllers/DateController.dart';

class LookForFido extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LoginValidityChecker loginValidityChecker = new LoginValidityChecker();
    loginValidityChecker.isLoggedIn(context);
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
  ReportController reportController = new ReportController();
  List<String> availableBreeds = new List<String>();
  List<String> coatColour = [
    "White",
    "Black",
    "Orange",
    "Red",
    "Cream",
    "Mixed"
  ];
  List<String> sexPet = ["f", "m"];
  List<Color> _color;
  List<Color> _colorSex;

  String typeOfPet;
  String breedOfPet;
  String colorOfCoat;
  String sexOfPet;
  TextEditingController controllerName;

  String fileName;
  DateTime _date;

  @override
  void initState() {
    super.initState();
    availableBreeds = ["UNSELECETED"];
    typeOfPet = " ";
    breedOfPet = "UNSELECETED";
    colorOfCoat = "Mixed";
    sexOfPet = " ";

    controllerName = new TextEditingController();
    _date = new DateTime.now();

    _color = [Colors.black, Colors.black];
    _colorSex = [Colors.black, Colors.black, Colors.black];
    print(availableBreeds);
  }

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
        body: SingleChildScrollView(
          child: new Container(
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
                    onPressed: () async {
                      var res = await reportController.retrieveReports(
                          controllerName.text,
                          _date,
                          sexOfPet,
                          breedOfPet,
                          typeOfPet,
                          colorOfCoat);
                      if (res != null && res is List<Fido> && res.isNotEmpty)
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => new ReportSearch(
                                  result: res //replace by New Contact Screen
                                  ),
                            ));
                    })

                // This trailing comma makes auto-formatting nicer for build methods.
              ],
            ),
          ),

          /* floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.*/
        ));
  }

  Widget _buildTypeOfPetDropDown() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildSelectType('assets/images/dogFace.png', 'dog', 0),
        _buildSelectType('assets/images/catFigure.png', 'cat', 1)
      ],
    );
  }

  updateBreedList(String type, int element) async {
    reportController.updateBreeds(type).then((rows) {
      setState(() {
        availableBreeds = rows;
        _color.setAll(0, [Colors.black, Colors.black]);
        _color[element] = Colors.green;
        typeOfPet = type;
        _updateBreedDropDown(type, availableBreeds.elementAt(0));
      });
    });
  }

  Widget _buildSelectType(String img, String type, int element) {
    return Material(
        child: InkWell(
            onTap: () {
              setState(() {
                updateBreedList(type, element);
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.3,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: _color[element],
                  width: 10,
                ),
              ),
              child: FittedBox(
                  child: Image(
                image: AssetImage(img),
                fit: BoxFit.fill,
              )),
            )));
  }

  Widget _buildCoatDropDown(List<String> items) {
    return DropdownButton<String>(
      value: colorOfCoat,
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
          colorOfCoat = newValue;
          //myData.setColorOfCoat(colorOfCoat);
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

  Widget buildSex(String type, int element, String img) {
    return Material(
        child: InkWell(
            onTap: () {
              setState(() {
                sexOfPet = type;
                _colorSex.setAll(0, [Colors.black, Colors.black, Colors.black]);
                _colorSex[element] = Colors.green;
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.18,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: _colorSex[element],
                  width: 5,
                ),
              ),
              child: FittedBox(
                  child: Image(
                image: AssetImage(img),
                fit: BoxFit.fill,
              )),
            )));
  }

  Widget _buildSexDropDown(List<String> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildSex(items[0], 0, 'assets/images/f.png'),
        buildSex(items[1], 1, 'assets/images/m.png'),
      ],
    );
  }

  Widget _buildBreedDropDown(List<String> items) {
    print(availableBreeds);
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

  Widget _buildSelectionPart() {
    return Column(children: [
      Row(children: [
        Text("Type of Pet "),
      ]),
      Row(
        children: [
          _buildTypeOfPetDropDown(),
        ],
      ),
      Row(children: [_buildBreedDropDown(availableBreeds)]),
      Row(children: [
        Text("Colour Coat "),
        _buildCoatDropDown(coatColour),
      ]),
      Row(children: [
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
              controller: controllerName,
              decoration: new InputDecoration(
                hintText: "Pet's name",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDate() {
    DateContoller dateController = new DateContoller();
    return Row(
      children: [
        Text("Lost On  "),
        DatePicker(
            selectedDate: _date,
            dateContoller: dateController,
            onChanged: ((DateTime date) {
              setState(() {
                _date = date;
              });
            }))
      ],
    );
  }
}
