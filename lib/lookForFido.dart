import 'package:dimaWork/Controllers/DateController.dart';
import 'package:dimaWork/reportSearch.dart';
import 'package:flutter/material.dart';
import 'Controllers/ReportController.dart';
import 'Controllers/datepicker.dart';
import 'Model/fido.dart';
import 'checkers/loginValidityChecker.dart';
import 'Controllers/DateController.dart';
import 'graphicPatterns/colorManagement.dart';
import 'graphicPatterns/infoBuilder.dart';

class LookForFido extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginValidityChecker loginValidityChecker = new LoginValidityChecker();
    loginValidityChecker.isLoggedIn(context);
    return  LookForFidoPage(title: 'Look For Fido');
  }
}

class LookForFidoPage extends StatefulWidget {
  LookForFidoPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LookForFidoPageState createState() => _LookForFidoPageState();
}

class _LookForFidoPageState extends State<LookForFidoPage> {
  ReportController reportController = new ReportController();
  List<String> availableBreeds = new List<String>();
  List<String> coatColour = ["White", "Black", "Orange", "Red", "Cream", "Mixed"];
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
    availableBreeds = ["Select Fido's type"];
    typeOfPet = " ";
    breedOfPet = "Select Fido's type";
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: setTitle(),
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
        body: SingleChildScrollView(
          child: new Container(
            color: ColorManagement.setBackGroundColor(),
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildSelectionPart(),
                InfoBuilder.addSpace(),
                buildNameCard(),
                InfoBuilder.addSpace(),
                buildLostOn(),
                InfoBuilder.addSpace(),
                ClipOval(
                  child: Material(
                  color: ColorManagement.setButtonColor(),
                  child: InkWell(
                  splashColor: ColorManagement.setMarkerColor(),
                    child: SizedBox(width: MediaQuery.of(context).size.width * 0.1, height: MediaQuery.of(context).size.height * 0.05, child: Icon(Icons.search)),
                    onTap: () async {
                      var res = await reportController.retrieveReports(controllerName.text, _date, sexOfPet, breedOfPet, typeOfPet, colorOfCoat);
                      if (res != null && res is List<Fido> && res.isNotEmpty)
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => new ReportSearch(
                                  result: res //replace by New Contact Screen
                                  ),
                            ));
                    })
              ),
            )],
          ),
        )));
  }

  Widget _buildTypeOfPetDropDown() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildSelectType('assets/images/dogFace.svg', 'dog', 0),
        _buildSelectType('assets/images/catFace.svg', 'cat', 1)
      ],
    );
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
                _colorSex.setAll(0, [Colors.black, Colors.black]);
                _colorSex[element] = ColorManagement.setMarkerColor();
              });
            },
            child:InfoBuilder.selectSexInfo(context,_colorSex,element,img)));
  }

  Widget _buildSexDropDown(List<String> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildSex(items[0], 0, 'assets/images/f.png'),
        buildSex(items[1], 1, 'assets/images/m.png'),
      ],
    );
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

  Widget _buildSelectionPart() {
    return Column(children: [
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

    ]);
  }
  Card buildNameCard(){
    return InfoBuilder.buildCard("Fido's name:",_buildNameTextFields(),context);
  }

  Card buildBreedCard(){
    return InfoBuilder.buildCard("Fido's breed:",_buildBreedDropDown(availableBreeds),context);
  }

  Card buildCoatCard(){
    return InfoBuilder.buildCard("Coat color:",_buildCoatDropDown(coatColour),context);
  }

  Card buildLostOn(){
    return InfoBuilder.buildCard("Lost on:",_buildDate(), context);
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
              cursorColor: ColorManagement.setTextColor(),
              decoration: new InputDecoration(
                hintText: "Fido's name",
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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

FittedBox setTitle(){
  return FittedBox(
      fit:BoxFit.fitWidth,
      child:Text(
        'LOOK FOR FIDO',
        style:   TextStyle(
          color:ColorManagement.setTextColor(),
        ),
      )
  );
}


