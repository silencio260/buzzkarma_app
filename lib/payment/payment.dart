import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:genrevibes/models/user_model.dart';
import 'package:genrevibes/sign_in/email_auth/FormValidator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:genrevibes/constants/constants.dart';
import 'package:genrevibes/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:genrevibes/payment/payout_history.dart';
//import 'package:genrevibes/controller/payout_controller.dart';

class Payment extends StatefulWidget {
//  User user;
//  Payment(User user) {
//    this.user = user;
//  }
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final userController = Get.put(UserController());
  final textController = TextEditingController();
  final _formFieldKey = GlobalKey<FormFieldState>();

  int amount = 5;
  int conversion = 100000;
  int totalPoint = 0;
  int dropdownValue = 5;
  String displayValue = '';
  String paymentEmail = '';

  var defaultStyle = TextStyle(color: Colors.black, fontSize: 14);
  var confirmStyle = TextStyle(color: Colors.green, fontSize: 14);
  var payEmailStyle; // = TextStyle(color: Colors.black, fontSize: 14);

  var displayNum = MaskedTextController(mask: '0,000,000.00');
  var displayNumFor5 = MaskedTextController(mask: '000,000.00');

  int getPoint() {
    totalPoint = conversion * totalPoint;
    return totalPoint;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalPoint = amount * conversion;
    if (amount == 5) {
      displayNumFor5.updateText(totalPoint.toString());
      displayValue = displayNumFor5.text;
    } else {
      displayNum.updateText(totalPoint.toString());
      displayValue = displayNum.text;
    }

    payEmailStyle = defaultStyle;

//    displayNum.updateText(totalPoint.toString());
//    displayValue = displayNum.text;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController.dispose();
  }

  void showToast(String msg, Color color) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  dynamic sendServerReq() async {
    var payoutUrl =
        'http://${kpayment.authority + kpayment.path + amount.toString() + '/' + paymentEmail}';
    print('=========+++++++======------[[[[[]]]]]]]]]');
    print(payoutUrl);
    var response = await http.get(Uri.parse(payoutUrl), headers: kheaders);
    var resJson = await jsonDecode(response.body);
    return resJson;
  }

  void paymentRequest() async {
    var points = userController.user.value.points;
    dynamic newUser = null;
    if (_formFieldKey.currentState.validate() == false) {
      showToast('You have entered an invalid payment Email', Colors.red);
    } else {
      if (points >= totalPoint) {
        showToast('Payment Requested Sucessfully', Colors.green);
        newUser = sendServerReq();
        userController.user.value.points = newUser['points'];
      } else {
        showToast('You do not have enough points', Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Redeem'),
        icon: Icon(Icons.wallet_giftcard_outlined),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        tooltip: 'Redeem',
        onPressed: paymentRequest,
      ),
      appBar: AppBar(
        title: Text('Request Payment'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            tooltip: 'Closes application',
            onPressed: () => {
              pushNewScreen(
                context,
                screen: PayoutHistory(),
                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              )
            },
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('images/paypalGiftcard.png'),
                width: 150,
                height: 150,
              ),
              Text(
                '\$$amount PayPal',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w200),
              ),
              Text(
                '${displayValue} Points',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
              DropDownFormField(
                titleText: 'Amount',
                hintText: 'Please choose one',
                value: amount,
                onChanged: (value) {
                  setState(() {
                    amount = value;
                    totalPoint = amount * conversion;
                    if (value == 5) {
                      displayNumFor5.updateText(totalPoint.toString());
                      displayValue = displayNumFor5.text;
                    } else {
                      displayNum.updateText(totalPoint.toString());
                      displayValue = displayNum.text;
                    }
                  });
                },
                dataSource: [
                  {
                    "display": "\$5",
                    "value": 5,
                  },
                  {
                    "display": "\$10",
                    "value": 10,
                  },
                  {
                    "display": "\$15",
                    "value": 15,
                  },
                  {
                    "display": "\$20",
                    "value": 20,
                  },
                  {
                    "display": "\$25",
                    "value": 25,
                  },
                  {
                    "display": "\$50",
                    "value": 50,
                  },
                ],
                textField: 'display',
                valueField: 'value',
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  keyboardType: TextInputType.name,
                  key: _formFieldKey,
                  autofocus: false,
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'PayPal email',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          payEmailStyle = confirmStyle;
                          paymentEmail = textController.text;
                          print('++++++++*******************+++++++++++++');
                          print(paymentEmail);
                          print(_formFieldKey.currentState.validate());
                        });
                      },
                      child: Text(
                        'Confirm?',
                        style: payEmailStyle,
                      ),
                    ),
                  ),
                  validator: FormValidator().validateEmail,
                  onChanged: (String value) {
                    setState(() {
                      payEmailStyle = defaultStyle;
                      paymentEmail = textController.text;
                    });
                  },
                ),
              ),
              PaymentNotice(),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentNotice extends StatelessWidget {
  String important =
      "*** IMPORTANT *** Payment will not be made if the email adddres is not registered to a PayPal account."
      "PayPal may take out some transaction fee. Payment will be within 72 hours. ";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Terms',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            important,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          )
        ],
      ),
    );
  }
}
