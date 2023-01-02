import 'package:flutter/material.dart';
import 'package:pointofsales/main.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 18.0),
            child: Text(
              "Register",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color: Colors.lightBlueAccent,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 6.0,
              bottom: 12,
              left: 12,
              right: 12,
            ),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_outline),
                label: const Text("Name"),
                hintText: "User name",
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black54),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 6.0,
              bottom: 12,
              left: 12,
              right: 12,
            ),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                label: const Text("email"),
                hintText: "abc@gmail.com",
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black54),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 6.0,
              bottom: 12,
              left: 12,
              right: 12,
            ),
            child: TextField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.password_outlined),
                label: const Text("Password"),
                hintText: "**********",
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black54),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 6.0,
              bottom: 12,
              left: 12,
              right: 12,
            ),
            child: TextField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.password_outlined),
                label: const Text("Confirm password"),
                hintText: "**********",
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black54),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MyHome(
                      selectedIndex: 0,
                    ),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.lightBlueAccent,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(
                        1.0,
                        1.0,
                      ),
                      blurRadius: 2.0,
                      spreadRadius: 1.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ), //BoxShadow
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Login Here'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
