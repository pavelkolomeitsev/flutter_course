import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
//import 'package:flutter/rendering.dart';

import './pages/authentication.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './scoped_models/main_scoped_model.dart';
import './models/product.dart';

void main() {
  /*debugPaintSizeEnabled = true;
  debugPaintBaselinesEnabled = true;
  debugPaintPointersEnabled = true;*/
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    final MainModel model = new MainModel();

    // we wrap out entire app with a scoped model instance
    return new ScopedModel<MainModel>(
        // named param 'model' needs an instance of our general scoped model type -> MainModel
        model: model, // it`s a SINGLE instance for entire app

        // named param 'child' needs a widget
        child: new MaterialApp( // we pass this instance (new ProductsModel()) to MaterialApp and all its children -> subtrees
          //debugShowMaterialGrid: true,
          theme: new ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
            buttonColor: Colors.deepPurple,
          ),
          //home: new AuthenticationPage(),
          routes: {
            '/': (BuildContext context) => new AuthenticationPage(),
            '/products': (BuildContext context) => new ProductsPage(model),
            '/admin': (BuildContext context) => new ProductsAdminPage(model),
          },
          onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');

            // if a name of page is invalid
            if (pathElements[0] != '') {
              return null;
            }

            if (pathElements[1] == 'product') {
              final String productId = (pathElements[2]);
              final Product product = model.allProducts.firstWhere((Product product){
                return product.id == productId;
              });
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) =>
                new ProductPage(product),
              );
            }

            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
              builder: (BuildContext context) => new ProductsPage(model),
            );
          },
        ),);
  }
}
