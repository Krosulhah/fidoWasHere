import 'package:postgres/postgres.dart';
import 'package:connectivity/connectivity.dart';
class ConnectionHandler{


  PostgreSQLConnection createConnection(){
    return PostgreSQLConnection(
        "ec2-52-31-233-101.eu-west-1.compute.amazonaws.com",
        5432,
        "d546e3qrqkclh8",
        username: "talusgwyiskbzs",
        password:
        "12b36d512f0f4a6f25f266b6d30bc19851f00e50c76d03f3d1fc5f1d3f1d0530",
        timeoutInSeconds: 30,
        queryTimeoutInSeconds: 30,
        timeZone: 'UTC',
        useSSL: true);
  }

 bool isConnected(var result) {
    if (result == ConnectivityResult.mobile||result==ConnectivityResult.wifi) {
        return true;
    }
    else
        return false;

  }
}