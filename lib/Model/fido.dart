import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Fido {
  int id;
  String sex;
  String breed;
  String name;
  String reporter;
  String colour;
  String type;
  bool isClosed;
  bool broughtHome;
  String broughtTo;
  String foundHere;
  Uint8List
      photo; //? File image = await ImagePicker.pickImage(source: imageSource);
  DateTime date;

  Fido();

  void setId(int id) {
    this.id = id;
  }

  int getId() {
    return this.id;
  }

  void setName(String name) {
    this.name = name;
  }

  String getName() {
    return this.name;
  }

  void setReporter(String name) {
    this.reporter = name;
  }

  String getReporter() {
    return this.reporter;
  }

  void setSex(String sex) {
    this.sex = sex;
  }

  String getSex() {
    return this.sex;
  }

  void setBreed(String breed) {
    this.breed = breed;
  }

  String getBreed() {
    return this.breed;
  }

  void setColour(String colour) {
    this.colour = colour;
  }

  String getColour() {
    return this.colour;
  }

  void setType(String type) {
    this.type = type;
  }

  String getType() {
    return this.type;
  }

  void setClosedStatus(bool isClosed) {
    this.isClosed = isClosed;
  }

  bool getClosedStatus() {
    return this.isClosed;
  }

  void setBroughtHome(String broughtHome) {
    bool boolean = false;
    if (broughtHome.contains("true")) boolean = true;

    this.broughtHome = boolean;
  }

  bool getBroughtHome() {
    return this.broughtHome;
  }

  void setFoundHere(String foundHere) {
    this.foundHere = foundHere;
  }

  String getFoundHere() {
    return this.foundHere;
  }

  void setBrouthto(String foundHere) {
    this.broughtTo = foundHere;
  }

  String getBroughtTo() {
    return this.broughtTo;
  }

  void setPhoto(String photo) {
    this.photo = base64Decode(photo);
  }

  Uint8List getPhoto() {
    return this.photo;
  }

  void setDate(DateTime date) {
    this.date = date;
  }

  DateTime getDate() {
    return this.date;
  }
}
