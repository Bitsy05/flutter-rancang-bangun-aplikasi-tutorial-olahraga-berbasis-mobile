import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_capstone_6/component/colors.dart';
import 'package:flutter_capstone_6/component/repository.dart';
import 'package:flutter_capstone_6/model/user/user_model.dart';
import 'package:flutter_capstone_6/screen/login/login_screen.dart';
import 'package:flutter_capstone_6/screen/register/register_controller.dart';
import 'package:flutter_capstone_6/screen/register/register_verification_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  bool isHide = true;
  bool isChecked = false;

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future regis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      return await http.post(
        Uri.parse("http://192.168.1.3/manajemen_tutorial/api/register.php"),

        // Uri.parse("https://timocratical-tear.000webhostapp.com/register.php"),
        body: {
          "nama_dpn": firstNameController.text,
          "nama_blkg": lastNameController.text,
          "no": '0',
          "email": emailController.text,
          "password": passwordController.text,
        },
      ).then((value) {
        var data = jsonDecode(value.body);
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Daftar akun berhasil, silahkan login')));
        });
      });
    } on Exception {
      var kWidth = MediaQuery.of(context).size.width;
      showModalBottomSheet(
          isDismissible: false,
          context: context,
          builder: (context) {
            return Container(
              height: kWidth / 2.8,
              child: Padding(
                padding: EdgeInsets.all(kWidth / 20),
                child: Column(
                  children: [
                    Text(
                      "Server tidak menanggapi, silahkan coba lagi atau cek koneksi internet Anda.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: kWidth / 27),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: kWidth / 30),
                      child: Container(
                        width: kWidth,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Kembali",
                            style: TextStyle(
                              fontSize: kWidth / 28,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Title Section
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: const [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Create a new account',
                        style: TextStyle(
                          color: n100,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Create an account so you can mantain your healthy life.",
                        maxLines: 2,
                        style: TextStyle(
                          color: fontLightGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Login Form Section
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      width: double.infinity,
                      child: SvgPicture.asset(
                          'assets/register/register_screen.svg'),
                    ),
                    const SizedBox(height: 15),
                    firstNameFormItem(),
                    const SizedBox(height: 15),
                    lastNameFormItem(),
                    const SizedBox(height: 15),
                    emailFormItem(),
                    const SizedBox(height: 15),
                    passwordFormItem(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Agree Privacy Section
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 15),
              //   child: Row(
              //     children: [
              //       Transform.scale(
              //         scale: 1.3,
              //         child: Checkbox(
              //             value: isChecked,
              //             checkColor: white,
              //             fillColor:
              //                 MaterialStateColor.resolveWith((states) => n60),
              //             shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(6)),
              //             side: const BorderSide(
              //               width: 1,
              //               color: n60,
              //             ),
              //             onChanged: (bool? value) {
              //               setState(() {
              //                 isChecked = value!;
              //               });
              //             }),
              //       ),
              //       SizedBox(
              //         width: MediaQuery.of(context).size.width,
              //         child: RichText(
              //           text: const TextSpan(
              //               text: 'By continuing you accept our ',
              //               style: TextStyle(
              //                 height: 1.2,
              //                 fontSize: 15,
              //                 color: n60,
              //                 fontWeight: FontWeight.w400,
              //               ),
              //               children: [
              //                 TextSpan(
              //                     text: 'Privacy Policy',
              //                     style: TextStyle(
              //                         decoration: TextDecoration.underline)),
              //                 TextSpan(text: ' and '),
              //                 TextSpan(
              //                     text: 'Term of Use',
              //                     style: TextStyle(
              //                         decoration: TextDecoration.underline)),
              //               ]),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // Button Register Section
              Container(
                margin: const EdgeInsets.only(
                    left: 25, right: 25, top: 32, bottom: 4),
                child: ElevatedButton(
                  onPressed: () {
                    regis();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: violet,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: white,
                    ),
                  ),
                ),
              ),

              // Goto login
              const SizedBox(height: 32),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: n80,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text(
                        " Login",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: violet,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget firstNameFormItem() {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      // height: 50,
      child: TextFormField(
        controller: firstNameController,
        validator: (String? value) => value == '' ? "Required" : null,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[A-Za-z]")),
        ],
        decoration: const InputDecoration(
          labelText: 'first name',
          labelStyle:
              TextStyle(fontSize: 14, color: n40, fontWeight: FontWeight.w400),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          floatingLabelStyle: TextStyle(color: n100),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: n100),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }

  Widget lastNameFormItem() {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      // height: 50,
      child: TextFormField(
        controller: lastNameController,
        validator: (String? value) => value == '' ? "Required" : null,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[A-Za-z]")),
        ],
        maxLines: 1,
        decoration: const InputDecoration(
          labelText: 'last name',
          labelStyle:
              TextStyle(fontSize: 14, color: n40, fontWeight: FontWeight.w400),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          floatingLabelStyle: TextStyle(color: n100),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: n100),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }

  Widget phoneNumberFormItem() {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      // height: 50,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: phoneNumberController,
        validator: (String? value) => value == '' ? "Required" : null,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        ],
        maxLines: 1,
        decoration: const InputDecoration(
          labelText: 'phone number',
          labelStyle:
              TextStyle(fontSize: 14, color: n40, fontWeight: FontWeight.w400),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          floatingLabelStyle: TextStyle(color: n100),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: n100),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }

  Widget emailFormItem() {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      // height: 50,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Required';
          }
          if (!value.contains("@")) {
            return 'Not a valid email';
          }
        },
        maxLines: 1,
        decoration: const InputDecoration(
          labelText: 'new email address',
          labelStyle:
              TextStyle(fontSize: 14, color: n40, fontWeight: FontWeight.w400),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          floatingLabelStyle: TextStyle(color: n100),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: n100),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }

  Widget passwordFormItem() {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      // height: 50,
      child: TextFormField(
        controller: passwordController,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Required';
          }
          if (value.contains(" ")) {
            return "Password contain space";
          }
          if (value.length < 8) {
            return "min password length 8";
          }
        },
        // inputFormatters: [LengthLimitingTextInputFormatter(20)],
        maxLines: 1,
        obscureText: isHide,
        decoration: InputDecoration(
          labelText: 'new password',
          labelStyle: const TextStyle(
              fontSize: 14, color: n40, fontWeight: FontWeight.w400),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          floatingLabelStyle: const TextStyle(color: n100),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: n100),
          ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          contentPadding: const EdgeInsets.all(10),
          suffixIcon: Container(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isHide = !isHide;
                });
              },
              child: isHide
                  ? SvgPicture.asset('assets/icons/password_show.svg')
                  : SvgPicture.asset('assets/icons/password_hide.svg'),
            ),
          ),
        ),
      ),
    );
  }

  Widget anotherRegisterItem(String image, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      height: 54,
      child: ListTile(
        tileColor: white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              style: BorderStyle.solid,
              color: n5,
            )),
        leading: Image.asset(image, width: 30, height: 30),
        title: Text(
          "Register with $title",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: n80,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        onTap: () {
          if (title == 'Google') {
            print('this register by $title');
          } else if (title == 'Facebook') {
            print('this register by $title');
          } else if (title == 'Apple') {
            print('this register by $title');
          }
        },
      ),
    );
  }
}
