import 'package:flutter/material.dart';
import 'editor.dart';
import 'play.dart';
import 'login.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

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

class AZkviztest extends StatefulWidget {
  const AZkviztest({super.key, required this.title});

  final String title;

  @override
  State<AZkviztest> createState() => _AZkviztestState();
}

class _AZkviztestState extends State<AZkviztest> {
  double _calculateDelay(int index) => (150 - (index * 50)).clamp(40, 150).toDouble();

  String _enteredText = '';
  String hoveredButton = "";
  String activeText = "";
  String uiColor = "cicada";

  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final double baseHoverWidth = WidgetsBinding.instance.window.physicalSize.height * 0.060;
  final double expandedHoverWidth = WidgetsBinding.instance.window.physicalSize.height * 0.105;

  // COLOR
  static final aTextColorA = Color.fromARGB(225, 250, 213, 165);
  static final aBgColorA = Color.fromARGB(255, 54, 25, 46);
  static final aBgColorB = Color.fromARGB(55, 0, 0, 0);
  static final aBgColorC = Color.fromARGB(255, 45, 15, 51);
  static final cTextColorA = Color.fromARGB(200, 130, 100, 110);
  static final cBgColorA = Color.fromARGB(255, 230, 160, 149);
  static final cBgColorB = Color.fromARGB(10, 0, 0, 0);
  static final cBgColorC = Color.fromARGB(0, 255, 255, 255);

  final Map<String, Color> BgColorA = {
    'c': cBgColorA,
    'a': aBgColorA,
  };
  final Map<String, Color> BgColorB = {
    'c': cBgColorB,
    'a': aBgColorB,
  };
  final Map<String, Color> BgColorC = {
    'c': cBgColorC,
    'a': aBgColorC,
  };
  final Map<String, Color> TextColorA = {
    'c': cTextColorA,
    'a': aTextColorA,
  };
  // ||

  Future<void> _animateText(String text) async {
    for (int i = 1; i <= text.length; i++) {
      if (hoveredButton != text) return; // Stop animation if hover changes
      setState(() {
        activeText = text.substring(0, i);
      });
      await Future.delayed(Duration(milliseconds: _calculateDelay(i).toInt()));
    }
  }

  void _onEnter(String buttonText) {
    setState(() {
      hoveredButton = buttonText;
      activeText = ""; // Reset text animation
    });
    _animateText(buttonText);
  }

  void _onExit() {
    setState(() {
      hoveredButton = "";
      activeText = "";
    });
  }

