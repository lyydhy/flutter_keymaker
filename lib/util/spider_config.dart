// 所有爬虫相关的配置文件
class SpiderConfig {
  // static _instance，_instance会在编译期被初始化，保证了只被创建一次
  static final SpiderConfig _instance = SpiderConfig._internal();

  //提供了一个工厂方法来获取该类的实例
  factory SpiderConfig() {
    return _instance;
  }

  // 通过私有方法_internal()隐藏了构造方法，防止被误创建
  SpiderConfig._internal() {}

  // 账号数据
  List<Account>? accountList;

  // 接码数据
  List<ConcatenatedCodes>? concatenatedCodesList;

  // ip配置
  List<IpPool>? ipPoolList;

}

// 账户
class Account {
  String? phone;
  String? password;
  String? token;

  Account(this.phone, this.password, {this.token});
}

// 接码
class ConcatenatedCodes {
  Account? account;
  String name;
  String type;

  ConcatenatedCodes({
    this.account,
    required this.type,
    required this.name,
  });
}

// ip
class IpPool {
  Account? account;
  String name;
  String type;

  IpPool({
    this.account,
    required this.type,
    required this.name,
  });
}
