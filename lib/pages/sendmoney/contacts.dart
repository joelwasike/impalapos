// import 'package:contacts_service/contacts_service.dart';
// import 'package:flutter/material.dart';

// class ContactListPage extends StatelessWidget {
//   final List<Contact> contacts;

//   const ContactListPage({Key? key, required this.contacts}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Contacts'),
//       ),
//       body: ListView.builder(
//         itemCount: contacts.length,
//         itemBuilder: (context, index) {
//           final contact = contacts[index];
//           return Card(
//             color: const Color(0xFFFDF8EE),
//             child: ListTile(
//               title: Text(contact.displayName ?? ''),
//               subtitle: Text(contact.phones?.isNotEmpty == true
//                   ? contact.phones!.first.value!
//                   : ''),
//               onTap: () {
//                 Navigator.pop(context, contact);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
