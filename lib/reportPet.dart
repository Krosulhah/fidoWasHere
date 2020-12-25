import 'package:dimaWork/checkers/loginValidityChecker.dart';
import 'package:dimaWork/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'Controllers/ReportController.dart';
import 'graphicPatterns/colorManagement.dart';
import 'home.dart';
import 'mapsUsage.dart';


class ReportPet extends StatelessWidget {
  String address;
  ReportPet({this.address});
  @override
  Widget build(BuildContext context) {
    LoginValidityChecker loginValidityChecker = new LoginValidityChecker();
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
  ReportController reportController = new ReportController();
  List<String> availableBreeds = new List<String>();
  List<String> coatColour = ["White", "Black", "Orange", "Red", "Cream", "Mixed"];
  List<String> sexPet = ["f", "m", "u"];
  List<Color> _color;
  List<Color> _colorSex;
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
  bool checkedValueNo = false;
  bool checkedValueYes = true;

  void _updateBreedDropDown(String type, String firstBreed) {
    setState(() {
      typeOfPet = type;
      breedOfPet = firstBreed;
    });
  }

  @override
  void initState() {
    super.initState();
    availableBreeds = ["Select Fido's type"];
    typeOfPet = "";
    breedOfPet = "Select Fido's type";
    colorOfCoat = "Mixed";
    sexOfPet = "";
    controllerContact = new TextEditingController();
    controllerName = new TextEditingController();
    foundOn = new TextEditingController();
    broughtTo = new TextEditingController();

    fileName = ' ';
    _color = [Colors.black, Colors.black];
    _colorSex = [Colors.black, Colors.black, Colors.black];
    print(availableBreeds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor:ColorManagement.setButtonColor(),
          centerTitle: true,
          title: setTitle(),
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

        backgroundColor:ColorManagement.setBackGroundColor(),//0xff8f70ff
        body:
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  boldNiceText("Fido's type",context),
                ]),
                addSpace(),
                _buildTypeOfPetDropDown(),
                addSpace(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  boldNiceText("Fido's gender",context),
                ]),
                addSpace(),
                _buildSexDropDown(sexPet),
                addSpace(),
                buildBreedCard(),
                addSpace(),
                buildCoatCard(),
                addSpace(),
                buildNameCard(),
                addSpace(),
                buildFoundOnCard(),
                addSpace(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  boldNiceText("Add Fido's picture",context),
                ]),
                addSpace(),
                _buildAddPhotoPet(),
                addSpace(),
                _buildRadioBox(),
                addSpace(),
                if (isBroughtTo == true) buildBroughtToCard(),
                addSpace(),
                _buildSendButton(),


              ],
            ),
          ),

        ));
  }
///-------------------------------------------- <COSTRUZIONE CARD>--------------------------------------------------------------////

  Card buildCard(String text, var build){
    return Card(
        elevation: 8.0,
        color: ColorManagement.setButtonColor(),
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child:Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                borderRadius:BorderRadius.all(Radius.circular(16.0)),
                color:ColorManagement.setSeparatorColor()),
            child:Column(mainAxisAlignment: MainAxisAlignment.center, children:
            [buildNiceText(text,context),
              addSpace(),
              build,
              addSpace()
            ]
            )
        )
    );
  }

  Card buildNameCard(){
    return buildCard("Fido's name (optional):",_buildNameTextFields());
  }

  Card buildBreedCard(){
    return buildCard("Fido's breed:",_buildBreedDropDown(availableBreeds));
  }

  Card buildCoatCard(){
    return buildCard("Coat color:",_buildCoatDropDown(coatColour));
  }

  Card buildFoundOnCard(){
    return buildCard("Found on:",_buildFoundOn());
  }

  Card buildBroughtToCard(){
    return buildCard("Brought to:",_buildBroughtTo());
  }

