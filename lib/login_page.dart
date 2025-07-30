import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register_page.dart';

// import 'home_page.dart';
import 'drawer_test.dart';

const adminEmails = ['terkapacman@admin.com', 'terkapacman@gmail.com'];
const adminUsername = ['Akbar', 'Achmar', 'Admin'];

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final emailController = TextEditingController();
  final emailOrUsernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String username = "";

  // Future<void> login() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   setState(() => loading = true);
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passwordController.text,
  //     );
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => mainScreen()),
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.message ?? 'Login failed')),
  //     );
  //   } finally {
  //     setState(() => loading = false);
  //   }
  // }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      String email;
      final input = emailOrUsernameController.text.trim();

      if (input.contains('@')) {
        // Input dianggap email langsung
        email = input;
      } else {
        // Input dianggap username → cari email-nya
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: input)
            .limit(1)
            .get();

        if (snapshot.docs.isEmpty) {
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'Username not found',
          );
        }

        final userData = snapshot.docs.first.data();
        email = userData['email'];
        username = userData['username'];
      }

      // Login pakai email dan password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: passwordController.text,
      );

      bool isAdmin =
          (adminEmails.contains(email) || adminUsername.contains(input));

      Navigator.pushReplacement(
        context,
        // MaterialPageRoute(builder: (_) => mainScreen()),
        MaterialPageRoute(
            builder: (_) => mainScreen(username: username, isAdmin: isAdmin)),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> login_guest() async {
    Navigator.pushReplacement(
      context,
      // MaterialPageRoute(builder: (_) => mainScreen()),
      MaterialPageRoute(builder: (_) => secondScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          children: const [
            Text(
              "TERKAPACMAN",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Monitoring Terrarium Katak Pacman",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              "lib/Assets/1x/Background.png",
              fit: BoxFit.cover,
            ),
          ),

          // Main content with scroll
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo
                Center(
                  child: Image.asset(
                    'lib/Assets/1x/Logo.png',
                    height: 150,
                    width: 150,
                  ),
                ),

                const SizedBox(height: 20),

                // Form area (scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // TextFormField(
                            //   controller: emailOrUsernameController,
                            //   decoration: const InputDecoration(
                            //     labelText: "Email or Username",
                            //     border: OutlineInputBorder(),
                            //   ),
                            //   validator: (val) => val != null && val.length >= 3
                            //       ? null
                            //       : "Invalid input",
                            // ),
                            Container(
                              height: 50,
                              width: 300,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: TextFormField(
                                controller: emailOrUsernameController,
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                validator: (val) =>
                                    val != null && val.length >= 3
                                        ? null
                                        : "Invalid input",
                              ),
                            ),
                            const SizedBox(height: 16),
                            // TextFormField(
                            //   controller: passwordController,
                            //   obscureText: true,
                            //   decoration: const InputDecoration(
                            //     labelText: "Password",
                            //     border: OutlineInputBorder(),
                            //   ),
                            //   validator: (val) => val != null && val.length >= 6
                            //       ? null
                            //       : "Min 6 chars",
                            // ),
                            Container(
                              height: 50,
                              width: 300,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: "Password",
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                validator: (val) =>
                                    val != null && val.length >= 6
                                        ? null
                                        : "Min 6 chars",
                              ),
                            ),
                            const SizedBox(height: 24),
                            loading
                                ? const CircularProgressIndicator()
                                : Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: login,
                                          child: const Text("Login"),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: login_guest,
                                          child: const Text("Login As Guest"),
                                        ),
                                      ),
                                    ],
                                  ),

                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const RegisterPage()),
                                );
                              },
                              child: const Text(
                                  "Don't Have Account Yet? Register"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
