class User{
  int idUser;
  String mail;
  String psw;
  String fbAccount;

  void setIdUser(int idUser){
    this.idUser=idUser;
  }

  int getIdUser(){
    return this.idUser;
  }

  void setMail(String mail){
    this.mail=mail;
  }

  String getMail(){
    return this.mail;
  }

  void setPsw(String psw){
    this.psw=psw;
  }

  String getPsw(){
    return this.psw;
  }

  void setFbAccount(String fbAccount){
    this.fbAccount=fbAccount;
  }

  String getFbAccount(){
    return this.fbAccount;
  }
}