import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constantes.dart';
import '../models/api_response.dart';
import '../models/product.dart';

import 'package:http/http.dart' as http;

Future<ApiResponse> getTables() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(Uri.parse("$productURL/tables"));
    switch (response.statusCode) {
      case 200:
        apiResponse.data =
            jsonDecode(response.body).map((e) => Product.fromJson(e)).toList();
        break;
      // case 401:
      //   apiResponse.error = "unauthorized";
      //   break;
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

Future<ApiResponse> getChairs() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(Uri.parse("$productURL/chaises"));
    switch (response.statusCode) {
      case 200:
        apiResponse.data =
            jsonDecode(response.body).map((e) => Product.fromJson(e)).toList();
        break;
      // case 401:
      //   apiResponse.error = "unauthorized";
      //   break;
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

Future<ApiResponse> getBaches() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(Uri.parse("$productURL/baches"));
    switch (response.statusCode) {
      case 200:
        apiResponse.data =
            jsonDecode(response.body).map((e) => Product.fromJson(e)).toList();
        break;
      case 401:
        apiResponse.error = "unauthorized";
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

Future<ApiResponse> getPodiums() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(Uri.parse("$productURL/podiums"));
    switch (response.statusCode) {
      case 200:
        apiResponse.data =
            jsonDecode(response.body).map((e) => Product.fromJson(e)).toList();
        break;
      // case 401:
      //   apiResponse.error = "unauthorized";
      //   break;
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

//update Good
Future<ApiResponse> updateProductQuantity(
    String id, int initialQuantite, int quantiteLouer) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // String token = await getToken();

    final response = await http.patch(Uri.parse('$productURL/$id'),
        /* headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },*/
        body: {'quantite': (initialQuantite - quantiteLouer).toString()});
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;

      default:
        apiResponse.error = "somethingWentWrong";
        break;
    }
  } catch (e) {
    print("erreur $e");
    apiResponse.error = "serverError";
  }
  return apiResponse;
}
