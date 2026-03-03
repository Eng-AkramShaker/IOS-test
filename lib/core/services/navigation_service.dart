import 'package:flutter/material.dart';

/// Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Get current context safely
BuildContext? get currentContext => navigatorKey.currentContext;

/// --------------------------------------------
/// Push
Future<void> push(String routeName, {Object? arguments}) async {
  final state = navigatorKey.currentState;

  if (state == null) return;

  await state.pushNamed(routeName, arguments: arguments);
}

/// --------------------------------------------
/// Replace
Future<void> pushReplacement(String routeName, {Object? arguments}) async {
  final state = navigatorKey.currentState;

  if (state == null) return;

  await state.pushReplacementNamed(routeName, arguments: arguments);
}

/// --------------------------------------------
/// Clear stack and navigate
Future<void> pushRemoveUntil(String routeName, {Object? arguments}) async {
  final state = navigatorKey.currentState;

  if (state == null) return;

  await state.pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments);
}

/// --------------------------------------------
/// Pop
void pop([Object? result]) {
  final state = navigatorKey.currentState;

  if (state == null) return;

  if (state.canPop()) {
    state.pop(result);
  }
}

/// --------------------------------------------
/// Pop until specific route
void popUntil(String routeName) {
  final state = navigatorKey.currentState;

  if (state == null) return;

  state.popUntil(ModalRoute.withName(routeName));
}
