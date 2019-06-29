import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main_scoped_model.dart';

enum AuthMode {
  SignUp,
  Login
}

class AuthenticationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final TextEditingController _passwordTextController = new TextEditingController();

  AuthMode _authMode = AuthMode.Login;

  _showWarningDialogue(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Attention!"),
            content: new Text("You should accept terms!"),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  void _submitForms(Function login) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (_formData['acceptTerms'] == false) {
      _showWarningDialogue(context);
      return;
    }

    _formKey.currentState.save();

    // call login-function with required params
    login(_formData['email'], _formData['password']);

    Navigator.pushReplacementNamed(context, '/products');
  }

  DecorationImage _buildBackgroundImage() {
    return new DecorationImage(
        fit: BoxFit.cover,
        colorFilter: new ColorFilter.mode(
            Colors.black.withOpacity(0.5), BlendMode.dstATop),
        image: AssetImage('assets/background.jpg'));
  }

  Widget _buildEmailTextField() {
    return new TextFormField(
      decoration: new InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'Your email',
        border: OutlineInputBorder(),
      ),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Email is required and should be correct!';
        }
      },
      keyboardType: TextInputType.emailAddress,
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return new TextFormField(
      decoration: new InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'Confirm your password',
        border: OutlineInputBorder(),
      ),
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Passwords do not match!';
        }
      },
      obscureText: true,
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return new TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.text,
      maxLength: 10,
      obscureText: true,
      decoration: new InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Password is required and should be more than 4 characters!';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return new SwitchListTile(
        title: new Text('Accept Terms'),
        value: _formData['acceptTerms'],
        onChanged: (bool value) {
          setState(() {
            _formData['acceptTerms'] = value;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 750.0 ? 500.0 : deviceWidth * 0.95;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Login",
        ),
      ),
      body: new Form(
        key: _formKey,
        child: new Container(
          decoration: new BoxDecoration(
            image: _buildBackgroundImage(),
          ),
          padding: EdgeInsets.all(20.0),
          child: new Center(
            child: new SingleChildScrollView(
              child: Container(
                width: targetWidth,
                child: new Column(
                  children: <Widget>[
                    _buildEmailTextField(),
                    new SizedBox(
                      height: 20.0,
                    ),
                    _buildPasswordTextField(),
                    new SizedBox(
                      height: 5.0,
                    ),
                    // check if _authMode is in SignUp mode we display _buildPasswordConfirmTextField() otherwise we display empty Container
                    _authMode == AuthMode.SignUp ? _buildPasswordConfirmTextField() : new Container(),
                    _buildAcceptSwitch(),
                    new FlatButton(
                        onPressed: () {
                          setState(() {
                            // change the value of _authMode
                            _authMode = _authMode == AuthMode.Login ? AuthMode.SignUp : AuthMode.Login;
                          });
                        },
                        child: new Text('Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}')),
                    new ScopedModelDescendant<MainModel>(builder:
                        (BuildContext context, Widget child, MainModel model) {
                      return new RaisedButton(
                          child: new Text("Login"),
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          // this syntax executes only if user clicks this button
                          // not when this page will render
                          onPressed: () => _submitForms(model.login));
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
