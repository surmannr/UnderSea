import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:undersea/core/lang/strings.dart';
import 'package:undersea/models/response/user_rank_dto.dart';
import 'package:undersea/services/navbar_controller.dart';
import 'package:undersea/services/user_service.dart';
import 'package:undersea/styles/style_constants.dart';

class Leaderboard extends StatefulWidget {
  Leaderboard({Key? key}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  final BottomNavBarController navbarcontroller =
      Get.find<BottomNavBarController>();
  var controller = Get.find<UserService>();
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

  Widget? _itemBuilder(BuildContext ctx, int idx) {
    var user = results[idx];

    return Column(
      children: [
        UnderseaStyles.divider(),
        Padding(
            padding: EdgeInsets.fromLTRB(35, 10, 15, 10),
            child: Row(
              children: [
                SizedBox(
                    child: Text('${user?.placement}. ',
                        style: UnderseaStyles.listRegular),
                    width: 30),
                SizedBox(width: 20),
                Text(user?.name ?? '', style: UnderseaStyles.listRegular),
                Expanded(child: Container()),
                Text(user?.points.toString() ?? '',
                    style: UnderseaStyles.listRegular)
              ],
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: GetBuilder<UserService>(builder: (controller) {
        results = controller.rankList.toList();
        itemCount = results.length;

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: UnderseaStyles.menuDarkBlue,
              leadingWidth: 0,
              leading: Container(),
              toolbarHeight: controller.loadingList.value ? 150 : 100,
              title: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        UnderseaStyles.inputField(
                            hint: Strings.username.tr,
                            color: Color(0xFF657A9D),
                            hintColor: UnderseaStyles.alternativeHintColor,
                            onChanged: controller.onSearchChanged,
                            validator: (string) {}),
                        controller.loadingList.value
                            ? UnderseaStyles.listProgressIndicator(
                                size: 30, padding: 10)
                            : Container()
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                _itemBuilder,
                childCount: itemCount,
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    results.isEmpty && !controller.loadingList.value
                        ? Text(Strings.no_user_named_this_way.tr,
                            style: UnderseaStyles.listRegular.copyWith(
                                fontSize: 15,
                                color: UnderseaStyles.underseaLogoColor))
                        : Container(),
                    SizedBox(
                        height: 20 + MediaQuery.of(context).padding.bottom),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
