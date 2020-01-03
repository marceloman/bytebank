import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final Contactdao _dao = Contactdao();
  

  @override
  Widget build(BuildContext context) {
    final Future<List<Contact>> fullList = _dao.findAll();
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: FutureBuilder<List<Contact>>(
        initialData: List(),
        future: fullList,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text('Loading'),
                  ],
                ),
              );
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<Contact> contacts = snapshot.data;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final Contact contact = contacts[index];
                  return _ContactItem(contact,
                      onDelete: () => removeItem(contact));
                },
                itemCount: contacts.length,
              );
              break;
          }

          return Text('Unknow Error');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ContactForm(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  removeItem(Contact contact) {
    setState(() {
      _dao.delete(contact);
    });
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;

  final VoidCallback onDelete;

  _ContactItem(this.contact, {this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: ListTile(
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: this.onDelete
            ,
          ),
          title: Text(
            contact.name,
            style: TextStyle(fontSize: 24),
          ),
          subtitle: Text(
            contact.accountNumber.toString(),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
