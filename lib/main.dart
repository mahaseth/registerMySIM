// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:nepali_date_picker/nepali_date_picker.dart';
// import 'package:telephony/telephony.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_sms/flutter_sms.dart';
// import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
// import 'package:nepali_utils/nepali_utils.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Register SIM',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Register SIM'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final Telephony telephony = Telephony.instance;
//   String _language = 'en';
//
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _masterSimController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _msgController = TextEditingController();
//   final TextEditingController _valueSms = TextEditingController();
//   int? _msgDocTypeController;
//   String? _msgDisVdcController;
//   DateTime  _issueDate = DateTime.now();
//   String _documentIssueDate = '';
//   NepaliDateTime _nepaliDateTime = NepaliDateTime.now();
//   final TextEditingController _msgDocNumberController = TextEditingController();
//   final TextEditingController _msgPhoneController = TextEditingController();
//
//
//   @override
//   void initState() {
//     super.initState();
//     _masterSimController.text = '+9779807907497';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextFormField(
//                     controller: _phoneController,
//                     keyboardType: TextInputType.phone,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Enter phone number';
//                       }
//                       return null;
//                     },
//                     decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: 'number',
//                         labelText: 'Mobile number to register'),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: DecoratedBox(
//                     decoration: const ShapeDecoration(
//                       shape: RoundedRectangleBorder(
//                         side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.cyan),
//                         borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                       ),
//                     ),
//                     child: DropdownButton<int>(
//                       value: _msgDocTypeController,
//                       elevation: 16,
//                         isExpanded: true,
//                       style: const TextStyle(color: Colors.deepPurple),
//                       onChanged: (int? newValue) {
//                         setState(() {
//                           _msgDocTypeController = newValue!;
//                         });
//                       },
//                       hint: const Text(
//                         'Select the document',
//                         style: TextStyle(color: Colors.black),
//                       ),
//                       icon: const Icon(
//                         Icons.arrow_downward,
//                         color: Colors.black,
//                       ),
//                       items: const [
//                         DropdownMenuItem(child: Text('Citizenship'),value: 2,),
//                         DropdownMenuItem(child: Text('Passport'),value: 1,),
//                         DropdownMenuItem(child: Text('License'),value: 3,)
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextFormField(
//                     controller: _msgDocNumberController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Document Number required';
//                       }
//                       return null;
//                     },
//                     decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: 'Document Number',
//                         labelText: 'Document Number'),
//                   ),
//                 ),
//               Padding(
//                 padding: const EdgeInsets.all(0.0),
//                 child: Text(
//                   'Document Issue Date: $_documentIssueDate',
//                     style: const TextStyle(
//                             fontSize: 18.0,
//                                 ),
//                         textAlign: TextAlign.center,
//                        ),
//               ),
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     const SizedBox(width: 10.0),
//                     const Text(
//                       'Change Date: ',
//                       style: TextStyle(fontSize: 18.0),
//                     ),
//                     _radio<String>('AD', 'en', _language,
//                             (value) => setState(() => {
//                                 _selectDate(value)
//                             })),
//                     _radio<String>('BS', 'ne', _language,
//                             (value) => setState(() => {
//                               _selectDate(value)
//                             })),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: DecoratedBox(
//                     decoration: const ShapeDecoration(
//                       shape: RoundedRectangleBorder(
//                         side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.cyan),
//                         borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                       ),
//                     ),
//                     child: DropdownButton<String>(
//                       value: _msgDisVdcController,
//                       elevation: 16,
//                       isExpanded: true,
//                       style: const TextStyle(color: Colors.deepPurple),
//                       hint: const Text(
//                         'Select the district-VDC',
//                         style: TextStyle(color: Colors.black),
//                       ),
//                       icon: const Icon(
//                         Icons.arrow_downward,
//                         color: Colors.black,
//                       ),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           _msgDisVdcController = newValue!;
//                         });
//                       },
//                       items: const [
//                         DropdownMenuItem(child: Text('Jhapa-Chandragadhi'),value: 'Jhapa-Chandragadhi',),
//                         DropdownMenuItem(child: Text('Ilam-Ilam'),value: 'Ilam-Ilam',),
//                         DropdownMenuItem(child: Text('Panchthar-Phidim'),value: 'Panchthar-Phidim',),
//                         DropdownMenuItem(child: Text('Taplejung-Taplejung'),value: 'Taplejung-Taplejung',),
//                         DropdownMenuItem(child: Text('Other-Other'),value: 'Other-Other',)
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextFormField(
//                     controller: _masterSimController,
//                     keyboardType: TextInputType.phone,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Enter master sim number';
//                       }
//                       return null;
//                     },
//                     decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: 'number',
//                         labelText: 'Master SIM mobile number'),
//                   ),
//                 ),
//                 ElevatedButton(
//                     onPressed: () => _sendSMS(), child: const Text('Send SMS'))
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//   _selectDate(value) async{
//     _language = value;
//     print(value);
//
//     if(_language == 'en')
//       {
//         showCupertinoModalPopup<void>(
//           context: context,
//           builder: (BuildContext context) {
//             return Container(
//               height: 216.0,
//               padding: const EdgeInsets.only(top: 6.0),
//               color: CupertinoColors.white,
//               child: DefaultTextStyle(
//                 style: const TextStyle(
//                   color: CupertinoColors.black,
//                   fontSize: 22.0,
//                 ),
//                 child: GestureDetector(
//                   onTap: () {},
//                   child: SafeArea(
//                     top: false,
//                     child: CupertinoDatePicker(
//                       mode: CupertinoDatePickerMode.date,
//                       initialDateTime: DateTime.now(),
//                       onDateTimeChanged: (DateTime newDateTime) {
//                         setState(() {
//                           _documentIssueDate = DateFormat("yyyy-MM-dd").format(newDateTime).toString();
//                           _issueDate =  newDateTime;
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       } else{
//       picker.showCupertinoDatePicker(
//             context: context,
//             initialDate:   NepaliDateTime.now(),
//             firstDate: NepaliDateTime(2000),
//             lastDate: NepaliDateTime(2090),
//             language:  Language.nepali,
//             dateOrder: DateOrder.mdy,
//             onDateChanged: (newDate) {
//               setState(() {
//                 _nepaliDateTime = newDate;
//                 _documentIssueDate = NepaliDateFormat("yyyy-MM-dd").format(_nepaliDateTime).toString();
//               });
//
//               // _issueDate = newDate;
//             },
//       );
//     }
//
//
//
//
//
//
//   }
//
//
//   _sendSMS() async {
//     final List<String>? listDisVdc = _msgDisVdcController?.split('-');
//     String phoneNumber = _phoneController.text;
//     String docNumber = _msgDocNumberController.text;
//     String district = listDisVdc![0];
//     String _stringIssueDate = _documentIssueDate.replaceAll('-', '');
//     String _issueDateLanguage = _language == 'en' ? 'e' : 'n';
//     print(_issueDate);
//     String message = '$phoneNumber*$_msgDocTypeController*$docNumber*$district*'
//         '$_stringIssueDate*${_issueDateLanguage}*${listDisVdc[1]}';
//     print(message);
//     List<String> recipents = [_masterSimController.text];
//
//     __sendSMS(message, recipents);
//
//
//     // try {
//     //   telephony.sendSms(to: '6666', message: message);
//     //   } catch (e) {
//     //     print(e);
//     //   }
//   }
//
//   void __sendSMS(String message, List<String> recipents) async {
//     String _result = await sendSMS(message: message, recipients: recipents)
//         .catchError((onError) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => _buildPopupDialog(context),
//       );
//       print(onError);
//     });
//     print(_result);
//     if(_result == 'SMS Sent!'){
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => _buildPopupDialog(context),
//       );
//     }
//   }
//
//
//
//   _getSMS() async {
//     List<SmsMessage> _messages = await telephony.getInboxSms(
//       columns: [SmsColumn.ADDRESS, SmsColumn.BODY],
//       filter: SmsFilter.where(SmsColumn.ADDRESS).equals(_phoneController.text)
//     );
//
//     for(var msg in _messages) {
//       print(msg.body);
//     }
//   }
//
//   Widget _radio<T>(
//       String title,
//       T value,
//       T groupValue,
//       ValueChanged<T> onChanged,
//       ) {
//     return Flexible(
//       child: RadioListTile<T>(
//         value: value,
//         groupValue: groupValue,
//         onChanged:  (v) => onChanged(v!),
//         title: Text(title),
//       ),
//     );
//   }
// }
//
// Widget _buildPopupDialog(BuildContext context) {
//   return AlertDialog(
//     title: const Text('SMS sent.'),
//     actions: <Widget>[
//       FlatButton(
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//         textColor: Theme.of(context).primaryColor,
//         child: const Text('Close'),
//       ),
//     ],
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter_send_sms/pages/oldSystem.dart';
import 'package:flutter_send_sms/pages/oldSystemPack.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:flutter/services.dart';
import 'package:telephony/telephony.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// MyApp
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      // telephony.listenIncomingSms(
      //     onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      title: 'Register My SIM',
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Register My SIM"),
            centerTitle: true,
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Old system'),
                Tab(text: 'Old system pack'),
                Tab(text: 'New system')
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              OldSystem(),
              OldSystemPack(),
              Text('data'),
            ],
          ),
        ),
      ),
    );
  }
}
