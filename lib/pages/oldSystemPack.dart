import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:telephony/telephony.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:background_sms/background_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OldSystemPack extends StatefulWidget {
  const OldSystemPack({Key? key}) : super(key: key);

  @override
  State<OldSystemPack> createState() => _OldSystemPackState();
}

class _OldSystemPackState extends State<OldSystemPack> {
  _getPermission() async => await [
    Permission.sms,
  ].request();

  Future<bool> _isPermissionGranted() async =>
      await Permission.sms.status.isGranted;

  Future<bool?> get _supportCustomSim async =>
      await BackgroundSms.isSupportCustomSim;


  final TextEditingController _phoneNumberForPack = TextEditingController();
  final TextEditingController _packCode = TextEditingController();
  final TextEditingController _masterSimController = TextEditingController();
  // final Telephony telephony = Telephony.instance;


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
                    controller: _phoneNumberForPack,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter phone number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'number',
                        labelText: 'Mobile number to activate pack'),
                  ),
                  TextFormField(
                    controller: _packCode,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter pack code';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Pack code', labelText: 'Pack code name'),
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
                        hintText: 'number',
                        labelText: 'Master SIM mobile number'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 100,
                      height: 10,
                      child: ElevatedButton(
                          onPressed: () => _sendSMS(),
                          child: const Text('Submit')),
                    ),
                  )
                ])));
  }

  _sendSMS() async {
    String phoneNumberPack = _phoneNumberForPack.text;
    String packCode = _packCode.text;
    String message = '$phoneNumberPack $packCode';
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
    //  andro  telephony.sendSms(to: '6666', message: message);
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



  void __sendSMS(String message, List<String> recipents, sendDirect) async {
    String _result = await sendSMS(
        message: message, recipients: recipents, sendDirect: sendDirect)
        .catchError((onError) {
      __sendSMS(message, recipents, false);
      print(onError);
    });
    print(_result);
    if (_result == 'SMS Sent!') {
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) => _buildPopupDialog(context),
      // );
    }
  }
}
