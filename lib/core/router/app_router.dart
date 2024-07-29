import 'package:flutter/material.dart';
import 'package:payflex/features/home/views/beneficiary_detail_page.dart';
import 'package:payflex/features/home/views/home_page.dart';
import 'package:payflex/features/user/views/login_page.dart';
import 'route_constants.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case RouteConstants.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case RouteConstants.beneDetail:
        final phoneNumber = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => BeneficiaryDetailPage(phoneNumber: phoneNumber ?? ''),
        );
      default:
        return null;
    }
  }
}
