import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:grace_link/auth/presentation/screens/register_screen.dart';
import 'package:grace_link/feed/presentation/screens/home_screen.dart';

class RouteClass {
  static String home = '/';
  static String register = '/register';
  static String login = '/login';

  static getHomeScreen() => home;
  static getRegisterScreen() => register;
  static getLoginScreen() => login;

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
      page: () => const HomeScreen(),
    ),
  ];
}
