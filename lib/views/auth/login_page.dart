import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trreu/controllers/login_controller.dart';
import 'package:trreu/views/auth/forget_password.dart';
import 'package:trreu/views/auth/signup_page.dart';
import 'package:trreu/views/colors.dart';
import 'package:trreu/views/res/commonWidgets.dart';
import 'package:trreu/views/root_page.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  // Initialize the controller (GetX)
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Location and Language
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        commonText("Thies, SN", size: 14),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 10,
                      backgroundImage: AssetImage('assets/images/france.png'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),

                // Log In Title
                commonText("Log In", size: 18, fontWeight: FontWeight.bold),
                const SizedBox(height: 16),

                // Email / Phone TextField
                commonTextfield(
                  hintText: "Enter Email or Phone Number",
                  loginController.emailController,
                ),

                const SizedBox(height: 12),

                // Password TextField with visibility toggle
                Obx(() {
                  return commonTextfield(
                    loginController.passwordController,
                    hintText: "Password",
                    issuffixIconVisible: true,
                    isPasswordVisible: loginController.isPasswordVisible.value,
                    changePasswordVisibility:
                        loginController.togglePasswordVisibility,
                  );
                }),

                // Remember me & Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Row(
                        children: [
                          Checkbox(
                            value: loginController.rememberMe.value,
                            onChanged: (val) {
                              loginController.rememberMe.value = val ?? false;
                            },
                          ),
                          commonText("Keep me logged in", size: 14),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ForgetPasswordScreen());
                      },
                      child: commonText(
                        "Forgot password?",
                        size: 14,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Log In Button
                Obx(
                  () => commonButton(
                    loginController.isLoading.value
                        ? 'Logging in...'
                        : "Log In",
                    onTap:
                        loginController.isLoading.value
                            ? null
                            : () {
                              loginController.login();
                            },
                  ),
                ),
                const SizedBox(height: 16),

                // Sign Up / Guest
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        commonText("New to Teeru? "),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => SignUpScreen());
                          },
                          child: commonText(
                            "Let’s get started",
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => RootPage());
                      },
                      child: commonText(
                        "Continue as guest",
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
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
