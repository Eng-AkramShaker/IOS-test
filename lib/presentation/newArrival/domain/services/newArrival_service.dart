import 'package:buynuk/presentation/newArrival/domain/models/newArrival_model.dart';
import 'package:buynuk/presentation/newArrival/domain/repository/newArrival_repo.dart';

class NewArrivalService {
  final NewArrivalRepository newArrivalRepository;

  NewArrivalService({required this.newArrivalRepository});

  // -----------------------------------------------------------------------
  /// Banners
  // -----------------------------------------------------------------------

  Future<NewArrivalModel> geNewArrival() async {
    return await newArrivalRepository.geNewArrival();
  }
}
