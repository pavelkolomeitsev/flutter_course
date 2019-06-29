import 'package:flutter/material.dart';
import 'dart:async';

import '../widgets/ui_elements/title_default.dart';
import '../widgets/products/address_tag.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {

  _showWarningDialogue(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Are you sure?"),
            content: new Text("This action cannot be undone!"),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("DISCARD"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: new Text("CONTINUE"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  }),
            ],
          );
        });
  }

  final Product product;

  ProductPage(this.product);

  Widget _buildTitleDescriptionAddressPrice(
      BuildContext context, Product product) {
    return new Container(
      padding: EdgeInsets.all(10.0),
      child: new Column(
        children: <Widget>[
          new TitleDefault(product.title),
          new Container(
            padding: EdgeInsets.all(20.0),
            alignment: AlignmentDirectional(-1.1, 0.0),
            child: new Text(
              product.description,
              style: new TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.normal,
                fontFamily: 'GreatVibes',
              ),
            ),
          ),
          new Container(
              padding: EdgeInsets.all(20.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Expanded(
                    child: new AddressTag('Union Square, San Francisco'),
                  ),
                  new SizedBox(
                    width: 10.0,
                  ),
                  new Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: new Text(
                      '\$${product.price}',
                      style: new TextStyle(fontSize: 25.0, color: Colors.white),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            product.title,
          ),
        ),
        body: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new FadeInImage(
              placeholder: AssetImage('assets/food.jpg'),
              image: NetworkImage(product.image),
              height: 300.0,
              fit: BoxFit.cover,
            ),
            new Container(padding: EdgeInsets.all(5.0),),
            _buildTitleDescriptionAddressPrice(context, product),
          ],
        ), // Column
      ),
    );
  }
}

/*
new Container(
                padding: EdgeInsets.all(10.0),
                child: new RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: new Text("Delete"),
                  onPressed: () => _showWarningDialogue(context),))
*/
