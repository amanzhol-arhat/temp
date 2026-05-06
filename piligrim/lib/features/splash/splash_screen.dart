import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../navigation/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(AppAnimations.kSplashTotalDuration, () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const MainScreen(),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.earth,
      body: SizedBox.expand(
        child:
            SvgPicture.asset(
                  AppAssets.splashPath,
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(
                    AppColors.sky,
                    BlendMode.srcIn,
                  ),
                )
                .animate()
                .fadeIn(
                  delay: AppAnimations.kSplashDelay,
                  duration: AppAnimations.kSplashFadeDuration,
                  curve: AppAnimations.kSplashCurve,
                )
                .scale(
                  begin: const Offset(1.4, 1.4),
                  end: const Offset(1, 1),
                  delay: AppAnimations.kSplashDelay,
                  duration:
                      AppAnimations.kSplashFadeDuration +
                      AppAnimations.kSplashSlideDuration,
                  curve: AppAnimations.kSplashCurve,
                ),
      ),
    );
  }
}
