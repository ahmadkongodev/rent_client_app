import 'dart:convert';

import 'package:open/models/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constantes.dart';
import '../models/api_response.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> registerClient(String nom, String prenom, String username,
    String password, String numero, String address) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // String token = await getToken();

    final response = await http.post(Uri.parse('$clientURL/register'), body: {
      'nom': nom,
      'prenom': prenom,
      'username': username,
      'password': password,
      'numero': numero,
      'address': address
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = Client.fromJson(jsonDecode(response.body));
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

Future<ApiResponse> loginClient(String username, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // String token = await getToken();

    final response = await http.post(Uri.parse('$clientURL/login'),
        body: {'username': username, 'password': password});
    switch (response.statusCode) {
      case 200:
        apiResponse.data = Client.fromJson(jsonDecode(response.body));

        break;
      case 401:
        apiResponse.error = "username or password not valid";
        break;
      case 404:
        apiResponse.error = "This user is not register yet";
        break;
      case 404:
        apiResponse.error = "remplissez tous les champs";
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

//get client id
Future<String> getClientId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('clientId') ?? "";
}
//delete id

Future<void> deleteClientId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
   pref.remove('clientId');
}
//show customer
Future<ApiResponse> showClient() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String id = await getClientId();

    final response = await http.get(Uri.parse('$clientURL/$id'));
    switch (response.statusCode) {
      case 200:
        apiResponse.data = Client.fromJson(jsonDecode(response.body));
        break;
      default:
        apiResponse.error = "${response.statusCode}something went wrong";
        break;
    }
  } catch (e) {
    apiResponse.error = "serverError";
    print(e);
  }
  return apiResponse;
}

Future<ApiResponse> updateClient(String nom, String prenom, String username,
    String numero, String address) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String id = await getClientId();

    final response = await http.patch(Uri.parse('$clientURL/$id'), body: {
      'nom': nom,
      'prenom': prenom,
      'username': username,
      'numero': numero,
      'address': address
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = Client.fromJson(jsonDecode(response.body));
        break;
      default:
        apiResponse.error = "${response.statusCode}something went wrong";
        break;
    }
  } catch (e) {
    apiResponse.error = "serverError";
    print(e);
  }
  return apiResponse;
}