///---------------------------------------------------------------------------------------------------------------------------///

  Widget _buildTypeOfPetDropDown() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildSelectType('assets/images/dogFace.svg', 'dog', 0),
        _buildSelectType('assets/images/catFace.svg', 'cat', 1)
      ],
    );
  }

  Widget _buildSelectType(String img, String type, int element) {
    return Material(
        color: ColorManagement.setBackGroundColor(),
        child: InkWell(
            onTap: () {
              setState(() {
                updateBreedList(type, element);
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.40,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManagement.setBackGroundColor(),
                border: Border.all(
                  color: _color[element],
                  width: 10,
                ),
              ),
              child: FittedBox(
                  child: SvgPicture.asset(img),
                fit: BoxFit.fill,
              )),
            ));
  }

  updateBreedList(String type, int element) async {
    reportController.updateBreeds(type).then((rows) {
      setState(() {
        availableBreeds = rows;
        _color.setAll(0, [Colors.black, Colors.black]);
        _color[element] = ColorManagement.setMarkerColor();
        typeOfPet = type;
        _updateBreedDropDown(type, availableBreeds.elementAt(0));
      });
    });
  }

  Widget _buildBreedDropDown(List<String> items) {
    return DropdownButton<String>(
      value: breedOfPet,
      icon: Icon(Icons.arrow_downward),
      iconEnabledColor: ColorManagement.setTextColor(),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: ColorManagement.setTextColor()),
      underline: Container(
        height: 2,
        color: ColorManagement.setTextColor(),
      ),
      onChanged: (String newValue) {
        setState(() {
          breedOfPet = newValue;
        });
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,textAlign: TextAlign.center),
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
      style: TextStyle(color: ColorManagement.setTextColor()),
      underline: Container(
        height: 2,
        color: ColorManagement.setTextColor(),
      ),
      onChanged: (String newValue) {
        setState(() {
          colorOfCoat = newValue;
        });
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,textAlign: TextAlign.center),
        );
      }).toList(),
    );
  }

  Widget buildSex(String type, int element, String img) {
    return Material(
        color: ColorManagement.setBackGroundColor(),
        child: InkWell(
            onTap: () {
              setState(() {
                sexOfPet = type;
                _colorSex.setAll(0, [Colors.black, Colors.black, Colors.black]);
                _colorSex[element] =ColorManagement.setMarkerColor();
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.18,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManagement.setBackGroundColor(),
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
        buildSex(items[2], 2, 'assets/images/u.png'),
      ],
    );
  }




  Widget _buildNameTextFields() {
    return new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.5,
            child: new TextField(
              textAlign: TextAlign.center,
              controller: controllerName,
              decoration: new InputDecoration(
                hintText: "Fido's name",
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
            boldNiceText('Have you or will you change the location of the Fido?',context),
            addSpace(),
          ],
        ),
        Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.4,
              child: ListTile(
                title: boldNiceText('Yes',context),
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
                title: boldNiceText('No',context),
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
          splashColor: ColorManagement.setButtonColor(),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextField(
              textAlign: TextAlign.center,
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
      Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextField(
              textAlign: TextAlign.center,
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
    return RaisedButton(
    textColor: ColorManagement.setTextColor(),
    color: ColorManagement.setButtonColor(),
          onPressed: () async {
            bool isReportValid = await reportController.checkAndSend(controllerName.text, broughtTo.text, foundOn.text, _image, isBroughtTo, sexOfPet, breedOfPet, typeOfPet, colorOfCoat);
            if (isReportValid) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            }
          },shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child:Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.5,
            child:
            Align(
                alignment: Alignment.center,
                child: Text('Send' ,textAlign: TextAlign.center)
            )
        )
    );
  }

  Future getImage(bool iscamera) async {
    ImagePicker petImage = new ImagePicker();
    if (iscamera) {
      PickedFile pickedPhoto = await petImage.getImage(
        source: ImageSource.camera,
      );
      _image = await pickedPhoto.readAsBytes();
    } else {
      PickedFile pickedPhoto = await petImage.getImage(
        source: ImageSource.gallery,
      );
      _image = await pickedPhoto.readAsBytes();
    }
    if (_image != null) {
      setState(() {
        fileName = 'fido.jpeg';
      });
    }
  }
}

FittedBox setTitle(){
  return FittedBox(
      fit:BoxFit.fitWidth,
      child:Text(
        'REPORT',
        style:   TextStyle(
          color:ColorManagement.setTextColor(),
        ),
      )
  );
}

Container buildNiceText(String text,BuildContext context){
  return Container(
    alignment: Alignment.center,
      width: MediaQuery.of(context).size.width*0.4,
      child: Text(text,
    style: TextStyle(
      color:ColorManagement.setTextColor(),
    ),
  ));
}

Container boldNiceText(String text,BuildContext context){
  return Container(
    alignment: Alignment.center,
      width: MediaQuery.of(context).size.width*0.4,
      child:Text(text,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color:ColorManagement.setTextColor(),
    ),
  ));
}


Container addSpace(){
  return Container(
    height: 5.0,
    width: 2.0,
  );
}

