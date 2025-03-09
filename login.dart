import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * 0.991,
          height: MediaQuery.of(context).size.height * 0.96,
          decoration: BoxDecoration(
              color: Color.fromARGB(10, 0, 0, 0),
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(35),),
              Column(
                children: [
                  Spacer(),
                  _menuText('Register'),
                  _menuText('or Log in'),
                  Spacer()
                ],
              ),
              Column(
                children: [
                  Spacer(),
                  _buildLoginButton("Google", Icons.pattern, 1),
                  Padding(padding: EdgeInsets.all(11),),
                  _buildLoginButton("Local", Icons.password, 1),
                  Padding(padding: EdgeInsets.all(11),),
                  _buildLoginButton("Return", Icons.arrow_back, 0.6),
                  Spacer()
                ],
              ),
              Padding(padding: EdgeInsets.all(40),),
            ],
          )
        ),
      )
    );
  }

  Widget _menuText(String menuText) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child:
      Text(menuText, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontWeight: FontWeight.bold, color: Color.fromARGB(200, 130, 100, 110)), textAlign: TextAlign.start),
    );
  }

  Widget _buildLoginButton(String loginText, IconData loginIcon, double size) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.4256 * size,
      height: MediaQuery.of(context).size.height * 0.2253 * size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(200))
      ),
      child: ElevatedButton(
        onPressed: () {if(loginText == "Local") {
            _localDialog();
          } else if(loginText == "Return") {
            Navigator.pop(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 230, 160, 149),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [SizedBox(width: 37), Icon(loginIcon, color: Color.fromARGB(200, 130, 100, 110), size: MediaQuery.of(context).size.width * 0.08 * size,), Text(loginText, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05 * size, fontWeight: FontWeight.bold, color: Color.fromARGB(200, 130, 100, 110)), textAlign: TextAlign.start)],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.07,
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 230, 160, 149),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        expands: false,
        maxLines: 1,
        minLines: 1,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(color: Color.fromARGB(200, 130, 100, 110), fontSize: MediaQuery.of(context).size.height * 0.025),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide.none),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: TextStyle(color: Color.fromARGB(150, 130, 100, 130), fontSize: MediaQuery.of(context).size.height * 0.025),
          hintText: hintText,
        ),
      ),
    );
  }

  Widget _buttonAction(String buttonText) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 230, 160, 149),
      ),
      onPressed: () {},
      child: Text(buttonText, style: TextStyle(color: Color.fromARGB(255, 130, 100, 130), fontStyle: FontStyle.italic ,fontWeight: FontWeight.bold,),),
    );
  }

  void _localDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 255, 230, 222),
          title: const Text('Local Login', style: TextStyle(color: Color.fromARGB(255, 130, 100, 130), fontStyle: FontStyle.normal ,fontWeight: FontWeight.bold,),),
          content:
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    _buildTextField("Username",),
                    SizedBox(height: 20,),
                    _buildTextField("Password",),
                    SizedBox(height: 8,),
                    _buildTextField("Pass again",),
                  ],
                ),
              ),
          actions: [
            _buttonAction("Register Instead"),
            _buttonAction("Log In")
          ],
        );
      },
    );
  }

}
