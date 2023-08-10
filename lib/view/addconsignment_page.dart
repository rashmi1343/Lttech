import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lttechapp/view/widgets/AddConsignment/AddConsignmentViewPageSix.dart';
import 'package:lttechapp/view/widgets/AddConsignment/AddConsignmentViewPagefive.dart';
import 'package:lttechapp/view/widgets/AddConsignment/AddConsignmentViewPagefour.dart';
import 'package:lttechapp/view/widgets/AddConsignment/AddConsignmentViewPageone.dart';
import 'package:lttechapp/view/widgets/AddConsignment/AddConsignmentViewPagethree.dart';
import 'package:lttechapp/view/widgets/AddConsignment/AddConsignmentViewPagetwo.dart';


class AddConsignmentPage extends StatelessWidget {
  const AddConsignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AddConsignmentViewPageone();

    /*final _controller = PageController(
      initialPage: 0,
    );

    return PageView(
      controller: _controller,
      pageSnapping: true,
      children: [
        AddConsignmentViewPageone(),
        AddConsignmentViewPagetwo(),
        AddConsignmentViewPagethree(),
        AddConsignmentViewPagefour(),
        AddConsignmentViewPagefive(),
        AddConsignmentViewPageSix(),
      ],
    );*/
  }
}
