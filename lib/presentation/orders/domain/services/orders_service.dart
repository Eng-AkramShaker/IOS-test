import 'package:buynuk/presentation/orders/domain/models/orders_model.dart';
import 'package:buynuk/presentation/orders/domain/repository/orders_repo.dart';

class OrdersService {
  final OrdersRepository ordersRepository;

  OrdersService({required this.ordersRepository});

  // -----------------------------------------------------------------------
  /// Orders
  // -----------------------------------------------------------------------

  Future<OrdersModel> getOrders() async {
    return await ordersRepository.getOrders();
  }
}
