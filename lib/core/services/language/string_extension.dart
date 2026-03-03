import 'package:buynuk/core/services/language/language_service.dart';

extension TranslateExtension on String {
  String get tr => Lang.tr(this);
}
