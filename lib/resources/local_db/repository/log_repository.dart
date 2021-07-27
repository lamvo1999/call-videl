import 'package:do_an_chuyen_nganh/modules/log.dart';
import 'package:do_an_chuyen_nganh/resources/local_db/db/hive_methods.dart';
import 'package:do_an_chuyen_nganh/resources/local_db/db/sqlite_methods.dart';
import 'package:flutter/material.dart';

class LogRepository {
  static var dbObject;
  static bool isHive;

  static init({@required bool isHive, @required String dbName}) {
    dbObject = isHive ? HiveMethods() : SqliteMethods();
    dbObject.openDb(dbName);
    dbObject.init();
  }

  static addLogs(Log log) => dbObject.addLogs(log);

  static deleteLogs(int logId) => dbObject.deleteLogs(logId);

  static getLogs() => dbObject.getLogs();

  static close() => dbObject.close();

}