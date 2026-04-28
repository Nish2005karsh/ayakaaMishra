import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/document/document_bloc.dart';
import 'bloc/trip/trip_bloc.dart';
import 'const/app_colors.dart';
import 'const/app_constants.dart';
import 'const/app_session.dart';
import 'data/repository/auth_repository.dart';
import 'data/repository/document_repository.dart';
import 'data/repository/trip_repository.dart';
import 'data/repository/vehicle_repository.dart';
import 'model/document_model.dart';
import 'model/trip_model.dart';
import 'provider/availability_provider.dart';
import 'provider/vehicle_provider.dart';
import 'screen/auth/login_screen.dart';
import 'screen/auth/otp_screen.dart';
import 'screen/dashboard/dashboard_screen.dart';
import 'screen/documents/document_upload_screen.dart';
import 'screen/splash/splash_screen.dart';
import 'screen/trips/trip_detail_screen.dart';
import 'screen/vehicle/vehicle_registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSession.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const AyakaaApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, _) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, _) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return OtpScreen(
          userId: extra['userId'] as int,
          mobile: extra['mobile'] as String,
        );
      },
    ),
    GoRoute(
      path: '/vehicle-registration',
      builder: (context, _) => const VehicleRegistrationScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, _) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/documents/upload',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return DocumentUploadScreen(
          docId: extra['docId'] as int,
          docName: extra['docName'] as String,
          fields: extra['fields'] as List<DocumentField>,
        );
      },
    ),
    GoRoute(
      path: '/trips/detail',
      builder: (context, state) =>
          TripDetailScreen(trip: state.extra as TripModel),
    ),
  ],
);

class AyakaaApp extends StatelessWidget {
  const AyakaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VehicleProvider(VehicleRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => AvailabilityProvider(TripRepository()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(AuthRepository()),
          ),
          BlocProvider<DocumentBloc>(
            create: (_) => DocumentBloc(DocumentRepository()),
          ),
          BlocProvider<TripBloc>(
            create: (_) => TripBloc(TripRepository()),
          ),
        ],
        child: MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
          theme: _buildTheme(),
        ),
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
