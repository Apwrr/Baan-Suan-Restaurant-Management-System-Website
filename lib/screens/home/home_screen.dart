import 'package:animation_2/constants.dart';
import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/models/Menu.dart';
import 'package:animation_2/screens/deatils/Details_Menu.dart';
import 'package:animation_2/screens/home/components/orders.dart';
import 'package:flutter/material.dart';
import 'components/footer.dart';
import 'components/header.dart';
import 'components/menu_card.dart';
import 'package:animation_2/api_service.dart';

class HomeScreen extends StatefulWidget {
  final int? table;
  final HomeController controller;
  final int? orderId;

  HomeScreen({this.table, required this.controller, this.orderId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Menu>> futureMenus;
  late Future<Order> fetchOrders;
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    futureMenus = ApiService().fetchMenus();
    //fetchOrders = ApiService().fetchOrders(widget.table);
    widget.controller.fetchOrders(widget.table!);


  }

  void _onCategorySelected(int category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  List<Menu> _getFilteredMenu(List<Menu> menus) {
    if (_selectedCategory == 0) {
      return menus;
    }
    print('_selectedCategory');
    print(_selectedCategory);
    print(menus.where((menu) => menu.menuCategoryId == _selectedCategory).toList());
    return menus.where((menu) => menu.menuCategoryId == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    print('Current orderId: ${widget.controller.orderItems.id}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Container(
          color: Color(0xFFEAEAEA),
          child: AnimatedBuilder(
            animation: widget.controller,
            builder: (context, _) {
              return LayoutBuilder(
                builder: (context, BoxConstraints constraints) {
                  return Stack(
                    children: [
                      // ส่วนของ FutureBuilder ที่ดึงข้อมูลเมนู
                      FutureBuilder<List<Menu>>(
                        future: futureMenus,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            List<Menu> fetchedMenus = snapshot.data ?? [];
                            List<Menu> filteredMenus = _getFilteredMenu(fetchedMenus);
                            return AnimatedPositioned(
                              duration: panelTransition,
                              top: widget.controller.homeState == HomeState.normal
                                  ? headerHeight
                                  : -(constraints.maxHeight - cartBarHeight * 2 - headerHeight),
                              left: 0,
                              right: 0,
                              height: constraints.maxHeight - headerHeight - cartBarHeight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(defaultPadding * 1.5),
                                    bottomRight: Radius.circular(defaultPadding * 1.5),
                                  ),
                                ),
                                child: GridView.builder(
                                  itemCount: filteredMenus.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                    mainAxisSpacing: defaultPadding,
                                    crossAxisSpacing: defaultPadding,
                                  ),
                                  itemBuilder: (context, index) => MenuCard(
                                    menu: filteredMenus[index],
                                    press: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration: const Duration(milliseconds: 500),
                                          reverseTransitionDuration: const Duration(milliseconds: 500),
                                          pageBuilder: (context, animation, secondaryAnimation) =>
                                              FadeTransition(
                                                opacity: animation,
                                                child: Details_Menu(
                                                  menu: filteredMenus[index],
                                                  onProductAdd: (int quantity, String remark) {
                                                    widget.controller.addProductToCart(
                                                        filteredMenus[index], quantity, remark);
                                                  },
                                                ),
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      // การ์ด Panel
                      AnimatedPositioned(
                        duration: panelTransition,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: widget.controller.homeState == HomeState.normal
                            ? cartBarHeight
                            : (constraints.maxHeight - cartBarHeight),
                        child: Container(
                          padding: const EdgeInsets.all(defaultPadding),
                          color: Color(0xFFEAEAEA),
                          alignment: Alignment.topLeft,
                          child: AnimatedSwitcher(
                            duration: panelTransition,
                            child: widget.controller.homeState == HomeState.normal
                                ? Footer(controller: widget.controller, table: widget.table)
                                : Footer(controller: widget.controller, table: widget.table),
                          ),
                        ),
                      ),
                      // Header
                      AnimatedPositioned(
                        duration: panelTransition,
                        top: widget.controller.homeState == HomeState.normal ? 0 : -headerHeight,
                        right: 0,
                        left: 0,
                        height: headerHeight,
                        child: HomeHeader(onCategorySelected: _onCategorySelected, table: widget.table),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
