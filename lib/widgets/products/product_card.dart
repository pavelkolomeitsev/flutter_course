import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
import '../ui_elements/title_default.dart';
import './address_tag.dart';
import '../../models/product.dart';
import '../../scoped_models/main_scoped_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow() {
    return new Container(
      padding: EdgeInsets.only(top: 10.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new TitleDefault(product.title),
          new SizedBox(
            width: 10.0,
          ),
          new PriceTag(product.price.toString()),
        ],
      ),
    );
  }

  Widget _buildButtonBar(BuildContext context) {
    return new ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return new ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              new IconButton(
                icon: new Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () => Navigator.pushNamed<bool>(
                    context, '/product/' + model.allProducts[productIndex].id),
              ),
              new IconButton(
                // a hack how to display with icon favorite product or not
                icon: new Icon(model.allProducts[productIndex].isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Colors.red,
                onPressed: () {
                  model.selectProduct(model.allProducts[productIndex].id);
                  model
                      .toggleProductFavoriteStatus(); // notifyListeners() will redraw the screen
                  model.selectProduct(null);
                },
              ),
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        children: <Widget>[
          // for this trick we have to have two images -> one placeholder (local image in assets directory)
          // the second one which will load from the network
          new FadeInImage(
            placeholder: AssetImage('assets/food.jpg'),
            image: NetworkImage(product.image),
            // to standardize the size of different images we set the height to permanent size
            // and fit param (BoxFit.cover) to show images nicely
            height: 300.0,
            fit: BoxFit.cover,
          ),
          _buildTitlePriceRow(),
          new AddressTag('Union Square, San Francisco'),
          new Text(product.userEmail),
          _buildButtonBar(context),
        ],
      ),
    );
  }
}
