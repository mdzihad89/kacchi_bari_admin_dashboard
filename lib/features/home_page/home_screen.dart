import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kacchi_bari_admin_dashboard/core/constants/asset_constants.dart';
import 'package:sidebarx/sidebarx.dart';
import '../../core/constants/color_constants.dart';
import '../auth/presentation/bloc/bloc/auth_bloc.dart';
import '../auth/presentation/bloc/event/auth_event.dart';
import '../auth/presentation/bloc/state/auth_state.dart';

class HomeScreen extends StatefulWidget {
 final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SidebarXController _controller;
  @override
  void initState() {
    super.initState();
     _controller = SidebarXController(selectedIndex: widget.navigationShell.currentIndex);
    _controller.addListener(_onItemSelected);
  }

  @override
  void dispose() {
    _controller.removeListener(_onItemSelected);
    _controller.dispose();
    super.dispose();
  }

  void _onItemSelected() {
    setState(() {
      widget.navigationShell.goBranch(_controller.selectedIndex);
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            context.go('/login');
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Row(
              children: [
                SidebarX(
                  controller: _controller,
                  theme: SidebarXTheme(
                    decoration: const BoxDecoration(
                      color: ColorConstants.cardBackgroundColor,
                    ),
                    textStyle: const TextStyle(color: Colors.grey),
                    selectedTextStyle: const TextStyle(color: Colors.white),
                    itemTextPadding: const EdgeInsets.only(left: 30),
                    selectedItemTextPadding: const EdgeInsets.only(left: 30),
                    selectedItemDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3E3E61), Color(0xFF2E2E48)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.28),
                          blurRadius: 30,
                        )
                      ],
                    ),
                    iconTheme: const IconThemeData(
                      color: Colors.grey,
                      size: 20,
                    ),
                    selectedIconTheme: const IconThemeData(
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  extendedTheme: const SidebarXTheme(
                    width: 200,
                    decoration: BoxDecoration(
                      color: ColorConstants.cardBackgroundColor,
                    ),
                    margin: EdgeInsets.only(right: 10),
                  ),
                  headerBuilder: (context, extended) {
                    return Padding(
                      padding: EdgeInsets.all(extended ? 20.0 : 5.0),
                      child: SvgPicture.asset(
                        AssetConstants.appLogo,
                        height: extended ? 60 : 30,
                      ),
                    );
                  },
                  footerBuilder: (context, extended) {
                    return _controller.extended
                        ? TextButton(
                            onPressed: () {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(SignOutRequested());
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.white),
                            ))
                        : const SizedBox();
                  },
                  items: [
                    SidebarXItem(
                      icon: Icons.dashboard,
                      label: 'Dashboard',
                      onTap: () {},
                    ),
                    SidebarXItem(
                      icon: Icons.people,
                      label: 'Employee',
                      onTap: () {},
                    ),
                    SidebarXItem(
                      icon: Icons.category,
                      label: 'Branch',
                      onTap: () {},
                    ),
                    SidebarXItem(
                      icon: Icons.category,
                      label: 'Category',
                      onTap: () {},
                    ),
                    SidebarXItem(
                      icon: Icons.food_bank,
                      label: 'Food',
                      onTap: () {},
                    ),

                    SidebarXItem(
                      icon: Icons.ac_unit,
                      label: 'Order',
                      onTap: () {},
                    ),

                    SidebarXItem(
                      icon: Icons.money,
                      label: 'Salary',
                      onTap: () {},
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child:  widget.navigationShell ,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

