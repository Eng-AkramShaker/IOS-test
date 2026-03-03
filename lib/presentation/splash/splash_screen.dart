import 'dart:async';
import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/routes/app_routes.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/core/services/navigation_service.dart';
import 'package:buynuk/core/services/prefe_service.dart';
import 'package:buynuk/presentation/auth/controllers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;

      final authProvider = context.read<AuthProvider>();

      // ✅ تحميل حالة المصادقة (توكن + زائر)
      await authProvider.loadAuthState();
      if (!mounted) return;

      // ✅ إذا مسجل دخول أو زائر → الصفحة الرئيسية
      if (authProvider.isLoggedIn || authProvider.isGuest) {
        _navigateTo(AppRoutes.mainNavigation);
        return;
      }

      // ✅ محاولة تسجيل دخول تلقائي
      final email = await PrefsService.getString('email');
      final password = await PrefsService.getString('password');

      if (email != null && password != null) {
        await authProvider.login(email: email, password: password);
        if (!mounted) return;

        _navigateTo(authProvider.isLoggedIn ? AppRoutes.mainNavigation : AppRoutes.login);
        return;
      }

      // ✅ مستخدم جديد
      final lang = await PrefsService.getString('languageCode');
      _navigateTo(lang == null ? AppRoutes.language : AppRoutes.login);
    } catch (e) {
      debugPrint('❌ Splash error: $e');
      if (!mounted) return;
      _navigateTo(AppRoutes.login);
    }
  }

  void _navigateTo(String route) {
    if (!mounted) return;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        pushReplacement(route);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo2.png",
                    width: 300,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.shopping_bag_outlined, size: 100, color: AppColors.primary);
                    },
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "appDescription".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(width: 30, height: 30, child: LoadingWidget()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
