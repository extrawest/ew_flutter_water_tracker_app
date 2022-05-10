import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_tracker/database/app_database.dart';
import 'package:water_tracker/database/home_dao.dart';
import 'package:water_tracker/models/item_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AppDatabase.isTestingMode = true;
  defineTests();
}

void defineTests() {
  group('database tests', () {

    const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '.';
    });

    late HomeDao homeDao;

    setUp(() async {
      homeDao = HomeDao();
    });

    test('save/get', () async {
      final item = Item(id: 0, name: 'itemName');
      await homeDao.save(item);
      expect(await homeDao.get(1), isNull);
      expect(await homeDao.get(0), isNotNull);
      expect((await homeDao.get(0))!.id, item.id);
      expect((await homeDao.get(0))!.name, item.name);
    });

    test('delete', () async {
      final item = Item(id: 0, name: 'itemName');
      await homeDao.delete(item);
      expect(await homeDao.get(0), isNull);
    });

    test('save/update', () async {
      final item = Item(id: 0, name: 'itemName');
      await homeDao.save(item);
      expect(await homeDao.get(0), isNotNull);
      await homeDao.update(Item(id: 0, name: 'itemNameUpdated'));
      expect(await homeDao.get(0), isNotNull);
      expect((await homeDao.get(0))!.name, 'itemNameUpdated');
    });

    test('getAll', () async {
      final item = Item(id: 0, name: 'itemName');
      final item1 = Item(id: 1, name: 'itemName1');
      final item2 = Item(id: 2, name: 'itemName2');
      await homeDao.save(item);
      await homeDao.save(item1);
      await homeDao.save(item2);
      expect(await homeDao.get(0), isNotNull);
      final List<Item> itemsList = await homeDao.getAll();
      expect(itemsList, isNotEmpty);
      expect(itemsList.length, 3);
      expect(itemsList[0].id, item.id);
    });

    test('clearStore', () async {
      final item = Item(id: 10, name: 'itemName');
      await homeDao.save(item);
      expect(await homeDao.get(10), isNotNull);
      await homeDao.clearStore();
      expect(await homeDao.get(10), isNull);
      expect((await homeDao.getAll()).length, 0);
    });

    tearDown(() async {
      await homeDao.clearStore();
      AppDatabase.isTestingMode = false;
    });

  });
}
