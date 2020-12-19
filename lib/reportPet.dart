import 'package:dimaWork/checkers/loginValidityChecker.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'Controllers/ReportController.dart';
import 'home.dart';
import 'mapsUsage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';

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
    LoginValidityChecker loginValidityChecker=new LoginValidityChecker();
    loginValidityChecker.isLoggedIn(context);
    return ReportPetPage();
  }
}

class ReportPetPage extends StatefulWidget {
  ReportPetPage({Key key, this.title, this.address}) : super(key: key);

  final String title;
  final String address;

  @override
  _ReportPetPageState createState() => _ReportPetPageState();
}


class _ReportPetPageState extends State<ReportPetPage> {

  ReportController reportController=new ReportController();
  List<String> availableBreeds=new List<String>();
  List<String> coatColour=  ["White", "Black", "Orange", "Red", "Cream", "Mixed"];
  List<String> sexPet = ["f", "m", "u"];
  List<Color> _color ;
  List<Color> _colorSex ;

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
  bool checkedValueNo = true;
  bool checkedValueYes = false;

  void _updateBreedDropDown(String type, String firstBreed) {
    setState(() {
      typeOfPet = type;
      breedOfPet = firstBreed;

    });
  }

  @override
  void initState() {
    super.initState();
    availableBreeds=["UNKNOWN"];
    typeOfPet = " ";
    breedOfPet = "UNKNOWN";
    colorOfCoat = "Mixed";
    sexOfPet = " ";
    controllerContact = new TextEditingController();
    controllerName = new TextEditingController();
    foundOn = new TextEditingController();
    broughtTo = new TextEditingController();

    fileName = ' ';
    _color=[Colors.black, Colors.black];
    _colorSex=[Colors.black, Colors.black,Colors.black];
    print(availableBreeds);


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
      resizeToAvoidBottomInset:false,
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
      body:SingleChildScrollView( child: Container(
        padding: EdgeInsets.all(16.0),
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row( mainAxisAlignment: MainAxisAlignment.center,
            children:[Text("Select Fido's type"),]),

            _buildTypeOfPetDropDown(),
            _buildBreedDropDown(availableBreeds),
            _buildSexDropDown(sexPet),

            _buildCoatDropDown(coatColour),
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
    ));
  }

  Widget _buildTypeOfPetDropDown()  {

    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[

        _buildSelectType('assets/images/dogFace.png','dog',0),

        _buildSelectType('assets/images/catFigure.png','cat',1)

      ],


    );





  }


  Widget _buildSelectType(String img,String type,int element){
    return Material(


        child: InkWell(
            onTap:  () {
              setState(()  {
                updateBreedList(type,element);

              });


            },

            child:Container(
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
              child: FittedBox(child:Image(image:AssetImage(img),
                fit: BoxFit.fill,
              )),

            ) )

    );
  }

  updateBreedList(String type,int element)  async {
    reportController.updateBreeds(type).then((rows) {

      setState(() {
        availableBreeds = rows;
        _color.setAll(0,[Colors.black,Colors.black]);
        _color[element]=Colors.green;
        typeOfPet=type;
        _updateBreedDropDown(type, availableBreeds.elementAt(0));


      });
    });}

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


  Widget buildSex(String type, int element,String img){
    return Material(


        child: InkWell(
            onTap:  () {
              setState(()  {

                sexOfPet=type;
                _colorSex.setAll(0,[Colors.black,Colors.black,Colors.black]);
                _colorSex[element]=Colors.green;

              });


            },

            child:Container(
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

              child: FittedBox(child:Image(image:AssetImage(img),
                fit: BoxFit.fill,
              )),

            ) )

    );
  }





  Widget _buildSexDropDown(List<String> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildSex(items[0],0,'assets/images/f.png'),
        buildSex(items[1],1,'assets/images/m.png'),
        buildSex(items[2],2,'assets/images/u.png'),
        ],

    );


    /*
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
          //myData.setSex(sexOfPet);
        });
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );*/
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Do you take it home?'),
          ],
        ),
        Row(
          children: [
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
          ],
        )
      ],
    );
  }

  Widget _buildAddPhotoPet() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
                hintText:
                "Example: Via street name, number, city, province, state",
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
                      userAddress: foundOn.text,
                      //replace by New Contact Screen
                    ),
                  ));
              setState(() {
                foundOn.text = result;
                //myData.setFoundLocation(result);
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
                hintText:
                "Example: Via street name, number, city, province, state",
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
                      userAddress: broughtTo.text,
                      //replace by New Contact Screen
                    ),
                  ));
              setState(() {
                broughtTo.text = result;
                //myData.setBroughtLocation(result);
              });
            },
          )
        ],
      ),

    ]);
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

          onPressed: () async {


            // myData.setName(controllerName.text);
            // myData.setBroughtLocation(broughtTo.text);
            // myData.setContactInfo(controllerContact.text);
            bool checkUserAddress = await _checkUserAddress(foundOn.text);
            if (checkUserAddress == false) {
              return;
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
              // myData.setFoundLocation(foundOn.text);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
              //TODO to implement the sending of
            }
          }),
    ]);
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
}