import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keymaker_template/component/custome_table.dart';
import 'package:timer_count_down/timer_count_down.dart';

class HomeIndexPage extends StatefulWidget {
  const HomeIndexPage({Key? key}) : super(key: key);

  @override
  State<HomeIndexPage> createState() => _HomeIndexPageState();
}

class _HomeIndexPageState extends State<HomeIndexPage> {
  final CustomTableHeader _tableHeader = CustomTableHeader(
    columns: const [
      {'title': "序号"},
      {'title': '手机号码'},
      {'title': '内容'},
      {'title': '验证码'},
      {'title': '状态'}
    ],
  );
  CustomTableController _tableController = CustomTableController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Container(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomTable(
              header: _tableHeader,
              controller: _tableController,
            ),
          ),
          Button(
            child: Text("增加数据"),
            onPressed: () {
              addData();
            },
          ),
        ],
      )),
    );
  }

  void addData() {
    for (int i = 0; i < 5; i++) {
      Future.delayed(Duration(milliseconds: 500), () {
        Control(_tableController).start();
      });
    }
  }
}

class Control {
  CustomTableController _tableController;

  Control(this._tableController);

  int? index;
  ValueNotifier<int> seconds = ValueNotifier(10);

  start() {
    index = _tableController.addData!(["153100", "", "", ""]);
    startTime();
    startYzm();
  }

  // 定时器
  startTime() {}

  // 验证码
  startYzm() {
    editTable(4, '发送验证码成功!');
    int ti = Random().nextInt(5) + 1;
    Future.delayed(Duration(seconds: ti), () {
      editTable(
        3,
        Countdown(
          seconds: 10,
          build: (BuildContext c, double t) {
            return Text(
              "接收验证码: ${t.toInt()}s",
              textAlign: TextAlign.center,
            );
          },
          onFinished: () {
            editTable(
              3,
              "验证码: " + next(100000, 999999).toString(),
            );
            editTable(4, '完成');
          },
        ),
      );
    });
  }

  int next(int min, int max) {
    var result = min + Random().nextInt(max - min);
    return result;
  }

  editTable(int idx, dynamic value) {
    _tableController.editData!(index!, idx, value);
  }
}
