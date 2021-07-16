import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:undersea/core/lang/strings.dart';
import 'package:undersea/core/theme/colors.dart';
import 'package:undersea/core/theme/text_styles.dart';
import 'package:undersea/services/navbar_controller.dart';
import 'package:undersea/views/attack_page.dart';
import 'package:undersea/views/city_tabs/city_tab_bar.dart';
import 'package:undersea/views/history_tabs/history_tab_bar.dart';
import 'package:undersea/views/profile.dart';
import 'package:undersea/widgets/app_bar_title.dart';
import 'package:undersea/widgets/asset_icon.dart';
import 'package:undersea/widgets/image_icon.dart';

import 'home_page.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key}) : super(key: key);
  final BottomNavBarController controller = Get.find<BottomNavBarController>();
  static final List<Widget> _appbarTitleOptions = <Widget>[
    SizedBox(
      height: 35,
      width: 100,
      child: USImageIcon(
          assetName: "undersea_small", color: USColors.underseaLogoColor),
    ),
    AppBarTitle(text: Strings.my_city.tr),
    AppBarTitle(text: Strings.attack.tr),
    AppBarTitle(text: Strings.my_forces.tr),
  ];
  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    CityTabBar(),
    AttackPage(),
    HistoryTabBar(() {})
  ];

  void _onItemTapped(int index) {
    controller.selectedTab.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: AppBar(
          toolbarHeight: controller.selectedTab.value == 0 ? 85 : 60,
          backgroundColor: USColors.hintColor,
          actions: [
            if (controller.selectedTab.value == 0)
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: GestureDetector(
                      onTap: () {
                        Get.to(ProfilePage());
                      },
                      child: SizedBox(
                          height: 40,
                          child: AssetIcon(iconName: "profile", iconSize: 42))))
          ],
          title: _appbarTitleOptions.elementAt(controller.selectedTab.value),
        ),
        body: Center(
          child: _widgetOptions.elementAt(controller.selectedTab.value),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: USColors.gradientColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: USImageIcon(assetName: 'tab_home'),
                label: Strings.home_page.tr,
              ),
              BottomNavigationBarItem(
                icon: USImageIcon(assetName: 'tab_city'),
                label: Strings.my_city.tr,
              ),
              BottomNavigationBarItem(
                icon: USImageIcon(assetName: 'tab_attack'),
                label: Strings.attack.tr,
              ),
              BottomNavigationBarItem(
                icon: USImageIcon(assetName: 'tab_units'),
                label: Strings.my_forces.tr,
              ),
            ],
            currentIndex: controller.selectedTab.value,
            iconSize: 30,
            backgroundColor: Colors.transparent,
            selectedItemColor: USColors.navbarIconColor,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            elevation: 0,
            selectedLabelStyle: USText.bottomNavbarTextStyle,
            unselectedLabelStyle: USText.bottomNavbarTextStyle
                .copyWith(color: USColors.unselectedNavbarIconColor),
          ),
        )));
  }
}
