import 'package:bytebank/models/contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Usando async
Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'bytebank.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute('CREATE TABLE contacts ('
          'id INTEGER PRIMARY KEY , '
          'name TEXT, '
          'account_number INTEGER)');
    },
    version: 1, /*onDowngrade: onDatabaseDowngradeDelete*/
  );
}

/*
getDatabase usando then 
Future<Database> getDatabase() {
  return getDatabasesPath().then((dbPath) {
    final String path = join(dbPath, 'bytebank.db');
    return openDatabase(path, onCreate: (db, version) {
      db.execute('CREATE TABLE contacts ('
          'id INTEGER PRIMARY KEY , '
          'name TEXT, '
          'account_number INTEGER)');
    }, version: 1, /*onDowngrade: onDatabaseDowngradeDelete*/);
  });
}*/


//usando async
Future<int> save(Contact contact) async{
  final Database db = await getDatabase();
  final Map<String, dynamic> contactMap = Map();
    contactMap['name'] = contact.name;
    contactMap['account_number'] = contact.accountNumber;
    return db.insert('contacts', contactMap);
  
}

/*
Save usando then
Future<int> save(Contact contact) {
  final Map<String, dynamic> contactMap = Map();
  return getDatabase().then((db) {
    contactMap['name'] = contact.name;
    contactMap['account_number'] = contact.accountNumber;
    debugPrint(
        'numero que chegou pra salvar: ' + contact.accountNumber.toString());
    debugPrint('numero que esta sendo salvo: ' +
        contactMap['account_number'].toString());
    return db.insert('contacts', contactMap);
  });
}*/

Future<List<Contact>> findAll() {
  return getDatabase().then((db) {
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
