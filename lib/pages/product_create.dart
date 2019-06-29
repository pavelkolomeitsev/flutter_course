import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  State<StatefulWidget> createState() => new _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {

  // instead of separate fields for every property, we create a Map-data structure
  // and hold all needed values in one Map-data structure
  Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg'
  };

  final GlobalKey<FormState> _formKey = new GlobalKey<
      FormState>(); // declare and initialize a reference to get access from any place of our app

  Widget _buildTitleTextField() {
    return new TextFormField(
      decoration: new InputDecoration(
        labelText: 'Product title',
      ),
      validator: (String value) {
        if (value.isEmpty || value.length < 2) {
          return 'Title is required and more than 2 characters!';
        }
      },
      onSaved: (String value) {
        // a Map -> key 'title'
        _formData['title'] = value;
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return new TextFormField(
      maxLines: 1,
      decoration: new InputDecoration(
        labelText: 'Description',
      ),
      validator: (String value) {
        if (value.isEmpty || value.length < 10) {
          return 'Description is required and more than 10 characters!';
        }
      },
      onSaved: (String value) {
        // a Map -> key 'description'
        _formData['description'] = value;
      },
    );
  }

  Widget _buildPriceTextField() {
    return new TextFormField(
      keyboardType: TextInputType.number,
      decoration: new InputDecoration(
        labelText: 'Price',
      ),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) {
          // check if input is a number by helping a regular expression

          return 'Price is required and should be a number!';
        }
      },
      onSaved: (String value) {
        // a Map -> key 'price'
        _formData['price'] = double.parse(value);
      },
    );
  }

  void _submitForm() {
    // if at least one field will be empty, we check it
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState
        .save(); // when we call this method, every onSave-method will be executed

    widget.addProduct(
        _formData); // here we execute addProduct function, we pass a Map with all needed values
    Navigator.of(context).pushReplacementNamed('/products');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    // wrap our container with GestureDetector and implement onTap()-method
    // we switch a focus (by tapping) from every TextFormField to empty place of the screen and in this way remove a keyboard
    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: new Container(
        margin: EdgeInsets.all(10.0),
        child: new Form(
          key: _formKey, // assign a GlobalKey to a Form-widget
          child: new ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleTextField(),
              _buildDescriptionTextField(),
              _buildPriceTextField(),
              new SizedBox(
                height: 10.0,
              ),
//          new GestureDetector(
//            onTap: _submitForm,
//            child: new Container(
//              color: Colors.green,
//              padding: EdgeInsets.all(10.0),
//              child: new Text('My button'),
//            ),
//          ),
              new RaisedButton(
                  child: new Text('Save'),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  onPressed: _submitForm),
            ],
          ),
        ),
      ),
    );
  }
}
