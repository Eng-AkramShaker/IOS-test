import 'package:buynuk/presentation/help_support/domain/models/Legal_model.dart';
import 'package:buynuk/presentation/help_support/domain/models/terms_model.dart';
import 'package:buynuk/presentation/help_support/domain/repository/help_support_repo.dart';

class HelpSupportService {
  final HelpSupportRepository helpSupportRepository;

  HelpSupportService({required this.helpSupportRepository});

  // -----------------------------------------------------------------------
  ///  Privacy Policy
  // -----------------------------------------------------------------------

  Future<LegalModel> getPrivacyPolicy() async {
    return await helpSupportRepository.getPrivacyPolicy();
  }

  // -----------------------------------------------------------------------
  /// Terms
  // -----------------------------------------------------------------------

  Future<LegalModel> getAllTerms() async {
    return await helpSupportRepository.getTerms();
  }
}
