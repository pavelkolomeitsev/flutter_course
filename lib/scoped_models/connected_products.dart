// here we have three separate classes, but in one file
// for making the properties of these classes private but visible for each other
import 'package:scoped_model/scoped_model.dart';

// all classes imported from 'package:http/http.dart' will be grouped in 'http' object
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products =
      []; // a temporary data-structure which holds all available products

  User _authenticatedUser;

  String _selProductId; // for setting id manually

  bool _isLoading = false; // check if we load a data from the server
}

mixin ProductsModel on ConnectedProductsModel {
  bool _showListOfFavorites =
      false; // a variable to switch to show full list of products (false) or favorite (true)

  // to get access to private _products list we have to implement a getter
  List<Product> get allProducts {
    // we copy an existing list (List<Product> _products = [];),
    // create a new one
    // and return a reference without changing the original list
    return List.from(_products);
  }

  // it`s a filtered list of favorite products
  List<Product> get displayProducts {
    if (_showListOfFavorites) {
      // here we create a new list from the old one with a condition 'where'
      // as a param we pass an instance of type 'Product'
      // in the body of method we set a condition
      // -> put to the new list an item of Product ONLY if it`s property 'isFavorite' is true
      // at the end we gather all selected items to the new list -> toList()
      return _products.where((Product product) => product.isFavorite).toList();
    }
    // here we return a full list
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  // for getting a selected product index outside
  String get selectedProductId {
    return _selProductId;
  }

  // возвращает выбранный продукт
  Product get selectedProduct {
    // if _selectedProductIndex isn`t defined
    if (selectedProductId == null) {
      return null;
    }
    // firstWhere-method returns one product. we give it one product
    // and it returns true if this product is the same we are looking for
    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  bool get displayListOfFavoritesOnly {
    return _showListOfFavorites;
  }

  Future<bool> addProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();

    // create a Map-object to convert it into a json-object
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
      'http://www.chocolate.news/wp-content/uploads/sites/294/2018/08/Dark-chocolate.jpg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    // send a post-request to a firebase with our converted Map-object in a body of request
    return http
        .post('https://flutter-products-6ba01.firebaseio.com/products.json',
        body: json.encode(productData))
    // make adding the product asynchronous, wait for the response
    // it will work only after when post-method will finish its work
    // it returns the response (object) from the server
        .then((http.Response response) {
      // check if received response is correct
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // the format of response is json object, so we have to decode it
      // and create a new Map-object
      final Map<String, dynamic> responseData = json.decode(response.body);

      final Product newProduct = new Product(
          id: responseData['name'],
          // it`s an id of newly created product
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      // return successful response operation
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }); // convert our Map-object into a json-object
  }

  // all methods should be public to access to them outside
  Future<bool> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> updatedData = {
      'title': title,
      'description': description,
      'image':
          'http://www.chocolate.news/wp-content/uploads/sites/294/2018/08/Dark-chocolate.jpg',
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };
    return http
        .put(
            'https://flutter-products-6ba01.firebaseio.com/products/${selectedProduct.id}.json',
            body: json.encode(updatedData))
        .then((http.Response response) {
      _isLoading = false;

      final Product updatedProduct = new Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      // this method returns index (int) of the product if product id
      // is equal for _selProductId (both String-type)
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();

    return http
        .delete(
            'https://flutter-products-6ba01.firebaseio.com/products/$deletedProductId.json')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  // here we fetch data from the server (Firebase)
  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://flutter-products-6ba01.firebaseio.com/products.json')
        .then<Null>((http.Response response) {
      // create an empty list of products
      final List<Product> fetchedProductList = [];

      // this data structure represents a list of products encoded in json objects
      // Map<String - (it will be an ID of product), Map<String, dynamic> - this Map is actually one product>
      final Map<String, dynamic> productListData = json.decode(response.body);

      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      // forEach-method will execute a function for each key/value pair in outer Map
      // as params of function we pass types of our outer Map
      // productId - key, productData - value
      productListData.forEach((String productId, dynamic productData) {
        final Product product = new Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            image: productData['image'],
            userEmail: productData['userEmail'],
            userId: productData['userId']);
        fetchedProductList.add(product);
      });

      // replace existing product list with fetchedProductList
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleProductFavoriteStatus() {
    // update the bool property of an exact product in an immutable (proper) way
    // it means -> take a selected product, copy it with a new product,
    // change in the new product bool property to the appropriate way,
    // replace a selected product in the list with a new one
    final bool isCurrentlyFavorite =
        selectedProduct.isFavorite; // note a bool property of the product
    final bool newFavoriteStatus =
        !isCurrentlyFavorite; // change existing status of property to another one
    // create a new product
    final Product updatedProduct = new Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    // reassign a list with updated product
    _products[selectedProductIndex] = updatedProduct;
    // when we call this method, scoped model forces flutter to redraw the screen
    // and updated data will appear on the screen
    notifyListeners();
  }

  // in this method we define item (by index) in the list manually
  void selectProduct(String productId) {
    _selProductId = productId; // выбрать конкретный продукт

    // This ensures, that existing pages are only immediately updated
    // (=> re-rendered) when a product is selected, not when it's unselected
    if (productId != null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    // this method inverts list of favorites and vice versa
    _showListOfFavorites = !_showListOfFavorites;
    notifyListeners(); // to redraw a screen with different lists
  }
}

mixin UserModel on ConnectedProductsModel {
  void login(String email, String password) {
    _authenticatedUser =
        new User(id: "sddfkgfohl", email: email, password: password);
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
