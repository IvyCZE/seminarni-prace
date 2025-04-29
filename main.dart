import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'editor.dart';
import 'play.dart';
import 'login.dart';

// Assuming Editor, PlayGame, LoginScreen are defined in these files

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seminární Práce',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print(">>> AuthWrapper rebuild. HasData: ${snapshot.hasData}, State: ${snapshot.connectionState}, User: ${snapshot.data?.uid}"); // Existing print is good
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          print(">>> AuthWrapper: User logged IN. Building AZkviztest with isGuest: false");
          return const AZkviztest(title: 'Seminární Práce Pg1', isGuest: false);
        } else {
          print(">>> AuthWrapper: User logged OUT. Building LoginScreen.");
          return const LoginScreen();
        }
      },
    );
  }
}


class AZkviztest extends StatefulWidget {
  const AZkviztest({
    super.key,
    required this.title,
    this.isGuest = false,
  });

  final String title;
  final bool isGuest;

  @override
  State<AZkviztest> createState() => _AZkviztestState();
}

class _AZkviztestState extends State<AZkviztest> {
  String hoveredButton = "";
  String activeText = "";
  String uiColor = "cicada";

  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  late double baseHoverWidth = WidgetsBinding.instance.window.physicalSize.height * 0.060;
  late double expandedHoverWidth = WidgetsBinding.instance.window.physicalSize.height * 0.105;

  static final aTextColorA = Color.fromARGB(225, 250, 213, 165);
  static final aBgColorA = Color.fromARGB(255, 54, 25, 46);
  static final aBgColorB = Color.fromARGB(100, 0, 0, 0);
  static final aBgColorC = Color.fromARGB(255, 30, 8, 40);
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

  @override
  void initState() {
    super.initState();
    // It's safer to calculate dimensions dependent on window/mediaquery later, e.g., in build
    // Or use didChangeDependencies if needed before first build but after initState
  }

  double _calculateDelay(int index) => (150 - (index * 50)).clamp(40, 150).toDouble();

  Future<void> _animateText(String text) async {
    for (int i = 1; i <= text.length; i++) {
      if (hoveredButton != text) return;
      if (!mounted) return;
      setState(() {
        activeText = text.substring(0, i);
      });
      await Future.delayed(Duration(milliseconds: _calculateDelay(i).toInt()));
    }
  }

  void _onEnter(String buttonText) {
    if (!mounted) return;
    setState(() {
      hoveredButton = buttonText;
      activeText = "";
    });
    _animateText(buttonText);
  }

  void _onExit() {
    if (!mounted) return;
    setState(() {
      hoveredButton = "";
      activeText = "";
    });
  }

