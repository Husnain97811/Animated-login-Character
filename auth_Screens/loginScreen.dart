import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter_gradient;
import 'package:flutter/services.dart';
import 'package:flutter_application_1/components/auth_RoundButton.dart';
import 'package:rive/rive.dart';

class loginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return loginScreenState();
  }
}

class loginScreenState extends State<loginScreen>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool obscureText = false;

  var riveUrl = 'assets/rive/animated_login_character_transparent.riv';
  var breathingRiveUrl = 'assets/rive/breathing_animation.riv';

  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;
  late StateMachineController? _stateMachineController;

  // Colors for gradient animation
  List<Color> gradientColors = [
    Colors.blue.shade400,
    const Color.fromARGB(255, 158, 133, 97),
    Colors.blue.shade200,
  ];

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 5), // Adjust animation duration
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_animationController)
      ..addListener(() {
        setState(() {}); // Update the state when the animation value changes
      });

    // Start the animation
    _animationController.repeat(); // Make the animation repeat indefinitely
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Gradient Background
          AnimatedContainer(
            duration: const Duration(milliseconds: 900), // Smooth transition
            decoration: BoxDecoration(
              gradient: flutter_gradient.LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  gradientColors[
                      (_animation.value * gradientColors.length).floor()],
                  gradientColors[
                      ((_animation.value * gradientColors.length) + 1).floor() %
                          gradientColors.length],
                ],
              ),
            ),
          ),
          // Rive Breathing Animation Background
          SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(),
            height: double.infinity,
            width: double.infinity,
            child: RiveAnimation.asset(
              breathingRiveUrl,
              fit: BoxFit.cover,
              stateMachines: ['StateMachine'],
              onInit: (artBoard) {
                _stateMachineController = StateMachineController.fromArtboard(
                    artBoard, 'StateMachine');
                if (_stateMachineController == null) return;
                artBoard.addController(_stateMachineController!);
                isChecking = _stateMachineController?.findInput('isChecking');
                isHandsUp = _stateMachineController?.findInput('isHandsUp');
                trigSuccess = _stateMachineController?.findInput('trigSuccess');
                trigFail = _stateMachineController?.findInput('trigFail');
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: RiveAnimation.asset(
                        riveUrl,
                        fit: BoxFit.cover,
                        stateMachines: ['Login Machine'],hello h
                        onInit: (artBoard) {
                          _stateMachineController =
                              StateMachineController.fromArtboard(
                                  artBoard, 'Login Machine');
                          if (_stateMachineController == null) return;
                          artBoard.addController(_stateMachineController!);
                          isChecking =
                              _stateMachineController?.findInput('isChecking');
                          isHandsUp =
                              _stateMachineController?.findInput('isHandsUp');
                          trigSuccess =
                              _stateMachineController?.findInput('trigSuccess');
                          trigFail =
                              _stateMachineController?.findInput('trigFail');
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            onChanged: (value) {
                              if (isHandsUp != null) {
                                isHandsUp!.change(false);
                              }
                              if (isChecking == null) return;
                              isChecking!.change(true);
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: passwordController,
                            onChanged: (value) {
                              if (isChecking != null) {
                                isChecking!.change(false);
                              }
                              if (isHandsUp == null) return;
                              isHandsUp!.change(true);
                            },
                            obscureText: obscureText,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                icon: Icon(
                                  obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                            },
                          ),
                          SizedBox(height: 102),
                          authRoundButton(
                            title: 'Login',
                            onpress: () {
                              if (formkey.currentState!.validate()) {
                                String userName = emailController.text;
                                String password = passwordController.text;

                                print(
                                    'Logging in : $userName with password: $password ');
                                isChecking!.change(false);
                                isHandsUp!.change(false);
                                trigFail!.change(false);
                                trigSuccess!.change(true);
                              } else {
                                isChecking!.change(false);
                                isHandsUp!.change(false);
                                trigSuccess!.change(false);
                                trigFail!.change(true);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
