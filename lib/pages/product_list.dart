import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_edit.dart';
import '../scoped_models/main_scoped_model.dart';

class ProductListPage extends StatefulWidget {

  final MainModel model;

  ProductListPage(this.model);

  @override
  State<StatefulWidget> createState() {

    return new _ProductListState();
  }

}

class _ProductListState extends State<ProductListPage>{

  @override
  void initState() {

    widget.model.fetchProducts();
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return new IconButton(
        icon: new Icon(Icons.edit),
        onPressed: () {
          // in this place we pass exact id of item of list of products
          // to define which item to edit
          model.selectProduct(model.allProducts[index].id);
          Navigator.of(context)
              .push(new MaterialPageRoute(builder: (BuildContext context) {
            return new ProductEditPage();
          })).then((_) {
            model.selectProduct(null);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return new ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return new Dismissible(
            key: new Key(model.allProducts[index].title),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                model.selectProduct(model.allProducts[index].id); // define id of item
                model.deleteProduct(); // and only then delete it
              }
            },
//          background: new Container(
//            color: Colors.black26,
//          ),
            child: new Column(
              children: <Widget>[
                new ListTile(
                  leading: new CircleAvatar(
                      backgroundImage:
                          NetworkImage(model.allProducts[index].image)),
                  title: new Text(model.allProducts[index].title),
                  subtitle: new Text(
                      '\$${model.allProducts[index].price.toString()}'),
                  trailing: _buildEditButton(context, index, model),
                ),
                new Divider(
                  color: Colors.black,
                ),
              ],
            ),
          );
        },
        itemCount: model.allProducts.length,
      );
    });
  }

}
