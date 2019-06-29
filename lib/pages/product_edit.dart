import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/helpers/ensure-visible.dart';
import '../models/product.dart';
import '../scoped_models/main_scoped_model.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
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
  final _titleFocusNode = new FocusNode(); // manage the focus node manually
  final _descriptionFocusNode =
      new FocusNode(); // manage the focus node manually
  final _priceFocusNode = new FocusNode(); // manage the focus node manually

  Widget _buildTitleTextField(Product product) {
    // we wrap our TextFormField with EnsureVisibleWhenFocused for ?
    return new EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      // bind focusNode-properties of EnsureVisibleWhenFocused and TextFormField
      child: new TextFormField(
        focusNode: _titleFocusNode,
        decoration: new InputDecoration(
          labelText: 'Product title',
        ),
        initialValue: product == null ? '' : product.title,
        validator: (String value) {
          if (value.isEmpty || value.length < 2) {
            return 'Title is required and more than 2 characters!';
          }
        },
        onSaved: (String value) {
          // a Map -> key 'title'
          _formData['title'] = value;
        },
      ),
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    return new EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: new TextFormField(
        focusNode: _descriptionFocusNode,
        maxLines: 1,
        decoration: new InputDecoration(
          labelText: 'Description',
        ),
        initialValue: product == null ? '' : product.description,
        validator: (String value) {
          if (value.isEmpty || value.length < 10) {
            return 'Description is required and more than 10 characters!';
          }
        },
        onSaved: (String value) {
          // a Map -> key 'description'
          _formData['description'] = value;
        },
      ),
    );
  }

  Widget _buildPriceTextField(Product product) {
    return new EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: new TextFormField(
        focusNode: _priceFocusNode,
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          labelText: 'Price',
        ),
        initialValue: product == null ? '' : product.price.toString(),
        // check by ternary operator if element is null it display empty string
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
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          // if isLoading is true it shows Circular Progress Indicator, else Raised Button
      return model.isLoading
          ? new Center(child: new CircularProgressIndicator(),)
          : new RaisedButton(
              child: new Text('Save'),
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              // as an arguments we pass into _submitForm() method two methods for adding and updating list of products
              onPressed: () => _submitForm(
                  model.addProduct,
                  model.updateProduct,
                  model.selectProduct,
                  model.selectedProductIndex));
    });
  }

  Widget _buildGestureDetector(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

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
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
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
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // as arguments we pass two functions
  void _submitForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProductIndex]) {
    // if at least one field will be empty, we check it
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState
        .save(); // when we call this method, every onSave-method will be executed

    // check where we are in add-mode or in edit-mode
    if (selectedProductIndex == -1) {
      // we want to add a new product
      // here we execute addProduct function, we pass a Map with all needed values
      addProduct(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      ).then((bool success) {

        if(success){
          Navigator.of(context)
              .pushReplacementNamed('/products')
              .then((_) => setSelectedProduct(null));
        }else{
          showDialog(
              context: context,
              builder: (BuildContext context){
            return new AlertDialog(
              title: new Text('Something went wrong...'),
              content: new Text('Please, try again!'),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: new Text('Okay')),
              ],
            );
          });
        }

      });
    } else {
      // we want to edit existed product
      updateProduct(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      ).then((_) => Navigator.of(context)
          .pushReplacementNamed('/products')
          .then((_) => setSelectedProduct(null)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // there are two possible cases: we switch to Edit page and edit desirable fields
    // the second case - it`s empty and there is nothing to edit
    // in the first case we display pageContent=(new GestureDetector...)
    // in the second case we create a new Scaffold...
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      // wrap our container with GestureDetector and implement onTap()-method
      // we switch a focus (by tapping) from every TextFormField to empty place of the screen and in this way remove a keyboard
      final Widget pageContent =
          _buildGestureDetector(context, model.selectedProduct);

      return model.selectedProductIndex == -1
          ? pageContent
          : new Scaffold(
              appBar: new AppBar(
                title: new Text('Edit product'),
              ),
              body: pageContent,
            );
    });
  }
}