  Widget _buildMenuButton(String text, IconData icon, double big, VoidCallback onPressed) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.25 * big,
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
              Icon(icon, size: MediaQuery.of(context).size.width * 0.04 * big, color: TextColorA[uiColor[0].toLowerCase()] ?? Colors.grey),
              Text(text, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.022 * big, fontWeight: FontWeight.bold, color: TextColorA[uiColor[0].toLowerCase()] ?? Colors.grey),),
              Spacer(),
            ],
          ),
        )
    );
  }

  Widget _buildHoverButton(String text, IconData icon, VoidCallback onPressed) {
    final bool isHovered = hoveredButton == text;
    final double currentBaseHoverWidth = MediaQuery.of(context).size.height * 0.060;
    final double adjustedTextWidth = (text.length > 4) ? (text.length - 4) * 8.0 : 0; // Simple adjustment
    final double currentExpandedHoverWidth = MediaQuery.of(context).size.height * 0.105 + adjustedTextWidth;


    return MouseRegion(
      onEnter: (_) => _onEnter(text),
      onExit: (_) => _onExit(),
      child: AnimatedContainer(
        width: isHovered ? currentExpandedHoverWidth : currentBaseHoverWidth,
        height: currentBaseHoverWidth,
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
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    activeText,
                    style: TextStyle(fontWeight: FontWeight.bold, color: TextColorA[uiColor[0].toLowerCase()] ?? Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    baseHoverWidth = MediaQuery.of(context).size.height * 0.060;
    expandedHoverWidth = MediaQuery.of(context).size.height * 0.105;

    return Scaffold(
      body: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 800;
            return isMobile ? buildMW(context) : buildPC(context);
          }
      ),
    );
  }

  Widget _menuText(String menuText) {
    double fontSize = MediaQuery.of(context).size.width * 0.1;
    if (fontSize > 70) fontSize = 70;
    if (fontSize < 30) fontSize = 30;
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      width: isMobile ? null : MediaQuery.of(context).size.width * 0.5, // Allow full width in mobile Column
      child: Text(
          menuText,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: TextColorA[uiColor[0].toLowerCase()] ?? Colors.grey),
          textAlign: isMobile ? TextAlign.center : TextAlign.start
      ),
    );
  }


  Widget buildPC(BuildContext context) {
    print(">>> AZkviztest build: widget.isGuest = ${widget.isGuest}");
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
                          print(">>> AZkviztest navigating to Editor: Using isGuest = ${widget.isGuest}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Editor(isGuest: widget.isGuest)),
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
                        // --- MODIFIED: Conditional Log off / Exit button ---
                        if (!widget.isGuest) ...[
                          _buildHoverButton("Log off", Icons.logout, () async {
                            await FirebaseAuth.instance.signOut();
                            // AuthWrapper will automatically navigate to LoginScreen
                          }),
                        ] else ...[
                          _buildHoverButton("Exit", Icons.exit_to_app, () {
                            // Navigate back to LoginScreen when guest exits
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          }),
                        ],
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            Expanded( // Ensure main content area can expand
              child: Container(
                padding: EdgeInsets.all(50),
                width: double.infinity,
                // height: MediaQuery.of(context).size.height - 100, // Remove fixed height, use Expanded
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
                      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Spacer(), // Use MainAxisAlignment.center instead
                        _menuText("Seminární"),
                        _menuText("práce"),
                        // Spacer()
                      ],
                    ),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                      children: [
                        // Spacer(), // Use MainAxisAlignment.center instead
                        _buildMenuButton(' Create', Icons.edit, 1, () {
                          print(">>> AZkviztest navigating to Editor (Menu): Using isGuest = ${widget.isGuest}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Editor(isGuest: widget.isGuest)),
                          );
                        },),
                        SizedBox(height: 10,),
                        _buildMenuButton(' Start Playing', Icons.cast, 1, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PlayGame()),
                          );
                        },),
                        SizedBox(height: 10,),
                        _buildMenuButton(' Join Game', Icons.spoke, 1, () => _buttonPressed('Join')),
                        // Login/Signup button removed (handled by AuthWrapper/LoginScreen)
                        // Spacer(),
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMW(BuildContext context) {
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Editor()));
                              }),
                              SizedBox(width: 5),
                              _buildHoverButton("Play", Icons.cast, () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PlayGame()));
                              }),
                              SizedBox(width: 5),
                              _buildHoverButton("Join", Icons.spoke, () => _buttonPressed("Join")),
                              Spacer(),
                              _buildHoverButton("Color", Icons.style, () => _uiColorChange()),
                              SizedBox(width: 5),
                              // --- MODIFIED: Conditional Sign Out / Exit button ---
                              if (!widget.isGuest) ...[
                                _buildHoverButton("Sign Out", Icons.logout, () async {
                                  await FirebaseAuth.instance.signOut();
                                  // AuthWrapper will automatically navigate to LoginScreen
                                }),
                              ] else ...[
                                _buildHoverButton("Exit", Icons.exit_to_app, () {
                                  // Navigate back to LoginScreen when guest exits
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  );
                                }),
                              ],
                              SizedBox(width: 5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 15)),
                  Expanded( // Use Expanded for main content area
                      child: Container(
                          padding: EdgeInsets.all(20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: BgColorB[uiColor[0].toLowerCase()] ?? Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _menuText("Seminární"),
                                _menuText("práce"),
                                SizedBox(height: 30),
                                _buildMenuButton(' Create', Icons.edit, 2, () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Editor()));
                                }),
                                SizedBox(height: 10,),
                                _buildMenuButton(' Start Playing', Icons.cast, 2, () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PlayGame()));
                                }),
                                SizedBox(height: 10,),
                                _buildMenuButton(' Join Game', Icons.spoke, 2, () => _buttonPressed('Join')),
                                // Login/Signup button removed
                              ],
                            ),
                          )
                      )
                  )
                ]
            )
        )
    );
  }

  void _uiColorChange() {
    if (!mounted) return;
    setState(() {
      if(uiColor == "cicada") {
        uiColor = "aster";
      }
      else {
        uiColor = "cicada";
      }
    });
  }

  void _buttonPressed(String value) {
    print("Button pressed: $value");
    // Implement actual logic for Join, etc.
  }
}
