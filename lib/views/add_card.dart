import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trreu/controllers/AddCardController.dart';
import 'package:trreu/views/colors.dart';
import 'package:trreu/views/res/commonWidgets.dart';

class AddCardPage extends StatelessWidget {
  AddCardPage({super.key});

  final AddCardController controller = Get.put(AddCardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: commonAppBar("New Card".tr, color: AppColors.primaryColor),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage("assets/images/Master_Card.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              commonTextfield(
                controller.cardHolderNameController,
                hintText: "Cardholder Name".tr,
              ),
              SizedBox(height: 16),
              commonTextfield(
                controller.cardNumberController,
                hintText: "Card Number".tr,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: commonTextfield(
                      controller.expireController,
                      hintText: "MM/YY".tr,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: commonTextfield(
                      controller.cvvController,
                      hintText: "CVV".tr,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Obx(
                () =>
                    controller.isLoading.value
                        ? CircularProgressIndicator()
                        : commonButton(
                          "Add Card".tr,
                          onTap: controller.addCard,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
