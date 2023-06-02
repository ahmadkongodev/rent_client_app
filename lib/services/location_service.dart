import 'dart:convert';

import 'package:open/constantes.dart';
import 'package:open/models/location.dart';

import '../models/api_response.dart';

import 'package:http/http.dart' as http;

Future<ApiResponse> insertLocation(DateTime date_fin, String id_client,
    String id_produit, int quantite_louer) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // String token = await getToken();

    final response = await http.post(Uri.parse(locationURL), body: {
      'date_fin': date_fin.toString(),
      'id_client': id_client,
      'id_produit': id_produit,
      'quantite_louer': quantite_louer.toString()
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = Location.fromJson(jsonDecode(response.body));
        break;
      case 409:
        apiResponse.error = "This username already exist, please change it";
        break;
      default:
        apiResponse.error = "somethingWentWrong";
        break;
    }
  } catch (e) {
    print('erreur: $e');
    apiResponse.error = "serverError";
  }
  return apiResponse;
}
