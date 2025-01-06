import 'dart:convert';
import 'dart:math';

import 'package:app/models/Flight.dart';
import 'package:http/http.dart' as http;

import '../globals.dart' as globals;

Future<Flight> createFlight(String callsign, String dest, String departure,
    String altn, String ete) async {
  final response = await http.post(
    Uri.parse(
      '${globals.apiURL}/init/request',
    ),
    body: jsonEncode(<String, String>{
      "id": callsign,
      "dest": dest,
      "dep": departure,
      "altn": altn,
      "ete": ete,
      "ADCReq": Random().nextBool().toString()
    }),
  );

  if (response.statusCode != 200) {
    return Future.error('Error ${response.statusCode}');
  } else {
    // Flight model succesfully created
    return Flight.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
