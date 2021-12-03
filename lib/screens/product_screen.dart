import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:flutter_app_productos/provider/providers.dart';
import 'package:flutter_app_productos/services/servies.dart';
import 'package:flutter_app_productos/ui/input_decorations.dart';
import 'package:flutter_app_productos/widgets/widgets.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    return ChangeNotifierProvider(
        create: (_) => ProductFormProvider(productService.selectedProduct),
        child: _ProductScreenBody(productService: productService));
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductService productService;

  @override
  Widget build(BuildContext context) {
    final productFormProvider = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(url: productService.selectedProduct.picture),
                Positioned(
                    top: 60,
                    left: 10,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new,
                          size: 40, color: Colors.white),
                    )),
                Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final XFile? pickedFile = await picker.pickImage(
                            //  source: ImageSource.camera,
                            source: ImageSource.gallery,
                            imageQuality: 100);

                        if (pickedFile == null) return;

                        productService
                            .updateSelectedProductImage(pickedFile.path);
                      },
                      icon: const Icon(Icons.camera_alt_outlined,
                          size: 40, color: Colors.white),
                    ))
              ],
            ),
            const _ProductForm(),
            const SizedBox(height: 30)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: productService.isSaving
            ? null
            : () async {
                if (!productFormProvider.isValidForm()) return;

                final String? imageUrl = await productService.updloadImage();

                if (imageUrl != null) {
                  productFormProvider.product.picture = imageUrl;
                }

                await productService
                    .saveOrCreateProduct(productFormProvider.product);
              },
        child: productService.isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.save_outlined),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productFormProvider = Provider.of<ProductFormProvider>(context);
    final product = productFormProvider.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        clipBehavior: Clip.antiAlias,
        width: double.infinity,
        // height: 200,
        decoration: _buildBoxDecoration(),
        child: Form(
            key: productFormProvider.formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    initialValue: product.name,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: "Nombre del producto", labelText: "Nombre:"),
                    onChanged: (val) => product.name = val,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                    }),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  initialValue: '${product.price}',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: "Q150", labelText: "Precio"),
                  onChanged: (val) => product.price =
                      double.tryParse(val) != null ? double.parse(val) : 0,
                ),
                const SizedBox(
                  height: 30,
                ),
                SwitchListTile.adaptive(
                    title: const Text('Disponible'),
                    activeColor: Colors.indigo,
                    value: product.available,
                    onChanged: productFormProvider.updateAvailability)
              ],
            )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ]);
}
