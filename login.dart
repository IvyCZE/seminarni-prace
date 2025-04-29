import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers; email/password TF
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  bool _isRegistering = false;
  String? _errorMessage = '';

  // --- Authentication Methods ---

  Future<void> _signInWithEmailPassword() async {
    setState(() { _errorMessage = ''; });
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      _emailController.clear();
      _passwordController.clear();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message ?? 'An unknown error occurred.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red));
    } catch (e) {
      if (!mounted) return;
      setState(() { _errorMessage = 'An unexpected error occurred.'; });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red));
    }
  }

  Future<void> _registerWithEmailPassword() async {
    setState(() { _errorMessage = ''; });
    if (_passwordController.text != _passwordConfirmController.text) {
      setState(() { _errorMessage = 'Passwords do not match.'; });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red));
      return;
    }
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      _emailController.clear();
      _passwordController.clear();
      _passwordConfirmController.clear();
      setState(() { _isRegistering = false; });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! Please log in.'), backgroundColor: Colors.green));


    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() { _errorMessage = e.message ?? 'An unknown error occurred.'; });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red));
    } catch (e) {
      if (!mounted) return;
      setState(() { _errorMessage = 'An unexpected error occurred.'; });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red));
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() { _errorMessage = ''; });
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      await _auth.signInWithPopup(googleProvider);

      // await _auth.signInWithRedirect(googleProvider);
      // final UserCredential? userCredential = await _auth.getRedirectResult();

      if (!mounted) return;

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() { _errorMessage = e.message ?? 'Google sign-in failed.'; });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red));
    } catch (e) {
      if (!mounted) return;
      setState(() { _errorMessage = 'An unexpected error occurred during Google sign-in.'; });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red));
    }
  }

  void _enterAsGuest() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AZkviztest(title: 'Seminární Práce (Guest)', isGuest: true)),
    );
  }

  // --- Widgets ---------------------------------------

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery.of(context).size.width > 800;
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(isLargeScreen ? 40 : 15),
              constraints: BoxConstraints(maxWidth: isLargeScreen ? 1000 : 600),
              decoration: BoxDecoration(
                  color: Color.fromARGB(10, 0, 0, 0),
                  borderRadius: BorderRadius.all(Radius.circular(25))
              ),
              child: isLargeScreen ? _buildLargeScreenLayout() : _buildSmallScreenLayout(),
            ),
          ),
        )
    );
  }

  Widget _buildLargeScreenLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _menuText(_isRegistering ? ' Register' : ' Log In'),
            ],
          ),
        ),
        SizedBox(width: 40), // Spacing
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLoginButton("Google", Icons.g_mobiledata, 1, _signInWithGoogle),
              SizedBox(height: 15),
              _buildLoginButton("Enter as Guest", Icons.no_accounts_outlined, 0.8, _enterAsGuest),
              SizedBox(height: 20),
              Text(
                'Or continue with:',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromARGB(150, 130, 100, 130)),
              ),
              SizedBox(height: 15),
              _buildEmailPasswordForm(),
              SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isRegistering = !_isRegistering;
                    _errorMessage = '';
                    _emailController.clear();
                    _passwordController.clear();
                    _passwordConfirmController.clear();
                  });
                },
                child: Text(
                    _isRegistering
                        ? 'Already have an account? Log In'
                        : 'Don\'t have an account? Register',
                    style: TextStyle(color: Color.fromARGB(255, 130, 100, 130))
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallScreenLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _menuText(_isRegistering ? 'Register' : 'Log In'),
        SizedBox(height: 30),
        _buildLoginButton("Google", Icons.g_mobiledata, 1, _signInWithGoogle),
        SizedBox(height: 15),
        _buildLoginButton("Enter as Guest", Icons.no_accounts_outlined, 1, _enterAsGuest),
        SizedBox(height: 20),
        Text(
          'Or continue with an Email:',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color.fromARGB(150, 130, 100, 130)),
        ),
        SizedBox(height: 15),
        _buildEmailPasswordForm(),
        SizedBox(height: 25),
        TextButton(
          onPressed: () {
            setState(() {
              _isRegistering = !_isRegistering;
              _errorMessage = '';
              _emailController.clear();
              _passwordController.clear();
              _passwordConfirmController.clear();
            });
          },
          child: Text(
              _isRegistering
                  ? 'Already have an account? Log In'
                  : 'Don\'t have an account? Register',
              style: TextStyle(color: Color.fromARGB(255, 130, 100, 130))
          ),
        )
      ],
    );
  }

  Widget _buildEmailPasswordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
            controller: _emailController,
            hintText: "Email",
            keyboardType: TextInputType.emailAddress),
        SizedBox(height: 15),
        _buildTextField(
            controller: _passwordController,
            hintText: "Password",
            obscureText: true),
        if (_isRegistering) ...[
          SizedBox(height: 15),
          _buildTextField(
              controller: _passwordConfirmController,
              hintText: "Confirm Password",
              obscureText: true),
        ],
        SizedBox(height: 25),
        _buttonAction(
          _isRegistering ? "Register" : "Log In",
          _isRegistering ? _registerWithEmailPassword : _signInWithEmailPassword,
        ),
      ],
    );
  }


  Widget _menuText(String menuText) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.08;
    if (fontSize > 70) fontSize = 70;
    if (fontSize < 30) fontSize = 30;

    return Text(
        menuText,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(200, 130, 100, 110)),
        textAlign: TextAlign.center
    );
  }

  Widget _buildLoginButton(String loginText, IconData loginIcon, double sizeFactor, VoidCallback onPressed) {
    double buttonHeight = MediaQuery.of(context).size.height * 0.1 * sizeFactor;
    double buttonWidth = MediaQuery.of(context).size.width * 0.8 * sizeFactor;
    if (buttonWidth > 400 * sizeFactor) buttonWidth = 400 * sizeFactor;

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 230, 160, 149),
          padding: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonHeight / 2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                loginIcon,
                color: Color.fromARGB(200, 130, 100, 110),
                size: buttonHeight * 0.5
            ),
            SizedBox(width: 15),
            Flexible(
              child: Text(
                loginText,
                style: TextStyle(
                    fontSize: buttonHeight * 0.3,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(200, 130, 100, 110)),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text}) {
    return Container(
      height: 55,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 230, 160, 149).withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: 1,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(color: Color.fromARGB(220, 130, 100, 110), fontSize: 16),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            hintStyle: TextStyle(color: Color.fromARGB(150, 130, 100, 130), fontSize: 16),
            hintText: hintText,
            isDense: true,
          ),
        ),
      ),
    );
  }

  Widget _buttonAction(String buttonText, Future<void> Function() onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 230, 160, 149),
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
            color: Color.fromARGB(255, 130, 100, 130),
            fontWeight: FontWeight.bold,
            fontSize: 16
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }
}
