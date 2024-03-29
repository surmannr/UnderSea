import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:undersea/lang/strings.dart';
import 'package:undersea/models/response/paged_result_of_user_rank_dto.dart';
import 'package:undersea/models/response/paged_result_of_world_winner_dto.dart';
import 'package:undersea/models/response/register_dto.dart';
import 'package:undersea/models/response/user_info_dto.dart';
import 'package:undersea/models/response/user_rank_dto.dart';

import 'package:undersea/network/providers/user_data_provider.dart';
import 'package:undersea/styles/style_constants.dart';
import 'package:undersea/views/bottom_nav_bar.dart';

import '../constants.dart';

class UserDataController extends GetxController {
  final UserDataProvider _userDataProvider;
  var storage = GetStorage();

  Rx<UserInfoDto?> userInfoData = Rx(null);
  Rx<bool> userInfoLoading = false.obs;
  Rx<String?> userInfoError = Rx(null);

  Rx<bool> loggingIn = false.obs;
  Rx<bool> regging = false.obs;

  Rx<bool> loadingList = false.obs;

  UserDataController(this._userDataProvider);

  Rx<PagedResultOfUserRankDto?> pagedRankList = Rx(null);
  Rx<PagedResultOfWorldWinnerDto?> winnerList = Rx(null);
  var searchText = ''.obs;
  var pageNumber = 1.obs;
  var alreadyDownloadedPageNumber = 0.obs;
  var pageSize = 10.obs;
  var rankList = <UserRankDto>[].obs;

  @override
  void onInit() {
    debounce(searchText, (String value) {
      getRankList();
    }, time: Duration(milliseconds: 500));
    super.onInit();
  }

  void onSearchChanged(String value) {
    searchText.value = value;
    pageNumber.value = 1;
    alreadyDownloadedPageNumber.value = 0;

    rankList.clear();
  }

  register(
      {required String username,
      required String password,
      required String confirmPassword,
      required String countryName,
      Function? onSuccess}) async {
    regging = true.obs;
    update();
    try {
      var registrationData = RegisterDto(
          userName: username,
          password: password,
          confirmPassword: confirmPassword,
          countryName: countryName);
      final response =
          await _userDataProvider.register(registrationData.toJson());
      if (response.statusCode == 200) {
        onSuccess != null ? onSuccess() : {};
      } else if (response.statusCode == 400) {
        var errors = response.bodyString!.split('"errors":')[1];
        var start = errors.indexOf('[') + 2;
        var end_ = errors.indexOf('(') - 1;
        var end = errors.indexOf(']') - 2;
        var errorMessage = errors.substring(start, end_ != -2 ? end_ : end);

        log(errorMessage);
        UnderseaStyles.snackbar(Strings.error_occurred.tr, errorMessage);
      } else {
        UnderseaStyles.snackbar(
            Strings.error_occurred.tr, 'Sikertelen regisztráció :(');
      }
    } catch (error) {
      UnderseaStyles.snackbar(
          Strings.error.tr, Strings.something_went_wrong.tr);
    } finally {
      regging = false.obs;
      update();
    }
  }

  login(String username, String password) async {
    loggingIn = true.obs;
    update();
    try {
      final body =
          'username=$username&password=$password&grant_type=password&client_id=undersea-flutter&scope=openid+api-openid';
      final response = await _userDataProvider.login(body);
      if (response.statusCode == 200) {
        storage.write(Constants.TOKEN, response.body!.token);
        Get.off(BottomNavBar());
      } else {
        UnderseaStyles.snackbar(
            Strings.error_occurred.tr, Strings.invalid_username_password.tr);
        log('ERROR: ${response.bodyString}');
      }
    } catch (error) {
      log('$error');
      UnderseaStyles.snackbar(
          Strings.error.tr, Strings.something_went_wrong.tr);
    } finally {
      //Get.off(BottomNavBar());
      loggingIn = false.obs;
      update();
    }
  }

