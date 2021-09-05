import 'package:flutter/material.dart';
import 'package:genrevibes/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:dart_ipify/dart_ipify.dart';

Map<dynamic, dynamic> data;

Future<Map> detectProxy() async {
  try {
    String ip = await Ipify.ipv4();
    Map<String, String> header = {'x-ip': ip};
    print('||||||||||||||||||||||||||');
    print(ip);
    var response = await http.get(kgetCountry, headers: header);
    if (response.statusCode == 200) {
      print(response);
      var jsonData = jsonDecode(response.body);
      var decoded = jsonData['data'][ip];
      data = {
        "ioscode": decoded['isocode'],
        "country": decoded['country'],
        "proxy": decoded['proxy']
      };
      print(data);
      return data;
    } else {
      print('failed request');
    }
  } catch (e) {
    print(e);
  }

  return data;
}
