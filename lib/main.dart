import 'package:duty/components/registration/OTP.dart';
import 'package:duty/components/registration/registration_area.dart';
import 'package:duty/provider/helpers.dart';
import 'package:duty/theme.dart';
import 'package:flutter/services.dart';
import 'package:duty/provider/GoogleAddressProvider.dart';
import 'package:duty/provider/SignInProvider.dart';
import 'package:duty/provider/stepper/StepperProvider_main.dart';
import 'package:duty/ui/logging_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<GoogleSignInProvider>(create: (_) => GoogleSignInProvider()),
      ChangeNotifierProvider<GoogleAddressProvider>(create: (_) => GoogleAddressProvider()),
      ChangeNotifierProvider<StepperProviderContinuity>(create: (_) => StepperProviderContinuity()),
      ChangeNotifierProvider<OTPProvider>(create: (_) => OTPProvider()),
      ChangeNotifierProvider<Helper>(create: (_) => Helper()),
    ],
    child: MaterialApp(
      initialRoute: '/',
      routes: {
        '/registrationRoute': (context) => RegistrationTextForm(),
        '/loginRoute': (context) => MyHomePage(),
        '/otpRoute': (context) => OTP(),
        '/loggingPageRoute': (context) => LandingPage(),
      },
      home: MyHomePage(),
    ),
  ));
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: mySecondaryColor,
      //body: Profile(uidWithLocation: {}),
      body: LandingPage(),

    );
  }
}
