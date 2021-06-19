//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_tune/auth/login_w_google.dart';
import 'package:core_tune/auth/register.dart';
import 'package:core_tune/loading/loading.dart';
import 'package:core_tune/main.dart';
import 'package:core_tune/page/Home.dart';
import 'package:core_tune/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /*Future<DocumentSnapshot> getData() async {
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance
        .collection("users")
        .doc("docID")
        .get();
  }*/
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

//  late String username, password;
  bool loading = false;
  bool _isObscured = true;
  Color _eyeButtonColor = Colors.grey;
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade900,
                      Colors.grey.shade200,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 36.0, horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sign-In",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Text(
                              "Tune - Core",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  validator: (val) => val!.isNotEmpty
                                      ? null
                                      : "please enter email address",
                                  onChanged: (val) {
                                    setState(() => email = val);
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFe7edeb),
                                    hintText: "Enter E-Mail",
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 50.0),
                                TextFormField(
                                  validator: (val) => val!.length < 6
                                      ? "enter more than 6 character"
                                      : null,
                                  controller: _passwordController,
                                  onChanged: (val) {
                                    setState(() => password = val);
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        if (_isObscured) {
                                          setState(() {
                                            _isObscured = false;
                                            _eyeButtonColor =
                                                Theme.of(context).primaryColor;
                                          });
                                        } else {
                                          setState(() {
                                            _isObscured = true;
                                            _eyeButtonColor = Colors.grey;
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        color: _eyeButtonColor,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFe7edeb),
                                    hintText: "Enter Password",
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  obscureText: _isObscured,
                                ),
                                SizedBox(height: 50.0),
                                Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() => loading = true);
                                        /*  print(
                                            "Email : ${_emailController.text}");
                                        print(
                                            "Password: ${_passwordController.text}");
                                      }
                                        setState(() => loading = true);*/
                                        await _auth.signInWithEmailAndPassword(
                                            email, password);

                                        if (user == true) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => Home(),
                                            ),
                                          );
                                        }
                                      }
                                      /*Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Home()),
                                      );*/
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: Text(
                                        "Sign - In",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 14.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Register();
                                      }));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: Text(
                                        "Create Account",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      '-- OR --',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                Text(
                                  'Sign - In With',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                //Spacer(),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Colors.black,
                                    minimumSize: Size(double.infinity, 50),
                                  ),
                                  icon: FaIcon(
                                    FontAwesomeIcons.google,
                                    color: Colors.black,
                                  ),
                                  label: Text('Sign In With Google'),
                                  onPressed: () {
                                    setState(() => loading = true);
                                    final provider =
                                        Provider.of<SignInGoogleProvider>(
                                            context,
                                            listen: false);
                                    provider.googleLogin();
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Home();
                                    }));
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
