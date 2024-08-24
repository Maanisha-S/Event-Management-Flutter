import 'package:event_management/controller/auth_services.dart';
import 'package:event_management/routes/routes.dart';
import 'package:event_management/widgets/material_button_design.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
@override
  void dispose() {
  emailController.dispose();
  passwordController.dispose();
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Login Your Account...",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  // obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "Email id",
                    hintText: "Enter your Email",
                    prefixIcon: const Icon(Icons.email),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF1F1A38), width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "Password",
                    hintText: "Enter your password",
                    prefixIcon: const Icon(Icons.lock),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF1F1A38), width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                MaterialButtonDesign(text: 'Login',height: 30,width: 150,onTap: ()async{
                  debugPrint("Login button pressed");
                  try {
                    String value = await AuthService.loginWithEmail(
                        emailController.text, passwordController.text);
                    debugPrint("AuthService response: $value");
                    String normalizedResponse = value.trim().toLowerCase();

                    if (normalizedResponse == "login successfully") {
                      Navigator.of(context).pushReplacementNamed(EventBookingAppRoutes.searchEventsRoute );
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: const Text("Login Successful",  style: TextStyle(color: Colors.white),
                          ),
                            backgroundColor: Colors.green.shade400,
                          ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:  Text(
                          'Enter your correct Email and Password',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ));
                    }
                  } catch (e) {
                    debugPrint("Error during login: $e");
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "An error occurred: $e",
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red.shade400,
                    ));
                  }
                },),


                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("No account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(EventBookingAppRoutes.signupRoute);
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1F1A38),fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
