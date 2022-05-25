import 'package:fluent_ui/fluent_ui.dart';

class CustomTable extends StatefulWidget {
  final CustomTableHeader header;
  final CustomTableController? controller;

  const CustomTable({
    Key? key,
    required this.header,
    this.controller,
  }) : super(key: key);

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  List<TableRow> dataSource = [];

  // 原始数据
  final List<List<dynamic>> _originDataSource = [];

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  // 注册控制器方法
  void initFunction() {
    if (widget.controller != null) {
      widget.controller?.addData = addData;
      widget.controller?.editData = editData;
    }
  }

  // 添加数据
  int addData(List<dynamic> list) {
    _originDataSource.add(list);
    list.insert(0, "${dataSource.length + 1}");

    dataSource.add(
      TableRow(
        children: list.map((e) {
          if (e is Widget) {
            return e;
          }
          return Text(
            e,
            textAlign: TextAlign.center,
          );
        }).toList(),
      ),
    );
    setState(() {});
    return dataSource.isEmpty ? 0 : dataSource.length - 1;
  }

  // 修改数据
  editData(int index, int idx, dynamic value) {
    _originDataSource[index][idx] = value;
    dataSource[index] = TableRow(children: [
      ..._originDataSource[index].asMap().keys.map((i) {
        dynamic e = _originDataSource[index][i];
        if (e is Widget) {
          return e;
        }
        return Text(
          e,
          textAlign: TextAlign.center,
        );
      }).toList(),
    ]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [tableHeaderRow(), ...dataSource],
    );
  }

  // 表头
  TableRow tableHeaderRow() {
    return TableRow(
      decoration: widget.header.decoration,
      children: widget.header.columns.asMap().keys.map((index) {
        var cur = widget.header.columns[index];
        TextStyle style = const TextStyle();
        if (cur['style'] != null && cur['style'] is TextStyle) {
          style = cur['style'];
        }
        return Text(
          cur['title'],
          style: style,
          textAlign: TextAlign.center,
        );
      }).toList(),
    );
  }
}

class CustomTableHeader {
  BoxDecoration decoration;
  List<Map<String, dynamic>> columns;

  CustomTableHeader({
    this.decoration = const BoxDecoration(),
    required this.columns,
  });
}

typedef AddData = int Function(List<dynamic> value);
typedef EditData = Function(int index, int idx, dynamic value);

class CustomTableController {
  AddData? addData;
  EditData? editData;

  dispose() {
    addData = null;
    editData = null;
  }
}
