import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kacchi_bari_admin_dashboard/core/constants/asset_constants.dart';
import 'package:kacchi_bari_admin_dashboard/features/auth/data/model/login_request_dto.dart';
import '../../../../core/constants/app_constant.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/util/responsive.dart';
import '../bloc/bloc/auth_bloc.dart';
import '../bloc/event/auth_event.dart';
import '../bloc/state/auth_state.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController(
    text: "mdzihad@gmail.com"
  );
  final TextEditingController passController = TextEditingController(
    text: "34413357"
  );


  bool passwordVisible = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDeskTop = Responsive.isDesktop(context);
    final isTab = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state is AuthError) {
            ElegantNotification.error(
              title:  const Text("Error",style: TextStyle(color: Colors.black),),
              description:  Text(state.message,style: const TextStyle(color: Colors.black),),
              width: 300,
              height: 100,
            ).show(context);
          } else if (state is Authenticated) {
            ElegantNotification.success(
              title:  const Text("Success",style: TextStyle(color: Colors.black),),
              width: 300,
              height: 100,
              description: const Text("Login Success",style: TextStyle(color: Colors.black),),
            ).show(context);
            context.replace('/dashboard');
          }
        },
        builder: (context, state) {
          return SizedBox(
            height: size.height,
            width: size.width,
            child: Row(
              children: [
                if (isDeskTop)
                  Expanded(
                    child: Image.network(
                      AppConstant.loginImageURl,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        final totalBytes = loadingProgress?.expectedTotalBytes;
                        final bytesLoaded =
                            loadingProgress?.cumulativeBytesLoaded;
                        if (totalBytes != null && bytesLoaded != null) {
                          return CircularProgressIndicator(
                            backgroundColor: Colors.white70,
                            value: bytesLoaded / totalBytes,
                            color: Colors.blue[900],
                            strokeWidth: 5.0,
                          );
                        } else {
                          return child;
                        }
                      },
                      frameBuilder: (BuildContext context, Widget child,
                          int? frame, bool wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }
                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOut,
                          child: child,
                        );
                      },
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Text('😢');
                      },
                    ),
                  ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: isMobile || isTab ? 10 : 20,
                      horizontal: isMobile ? 30 : 150),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AssetConstants.appLogo),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF000000).withOpacity(0.1),
                              width: 5),
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome",
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.normal),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: Text(
                                  "E mail",
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              TextFormField(
                                controller: emailController,
                                maxLines: 1,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF4F4F4F),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Email can't be empty";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFF16181B),
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: const Color(0xFF4F4F4F),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: Text(
                                  "Password",
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              TextFormField(
                                controller: passController,
                                maxLines: 1,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF4F4F4F),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Password can't be empty";
                                  }
                                  return null;
                                },
                                obscureText: passwordVisible,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(
                                        () {
                                          passwordVisible = !passwordVisible;
                                        },
                                      );
                                    },
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFF16181B),
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: GoogleFonts.inter(
                                    color: const Color(0xFF4F4F4F),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed:() {
                                      if (formKey.currentState!.validate()) {
                                        context.read<AuthBloc>().add(
                                          SignInWithEmailPassword(
                                            loginRequestDto: LoginRequestDto(
                                              email: emailController.text,
                                              password: passController.text,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ColorConstants.primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)),
                                    ),
                                    child: state is AuthLoading
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            "Login",
                                            style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}