  void userInfo() async {
    userInfoError = null.obs;
    userInfoLoading = true.obs;
    userInfoData = null.obs;
    await Future.delayed(const Duration(milliseconds: 10), () {
      update();
    });
    try {
      final response = await _userDataProvider.getUserInfo();
      if (response.statusCode == 200) {
        userInfoData = Rx(response.body);

        storage.write(Constants.ROUND_NUM, userInfoData.value?.round);
      }
    } catch (error) {
      userInfoError = error.toString().obs;
      log('$error');
    } finally {
      userInfoLoading = false.obs;
      await Future.delayed(const Duration(milliseconds: 10), () {
        update();
      });
    }
  }

  getRankList() async {
    if (pagedRankList.value != null &&
        pagedRankList.value!.allResultsCount <
            alreadyDownloadedPageNumber.value * pageSize.value) return;
    loadingList = true.obs;

    try {
      await Future.delayed(const Duration(milliseconds: 10), () {
        update();
      });
      final response = await _userDataProvider.getRankList(pageSize.value,
          pageNumber.value, searchText.value.removeAllWhitespace);
      if (response.statusCode == 200) {
        pagedRankList = Rx(response.body!);
        if (alreadyDownloadedPageNumber.value !=
            pagedRankList.value!.pageNumber) {
          rankList.value += pagedRankList.value?.results ?? [];
          alreadyDownloadedPageNumber.value = pageNumber.value;
        }
      }
    } catch (error) {
      log('$error');
    } finally {
      loadingList = false.obs;
      await Future.delayed(const Duration(milliseconds: 10), () {
        update();
      });
    }
  }

  getWinners() async {
    try {
      final response = await _userDataProvider.getWinners();
      if (response.statusCode == 200) {
        winnerList = Rx(response.body!);

        int roundPersisted = storage.read(Constants.ROUND_NUM) ?? 0;
        var winner = winnerList.value?.results?.first;
        var round = userInfoData.value?.round ?? roundPersisted + 1;

        var areDatesCorrect = winner?.date.toString() !=
            storage.read(
              Constants.WINNER_DATE + (userInfoData()?.name ?? 'name'),
            );

        if (round < roundPersisted &&
            winnerList.value?.allResultsCount != 0 &&
            areDatesCorrect) {
          Get.defaultDialog(
              title: "Új játék indult!",
              backgroundColor: UnderseaStyles.hintColor,
              titleStyle: UnderseaStyles.listBold.copyWith(fontSize: 16),
              barrierDismissible: true,
              radius: 20,
              content: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                      width: 300,
                      height: 320,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Image.asset(
                              'assets/buildings/happy_soldier.png',
                              width: 130,
                              height: 130,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Az előző játék győztese',
                              style: UnderseaStyles.listBold),
                          SizedBox(height: 5),
                          Text(' ${winner?.userName}',
                              style: UnderseaStyles.listRegular),
                          Text(' ${winner?.countryName}',
                              style: UnderseaStyles.listRegular),
                          Expanded(child: Container()),
                          UnderseaStyles.elevatedButton(
                              text: 'Ok',
                              width: 100,
                              height: 40,
                              onPressed: () {
                                storage.write(
                                    Constants.WINNER_SHOWN +
                                        (userInfoData()?.name ?? 'name'),
                                    true);
                                storage.write(
                                    Constants.WINNER_DATE +
                                        (userInfoData()?.name ?? 'name'),
                                    winner?.date.toString());
                                Get.back();
                              }),
                        ],
                      ))));
        }
      }
    } catch (error) {
      log('$error');
    }
  }

  void reset() {
    pagedRankList = Rx(null);
    searchText.value = '';
    pageNumber.value = 1;
    alreadyDownloadedPageNumber.value = 0;
    pageSize.value = 10;
    rankList.clear();
    //rankList.value.clear();
  }
}
