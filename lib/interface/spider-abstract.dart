import 'package:flutter_keymaker_template/component/custome_table.dart';

import '../util/spider_config.dart';

abstract class SpiderAbstract {
  CustomTableController? tableController;
  int? index;

  // 修改表格
  editTable(int idx, dynamic value);

  // 获取配置文件
  SpiderConfig get spiderConfig;
}

class Spider implements SpiderAbstract{
  @override
  CustomTableController? tableController;

  @override
  int? index;

  @override
  editTable(int idx, value) {
    tableController?.editData!(index!, idx, value);
  }

  @override
  SpiderConfig get spiderConfig {
    return SpiderConfig();
  }

}