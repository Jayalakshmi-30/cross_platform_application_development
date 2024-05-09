import 'package:crossplatform_crud_operations/assets/image_assets.dart';
import 'package:crossplatform_crud_operations/screens/home_screen.dart';
import 'package:crossplatform_crud_operations/screens/signup_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const LoginScreen());

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String _title = 'Task Manager App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          toolbarTextStyle: const TextTheme(
            titleLarge: TextStyle(
              color: Colors.white, // Set the text color to white
              fontSize: 20.0, // Adjust the font size if needed
              fontWeight: FontWeight.bold, // Adjust the font weight if needed
            ),
          ).bodyMedium,
          titleTextStyle: const TextTheme(
            titleLarge: TextStyle(
              color: Colors.white, // Set the text color to white
              fontSize: 20.0, // Adjust the font size if needed
              fontWeight: FontWeight.bold, // Adjust the font weight if needed
            ),
          ).titleLarge,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
          backgroundColor: Colors.blue,
        ),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? _nameErrorText;
  String? _passwordErrorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              ImageAssets.bitsImageIcon,
              height: 100,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
                errorText: _nameErrorText,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                errorText: _passwordErrorText,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _nameErrorText = nameController.text.isEmpty ? 'Field cannot be empty' : null;
                  _passwordErrorText = passwordController.text.isEmpty ? 'Field cannot be empty' : null;
                });
                if (_nameErrorText == null && _passwordErrorText == null) {
                  // Check if the entered credentials match
                  if (nameController.text == 'jayalakshmi@gmail.com' && passwordController.text == 'bits@123') {
                    // Navigate to the home screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  } else {
                    // Show a SnackBar with an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid credentials'),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
              ),
              child: const Text('SIGN IN', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Do not have account?'),
              const SizedBox(height: 10),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('SIGN UP', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
