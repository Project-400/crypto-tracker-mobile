import 'package:amplify_flutter/amplify.dart';

Future<bool> checkIfAuthenticated() async {
  final session = await Amplify.Auth.fetchAuthSession();
//  await Future.delayed(Duration(seconds: 2));
//  return true;
  return session.isSignedIn;
}
