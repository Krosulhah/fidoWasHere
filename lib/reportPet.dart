import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'home.dart';
import 'myDataStructure.dart';
import 'mapsUsage.dart';
import 'package:fluttertoast/fluttertoast.dart';

/**modifica
 *
 * quando fai push per prendere le coordinate dalla mappa hai bisogno di settare lo stato della schermata per
 * visualizzare l'indirizzo inserito
 *
 * **/

class ReportPet extends StatelessWidget {
  // This widget is the root of your application.
  String address;

  ReportPet({this.address});

  @override
  Widget build(BuildContext context) {
    return ReportPetPage();
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
  MyDataStructure myData;
  List<String> listOfPets = ["Cat", "Dog"];
  List<String> dogBreed = ["Pitbull", "Bulldog"];
  List<String> catBreed = ["American Shorthair", "Bombay"];
  List<String> coatColour = ["White", "Black"];
  List<String> sexPet = ["f", "m", "u"];
  String typeOfPet;
  String breedOfPet;
  String colorOfCoat;
  String sexOfPet;
  TextEditingController controllerName;

  var _image;
  String fileName;
  TextEditingController foundOn;
  TextEditingController broughtTo;
  TextEditingController controllerContact;
  bool isBroughtTo = false;
  bool checkedValueYes = true;
  bool checkedValueNo = false;

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
    if (_image != null) {
      setState(() {
        fileName = 'fido.jpeg';
      });
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

    myData = new MyDataStructure();
    typeOfPet = "Dog";
    breedOfPet = "Pitbull";
    colorOfCoat = "White";
    sexOfPet = "f";
    controllerContact = new TextEditingController();
    controllerName = new TextEditingController();
    foundOn = new TextEditingController();
    broughtTo = new TextEditingController();
    myData.setBreedOfPet(breedOfPet);
    myData.setTypeOfPet(typeOfPet);
    myData.setColorOfCoat(colorOfCoat);
    myData.setSex(sexOfPet);
    fileName = ' ';
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
        title: Text("Report a Fido"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildSelectionPart(),
            _buildNameTextFields(),
            _buildFoundOn(),
            _buildRadioBox(),
            if (isBroughtTo == true) _buildBroughtTo(),

            _buildAddPhotoPet(),
            _buildSendButton(),

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

  Widget _buildSendButton() {
    return Column(children: [
      RaisedButton(
          child: Text("send"),
          textColor: Colors.white,
          color: Color(0xFF6200EE),
          /* onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              ) */

          onPressed: () {
            myData.setName(controllerName.text);
            myData.setBroughtLocation(broughtTo.text);
            myData.setContactInfo(controllerContact.text);
            if (foundOn.text == "") {
              Fluttertoast.showToast(
                  msg: "Found On field is obligatory",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  fontSize: 16.0,
                  textColor: Colors.red,
                  backgroundColor: Colors.white);
            } else if (_image == null) {
              Fluttertoast.showToast(
                  msg: "A photo of the FIDO is obligatory",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  fontSize: 16.0,
                  textColor: Colors.red,
                  backgroundColor: Colors.white);
            } else {
              myData.setFoundLocation(foundOn.text);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
              //TODO to implement the sending of
            }
          }),
    ]);
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
      Row(children: [
        Text("Type of Pet   "),
        _buildTypeOfPetDropDown(listOfPets),
      ]),
      Row(children: [
        Text("Pet Breed   "),
        if (typeOfPet == "Dog")
          _buildBreedDropDown(dogBreed)
        else
          _buildBreedDropDown(catBreed)
      ]),
      Row(children: [
        Text("Type of Pet   "),
        _buildCoatDropDown(coatColour),
      ]),
      Row(children: [
        Text("Type of Pet   "),
        _buildSexDropDown(sexPet),
      ]),
    ]);
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
          myData.setColorOfCoat(colorOfCoat);
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
          //myData.setSex(sexOfPet);
          myData.setSex(sexOfPet);
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

  Widget _buildNameTextFields() {
    return new Container(
      child: new Row(
        children: <Widget>[
          Text("Name        "),
          new Container(
            height: MediaQuery.of(context).size.height * 0.06,
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

  Widget _buildRadioBox() {
    return Column(
      children: [
        Row(
          children: [
            Text('Have you changed the position of the Fido?'),
          ],
        ),
        Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.4,
              child: ListTile(
                title: Text('No'),
                leading: Radio(
                  value: checkedValueNo,
                  groupValue: isBroughtTo,
                  onChanged: (value) {
                    setState(() {
                      isBroughtTo = value;
                    });
                  },
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.4,
              child: ListTile(
                title: Text('Yes'),
                leading: Radio(
                  value: checkedValueYes,
                  groupValue: isBroughtTo,
                  onChanged: (value) {
                    setState(() {
                      isBroughtTo = value;
                    });
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildAddPhotoPet() {
    return Row(
      children: [
        Text(fileName),
        FloatingActionButton(
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
        ),
      ],
    );
  }

  Widget _buildFoundOn() {
    return Column(children: [
      Row(
        children: [
          Text("Found on  "),
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextField(
              controller: foundOn,
              decoration: new InputDecoration(
                hintText: "Found Location ",
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () async {
              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapsUsage(
                        //replace by New Contact Screen
                        ),
                  ));
              setState(() {
                foundOn.text = result;
                myData.setFoundLocation(result);
              });
            },
          )
        ],
      ),
    ]);
  }

  Widget _buildBroughtTo() {
    return Column(children: [
      Row(
        children: [
          Text("Brough to  "),
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextField(
              controller: broughtTo,
              decoration: new InputDecoration(
                hintText: "Brought to Location",
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () async {
              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapsUsage(
                        //replace by New Contact Screen
                        ),
                  ));
              setState(() {
                broughtTo.text = result;
                myData.setBroughtLocation(result);
              });
            },
          )
        ],
      ),
      Row(children: <Widget>[
        Text("Contact     "),
        new Container(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width * 0.5,
          child: new TextField(
            controller: controllerContact,
            decoration: new InputDecoration(
              hintText: "Contact Information",
            ),
          ),
        ),
      ])
    ]);
  }
}
