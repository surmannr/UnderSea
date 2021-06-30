import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:undersea/controllers/soldiers_controller.dart';
import 'package:undersea/lang/strings.dart';
import 'package:undersea/models/soldier.dart';
import 'package:undersea/styles/style_constants.dart';

class AttackPage extends StatefulWidget {
  @override
  _AttackPageState createState() => _AttackPageState();
}

class _AttackPageState extends State<AttackPage> {
  int? _selectedIndex;
  var sliderValues = List<int>.generate(3, (index) => 0);
  var mercenaryPrice = 0;
  List<Soldier> soldierList = Get.find<SoldiersController>().soldierList;
  bool firstPage = true;
  late final Timer? _debounce;
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      Get.snackbar("Query changed", query,
          icon: Icon(Icons.app_registration),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blueAccent);
    });
  }

  @override
  void initState() {
    firstPage = true;
    super.initState();
  }

  bool _canAttack() {
    if (sliderValues.every((element) => element == 0)) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (firstPage)
      return UnderseaStyles.tabSkeleton(
        buttonText: Strings.proceed,
        isDisabled: _selectedIndex == null ? true : false,
        onButtonPressed: () {
          setState(() {
            firstPage = false;
          });
        },
        list: ListView.builder(
            itemCount: 20,
            itemBuilder: (BuildContext context, int i) {
              if (i.isOdd) return UnderseaStyles.divider();
              if (i == 0) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(25, 20, 15, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Strings.first_step.tr,
                            style:
                                UnderseaStyles.listBold.copyWith(fontSize: 22)),
                        Text(Strings.select.tr,
                            style: UnderseaStyles.listRegular
                                .copyWith(fontSize: 22)),
                        SizedBox(height: 20),
                        UnderseaStyles.inputField(
                            hint: Strings.username.tr,
                            color: Color(0xFF657A9D),
                            hintColor: UnderseaStyles.alternativeHintColor,
                            onChanged: _onSearchChanged),
                      ]),
                );
              }
              if (i == 19) return SizedBox(height: 100);
              return ListTile(
                  onTap: () {
                    setState(() {
                      i != _selectedIndex
                          ? _selectedIndex = i
                          : _selectedIndex = null;
                    });
                  },
                  title: Padding(
                      padding: EdgeInsets.fromLTRB(25, 0, 15, 0),
                      child: Row(
                        children: [
                          SizedBox(
                              child: Text('${i ~/ 2}. ',
                                  style: UnderseaStyles.listRegular),
                              width: 30),
                          SizedBox(width: 20),
                          Text('kiscsiko98',
                              style: UnderseaStyles.listRegular
                                  .copyWith(fontSize: 20)),
                          Expanded(child: Container()),
                          if (i == _selectedIndex)
                            UnderseaStyles.iconsFromImages("done", size: 28),
                          SizedBox(width: 20)
                        ],
                      )));
            }),
      );
    else
      return UnderseaStyles.tabSkeleton(
          buttonText: Strings.lets_attack,
          isDisabled: !_canAttack(),
          onButtonPressed: () {
            setState(() {
              firstPage = true;
            });
          },
          list: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int i) {
                if (i == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: UnderseaStyles.underseaLogoColor,
                              size: 35,
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  firstPage = true;
                                });
                              },
                              child: Text(Strings.back.tr,
                                  style: UnderseaStyles.buttonTextStyle
                                      .copyWith(
                                          color:
                                              UnderseaStyles.underseaLogoColor,
                                          fontSize: 20)),
                            )
                          ],
                        ),
                      ),
                      UnderseaStyles.infoPanel(
                          Strings.second_step.tr, Strings.unit_select.tr,
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 0)),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  );
                }
                if (i == 4) return SizedBox(height: 100);
                return Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: UnderseaStyles.assetIcon(
                              soldierList[i - 1].iconName),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 25,
                                ),
                                child: Text(
                                    '${soldierList[i - 1].name} ${sliderValues[i - 1]}/${soldierList[i - 1].available}',
                                    style: UnderseaStyles.listRegular
                                        .copyWith(height: 1.2)),
                              ),
                              SizedBox(height: 8),
                              Container(
                                height: 20,
                                child: Slider(
                                  value: sliderValues[i - 1].toDouble(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      var amountBeforeChange =
                                          sliderValues[i - 1];
                                      sliderValues[i - 1] = newValue.round();
                                      mercenaryPrice = (mercenaryPrice +
                                              newValue -
                                              amountBeforeChange *
                                                  soldierList[i - 1].price)
                                          .toInt();
                                    });
                                  },
                                  min: 0,
                                  max: soldierList[i - 1].available.toDouble(),
                                  activeColor: UnderseaStyles.underseaLogoColor,
                                  inactiveColor: Color(0x883B7DBD),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ));
              }));
  }
}
