import 'package:flutter/material.dart';
import 'editor.dart';

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
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final double baseHoverWidth = WidgetsBinding.instance.window.physicalSize.height * 0.060;
  final double expandedHoverWidth = WidgetsBinding.instance.window.physicalSize.height * 0.105;
  String _enteredText = '';
  String hoveredButton = "";
  String activeText = "";

  double _calculateDelay(int index) => (150 - (index * 50)).clamp(40, 150).toDouble();

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
        backgroundColor: Color.fromARGB(255, 230, 160, 149),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox( width: 35,),
          Icon(icon, size: MediaQuery.of(context).size.width * 0.04, color: Color.fromARGB(200, 130, 100, 110),),
          Text(text, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.022, fontWeight: FontWeight.bold, color: Color.fromARGB(200, 130, 100, 110),),),
          Spacer(),
        ],
      ),
    ));
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
            backgroundColor: Color.fromARGB(255, 230, 160, 149),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20),
              if (isHovered)
                Text(
                  activeText,
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                      color: Color.fromARGB(10, 0, 0, 0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 5),
                        _buildHoverButton("Edit", Icons.edit, () => _buttonPressed("Edit")),
                        SizedBox(width: 5),
                        _buildHoverButton("Play", Icons.cast, () => _buttonPressed("Play")),
                        SizedBox(width: 5),
                        _buildHoverButton("Join", Icons.spoke, () => _buttonPressed("Join")),
                        Spacer(),
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
                // image: DecorationImage(image: AssetImage('assets/main.jpg'), fit: BoxFit.cover,),
                  color: Color.fromARGB(10, 0, 0, 0),
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
                          Text('Random', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontWeight: FontWeight.bold, color: Color.fromARGB(200, 130, 100, 110),), textAlign: TextAlign.start),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child:
                        Text('Text', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontWeight: FontWeight.bold, color: Color.fromARGB(200, 130, 100, 110),), textAlign: TextAlign.start),
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
                      _buildMenuButton(' Start Playing', Icons.cast, () => _buttonPressed('abc')),
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
  void _textInput(String value) {
    setState(() {
      _enteredText = value;
    });
    print("Entered text: $_enteredText");
  }

  void _buttonPressed(String value) {
    print("Button pressed: $value");
  }
}
