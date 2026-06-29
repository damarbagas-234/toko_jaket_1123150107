import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toko_jaket_1123150107/core/constants/app_constants.dart';
import 'package:toko_jaket_1123150107/core/services/dio_client.dart';
import 'package:toko_jaket_1123150107/features/dashboard/data/models/product_model.dart';


enum ProductStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier{
  ProductStatus       _status   = ProductStatus.initial;
  List<ProductModel>  _products = [];
  String?             _error;
  ProductStatus      get status   => _status;
  List<ProductModel> get products => _products;
  String?            get error    => _error;
  bool               get isLoading => _status == ProductStatus.loading;

  // Fetch products — token otomatis disertakan oleh DioClient interceptor
  Future<void> fetchProducts() async {
    _status = ProductStatus.loading;
    notifyListeners();

    try {
      final response = await DioClient.instance.get(AppConstants.products);

      debugPrint('[ProductProvider] response: ${response.data}');

      // Backend response: { "data": [ {...}, {...} ] }
      final rawData = response.data;
      final List<dynamic>? data = rawData is Map ? rawData['data'] as List<dynamic>? : null;

      if (data == null) {
        _error  = 'Format respons tidak dikenali';
        _status = ProductStatus.error;
      } else {
        _products = data.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
        _status   = ProductStatus.loaded;
      }
    } on DioException catch (e) {
      debugPrint('[ProductProvider] DioException: ${e.response?.statusCode} ${e.response?.data}');
      _error  = (e.response?.data is Map ? e.response?.data['message'] : null) ?? 'Gagal memuat produk (${e.response?.statusCode})';
      _status = ProductStatus.error;
    } catch (e) {
      debugPrint('[ProductProvider] Error: $e');
      _error  = 'Terjadi kesalahan: $e';
      _status = ProductStatus.error;
    }

    notifyListeners();
  }

}