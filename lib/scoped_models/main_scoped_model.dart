import 'package:scoped_model/scoped_model.dart';

import './connected_products.dart';

// we take one general class and connect in it our all scoped model classes
// (we share functionality and properties of these classes in one general class)
// by helping of mixins of Dart language
class MainModel extends Model with ConnectedProductsModel, ProductsModel, UserModel, UtilityModel{}