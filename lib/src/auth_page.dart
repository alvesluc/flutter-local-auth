import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_auth/src/widgets/no_biometrics_enrolled_dialog.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import 'widgets/generic_auth_error_dialog.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage> {
  final localAuth = LocalAuthentication();
  bool isAuthenticated = false;

  Future<bool> canCheckBiometrics() async {
    final isDeviceSupported = await localAuth.isDeviceSupported();
    log('isDeviceSupported: $isDeviceSupported');

    if (!isDeviceSupported) return false;

    final canCheckBiometrics = await localAuth.canCheckBiometrics;
    log('canCheckBiometrics: $canCheckBiometrics');
    return isDeviceSupported && canCheckBiometrics;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    final availableBiometrics = await localAuth.getAvailableBiometrics();
    log('availableBiometrics: $availableBiometrics');

    return availableBiometrics;
  }

  Future<void> authenticate() async {
    try {
      final didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Use cellphone password',
      );
      log('didAuthenticate: $didAuthenticate');

      return setIsAuthenticated(didAuthenticate);
    } on PlatformException catch (e) {
      setIsAuthenticated(false);

      return handleAuthenticationErrors(e);
    }
  }

  Future<void> handleAuthenticationErrors(PlatformException e) async {
    if (e.code == auth_error.passcodeNotSet ||
        e.code == auth_error.notEnrolled) {
      return showDialog(
        context: context,
        builder: (_) => const NoBiometricsEnrolledDialog(),
      );
    }

    return showDialog(
      context: context,
      builder: (_) => const GenericAuthErrorDialog(),
    );
  }

  void setIsAuthenticated(bool value) {
    if (isAuthenticated != value) {
      setState(() => isAuthenticated = value);
    }
  }

  @override
  void initState() {
    super.initState();
    canCheckBiometrics().then((canCheckBiometrics) {
      if (canCheckBiometrics) {
        getAvailableBiometrics().then((availableBiometrics) {
          if (availableBiometrics.isEmpty) return;
          authenticate();
        });
      }
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User authenticated: ${isAuthenticated ? 'Yes' : 'No'}'),
            ElevatedButton(
              onPressed: () => authenticate(),
              child: const Text('Use cellphone password'),
            ),
          ],
        ),
      ),
    );
  }
}
