import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entity/VehicleRegistrationResponseList.dart';
import '../entity/trucktyperesponse.dart';
import '../presenter/Lttechprovider.dart';
import 'ColorTheme.dart';

class MultiSelectChip extends StatefulWidget {
  final List<RegistrationList?> reportList;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.reportList,{required this.onSelectionChanged});
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}
class _MultiSelectChipState extends State<MultiSelectChip> {
 // String selectedChoice = "";



  int idx=0;
  // this function will build and return the choice list
  _buildChoiceList() {
    var providerlltech = Provider.of<Lttechprovider>(context, listen: false);
    List<Widget> choices = [];
    widget.reportList.forEach((item) {
      //isselected.add(false);

      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          selectedColor: Color(0xff0AAC19),
          label:
          Text(item!.truckRegistration.toString(),style: TextStyle(
              fontSize: 14,
              fontFamily:
              'InterMedium')),
          selected: providerlltech.arrstrselectedtrailer!.contains(item.truckSetupId.toString()),
          onSelected: (selected) {
            setState(() {
            //arrdisplayselectedtrailer
            if ( providerlltech.arrstrselectedtrailer!.contains(item.truckSetupId.toString())) {
              providerlltech.arrstrselectedtrailer!.remove(item.truckSetupId.toString());
              providerlltech.arrdisplayselectedtrailer!.remove(item.truckRegistration.toString());
              providerlltech.isselected[idx] = false;
            }
            else {
              providerlltech.isselected[idx] = true;
              providerlltech.arrstrselectedtrailer!.add(
                  item.truckSetupId.toString());
              providerlltech.arrdisplayselectedtrailer!.add(item.truckRegistration.toString());
              providerlltech.notifyListeners();

            }
              widget.onSelectionChanged(providerlltech.arrstrselectedtrailer!); // +added
            });
            print("selected:"+providerlltech.arrstrselectedtrailer!.length.toString());
              providerlltech.addTimeSheetRequestObj.trailer = providerlltech.arrstrselectedtrailer!;
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}