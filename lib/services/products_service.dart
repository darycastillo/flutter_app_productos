import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app_productos/models/models.dart';

class ProductService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-2c34b-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  bool isLoading = true;
  bool isSaving = false;
  late Product selectedProduct;
  File? pictureFile;

  final storage = const FlutterSecureStorage();

  ProductService() {
    loadProducts();
  }

  loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(
        _baseUrl, 'products.json', {'auth': await storage.read(key: 'token')});
    final response = await http.get(url);
    final Map<String, dynamic> productMap = json.decode(response.body);

    productMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      //crear
      await createProduct(product);
    } else {
      //actualizar
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json',
        {'auth': await storage.read(key: 'token')});
    /*   final response =  */ await http.put(url, body: product.toJson());
    final indexProduct = products.indexWhere((ele) => ele.id == product.id);
    if (indexProduct >= 0) {
      products[indexProduct] = product;
    }
    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(
        _baseUrl, 'products.json', {'auth': await storage.read(key: 'token')});
    final response = await http.post(url, body: product.toJson());
    final decodedData = json.decode(response.body);
    product.id = decodedData['name'];
    products.add(product);
    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    pictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  updloadImage() async {
    if (pictureFile == null) return null;
    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/dcg8ezf7z/image/upload?upload_preset=smt2gdan");

    final uploadImageRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', pictureFile!.path);

    uploadImageRequest.files.add(file);

    final streamResponse = await uploadImageRequest.send();

    final response = await http.Response.fromStream(streamResponse);
    if (response.statusCode != 200 && response.statusCode != 201) {
      print("Algo salio mal");
      print(response.body);
      return null;
    }

    pictureFile = null;

    Map<String, dynamic> decodeResponse = json.decode(response.body);
    return decodeResponse['secure_url'];
  }
}