  Widget _buildMenuButton(String text, IconData icon, VoidCallback onPressed) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.height * 0.125,
      child:
      ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: BgColorA[uiColor[0].toLowerCase()] ?? Colors.grey,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox( width: 35,),
            Icon(icon, size: MediaQuery.of(context).size.width * 0.04, color: TextColorA[uiColor[0].toLowerCase()] ?? Colors.grey),
            Text(text, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.022, fontWeight: FontWeight.bold, color: TextColorA[uiColor[0].toLowerCase()] ?? Colors.grey),),
            Spacer(),
          ],
        ),
      )
    );
  }
  Widget _buildHoverButton(String text, IconData icon, VoidCallback onPressed) {
    final bool isHovered = hoveredButton == text;

    return MouseRegion(
      onEnter: (_) => _onEnter(text),
      onExit: (_) => _onExit(),
      child: AnimatedContainer(
        width: isHovered ? expandedHoverWidth : baseHoverWidth,
        height: baseHoverWidth,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: BgColorA[uiColor[0].toLowerCase()] ?? Colors.grey,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: TextColorA[uiColor[0].toLowerCase()] ?? Colors.grey,),
              if (isHovered)
                Text(
                  activeText,
                  style: TextStyle(fontWeight: FontWeight.bold, color: TextColorA[uiColor[0].toLowerCase()] ?? Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
          builder: (context, constraints) {
            // Define a breakpoint, e.g. 800 pixels
            bool isMobile = constraints.maxWidth < 800;
            var builds = isMobile ? buildMW(context) : buildPC(context);
            return builds;
          }
      ),
    );
  }

  Widget _menuText(String menuText) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child:
      Text(menuText, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontWeight: FontWeight.bold, color: TextColorA[uiColor[0].toLowerCase()] ?? Colors.grey), textAlign: TextAlign.start),
    );
  }

  Widget buildPC(BuildContext context) {
    return Scaffold(
      backgroundColor: BgColorC[uiColor[0].toLowerCase()] ?? Colors.grey,
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: BgColorB[uiColor[0].toLowerCase()] ?? Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 5),
                        _buildHoverButton("Edit", Icons.edit, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Editor()),
                          );
                        },),
                        SizedBox(width: 5),
                        _buildHoverButton("Play", Icons.cast, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PlayGame()),
                          );
                        },),
                        SizedBox(width: 5),
                        _buildHoverButton("Join", Icons.spoke, () => _buttonPressed("Join")),
                        Spacer(),
                        _buildHoverButton("Color", Icons.style, () => _uiColorChange()),
                        SizedBox(width: 5),
                        _buildHoverButton("User", Icons.perm_identity_rounded, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            Container(
              padding: EdgeInsets.all(50),
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: BgColorB[uiColor[0].toLowerCase()] ?? Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                  Column(
                    children: [
                      Spacer(),
                      _menuText("Seminární"),
                      _menuText("práce"),
                      Spacer()
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Spacer(),
                      _buildMenuButton(' Create', Icons.edit, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Editor()),
                        );
                      },),
                      SizedBox(height: 10,),
                      _buildMenuButton(' Start Playing', Icons.cast, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlayGame()),
                        );
                      },),
                      SizedBox(height: 10,),
                      _buildMenuButton(' Join Game', Icons.spoke, () => _buttonPressed('abc')),
                      SizedBox(height: 10,),
                      _buildMenuButton(' Login or Signup', Icons.perm_identity_rounded, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },),
                      Spacer(),
                    ],
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _uiColorChange() {
    if(uiColor == "cicada") {
      uiColor = "aster";
    }
    else {
      uiColor = "cicada";
    }
    setState((){});
  }

  void _buttonPressed(String value) {
    print("Button pressed: $value");
  }

  // ###############################################################################################################
  Widget buildMW(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: BgColorB[uiColor[0].toLowerCase()] ?? Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 5),
                        _buildHoverButton("Edit", Icons.edit, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Editor()),
                          );
                        },),
                        SizedBox(width: 5),
                        _buildHoverButton("Play", Icons.cast, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PlayGame()),
                          );
                        },),
                        SizedBox(width: 5),
                        _buildHoverButton("Join", Icons.spoke, () => _buttonPressed("Join")),
                        Spacer(),
                        _buildHoverButton("Color", Icons.style, () => _uiColorChange()),
                        SizedBox(width: 5),
                        _buildHoverButton("User", Icons.perm_identity_rounded, () => _buttonPressed("User")),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            Container(
              padding: EdgeInsets.all(50),
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: BgColorB[uiColor[0].toLowerCase()] ?? Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                  Column(
                    children: [
                      Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child:
                        Text('Random', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontWeight: FontWeight.bold, color: TextColorA[uiColor[0].toLowerCase()] ?? Colors.grey), textAlign: TextAlign.start),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child:
                        Text('Text', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontWeight: FontWeight.bold, color: TextColorA[uiColor[0].toLowerCase()] ?? Colors.grey), textAlign: TextAlign.start),
                      ),
                      Spacer()
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Spacer(),
                      _buildMenuButton(' Create', Icons.edit, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Editor()),
                        );
                      },),
                      SizedBox(height: 10,),
                      _buildMenuButton(' Start Playing', Icons.cast, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlayGame()),
                        );
                      },),
                      SizedBox(height: 10,),
                      _buildMenuButton(' Join Game', Icons.spoke, () => _buttonPressed('abc')),
                      SizedBox(height: 10,),
                      _buildMenuButton(' Login or Signup', Icons.perm_identity_rounded, () => _buttonPressed('abc')),
                      Spacer(),
                    ],
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
