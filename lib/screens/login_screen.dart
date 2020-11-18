import 'package:clothing_store/models/user_model.dart';
import 'package:clothing_store/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: Text("Entrar"),
            centerTitle: true,
            actions: <Widget>[
              FlatButton(
                child: Text(
                    "CRIAR CONTA",
                    style: TextStyle(
                        fontSize: 15
                    )
                ),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignUpScreen())
                  );
                },
              )
            ]
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(child: CircularProgressIndicator());
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "E-mail"
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if(text.isEmpty || !text.contains("@")) return "E-mail inválido";
                      }
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        hintText: "Senha"
                    ),
                    obscureText: true,
                    validator: (text) {
                      if(text.isEmpty || text.length < 6) return "Senha inválida";
                    },
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          onPressed: () {
                            if(_emailController.text.isEmpty)
                              _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                      content: Text("Insira seu email para recuperar a senha"),
                                      backgroundColor: Colors.redAccent,
                                      duration: Duration(seconds: 2)
                                  )
                              );
                            else {
                              model.recoverPass(_emailController.text);
                              _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                      content: Text("Confira seu e-mail!"),
                                      backgroundColor: Theme.of(context).primaryColor,
                                      duration: Duration(seconds: 2)
                                  )
                              );
                            }

                          },
                          child: Text(
                            "Esqueci minha senha",
                            textAlign: TextAlign.right,
                          ),
                          padding: EdgeInsets.zero
                      )
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                      height: 44,
                      child: RaisedButton(
                          child: Text(
                            "Entrar",
                            style: TextStyle(
                                fontSize: 18
                            ),
                          ),
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            if(_formKey.currentState.validate()){

                            }

                            model.signIn(
                                email: _emailController.text,
                                pass: _passwordController.text,
                                onSuccess: _onSuccess,
                                onFailure: _onFailure
                            );
                          }
                      )
                  )
                ],
              ),
            );
          },
        )
    );
  }
  void _onSuccess(){
    Navigator.of(context).pop();
  }

  void _onFailure(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
            content: Text("Falha ao entrar, verifique usuário e senha!"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2)
        )
    );
  }
}