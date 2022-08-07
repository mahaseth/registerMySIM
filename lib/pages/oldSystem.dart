import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:intl/intl.dart';
// import 'package:telephony/telephony.dart';
import 'package:background_sms/background_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OldSystem extends StatefulWidget {
  const OldSystem({Key? key}) : super(key: key);

  @override
  State<OldSystem> createState() => _OldSystemState();
}

class _OldSystemState extends State<OldSystem> {
  // final Telephony telephony = Telephony.instance;

  _getPermission() async => await [
    Permission.sms,
  ].request();

  Future<bool> _isPermissionGranted() async =>
      await Permission.sms.status.isGranted;

  Future<bool?> get _supportCustomSim async =>
      await BackgroundSms.isSupportCustomSim;

  final TextEditingController _phoneNumberToRegister = TextEditingController();
  final TextEditingController _documentNumber = TextEditingController();
  final TextEditingController _masterSimNumber = TextEditingController();
  final TextEditingController _documentIssueDate = TextEditingController();
  final TextEditingController _masterSimController = TextEditingController();
  String _language = 'en';
  // Initial Selected Value
  int? _documentTypeValue;
  String? _districtVdcValue;

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  @override
  Widget build(BuildContext context) {
    _masterSimController.text = '+9779802479249';
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(8.0),
      child: ListView(
        itemExtent: 70.0,
        padding: EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: _phoneNumberToRegister,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter phone number';
              }
              return null;
            },
            decoration: InputDecoration(
                hintText: 'number', labelText: 'Mobile number to register'),
          ),
          DropdownButton(
            // Initial Value
            value: _documentTypeValue,
            isExpanded: true,

            // Down Arrow Icon
            icon: Icon(Icons.keyboard_arrow_down),

            hint: Text('Select the document'),

            // Array list of items
            items: const [
              DropdownMenuItem(
                child: Text('Citizenship'),
                value: 2,
              ),
              DropdownMenuItem(
                child: Text('Passport'),
                value: 1,
              ),
              DropdownMenuItem(
                child: Text('Nepali License'),
                value: 3,
              ),
              DropdownMenuItem(
                child: Text('Nepali Votercard'),
                value: 16,
              ),
              DropdownMenuItem(
                child: Text('Indian Adharcard'),
                value: 59,
              )
            ],
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (int? newValue) {
              setState(() {
                _documentTypeValue = newValue!;
              });
            },
          ),
          TextFormField(
            controller: _documentNumber,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter phone number';
              }
              return null;
            },
            decoration: InputDecoration(
                hintText: 'Document number', labelText: 'Document number'),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Document Issue date type: ',
              ),
              _radio<String>('AD', 'en', _language,
                  (value) => setState(() => {_language = value})),
              _radio<String>('BS', 'ne', _language,
                  (value) => setState(() => {_language = value})),
            ],
          ),
          TextFormField(
            controller: _documentIssueDate,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter document issue date';
              }
              return null;
            },
            decoration: InputDecoration(
                hintText: 'Document issue date',
                labelText: 'Document Issue date:  yyyy-mm-dd',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.edit_calendar),
                  tooltip: 'Increase volume by 10',
                  onPressed: () {
                    setState(() {
                      _selectDate();
                    });
                  },
                )),
          ),
          DropdownButton(
            // Initial Value
            value: _districtVdcValue,
            isExpanded: true,

            // Down Arrow Icon
            icon: Icon(Icons.keyboard_arrow_down),

            hint: Text('Select the district-VDC'),

            // Array list of items
            items: const [
              DropdownMenuItem(
                child: Text('Jhapa-Chandragadhi'),
                value: 'Jhapa-Chandragadhi',
              ),
              DropdownMenuItem(
                child: Text('Ilam-Ilam'),
                value: 'Ilam-Ilam',
              ),
              DropdownMenuItem(
                child: Text('Panchthar-Phidim'),
                value: 'Panchthar-Phidim',
              ),
              DropdownMenuItem(
                child: Text('Taplejung-Taplejung'),
                value: 'Taplejung-Taplejung',
              ),
              DropdownMenuItem(
                child: Text('Other-Other'),
                value: 'Other-Other',
              )
            ],
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (String? newValue) {
              setState(() {
                _districtVdcValue = newValue!;
              });
            },
          ),
          TextFormField(
            controller: _masterSimController,
            enabled: false,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter master sim number';
              }
              return null;
            },
            decoration: const InputDecoration(
                hintText: 'number', labelText: 'Master SIM mobile number'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              height: 10,
              child: ElevatedButton(
                  onPressed: () => _sendSMS(), child: const Text('Submit')),
            ),
          )
        ],
      ),
    ));
  }

  _selectDate() async {
    if (_language == 'en') {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 216.0,
            padding: const EdgeInsets.only(top: 6.0),
            color: CupertinoColors.white,
            child: DefaultTextStyle(
              style: const TextStyle(
                color: CupertinoColors.black,
                fontSize: 22.0,
              ),
              child: GestureDetector(
                onTap: () {},
                child: SafeArea(
                  top: false,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        _documentIssueDate.text = DateFormat("yyyy-MM-dd")
                            .format(newDateTime)
                            .toString();
                      });
                    },
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      picker.showCupertinoDatePicker(
        context: context,
        initialDate: NepaliDateTime.now(),
        firstDate: NepaliDateTime(2000),
        lastDate: NepaliDateTime(2090),
        language: Language.nepali,
        dateOrder: DateOrder.mdy,
        onDateChanged: (newDate) {
          setState(() {
            _documentIssueDate.text =
                NepaliDateFormat("yyyy-MM-dd").format(newDate).toString();
          });

          // _issueDate = newDate;
        },
      );
    }
  }

  _sendSMS() async {
    final List<String>? listDisVdc = _districtVdcValue?.split('-');
    String phoneNumber = _phoneNumberToRegister.text;
    String docNumber = _documentNumber.text;
    String district = listDisVdc![0];
    String _stringIssueDate = _documentIssueDate.text.replaceAll('-', '');
    String _issueDateLanguage = _language == 'en' ? 'e' : 'n';
    String message = '$phoneNumber*$_documentTypeValue*$docNumber*$district*'
        '$_stringIssueDate*$_issueDateLanguage*${listDisVdc[1]}';
    print(message);
    List<String> recipents = [_masterSimController.text];
    String receiver = _masterSimController.text;

    // testSendSMS();
    if (await _isPermissionGranted()) {
      if ((await _supportCustomSim)!) {
        _sendMessage(receiver, message, simSlot: 1);
      }
      else {
        _sendMessage(receiver, message);
      }
    } else {
      _getPermission();
    }

    // __sendSMS(message, recipents, true);

    // try {
    //   telephony.sendSms(to: '6666', message: message);
    //   } catch (e) {
    //     print(e);
    //    __sendSMS(message, recipents);
    //   }
  }

  _sendMessage(String phoneNumber, String message, {int? simSlot}) async {
    List<String> recipents = [phoneNumber];
    var result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: simSlot);
    if (result == SmsStatus.sent) {
      print("Sent");
      Fluttertoast.showToast(
          msg: "Submitted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      print("Failed");
      __sendSMS(message, recipents, true);
    }
  }

  // void testSendSMS() {
  //   String _message = '';
  //     SmsSender sender = SmsSender();
  //     String address = "1234567";
  //
  //     SmsMessage message = SmsMessage(address, 'Hello flutter!');
  //     message.onStateChanged.listen((state) {
  //     if (state == SmsMessageState.Sent) {
  //     print("SMS is sent!");
  //     setState(() {
  //     _message = "SMS is sent";
  //     });
  //     } else if (state == SmsMessageState.Delivered) {
  //     print("SMS is delivered!");
  //     setState(() {
  //     _message = "SMS is delivered!";
  //     });
  //     }
  //     });
  //     sender.sendSms(message);
  // }

    void __sendSMS(String message, List<String> recipents, sendDirect) async {
    String _result = await sendSMS(message: message, recipients: recipents, sendDirect: sendDirect)
        .catchError((onError) {
      __sendSMS(message, recipents, false);
      print(onError);
    });
    print(_result);
    if(_result == 'SMS Sent!'){
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) => _buildPopupDialog(context),
      // );
    }
  }

  Widget _radio<T>(
    String title,
    T value,
    T groupValue,
    ValueChanged<T> onChanged,
  ) {
    return Flexible(
      child: RadioListTile<T>(
        value: value,
        groupValue: groupValue,
        onChanged: (v) => onChanged(v!),
        title: Text(title),
      ),
    );
  }
}
