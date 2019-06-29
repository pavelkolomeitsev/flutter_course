import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_card.dart';
import '../../models/product.dart';
import '../../scoped_models/main_scoped_model.dart';

class Products extends StatelessWidget {

  // in signature of this method we pass a list of products of type 'Product'
  Widget _buildProductList(List<Product> products) {
    Widget productCard;

    if (products.length > 0) {
      productCard = new ListView.builder(
        itemBuilder: (BuildContext context, int index) => new ProductCard(products[index], index),
        itemCount: products.length,
      );
    } else
      productCard =
          new Container(); //Center(child: new Text("No products found, please add some"),)

    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    print("Product Widget build method");
    // the method -> '(BuildContext context, Widget child, Model model){}' in builder will be executed
    // when ANY CHANGES in data (scoped model package -> products file) will occur
    // also we have to point which type of scoped model package this method has to monitor -> <ProductsModel>
    // and as an argument -> 'ProductsModel model'
    return new ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
      // in this method we have to return a widget!!!
      // for passing data to _buildProductList() we have to pass an argument -> 'Model model'
      return _buildProductList(model.displayProducts);
    });
  }
}
