import 'package:awraki_poc/screens/create_document.dart';
import 'package:awraki_poc/screens/document.dart';
import 'package:awraki_poc/screens/draft.dart';
import 'package:awraki_poc/screens/login.dart';
import 'package:awraki_poc/screens/verify.dart';
import 'package:flutter/cupertino.dart';

class Routes {
  Routes._();

  static const String login = '/login';
  static const String sign = '/sign';
  static const String document = '/document';
  static const String createDocument = '/create-document';
  static const String draft = '/draft';
  static const String verify = '/verify';

  static final routes = <String, WidgetBuilder>{
    login: (_) => const LoginScreen(),
    document: (_) => const DocumentScreen(),
    createDocument: (_) => const CreateDocumentScreen(),
    draft: (_) => const DraftScreen(),
    verify: (_) => const VerifyScreen(),
  };
}
