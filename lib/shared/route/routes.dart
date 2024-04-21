import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:grace_link/auth/presentation/screens/auth_screen.dart';
import 'package:grace_link/auth/presentation/screens/confirm_email_verification_screen.dart';
import 'package:grace_link/auth/presentation/screens/forget_password_screen.dart';
import 'package:grace_link/auth/presentation/screens/log_in_screen.dart';
import 'package:grace_link/auth/presentation/screens/register_screen.dart';
import 'package:grace_link/auth/presentation/screens/verify_email_screen.dart';
import 'package:grace_link/feed/presentation/screens/home_screen.dart';
import 'package:grace_link/feed/presentation/screens/main_screen.dart';

class RouteClass {
  static String home = '/';
  static String register = '/register';
  static String login = '/login';
  static String forgetPassword = '/forget-password';
  static String verifyEmail = '/verify-email';
  static String confirmEmail = '/confirm-email';
  static String authScreen = '/auth-screen';
  static String mainScreen = '/main-screen';

  static getHomeScreen() => home;
  static getRegisterScreen() => register;
  static getLoginScreen() => login;
  static getForgetPasswordScreen() => forgetPassword;
  static getVerifyEmailScreen() => verifyEmail;
  static getConfirmEmailScreen() => confirmEmail;
  static getAuthScreen() => authScreen;
  static getMainScreen() => mainScreen;

  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: register,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: login,
      page: () => const LogInScreen(),
    ),
    GetPage(
      name: login,
      page: () => const LogInScreen(),
    ),
    GetPage(
      name: forgetPassword,
      page: () => const ForgetPasswordScreen(),
    ),
    GetPage(
      name: verifyEmail,
      page: () => const VerifyEmailScreen(),
    ),
    GetPage(
      name: confirmEmail,
      page: () => const ConfirmEmailScreen(),
    ),
    GetPage(
      name: authScreen,
      page: () => const AuthScreen(),
    ),
    GetPage(
      name: mainScreen,
      page: () => const MainScreen(),
    ),
  ];
}
