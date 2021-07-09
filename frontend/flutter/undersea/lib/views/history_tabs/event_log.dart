import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:undersea/controllers/battle_data_controller.dart';
import 'package:undersea/lang/strings.dart';
import 'package:undersea/models/response/spy_report_dto.dart';
import 'package:undersea/styles/style_constants.dart';

class EventLogPage extends StatefulWidget {
  @override
  _EventLogPageState createState() => _EventLogPageState();
}

class _EventLogPageState extends State<EventLogPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(color: UnderseaStyles.menuDarkBlue),
            child: ListView.builder(
                itemCount: 50,
                itemBuilder: (BuildContext context, int i) {
                  if (i == 0) return SizedBox(height: 20);
                  if (i.isEven) {
                    return UnderseaStyles.divider();
                  } else {
                    return _buildRow(i);
                  }
                })));
  }

  Widget _buildRow(int i) {
    int roundNumber = 50;
    String eventName = "Elképesztő elemi csapás";
    return Tooltip(
        decoration: BoxDecoration(
            color: UnderseaStyles.hintColor,
            borderRadius: BorderRadius.all(Radius.circular(32))),
        textStyle: UnderseaStyles.listRegular,
        showDuration: Duration(milliseconds: 500),
        message:
            'Katonáid elégedettek ebben a körben, minden katona támadása csökken eggyel.',
        child: ListTile(
            title: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            children: [
              Text(eventName,
                  style: UnderseaStyles.listBold.copyWith(fontSize: 16)),
              Expanded(
                child: Container(),
              ),
              Text('$roundNumber. kör',
                  style: UnderseaStyles.listBold.copyWith(fontSize: 15))
            ],
          ),
        )));
  }
}
