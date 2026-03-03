import 'package:buynuk/presentation/flash_sales/domain/models/flashSales_model.dart';
import 'package:buynuk/presentation/flash_sales/domain/repository/flashSales_repo.dart';

class FlashSalesService {
  final FlashSalesRepository flashSalesRepository;

  FlashSalesService({required this.flashSalesRepository});

  // -----------------------------------------------------------------------
  /// getFlashSales
  // -----------------------------------------------------------------------

  Future<FlashSalesModel> getFlashSales() async {
    return await flashSalesRepository.getFlashSales();
  }
}
