import 'package:bytebank/models/contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> createDatabase() {
  return getDatabasesPath().then((dbPath) {
    final String path = join(dbPath, 'bytebank.db');
    return openDatabase(path, onCreate: (db, version) {
      db.execute('CREATE TABLE contacts ('
          'id INTEGER PRIMARY KEY , '
          'name TEXT, '
          'account_number INTEGER)');
    }, version: 1, /*onDowngrade: onDatabaseDowngradeDelete*/);
  });
}

Future<int> save(Contact contact) {
  final Map<String, dynamic> contactMap = Map();
  return createDatabase().then((db) {
    contactMap['name'] = contact.name;
    contactMap['account_number'] = contact.accountNumber;
    debugPrint(
        'numero que chegou pra salvar: ' + contact.accountNumber.toString());
    debugPrint('numero que esta sendo salvo: ' +
        contactMap['account_number'].toString());
    return db.insert('contacts', contactMap);
  });
}

Future<List<Contact>> findAll() {
  return createDatabase().then((db) {
    return db.query('contacts').then((maps) {
      final List<Contact> contacts = List();
      for (Map<String, dynamic> map in maps) {
        final Contact contact = Contact(
          map['id'],
          map['name'],
          map['account_number'],
        );
        debugPrint('numero da conta que foi pesquisado: ' +
            map['account_number'].toString());
        contacts.add(contact);
      }
      return contacts;
    });
  });
}
