class DrivereModel{
  int did,contact;
  String Name;
  String imagePath;
  DrivereModel({required this.did,required this.Name,required this.contact,required this.imagePath});
  Map<String,dynamic> toMap(){
    return{
      'did': did,
      'Name':Name,
      'contact':contact,
      'imagePath':imagePath

    };
  }
}