import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toko_jaket_1123150107/core/constants/app_strings.dart';
import 'package:toko_jaket_1123150107/core/routes/app_router.dart';
import 'package:toko_jaket_1123150107/core/services/global_institute_pay_service.dart';
import 'package:toko_jaket_1123150107/core/theme/app_theme.dart';
import 'package:toko_jaket_1123150107/features/auth/presentation/providers/auth_provider.dart';
import 'package:toko_jaket_1123150107/features/cart/presentation/providers/cart_provider.dart';
import 'package:toko_jaket_1123150107/features/dashboard/presentation/providers/product_provider.dart';
import 'package:toko_jaket_1123150107/features/order/presentation/providers/order_provider.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GlobalInstitutePayService().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:                      AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme:                      AppTheme.light,
      initialRoute:               AppRouter.splash,
      routes:                     AppRouter.routes,
    );
  }
}