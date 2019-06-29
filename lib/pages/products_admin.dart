import 'package:flutter/material.dart';

import './product_edit.dart';
import './product_list.dart';
import '../scoped_models/main_scoped_model.dart';

class ProductsAdminPage extends StatelessWidget {

  final MainModel model;

  ProductsAdminPage(this.model);

  Widget _buildSideDrawer(BuildContext context){

     return new Drawer(
       child: new Column(
         children: <Widget>[
           new AppBar(
             automaticallyImplyLeading: false,
             title: new Text("Choose"),
           ),
           new ListTile(
             leading: new Icon(Icons.shop),
             title: new Text("All Products"),
             onTap: () {
               Navigator.pushReplacementNamed(context, '/products');
             },
           )
         ],
       ),
     );
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: new AppBar(
          title: new Text("Manage Products"),
          bottom: new TabBar(tabs: <Widget>[
            new Tab(
              icon: new Icon(Icons.create),
              text: "Create Product",
            ),
            new Tab(
              icon: new Icon(Icons.list),
              text: "My Products",
            ),
          ]),
        ),
        body: new TabBarView(children: <Widget>[
          new ProductEditPage(),
          new ProductListPage(model),
        ]),
      ),
    );
  }
}
