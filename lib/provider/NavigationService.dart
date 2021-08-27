import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, argumentsData) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: argumentsData);
  }

  Future<dynamic> navigateToUntil(String routeName) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName, ModalRoute.withName('/'));
  }
}
