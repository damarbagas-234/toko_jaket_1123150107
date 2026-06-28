import 'package:flutter/material.dart';
import 'package:toko_jaket_1123150107/core/guards/auth_guard.dart';
import 'package:toko_jaket_1123150107/core/services/secure_storage.dart';
import 'package:toko_jaket_1123150107/features/auth/presentation/pages/login_page.dart';
import 'package:toko_jaket_1123150107/features/auth/presentation/pages/register_page.dart';
import 'package:toko_jaket_1123150107/features/auth/presentation/pages/verify_email_page.dart';
import 'package:toko_jaket_1123150107/features/cart/presentation/pages/cart_page.dart';
import 'package:toko_jaket_1123150107/features/cart/presentation/pages/checkout_page.dart';
import 'package:toko_jaket_1123150107/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:toko_jaket_1123150107/features/order/data/models/order_model.dart';
import 'package:toko_jaket_1123150107/features/order/presentation/pages/my_orders_page.dart';
import 'package:toko_jaket_1123150107/features/order/presentation/pages/order_success_page.dart';
import 'package:toko_jaket_1123150107/features/order/presentation/pages/payment_pending_page.dart';

class AppRouter {
  static const String splash      = '/';
  static const String login       = '/login';
  static const String register    = '/register';
  static const String verifyEmail = '/verify-email';
  static const String dashboard   = '/dashboard';
  static const String cart        = '/cart';
  static const String checkout    = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String myOrders    = '/my-orders';
  static const String paymentPending = '/payment-pending';

  static Map<String, WidgetBuilder> get routes => {
    splash:       (_) => const SplashPage(),
    login:        (_) => const LoginPage(),
    register:     (_) => const RegisterPage(),
    verifyEmail:  (_) => const VerifyEmailPage(),
    dashboard:    (_) => const AuthGuard(child: DashboardPage()),
    cart:         (_) => const CartPage(),
    checkout:     (_) => const CheckoutPage(),
    myOrders:     (_) => const MyOrdersPage(),
    orderSuccess: (context) {
      final order =
          ModalRoute.of(context)!.settings.arguments as OrderModel;
      return OrderSuccessPage(order: order);
    },
    paymentPending: (context) {
      final order =
          ModalRoute.of(context)!.settings.arguments as OrderModel;
      return PaymentPendingPage(order: order);
    },
  };
}

/// Halaman splash — cek token tersimpan, redirect otomatis
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final token = await SecureStorage.getToken();
    final route = token != null ? AppRouter.dashboard : AppRouter.login;
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
}