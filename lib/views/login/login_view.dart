import 'package:cyfeer_apartment_handover/util/app_constants.dart';
import 'package:cyfeer_apartment_handover/util/constants.dart';
import 'package:cyfeer_apartment_handover/util/responsive.dart';
import 'package:cyfeer_apartment_handover/util/router.dart';
import 'package:cyfeer_apartment_handover/view_models/login_viewmodel.dart';
import 'package:cyfeer_apartment_handover/view_models/models/login_state.dart';
import 'package:cyfeer_apartment_handover/components/textfield_login.dart';
import 'package:cyfeer_apartment_handover/views/handover_apartment/handover_apartment_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState?>(loginViewModelProvider, (previous, next) {
      if (next?.user != null) {
        AppRouter.pushPage(context, HandoverApartmentView());
      } else if (next?.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next!.error!)),
        );
      }
    });

    // Determine responsive values
    final isTabletOrLarger = !Responsive.isMobile(context);
    final logoHeight = Responsive.responsiveValue<double>(
      context,
      mobile: 100,
      tablet: 120,
      desktop: 140,
    );
    final verticalGap = Responsive.responsiveValue<double>(
      context,
      mobile: kDefaultPadding * 3,
      tablet: kDefaultPadding * 4,
      desktop: kDefaultPadding * 5,
    );
    final horizontalPadding = Responsive.responsiveValue<double>(
      context,
      mobile: kDefaultPadding,
      tablet: kDefaultPadding * 6,
      desktop: kDefaultPadding * 10,
    );
    final buttonWidth = Responsive.responsiveValue<double?>(
      context,
      mobile: null,
      tablet: Responsive.screenWidth(context) * 0.4,
      desktop: Responsive.screenWidth(context) * 0.3,
    );
    final buttonHeight = Responsive.responsiveValue<double>(
      context,
      mobile: 48,
      tablet: 52,
      desktop: 56,
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTabletOrLarger ? 600 : double.infinity,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: kDefaultPadding),
                          child: Image.asset(
                            'assets/images/logo_cyhome.png',
                            height: logoHeight,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Gap(verticalGap),
                        TextFieldLogin(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icon(Icons.phone),
                          hintText: AppConstants.hintEnterPhoneNumber,
                          textStyle: TextStyle(
                            fontSize: Responsive.responsiveFontSize(
                              context,
                              16,
                              minSize: 14,
                              maxSize: 18,
                            ),
                          ),
                        ),
                        TextFieldLogin(
                          controller: _passwordController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                          prefixIcon: Icon(Icons.lock),
                          hintText: AppConstants.hintEnterPassword,
                          textStyle: TextStyle(
                            fontSize: Responsive.responsiveFontSize(
                              context,
                              16,
                              minSize: 14,
                              maxSize: 18,
                            ),
                          ),
                        ),
                        Gap(kDefaultPadding),
                        SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: () => _attemptLogin(),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: Responsive.responsiveFontSize(
                                  context,
                                  16,
                                  minSize: 14,
                                  maxSize: 18,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Text(AppConstants.login),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _attemptLogin() {
    if (_formKey.currentState!.validate()) {
      ref.read(loginViewModelProvider.notifier).attemptLogin(
            _phoneNumberController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }
}
