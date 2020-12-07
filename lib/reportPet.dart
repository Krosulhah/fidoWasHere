import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'mapsUsage.dart';

class ReportPet extends StatelessWidget {
  // This widget is the root of your application.
  String address;

  ReportPet({this.address});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Report A Pet',
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
      home: ReportPetPage(title: 'Report A Pet', address: address),
    );
  }
}

class ReportPetPage extends StatefulWidget {
  ReportPetPage({Key key, this.title, this.address}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String address;

  @override
  _ReportPetPageState createState() => _ReportPetPageState();
}

class _ReportPetPageState extends State<ReportPetPage> {
  List<String> listOfPets = ["Cat", "Dog"];
  List<String> dogBreed = ["Pitbull", "Bulldog"];
  List<String> catBreed = ["American Shorthair", "Bombay"];
  String typeOfPet = "Dog";
  String breedOfPet = "Pitbull";
  var _image;
  TextEditingController foundOn;
  TextEditingController broughtTo;

  void _updateBreedDropDown(String type, String firstBreed) {
    setState(() {
      typeOfPet = type;
      breedOfPet = firstBreed;
    });
  }

  Future getImage(bool iscamera) async {
    // get the application directory
    ImagePicker petImage = new ImagePicker();
    var directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    // open a new file in the application directory
    var file = new File("$path/pet.img");
    if (iscamera) {
      _image = await petImage.getImage(
        source: ImageSource.camera,
      );
    } else {
      _image = await petImage.getImage(
        source: ImageSource.gallery,
      );
    }
    // open the writer
    var writers = file.openWrite(
      mode: FileMode.write,
      encoding: SystemEncoding(),
    );
    // write file on the disk
    writers.write(_image);
    // close the writer
    writers.close();
  }

  @override
  void initState() {
    super.initState();
    foundOn = new TextEditingController(text: widget.address);
    print(widget.address);
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
            _buildLocation(),
            _buildAddPhotoPet(),

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

  Widget _buildSelectionPart() {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Type of Pet   "),
        _buildTypeOfPetDropDown(listOfPets),
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Pet Breed   "),
        if (typeOfPet == "Dog")
          _buildBreedDropDown(dogBreed)
        else
          _buildBreedDropDown(catBreed)
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

  Widget _buildAddPhotoPet() {
    return FloatingActionButton(
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: Text("choose the source"),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    getImage(true);
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.camera),
                ),
                SimpleDialogOption(
                  child: Icon(Icons.storage),
                  onPressed: () {
                    getImage(false);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      },
      tooltip: 'Pick Image',
      child: Icon(Icons.add_a_photo),
    );
  }

  Widget _buildLocation() {
    return Column(children: [
      Row(
        children: [
          Text("Found on  "),
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextField(
              controller: foundOn,
              decoration: new InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: "Found Location ",
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => new MapsUsage(
                      //replace by New Contact Screen
                      ),
                )),
          )
        ],
      ),
      Row(
        children: [
          Text("Brough to  "),
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextField(
              decoration: new InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: "Brought to Location",
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => new MapsUsage(
                      //replace by New Contact Screen
                      ),
                )),
          )
        ],
      )
    ]);
  }
}
