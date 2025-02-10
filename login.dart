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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child:
                    Text('Login or', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontWeight: FontWeight.bold, color: Color.fromARGB(200, 130, 100, 110)), textAlign: TextAlign.start),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child:
                    Text('Sign up', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontWeight: FontWeight.bold, color: Color.fromARGB(200, 130, 100, 110)), textAlign: TextAlign.start),
                  ),
                  Spacer()
                ],
              ),
              Column(
                children: [
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.4256,
                    height: MediaQuery.of(context).size.height * 0.2253,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(200))
                    ),
                    child: ElevatedButton(
                      onPressed: () => (),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 230, 160, 149),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [SizedBox(width: 37), Icon(Icons.pattern, color: Color.fromARGB(200, 130, 100, 110), size: MediaQuery.of(context).size.width * 0.08,), Text('Google', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold, color: Color.fromARGB(200, 130, 100, 110)), textAlign: TextAlign.start)],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(11),),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.4256,
                    height: MediaQuery.of(context).size.height * 0.2253,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(200))
                    ),
                    child: ElevatedButton(
                      onPressed: () => (),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 230, 160, 149),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [SizedBox(width: 37), Icon(Icons.key, color: Color.fromARGB(200, 130, 100, 110), size: MediaQuery.of(context).size.width * 0.08,), Text(' Other', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold, color: Color.fromARGB(200, 130, 100, 110)), textAlign: TextAlign.start)],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(11),),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.4256,
                    height: MediaQuery.of(context).size.height * 0.2253,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(200))
                    ),
                    child: ElevatedButton(
                      onPressed: () => (),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 230, 160, 149),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [SizedBox(width: 45), Icon(Icons.password, color: Color.fromARGB(200, 130, 100, 110), size: MediaQuery.of(context).size.width * 0.08,), Text(' Local', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold, color: Color.fromARGB(200, 130, 100, 110)), textAlign: TextAlign.start)],
                      ),
                    ),
                  ),
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
}
