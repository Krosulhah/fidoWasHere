class ReportPetData {
  String _typeOfPet;
  String _breedOfPet;
  String _colorOfCoat;
  String _sex;
  String _name;
  String _foundLocation;
  String _broughtLocation;
  String _contactInfo;
  var _photo;

/* MyDataStructure(
      String typeOfPet,
      String breedOfPet,
      String colorOfCoat,
      String sex,
      String name,
      String foundLocation,
      String broughtLocation,
      var photo) {
    this.typeOfPet = typeOfPet;
    this.breedOfPet = breedOfPet;
    this.colorOfCoat = colorOfCoat;
    this.sex = sex;
    this.name = name;
    this.foundLocation = foundLocation;
    this.broughtLocation = broughtLocation;
    this.photo = photo;
  }
 */
  String getTypeOfPet() {
    return this._typeOfPet;
  }

  String getBreedOfPet() {
    return this._breedOfPet;
  }

  String getColorOfCoat() {
    return this._colorOfCoat;
  }

  String getSex() {
    return this._sex;
  }

  String getName() {
    return this._name;
  }

  String getFoundLocation() {
    return this._foundLocation;
  }

  String getBroughtLocation() {
    return this._broughtLocation;
  }

  String getContactInfo() {
    return this._contactInfo;
  }

  getPhoto() {
    return this._photo;
  }

  void setTypeOfPet(String typeOfPet) {
    this._typeOfPet = typeOfPet;
  }

  void setBreedOfPet(String breedOfPet) {
    this._breedOfPet = breedOfPet;
  }

  void setColorOfCoat(String colorOfCoat) {
    this._colorOfCoat = colorOfCoat;
  }

  void setSex(String sex) {
    this._sex = sex;
  }

  void setName(String name) {
    this._name = name;
  }

  void setFoundLocation(String foundLocation) {
    this._foundLocation = foundLocation;
  }

  void setBroughtLocation(String broughtLocation) {
    this._broughtLocation = broughtLocation;
  }

  setPhoto(var photo) {
    this._photo = photo;
  }

  void setContactInfo(String contactInfo) {
    this._contactInfo = contactInfo;
  }
}
