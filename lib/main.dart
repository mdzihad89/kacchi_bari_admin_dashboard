import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kacchi_bari_admin_dashboard/features/auth/domain/repository/auth_repository.dart';
import 'package:kacchi_bari_admin_dashboard/features/branch/presentation/bloc/branch_bloc.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/domain/repository/category_repository.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/presentation/bloc/category_bloc.dart';
import 'package:kacchi_bari_admin_dashboard/features/employee/domain/repository/emplyee_repository.dart';
import 'package:kacchi_bari_admin_dashboard/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:kacchi_bari_admin_dashboard/service_locator.dart';
import 'core/app/app_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'core/constants/color_constants.dart';
import 'features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'features/branch/domain/repository/branch_repository.dart';
import 'features/prodduct/domain/repository/product_repository.dart';
import 'features/prodduct/presentation/bloc/product_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  initAppModule();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context)=>AuthBloc(authRepository: instance<AuthRepository>(),),
        ),
        BlocProvider<EmployeeBloc>(
          create: (context)=>EmployeeBloc(employeeRepository:  instance<EmployeeRepository>(),),
        ),

        BlocProvider<BranchBloc>(
          create: (context)=>BranchBloc(branchRepository:  instance<BranchRepository>(),),
        ),

        BlocProvider<CategoryBloc>(
          create: (context)=>CategoryBloc(categoryRepository:  instance<CategoryRepository>(),),
        ),
        BlocProvider<ProductBloc>(
          create: (context)=>ProductBloc(productRepository:  instance<ProductRepository>(),),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter().router,
        title: 'Kacchi Bari',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: TextTheme(
            displaySmall: GoogleFonts.inter(fontSize: 11,fontWeight: FontWeight.w500, color: Colors.white),
            bodySmall: GoogleFonts.inter(fontSize: 13,fontWeight: FontWeight.w500, color: Colors.white),
            bodyMedium: GoogleFonts.inter(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
            bodyLarge: GoogleFonts.inter(fontSize: 19,  fontWeight: FontWeight.w800, color: Colors.white),
            titleMedium: GoogleFonts.inter(fontSize: 25, color: Colors.white , fontWeight: FontWeight.bold),
            titleLarge: GoogleFonts.inter(fontSize: 38, color: Colors.white , fontWeight: FontWeight.bold),
          ),

        ),
      ),
    );
  }
}

 