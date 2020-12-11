import 'dart:html';

class Fido{

  int id;
  String sex;
  String breed;
  String colour;
  String type;
  bool isClosed;
  bool broughtHome;
  String broughtTo;
  String foundHere;
  File photo; //? File image = await ImagePicker.pickImage(source: imageSource);
  DateTime date;

  Fido();

  void setId(int id){
    this.id=id;
  }

  int getId(){
    return this.id;
  }

  void setSex(String sex){
    this.sex=sex;
  }

  String getSex(){
    return this.sex;
  }

  void setBreed(String breed){
    this.breed=breed;
  }

  String getBreed(){
    return this.breed;
  }

  void setColour(String colour){
    this.colour=colour;
  }

  String getColour(){
    return this.colour;
  }

  void setType(String type){
    this.type=type;
  }

  String getType(){
    return this.type;
  }

  void setClosedStatus(bool isClosed){
    this.isClosed=isClosed;
  }

  bool getClosedStatus(){
    return this.isClosed;
  }

  void setBroughtHome(bool broughtHome){
    this.broughtHome=broughtHome;
  }

  bool getBroughtHome(){
    return this.broughtHome;
  }

  void setFoundHere(String foundHere){
    this.foundHere=foundHere;
  }

  String getFoundHere(){
    return this.foundHere;
  }

  void setPhoto(File photo){
    this.photo=photo;
  }

  File getPhoto(){
    return this.photo;
  }

  void setDate(DateTime date){
    this.date=date;
  }

  DateTime getDate(){
    return this.date;
  }
}