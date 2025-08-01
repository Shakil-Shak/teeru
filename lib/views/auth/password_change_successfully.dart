// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trreu/views/auth/create_new_password_page.dart';
import 'package:trreu/views/colors.dart';
import 'package:trreu/views/res/commonWidgets.dart';

class PasswordChangedSuccessfullyScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();

  PasswordChangedSuccessfullyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 20),
              Column(
                children: [
                  Icon(
                    Icons.check_box_rounded,
                    size: 140,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.6,
                    child: commonText(
                      "Congratulation! You have been successfully authenticate."
                          .tr,
                      isBold: true,
                      size: 14,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 30),
                  commonButton(
                    "Continue".tr,
                    textSize: 16,
                    onTap: () {
                      Get.to(CreateNewPasswordScreen());
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Image.asset("assets/images/full_logo.png"),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
