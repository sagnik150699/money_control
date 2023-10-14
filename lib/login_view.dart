import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_control/components.dart';
import 'package:sign_button/sign_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'view_model.dart';


class LoginView extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    final double deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: deviceHeight / 8),
            Center(
              child: SvgPicture.asset("assets/piggy2.svg", width: 210.0),
            ),
            SizedBox(height: 30.0),
            EmailAndPasswordFields(),
            SizedBox(height: 30.0),
            RegisterAndLogin(),
            SizedBox(height: 30.0),
            SignInButton(
                buttonType: ButtonType.google,
                btnColor: Colors.black,
                btnTextColor: Colors.white,
                buttonSize: ButtonSize.large,
                onPressed: () async {
                  if (kIsWeb) {
                    await viewModelProvider.signInWithGoogleWeb(context);
                  } else {
                    await viewModelProvider.signInWithGoogleMobile(context);
                  }
                })
          ],
        ),
      ),
    ));
  }
}

TextEditingController _emailField = TextEditingController();
TextEditingController _passwordField = TextEditingController();

class EmailAndPasswordFields extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          //Email
          SizedBox(
            width: 330.0,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              controller: _emailField,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  hintText: "Email",
                  hintStyle: GoogleFonts.openSans()),
            ),
          ),
          SizedBox(height: 20.0),
          //Password
          SizedBox(
            width: 330.0,
            child: TextFormField(
              textAlign: TextAlign.center,
              controller: _passwordField,
              obscureText: viewModelProvider.isObscure,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  prefixIcon: IconButton(
                    onPressed: () {
                      viewModelProvider.toggleObscure();
                    },
                    icon: Icon(
                      viewModelProvider.isObscure
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                      size: 30.0,
                    ),
                  ),
                  hintText: "Password",
                  hintStyle: GoogleFonts.openSans()),
            ),
          )
        ],
      ),
    );
  }
}

class RegisterAndLogin extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Register
          SizedBox(
            height: 50.0,
            width: 150.0,
            child: MaterialButton(
              child: OpenSans(text: "Register", size: 24.0),
              splashColor: Colors.grey,
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onPressed: () async {
                await viewModelProvider.createUserWithEmailAndPassword(
                    context, _emailField.text, _passwordField.text);
              },
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            "OR",
            style: GoogleFonts.pacifico(fontSize: 15.0),
          ),
          SizedBox(width: 10.0),
          //Login
          SizedBox(
            height: 50.0,
            width: 150.0,
            child: MaterialButton(
              child: OpenSans(text: "Login", size: 24.0),
              onPressed: () async {
                viewModelProvider.signInWithEmailAndPassword(
                    context, _emailField.text, _passwordField.text);
              },
              splashColor: Colors.grey,
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
