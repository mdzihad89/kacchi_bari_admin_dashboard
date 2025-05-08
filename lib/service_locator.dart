import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:kacchi_bari_admin_dashboard/core/constants/app_constant.dart';
import 'package:kacchi_bari_admin_dashboard/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kacchi_bari_admin_dashboard/features/auth/domain/repository/auth_repository.dart';
import 'package:kacchi_bari_admin_dashboard/features/branch/data/repositories/branch_repo_impl.dart';
import 'package:kacchi_bari_admin_dashboard/features/branch/domain/repository/branch_repository.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/data/repositories/category_repository_impl.dart';
import 'package:kacchi_bari_admin_dashboard/features/dashboard/data/dashboard_repository_impl.dart';
import 'package:kacchi_bari_admin_dashboard/features/dashboard/domain/dashboard_repository.dart';
import 'package:kacchi_bari_admin_dashboard/features/employee/data/repositories/employee_repository_impl.dart';
import 'package:kacchi_bari_admin_dashboard/features/employee/domain/repository/emplyee_repository.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/domain/staff_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/app/app_prefs.dart';
import 'core/network/api_service.dart';
import 'core/network/dio_factory.dart';
import 'core/network/network_info.dart';
import 'features/category/domain/repository/category_repository.dart';
import 'features/order/data/order_repo_impl.dart';
import 'features/order/domain/order_repository.dart';
import 'features/prodduct/data/repositories/protuct_repository_impl.dart';
import 'features/prodduct/domain/repository/product_repository.dart';
import 'features/salary/data/repository/staff_repo_impl.dart';


final instance = GetIt.instance;

Future<void> initAppModule() async {
  final SharedPreferencesWithCache sharedPreferencesWithCache = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String> {AppConstant.TOKEN_KEY},
      ),
  );
  instance.registerLazySingleton<SharedPreferencesWithCache>(() => sharedPreferencesWithCache);
  instance.registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));
  instance.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(InternetConnection()));
  instance.registerLazySingleton<DioFactory>(() => DioFactory());
  final dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton(() => ApiService(dio,instance(), instance()));
  instance.registerFactory<AuthRepository>(() => AuthRepositoryImpl(instance(), instance()));
  instance.registerFactory<EmployeeRepository>(() => EmployeeRepositoryImpl(instance()));
  instance.registerFactory<BranchRepository>(() => BranchRepositoryImpl(instance()));
  instance.registerFactory<CategoryRepository>(() => CategoryRepositoryImpl(instance()));
  instance.registerFactory<ProductRepository>(() => ProductRepositoryImpl(instance()));
  instance.registerFactory<DashboardRepository>(() => DashboardRepositoryImpl(instance()));
  instance.registerFactory<StaffRepository>(() => StaffRepoImpl(instance()));
  instance.registerFactory<OrderRepository>(() => OrderRepositoryImpl(instance()));
  instance.registerFactory<OrderRepositoryImpl>(() => OrderRepositoryImpl(instance()));


}