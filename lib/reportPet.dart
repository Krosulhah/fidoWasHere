
import 'package:dimaWork/graphicPatterns/infoBuilder.dart';
import 'package:dimaWork/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'Controllers/ReportController.dart';
import 'Loading.dart';
import 'graphicPatterns/colorManagement.dart';
import 'home.dart';
import 'mapsUsage.dart';


class ReportPet extends StatelessWidget {
  String address;
  ReportPet({this.address});
  @override
  Widget build(BuildContext context) {
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
  final GlobalKey<State> key= new GlobalKey<State>();

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
                  InfoBuilder.boldNiceText("Fido's type",context),
                ]),
                InfoBuilder.addSpace(),
                _buildTypeOfPetDropDown(),
                InfoBuilder.addSpace(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  InfoBuilder.boldNiceText("Fido's gender",context),
                ]),
                InfoBuilder.addSpace(),
                _buildSexDropDown(sexPet),
                InfoBuilder.addSpace(),
                buildBreedCard(),
                InfoBuilder.addSpace(),
                buildCoatCard(),
                InfoBuilder.addSpace(),
                buildNameCard(),
                InfoBuilder.addSpace(),
                buildFoundOnCard(),
                InfoBuilder.addSpace(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  InfoBuilder.boldNiceText("Add Fido's picture",context),
                ]),
                InfoBuilder.addSpace(),
                _buildAddPhotoPet(),
                InfoBuilder.addSpace(),
                _buildRadioBox(),
                InfoBuilder.addSpace(),
                if (isBroughtTo == true) buildBroughtToCard(),
                InfoBuilder.addSpace(),
                _buildSendButton(),


              ],
            ),
          ),

        ));
  }
///-------------------------------------------- <COSTRUZIONE CARD>--------------------------------------------------------------////
  Card buildNameCard(){
    return InfoBuilder.buildCard("Fido's name (optional):",_buildNameTextFields(),context);
  }

  Card buildBreedCard(){
    return InfoBuilder.buildCard("Fido's breed:",_buildBreedDropDown(availableBreeds),context);
  }

  Card buildCoatCard(){
    return InfoBuilder.buildCard("Coat color:",_buildCoatDropDown(coatColour),context);
  }

  Card buildFoundOnCard(){
    return InfoBuilder.buildCard("Found on:",_buildFoundOn(),context);
  }

  Card buildBroughtToCard(){
    return InfoBuilder.buildCard("Brought to:",_buildBroughtTo(),context);
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
            child: InfoBuilder.selectTypeInfo(context,_color,element,img),
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
            child: InfoBuilder.selectSexInfo(context,_colorSex,element,img)));
  }

  Widget _buildSexDropDown(List<String> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
              cursorColor: ColorManagement.setTextColor(),
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
            InfoBuilder.boldNiceText('Have you or will you change the location of the Fido?',context),
            InfoBuilder.addSpace(),
          ],
        ),
        Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.4,
              child: ListTile(
                title: InfoBuilder.boldNiceText('Yes',context),
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
                title: InfoBuilder.boldNiceText('No',context),
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
              cursorColor: ColorManagement.setTextColor(),
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
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextField(
              textAlign: TextAlign.center,
              controller: broughtTo,
              cursorColor: ColorManagement.setTextColor(),
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
          onPressed: ()  {

              _handleReport();

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
  Future <void> _handleReport()async {
    bool isReportValid=false;
      try{
        Dialogs.showLoadingDialog(context, key);
        var check= await reportController.checkFieldsReport(controllerName.text, broughtTo.text, foundOn.text, _image, isBroughtTo, sexOfPet, breedOfPet, typeOfPet, colorOfCoat);
       print("hey");
        if(check.isEmpty){
          isReportValid = await reportController.checkAndSend(controllerName.text, broughtTo.text, foundOn.text, _image, isBroughtTo, sexOfPet, breedOfPet, typeOfPet, colorOfCoat);
        }
        Navigator.of(context, rootNavigator: true)
            .pop(); //close the dialoge

        if (isReportValid) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
        }
        else if(check is String){
          showDialog(
              context: context,
              child: new AlertDialog(
                title: new Text(check),
              ));}
      }catch (error){print (error);}
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






