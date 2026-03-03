import 'package:buynuk/presentation/cart/domain/models/add_to_cart_model.dart';
import 'package:buynuk/presentation/cart/domain/models/cart_model.dart';
import 'package:buynuk/presentation/cart/domain/models/delete_art_model.dart';
import 'package:buynuk/presentation/cart/domain/repository/cart_repo.dart';

class CartService {
  final CartRepository cartRepository;

  CartService({required this.cartRepository});

  // -----------------------------------------------------------------------
  /// getCart
  // -----------------------------------------------------------------------

  Future<CartModel> getCart() async {
    return await cartRepository.getCart();
  }

  // -----------------------------------------------------------------------
  /// add
  // -----------------------------------------------------------------------

  Future<AddToCartModel> addToCart(num productId) async {
    return await cartRepository.addToCart(productId);
  }

  // -----------------------------------------------------------------------
  /// delete
  // -----------------------------------------------------------------------

  Future<DeleteCart> deleteCart(num productId) async {
    return await cartRepository.deleteCart(productId);
  }
}
