import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:genrevibes/controller/payout_controller.dart';
import 'package:genrevibes/constants/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:jiffy/jiffy.dart';
import 'package:recase/recase.dart';

class PayoutHistory extends StatelessWidget {
  Color processingColor = Colors.black;

  final payoutController = Get.put(PayoutController());

  void changeColor(var payout) {
    if (payout.rejected) {
      processingColor = Colors.redAccent;
    } else if (payout.approved) {
      processingColor = Colors.green;
    } else {
      processingColor = Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GetX<PayoutController>(builder: (controller) {
              return ListView.separated(
                  itemCount: controller.payouts.length,
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.grey,
                    );
                  },
                  itemBuilder: (context, index) {
                    var payout = controller.payouts[index];
                    var paymentEmail = payout.paymentEmail == null || payout.paymentEmail.isEmpty
                        ? ''
                        : payout.paymentEmail;

                    changeColor(payout);

                    return ListTile(
                        title: Text(
                          '\$${payout.amount}',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                          ),
                        ),
                        subtitle: Text("${Jiffy(payout.date).fromNow()}."),
                        //subtitle: Text("${Jiffy(payout.date).fromNow()}. \n" + paymentEmail),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              payout.status.titleCase,
                              style: TextStyle(color: processingColor),
                            ),
                            Icon(Icons.keyboard_arrow_right),
                          ],
                        )
//                      isThreeLine: true,
                        );
                  });
            }),
          )
        ],
      ),
    );
  }
}
