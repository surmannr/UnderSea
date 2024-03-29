import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:undersea/controllers/navbar_controller.dart';
import 'package:undersea/controllers/user_data_controller.dart';
import 'package:undersea/lang/strings.dart';
import 'package:undersea/models/response/user_rank_dto.dart';
import 'package:undersea/styles/style_constants.dart';

class Leaderboard extends StatefulWidget {
  Leaderboard({Key? key}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  final BottomNavBarController navbarcontroller =
      Get.find<BottomNavBarController>();
  var controller = Get.find<UserDataController>();
  late int itemCount;
  List<UserRankDto?> results = [];

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    controller.searchText.value = '';
    controller.alreadyDownloadedPageNumber.value = 0;
    controller.pageNumber.value = 1;
    controller.rankList.clear();
    controller.getRankList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (controller.pageNumber.value >
            controller.alreadyDownloadedPageNumber.value) return;
        controller.pageNumber.value++;
        controller.getRankList();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //results = [];
    return Scaffold(
        backgroundColor: UnderseaStyles.menuDarkBlue,
        appBar: AppBar(
          title: Text(Strings.leaderboard.tr, style: UnderseaStyles.listBold),
          toolbarHeight: 85,
          backgroundColor: UnderseaStyles.hintColor,
          actions: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 30, 10),
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                      navbarcontroller.selectedTab.value = 2;
                    },
                    child: SizedBox(
                      height: 40,
                      child: ShaderMask(
                        child: UnderseaStyles.imageIcon("tab_attack",
                            size: 30, color: UnderseaStyles.underseaLogoColor),
                        shaderCallback: (Rect bounds) {
                          final Rect rect = Rect.fromLTRB(0, 0, 30, 30);
                          return LinearGradient(
                                  colors: UnderseaStyles.gradientColors,
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)
                              .createShader(rect);
                        },
                      ),
                    ))),
          ],
        ),
        body: GetBuilder<UserDataController>(builder: (controller) {
          results = controller.rankList.toList();
          itemCount = results.length * 2 + 2;
          return ListView.builder(
              itemCount: controller.loadingList.value || results.isEmpty
                  ? 1
                  : itemCount,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int i) {
                if (i.isOdd) return UnderseaStyles.divider();
                if (i == 0) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                        child: UnderseaStyles.inputField(
                            hint: Strings.username.tr,
                            color: Color(0xFF657A9D),
                            hintColor: UnderseaStyles.alternativeHintColor,
                            onChanged: controller.onSearchChanged,
                            validator: (string) {}),
                      ),
                      controller.loadingList.value
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: const SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator()),
                              ),
                            )
                          : Container(),
                      results.isEmpty
                          ? Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 100,
                                  ),
                                  Text('Nincs ilyen nevű felhasználó',
                                      style: UnderseaStyles.listRegular
                                          .copyWith(
                                              fontSize: 15,
                                              color: UnderseaStyles
                                                  .underseaLogoColor)),
                                  SizedBox(height: 20),
                                ],
                              ),
                            )
                          : Container()
                    ],
                  );
                }
                var user = results[i ~/ 2 - 1];
                return Padding(
                    padding: EdgeInsets.fromLTRB(35, 10, 15, 10),
                    child: Row(
                      children: [
                        SizedBox(
                            child: Text('${user?.placement}. ',
                                style: UnderseaStyles.listRegular),
                            width: 30),
                        SizedBox(width: 20),
                        Text(user?.name ?? '',
                            style: UnderseaStyles.listRegular),
                        Expanded(child: Container()),
                        Text(user?.points.toString() ?? '',
                            style: UnderseaStyles.listRegular)
                      ],
                    ));
              });
        }));
  }
}
