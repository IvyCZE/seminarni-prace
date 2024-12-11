import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seminární Práce',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AZkviztest(title: 'Seminární Práce Pg1'),
    );
  }
}
class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(10, 0, 0, 0)),
    );
  }
}
class AZkviztest extends StatefulWidget {
  const AZkviztest({super.key, required this.title});

  final String title;

  @override
  State<AZkviztest> createState() => _AZkviztestState();
}

class _AZkviztestState extends State<AZkviztest> {

  void _buttonPressed(String value) {}
  var hoverOnCreate = 50;
  var isOpenCreate = "";
  var hoverOnHost = 50;
  var isOpenHost = "";
  var hoverOnJoin = 50;
  var isOpenJoin = "";
  bool hoverCheckCreate = false;
  bool hoverCheckHost = false;
  bool hoverCheckJoin = false;
  double delayCreate = 100;
  double delayHost = 100;
  double delayJoin = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding:  EdgeInsets.all(5.0),
          ),
          Row(
            children: [
              Padding(
                padding:  EdgeInsets.all(5.0),
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Color.fromARGB(10, 0, 0, 0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                width: MediaQuery.of(context).size.width * 0.98,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Padding(
                      padding:  EdgeInsets.all(5),
                    ),
                    AnimatedContainer(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(10, 0, 0, 0),
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      ),
                      width: 80 + (hoverOnCreate + hoverOnHost + hoverOnJoin as double),
                      alignment: Alignment.center,
                      curve: Curves.easeOut,
                      duration: Duration(milliseconds: 200),
                      child: Row(
                        children: [
                          Spacer(),
                          MouseRegion(
                            onEnter: (_) => {
                              setState(() => hoverOnCreate = 90),
                              setState(() => hoverCheckCreate = true),
                              for (int i = 1; i <= "Edit".length; i++) {
                                delayCreate = (150 - (i * 50)).clamp(45, 150) as double,
                                Future.delayed(Duration(milliseconds: delayCreate * i as int), () {
                                  if (hoverCheckCreate == true)
                                  {
                                    setState(() {
                                      isOpenCreate = "Edit".substring(0, i);
                                      setState(() => hoverOnJoin = 50);
                                      setState(() => isOpenJoin = "");
                                      setState(() => hoverOnHost = 50);
                                      setState(() => isOpenHost = "");
                                    });
                                  }
                                })
                              },
                            },
                            onExit: (_) => {
                              setState(() => hoverOnCreate = 50),
                              setState(() => isOpenCreate = ""),
                              setState(() => hoverCheckCreate = false),
                            },
                            child: AnimatedContainer(
                              width: hoverOnCreate as double,
                              height: 50,
                              curve: Curves.easeOut,
                              duration: Duration(milliseconds: 250),
                              child: ElevatedButton(
                                onPressed: () => _buttonPressed("test"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 230, 160, 149),
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)
                                  )
                                ),
                                child: Center(
                                    child:
                                        Row(
                                          children: [
                                            Spacer(),
                                            Icon(Icons.edit, size: 20,),
                                            Text(isOpenCreate, style: TextStyle(fontWeight: FontWeight.bold),),
                                            Spacer(),
                                          ]
                                        )
                                ),
                              )
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.all(5),
                          ),
                          MouseRegion(
                            onEnter: (_) => {
                              setState(() => hoverOnHost = 90),
                              setState(() => hoverCheckHost = true),
                              for (int i = 1; i <= "Play".length; i++) {
                                delayHost = (150 - (i * 50)).clamp(40, 150) as double,
                                Future.delayed(Duration(milliseconds: delayHost * i as int), () {
                                  if (hoverCheckHost == true) {
                                    setState(() {
                                      isOpenHost = "Play".substring(0, i);
                                      setState(() => hoverOnCreate = 50);
                                      setState(() => isOpenCreate = "");
                                      setState(() => hoverOnJoin = 50);
                                      setState(() => isOpenJoin = "");
                                    });
                                  }
                                })
                              },
                            },
                            onExit: (_) => {
                              setState(() => hoverOnHost = 50),
                              setState(() => isOpenHost = ""),
                              setState(() => hoverCheckHost = false),
                            },
                            child: AnimatedContainer(
                                width: hoverOnHost as double,
                                height: 50,
                                curve: Curves.easeOut,
                                duration: Duration(milliseconds: 250),
                                child: ElevatedButton(
                                  onPressed: () => _buttonPressed("test"),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(255, 230, 160, 149),
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50)
                                      )
                                  ),
                                  child: Center(
                                      child:
                                      Row(
                                          children: [
                                            Spacer(),
                                            Icon(Icons.cast, size: 20,),
                                            Text(isOpenHost, style: TextStyle(fontWeight: FontWeight.bold),),
                                            Spacer(),
                                          ]
                                      )
                                  ),
                                )
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.all(5),
                          ),
                          MouseRegion(
                            onEnter: (_) => {
                              setState(() => hoverOnJoin = 90),
                              setState(() => hoverCheckJoin = true),
                              for (int i = 1; i <= "Join".length; i++) {
                                delayJoin = (150 - (i * 50)).clamp(40, 150) as double,
                                Future.delayed(Duration(milliseconds: delayJoin * i as int), () {
                                  if (hoverCheckJoin == true) {
                                    setState(() {
                                      isOpenJoin = "Join".substring(0, i);
                                      setState(() => hoverOnCreate = 50);
                                      setState(() => isOpenCreate = "");
                                      setState(() => hoverOnHost = 50);
                                      setState(() => isOpenHost = "");
                                    });
                                  }
                                })
                              },
                            },
                            onExit: (_) => {
                              setState(() => hoverOnJoin = 50),
                              setState(() => isOpenJoin = ""),
                              setState(() => hoverCheckJoin = false),
                            },
                            child: AnimatedContainer(
                                width: hoverOnJoin as double,
                                height: 50,
                                curve: Curves.easeOut,
                                duration: Duration(milliseconds: 250),
                                child: ElevatedButton(
                                  onPressed: () => _buttonPressed("test"),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(255, 230, 160, 149),
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50)
                                      )
                                  ),
                                  child: Center(
                                      child:
                                      Row(
                                          children: [
                                            Spacer(),
                                            Icon(Icons.spoke, size: 20,),
                                            Text(isOpenJoin, style: TextStyle(fontWeight: FontWeight.bold),),
                                            Spacer(),
                                          ]
                                      )
                                  ),
                                )
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 100,
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => _buttonPressed("test"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 230, 160, 149),
                            padding: EdgeInsets.all(20),
                            shape: CircleBorder()
                        ),
                        child: Icon(Icons.perm_identity_rounded, size: 20,),
                      ),
                    ),
                    Padding(
                        padding:  EdgeInsets.all(5.0),
                    ),
                  ],
                            )
                          ,
                ),
              Padding(
                padding:  EdgeInsets.all(5.0),
              ),
            ],
          )]
      ),
    );
  }
}
