import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lttechapp/view/widgets/ConsignmentDetailsScreen.dart';




class ConsignmentDetailsPage extends StatelessWidget {
  final int index;
  String consignmentId;

  ConsignmentDetailsPage({
    required this.index,
    required this.consignmentId,
  });

  @override
  Widget build(BuildContext context) {
    return ConsignmentDetailsScreen(index: this.index,consignmentid:this.consignmentId);
  }
}
