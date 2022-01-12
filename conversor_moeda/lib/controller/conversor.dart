import 'dart:async';

import 'package:conversor_moeda/util/api.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

// ignore: non_constant_identifier_names
Future<Map> GetData() async {
  var url = Uri.parse(api);
  var response = await http.get(url).then((value) => value);
  return await jsonDecode(response.body);
}
