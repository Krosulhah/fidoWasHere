import 'package:dimaWork/Model/breed.dart';

import '../connectionHandler.dart';

class ReportController{
  ConnectionHandler connectionHandler = new ConnectionHandler();

  Future<List<Breed>> retrievePossibleBreed(String type) async {
    List<Breed> breeds=new List<Breed>();
    var connection = connectionHandler.createConnection();
    await connection.open();
    List<List<dynamic>> results = await connection.query(
        "SELECT * FROM public.\"Breed\" WHERE typepet= @t OR  typepet= @b ",
        substitutionValues: {"t": type, "b":'cad'});
    connection.close();
    for(final row in results){
      Breed breed=new Breed();
      breed.setBreedName(row[0]);
      breed.setFidoType(row[1]);
      breeds.add(breed);
    }
    return breeds;
  }

}