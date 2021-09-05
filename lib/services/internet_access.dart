import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';

/*class InternetAccess extends StatelessWidget {

  var connectivityResult = await (Connectivity().checkConnectivity());


  if (connectivityResult == ConnectivityResult.mobile) {
  // I am connected to a mobile network.
  } else if (connectivityResult == ConnectivityResult.wifi) {
  // I am connected to a wifi network.
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}*/

Future<bool> InternetAcces() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    Fluttertoast.showToast(
      msg: "No Network Connection",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 10,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    return true;
  }

  return false;
}

Future<Widget> DetectInternetOnProfile() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    Fluttertoast.showToast(
      msg: "No Network Connection",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 10,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    // return Container();
  }

  return Container();
}
