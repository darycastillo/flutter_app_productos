import 'package:flutter/material.dart';
import 'package:flutter_app_productos/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Product product;

  ProductFormProvider(this.product);

  void updateAvailability(bool val) {
    product.available = val;
    notifyListeners();
  }

  bool isValidForm() {
    return formkey.currentState?.validate() ?? false;
  }
}
