import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

Future<String> userAuthSub() async {
  List<AuthUserAttribute> attrs = await Amplify.Auth.fetchUserAttributes();
  String sub = attrs.firstWhere((element) => element.userAttributeKey == 'sub').value;
  return sub;
}
