class LoginViewModel{
  String equipmentCode;
  String securityCode;
  bool isAlreadyLogin;

  LoginViewModel({
    this.equipmentCode,
    this.securityCode,
    this.isAlreadyLogin
  });

  LoginViewModel.withParams(String equipmentCode,String securityCode, bool isAlreadyLogin){
    this.equipmentCode=equipmentCode;
    this.securityCode=securityCode;
    this.isAlreadyLogin=isAlreadyLogin;
  }

  String getEquipmentCode(){
    return equipmentCode;
  }

  String getSecurityCode(){
    return securityCode;
  }

  bool isIsAlreadyLogin(){
    return isAlreadyLogin;
  }
}