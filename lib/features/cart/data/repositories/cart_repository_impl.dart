import 'package:toko_jaket_1123150107/core/constants/app_constants.dart';
import 'package:toko_jaket_1123150107/core/services/dio_client.dart';
import 'package:toko_jaket_1123150107/features/cart/data/models/cart_model.dart';
import 'package:toko_jaket_1123150107/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  @override
  Future<CartModel> getCart() async {
    final response = await DioClient.instance.get(AppConstants.cart);
    final data = response.data['data'] as Map<String, dynamic>;
    return CartModel.fromJson(data);
  }

  @override
  Future<void> addToCart(int productId, int quantity) async {
    await DioClient.instance.post(
      AppConstants.cart,
      data: {'product_id': productId, 'quantity': quantity},
    );
  }

  @override
  Future<void> updateCartItem(int cartItemId, int quantity) async {
    await DioClient.instance.put(
      '${AppConstants.cart}/$cartItemId',
      data: {'quantity': quantity},
    );
  }

  @override
  Future<void> removeCartItem(int cartItemId) async {
    await DioClient.instance.delete('${AppConstants.cart}/$cartItemId');
  }

  @override
  Future<void> clearCart() async {
    await DioClient.instance.delete(AppConstants.cart);
  }
}
