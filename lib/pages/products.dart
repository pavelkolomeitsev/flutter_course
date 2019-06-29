import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/products/products.dart';
import '../scoped_models/main_scoped_model.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;

  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  initState() {
    widget.model.fetchProducts(); // display all products from the Firebase
    super.initState();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return new Drawer(
        child: new Column(
      children: <Widget>[
        new AppBar(
          automaticallyImplyLeading: false,
          title: new Text("Choose"),
        ),
        new ListTile(
          leading: new Icon(Icons.edit),
          title: new Text("Manage Products"),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/admin');
          },
        )
      ],
    ));
  }

  Widget _buildProductList() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = new Center(child: new Text('No products found!'));

        if (model.displayProducts.length > 0 && !model.isLoading) {
          content = new Products();
        } else if (model.isLoading) {
          content =
              new Center(child: new CircularProgressIndicator()); // spinner
        }
        return new RefreshIndicator(child: content, onRefresh: model.fetchProducts);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: new AppBar(
        title: new Text(
          "AppBar",
        ),
        actions: <Widget>[
          new ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
            return new IconButton(
              // we check what value has '_showListOfFavorites' (false or true)
              // and display it by helping an icon 'favorite' or 'favorite_border'
              icon: new Icon(model.displayListOfFavoritesOnly
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () {
                model.toggleDisplayMode();
              },
            );
          }),
        ],
      ),
      body: _buildProductList(),
    );
  }
}
