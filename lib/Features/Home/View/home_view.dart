// ignore_for_file: prefer_final_fields

import 'package:check_obsity/Features/Results/view/results_view.dart';
import 'package:check_obsity/Core/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String selectedGender = "notselected";
  TextEditingController _ageController = TextEditingController();
  TextEditingController _cmHeightController = TextEditingController();
  TextEditingController _ftHeightController = TextEditingController();
  TextEditingController _inHeightController = TextEditingController();
  TextEditingController _lbsWeightController = TextEditingController();
  TextEditingController _kgsWeightController = TextEditingController();
  List<String> heightUnits = ['cm', 'ft.in'];
  List<String> weightUnits = ['lbs', 'kgs'];
  String selectedHeightUnit = 'cm';
  String selectedWeightUnit = 'lbs';

  double calculateBMI() {
    double height;
    double weight;

    if (selectedHeightUnit == 'cm') {
      height = double.tryParse(_cmHeightController.text) ?? 0;
    } else {
      double feet = double.tryParse(_ftHeightController.text) ?? 0;
      double inches = double.tryParse(_inHeightController.text) ?? 0;
      height = (feet * 30.48) + (inches * 2.54);
    }

    if (selectedWeightUnit == 'lbs') {
      var w = (double.tryParse(_lbsWeightController.text) ?? 0 * 0.453592);
      weight = (w * 0.453592);
    } else {
      weight = double.tryParse(_kgsWeightController.text) ?? 0;
    }

    return weight / ((height / 100) * (height / 100));
  }

  void onPressedCheckHealth(
    String gender,
    String age,
    String height,
    String weight,
    String heightUnit,
    String weightUnit,
  ) {
    if (selectedGender == 'notselected') {
      showValidationError('Gender not selected');
      return;
    }
    double parsedAge = double.tryParse(age) ?? 0;
    if (parsedAge < 3 || parsedAge > 100) {
      showValidationError('Invalid Age');
      return;
    }

    double parsedHeight;
    if (selectedHeightUnit == 'cm') {
      parsedHeight = double.tryParse(_cmHeightController.text) ?? 0;
    } else {
      double feet = double.tryParse(_ftHeightController.text) ?? 0;
      double inches = double.tryParse(_inHeightController.text) ?? 0;
      if (feet < 0 || inches < 0) {
        showValidationError('Invalid Height');
        return;
      }
      parsedHeight = (feet * 30.48) + (inches * 2.54);
    }

    if (parsedHeight <= 0) {
      showValidationError('Invalid Height');
      return;
    }

    double parsedWeight;
    if (selectedWeightUnit == 'lbs') {
      parsedWeight = double.tryParse(_lbsWeightController.text) ?? 0;
    } else {
      parsedWeight = double.tryParse(_kgsWeightController.text) ?? 0;
    }

    if (parsedWeight <= 0) {
      showValidationError('Invalid Weight');
      return;
    }

    if (_ageController.text.isEmpty ||
        (_cmHeightController.text.isEmpty &&
            (_ftHeightController.text.isEmpty ||
                _inHeightController.text.isEmpty)) ||
        ((_lbsWeightController.text.isEmpty && selectedWeightUnit == 'lbs') ||
            (_kgsWeightController.text.isEmpty &&
                selectedWeightUnit == 'kgs'))) {
      showValidationError('Incomplete height or weight');
      return;
    }

    double bmi = calculateBMI();

    Get.to(
      () => Results(
        bmi: bmi,
        gender: gender,
        age: parsedAge,
        height: height,
        weight: weight,
        heightUnit: heightUnit,
        weightUnit: weightUnit,
      ),
    );
  }

  void showValidationError(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Validation Error',
          style: TextStyle(color: AppColors.blueColor),
        ),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.blackColor),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: AppColors.blueColor),
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColors.blueColor),
            ),
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60.h),
            Center(
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Check Obesity\nCheck Your Health',
                      style: TextStyle(
                        color: AppColors.normalBMIColor,
                        decoration: TextDecoration.none,
                        fontSize: ScreenUtil().setSp(40.0),
                        fontFamily: 'RubikBold',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                selectedGender == "notselected"
                    ? Image.asset(
                        'assets/images/questionmark.png',
                        width: 227.w,
                        height: 230.h,
                      )
                    : selectedGender == 'female'
                    ? _getFemaleImage()
                    : _getMaleImage(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Gender
                    Text(
                      "Gender",
                      style: TextStyle(
                        color: AppColors.normalBMIColor,
                        decoration: TextDecoration.none,
                        fontSize: ScreenUtil().setSp(24.0),
                        fontFamily: 'RubikBold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        height: 52.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedGender = 'male';
                                });
                              },
                              child: Container(
                                height: 52.h,
                                width: 75.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.r),
                                  ),
                                  color: selectedGender == 'male'
                                      ? Colors.green
                                      : Colors.white,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.male,
                                    color: selectedGender == 'male'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedGender = 'female';
                                });
                              },
                              child: Container(
                                height: 52.h,
                                width: 75.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.r),
                                  ),
                                  color: selectedGender == 'female'
                                      ? Colors.green
                                      : Colors.white,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.female,
                                    color: selectedGender == 'female'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //freeSPACE
                    SizedBox(height: 20.h),

                    //Age
                    Text(
                      "Age",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.normalBMIColor,
                        decoration: TextDecoration.none,
                        fontSize: ScreenUtil().setSp(24.0),
                        fontFamily: 'RubikBold',
                      ),
                    ),
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        height: 52.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.1.w),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10.w),
                            border: InputBorder.none,
                            hintText: "Age",
                            counterText: "",
                          ),
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        ),
                      ),
                    ),

                    //freeSPACE
                    SizedBox(height: 20.h),

                    //Height
                    Row(
                      children: [
                        Text(
                          "Height",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.normalBMIColor,
                            decoration: TextDecoration.none,
                            fontSize: ScreenUtil().setSp(24.0),
                            fontFamily: 'RubikBold',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: DropdownButton<String>(
                            value: selectedHeightUnit,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedHeightUnit = newValue!;
                              });
                            },
                            items: heightUnits.map<DropdownMenuItem<String>>((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: ScreenUtil().setSp(20.0),
                                    fontFamily: 'RubikBold',
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    selectedHeightUnit == "cm"
                        ? Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(10.r),
                            child: Container(
                              height: 52.h,
                              width: 150.w,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.1.w),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 10.w),
                                  border: InputBorder.none,
                                  hintText: "Cm",
                                  counterText: "",
                                ),
                                controller: _cmHeightController,
                                keyboardType: TextInputType.number,
                                maxLength: 5,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(10.r),
                                child: Container(
                                  height: 52.h,
                                  width: 70.w,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.1.w),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                        left: 10.w,
                                      ),
                                      border: InputBorder.none,
                                      hintText: "Ft",
                                      counterText: "",
                                    ),
                                    controller: _ftHeightController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 2,
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.enforced,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(10.r),
                                child: Container(
                                  height: 52.h,
                                  width: 70.w,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.1.w),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                        left: 10.w,
                                      ),
                                      border: InputBorder.none,
                                      hintText: "In",
                                      counterText: "",
                                    ),
                                    controller: _inHeightController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 3,
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.enforced,
                                  ),
                                ),
                              ),
                            ],
                          ),

                    //freeSPACE
                    SizedBox(height: 20.h),

                    //Weight
                    Row(
                      children: [
                        Text(
                          "Weight",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.normalBMIColor,
                            decoration: TextDecoration.none,
                            fontSize: ScreenUtil().setSp(24.0),
                            fontFamily: 'RubikBold',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: DropdownButton<String>(
                            value: selectedWeightUnit,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedWeightUnit = newValue!;
                              });
                            },
                            items: weightUnits.map<DropdownMenuItem<String>>((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: ScreenUtil().setSp(20.0),
                                    fontFamily: 'RubikBold',
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        height: 52.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.1.w),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            if (value.length > 5) {
                              // Limit the length to 5 characters
                              _lbsWeightController.text = value.substring(0, 5);
                              _kgsWeightController.text = value.substring(0, 5);
                            }
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10.w),
                            border: InputBorder.none,
                            hintText: selectedWeightUnit == "lbs"
                                ? "Lbs"
                                : "Kgs",
                            counterText: "",
                          ),
                          controller: selectedWeightUnit == "lbs"
                              ? _lbsWeightController
                              : _kgsWeightController,
                          keyboardType: TextInputType.number,
                          maxLength: 5,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // //freeSPACE
            // selectedGender == "notselected"
            //     ? SizedBox(height: 142.h)
            //     : SizedBox(height: 48.h),

            //Button
            SizedBox(height: 50.h),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: const MaterialStatePropertyAll(
                  AppColors.normalBMIColor,
                ),
                minimumSize: const MaterialStatePropertyAll(Size(250, 55)),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              onPressed: () {
                if (selectedHeightUnit == "cm" && selectedWeightUnit == "lbs") {
                  onPressedCheckHealth(
                    selectedGender,
                    _ageController.text,
                    _cmHeightController.text,
                    _lbsWeightController.text,
                    selectedHeightUnit,
                    selectedWeightUnit,
                  );
                } else if (selectedHeightUnit == "ft.in" &&
                    selectedWeightUnit == "lbs") {
                  onPressedCheckHealth(
                    selectedGender,
                    _ageController.text,
                    "${_ftHeightController.text}.${_inHeightController.text}",
                    _lbsWeightController.text,
                    selectedHeightUnit,
                    selectedWeightUnit,
                  );
                } else if (selectedHeightUnit == "cm" &&
                    selectedWeightUnit == "kgs") {
                  onPressedCheckHealth(
                    selectedGender,
                    _ageController.text,
                    _cmHeightController.text,
                    _kgsWeightController.text,
                    selectedHeightUnit,
                    selectedWeightUnit,
                  );
                } else if (selectedHeightUnit == "ft.in" &&
                    selectedWeightUnit == "kgs") {
                  onPressedCheckHealth(
                    selectedGender,
                    _ageController.text,
                    "${_ftHeightController.text}.${_inHeightController.text}",
                    _kgsWeightController.text,
                    selectedHeightUnit,
                    selectedWeightUnit,
                  );
                }
              },
              child: Text(
                "Check Health",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(26.0),
                  fontFamily: 'RubikBold',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFemaleImage() {
    int age = int.tryParse(_ageController.text) ?? 0;
    return age > 60
        ? Image.asset(
            'assets/persons/grand_mother.jpg',
            width: 227.w,
            height: 630.h,
          )
        : Image.asset('assets/persons/girl.jpg', width: 227.w, height: 630.h);
  }

  Widget _getMaleImage() {
    int age = int.tryParse(_ageController.text) ?? 0;
    return age > 60
        ? Image.asset(
            'assets/persons/grand_father.jpg',
            width: 227.w,
            height: 630.h,
          )
        : Image.asset('assets/persons/man.jpg', width: 227.w, height: 630.h);
  }
}
