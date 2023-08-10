import 'dart:convert';
import 'dart:io';

import 'package:flutter_signature_view/flutter_signature_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lttechapp/utility/env.dart';
import 'package:lttechapp/view/widgets/Location/MapBoxLocation.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';

import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/ColorTheme.dart';
import 'package:lttechapp/utility/SizeConfig.dart';
import 'package:lttechapp/utility/bottomappbar.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';

import '../../entity/CountriesResponse.dart';
import '../../entity/GetGeoLocationResponse.dart';
import '../../utility/Constant/endpoints.dart';
import '../../utility/CustomTextStyle.dart';
import '../../utility/PDFViewerFromUrl.dart';
import '../../utility/StatefulWrapper.dart';
import 'Jobdetail/JobdetailView.dart';
import 'SignatureView/SignatureView.dart';

class ConsignmentDetailsScreen extends StatelessWidget {
  final int index;
  String consignmentid;

  ConsignmentDetailsScreen({
    required this.index,
    required this.consignmentid,
  });

  BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    // print("IndexPst:$index");
    SizeConfig().init(context);
    _context = context;
    Future<bool> _onWillPop() async {
      print("back called");
      final provider = Provider.of<Lttechprovider>(context, listen: false);
      // provider.allpageNum = 0;
      // provider.bookedpageNum = 0;
      // provider.confirmedpageNum = 0;
      // provider.deliveredpageNum = 0;
      provider.navigatetoConsignmentJob(context);

      return true;
    }

    final provider = Provider.of<Lttechprovider>(context, listen: false);
    var deliveredCountryName = '';
    var customerCountryName = '';
    var pickUpCustomerName = '';
    var toDelCustomerName = '';
    double? getGeoStartedLatitude;
    double? getGeoStartedLongitude;
    double? getGeoDeliveredLatitude;
    double? getGeoDeliveredLongitude;
    DateTime? delivereddate;
    var formatdelivereddate;
    var formatGeodelivereddate;
    return StatefulWrapper(
      onInit: () async {
        await Provider.of<Lttechprovider>(context, listen: false)
            .consignmentByIdRequest(consignmentid, _context);
        await provider.getAllCountriesRequest('1');

        int? deliveredCountryId =
            provider.consignmentByIdresponse.data!.deliveryCountryId;
        print("deliveredCountryId:$deliveredCountryId");

        final deliverycountry = provider.objgetallCountries.data
            .firstWhere((element) => element.id == deliveredCountryId);
        //  if (deliverycountry.isNotEmpty) {
        deliveredCountryName = deliverycountry.countryName.toString();
        print('deliveredCountryName: ${deliverycountry.countryName}');
        // }
        toDelCustomerName = provider.consignmentByIdresponse.data!
            .customerDeliveryDetails!.customerCompanyName
            .toString();
        pickUpCustomerName = provider.consignmentByIdresponse.data!
            .customerPickupDetails!.customerCompanyName
            .toString();
        int? customerCountryId =
            provider.consignmentByIdresponse.data!.countryId;
        print("customerCountryId:$customerCountryId");

        final customercountry = provider.objgetallCountries.data
            .firstWhere((element) => element.id == customerCountryId);
        // if (customercountry.isNotEmpty) {
        customerCountryName = customercountry.countryName.toString();
        print('customerCountryName: ${customercountry.countryName}');
        // }
        provider.setUpdateView = true;
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Consumer<Lttechprovider>(builder: (context, value, child) {
          DateTime? bookeddate = value.consignmentByIdresponse.data!.bookedDate;
          var formatBookedDate =
              DateFormat.yMMMMd().format(bookeddate ?? DateTime.now());
          // print("formatBookedDate:$formatBookedDate");
          DateTime? pickupdate = value.consignmentByIdresponse.data!.pickupDate;
          var formatPickUpDate =
              DateFormat.yMMMMd().format(pickupdate ?? DateTime.now());
          // print("formatPickUpDate:$formatPickUpDate");
          DateTime? deliverydate =
              value.consignmentByIdresponse.data!.deliveryDate;
          var formatDeliveryDate =
              DateFormat.yMMMMd().format(deliverydate ?? DateTime.now());
          // print("formatDeliveryDate:$formatDeliveryDate");
          DateTime? geodate = DateTime.now();
          var formatGeoDate = DateFormat('MMM d, yyyy - h:mm a')
              .format(geodate ?? DateTime.now());
          DateTime? recieveddate =
              value.consignmentByIdresponse.data!.signatureDate;
          print("recieveddate:$recieveddate");
          var formatrecieveddate =
              DateFormat.yMMMMd().format(recieveddate ?? DateTime.now());

          print("formatrecieveddate:$formatrecieveddate");
          String currentDate =
              DateFormat("dd MMMM,yyyy – kk:mm a").format(DateTime.now());
          print(currentDate);

          String deliveryaddress =
              "${value.consignmentByIdresponse.data!.deliveryAddres}\n${value.consignmentByIdresponse.data!.deliverySuburb} \nIndia\n${value.consignmentByIdresponse.data!.deliveryZipCode}";
          String str =
              " ${value.consignmentByIdresponse.data!.signature.toString()}";

          String signature =
              // "iVBORw0KGgoAAAANSUhEUgAAAUsAAAEqCAYAAACcH3JhAAAABHNCSVQICAgIfAhkiAAAGMNJREFUeJzt3UtWKzm2xvEt36xcmFFUOydxTDerG5MwDMJmEOBJRLeqS5xJZLtqEpi1qpZ1GxCcwEgKKZ56/H+de4vkGAP2x5a2HiIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEqfWfgIA7G5O1W5zkV33Y5eNNG/7ulnnGZWLsAQitT1VL6K/BuU1peXx9aE+LvOMykZYAhG6faqOWsnB9/MJzflt1n4CAMbTSg7b50rfPlXHtZ9LrghLICNayWF7ql4IzekRlkAqlDRKy6MoaZyfp2WnlRwIzGkRlkAi1EV+vj7Ux/O+vjvf10ppeXR9PoE5LcISSNTrQ33sC00CczqEJZC414f6qLQ82kKTwJwGYQlk4PWhPrahafrvBOZ4hCWQEQJzPoQlkBkCcx6EJZAhAnN6hCWQCL2RHyGfT2BOi7AEInTZGBae9xyqYUJgToewBBJyc6p2of+mLzCHPGaJCEsgQm/7ujFta1TifxJRlyswhz5maQhLIFJaDOGmZTe0ErQGppYdw/F+hCUQqamrS5H3wDQ9JsPxfoQlEDFbdTn5YwrD8T6EJRAx2107Y4bNb/u6sQ3HqS7tCEsgdqZhc+Cay2u2KyioLu0ISyByUzd6WjR7whCWQOTmaPSIuJs9Yx43V4QlkIC5qktbs4fq8jvCEkjAXNWl7XFZSvQdYQkkYo5lRNbHFZo91whLYCXbU/UScte3bRnR2AqQpUR+CEtgBbdP1bGtCtu7vr3+4QxDcRF7s4fq8hfCEljBt46z55Id21B8iobMnI+dA8ISWMPApoqrITM21Gj2uBGWQER8hr22hkzQcD7wsRmOE5bAKmyh5DPstTZkPv79mMCk2WOn1n4CQKlun6qjbbeMVnJn6377/Hvfx7DZPlf62weVNOd9fTfk8XJAZQmsxHl6uZaXvkrO9e99H8Pxb2dZ05kyKktgZbFWmKbqcky1mjoqS2BltuPSRPwaK68P9VErsQ6PlZaXQZ1yQ2e8ZIQlEIGxDZu3fd24ApNrb8cjLIEI2HbQiEh4YFoeJzQw1UV+Xn9sc0lv3vL2qTqGbi01ISyBSFiXE73/R+/APO/ryQLz278feUL70j7ncztbS4c2vQhLIBK2HTSfArYeThGYl036c5amxtfQ6piwBCLirC4lrDI87+s721xoCXOYtu9v6B8BwhKISG91KWFB51qL2bc90rhEKJG1lrblVErL49ClT4QlEJm+6lIkbB+4c/H6yO2RsbKtO3Ut0+pDWAKR8akuReQ96Dw7vL2BaXscw/OIfY+47efh2u3kg7AEIuRTXX5+ruewvG97ZPs4qc9l2obfY6pKEZH/G/OPAczjf//869+///mHEuU5R6hk97d//HH8/c8/1H//9Vdj+7T//uuvxvm4SnaiZPf7n3+ov/3jj50o+buI/L37KRst/3F9jTXdPlVH0/emN/L4v3/+9e8xj01lCURqSCXkU2X2bY9sHye1+8PnaOp0EZZAxKzDZsecplZy6JvL7Nvt8+vBjFValAvT52jqdBGWQMRc2yD7wq6vymx3+4xtfMRgrqbOl8ea6oEAzOPmVO2Ulm/Le9rj0vqOaBPxa3D4PE738USmq9rGcA2/p3x+hCWQgO2pevk2JO6cXD5VYPo+VvcxRdYNTeOp7iJyvq8nzTfCEkhAX3XZ/m+voFPSqIv8vGykcTU+UgjNpapKEcISSEZfddkKCTmR92CxBaetanM91lKBuWRQihCWQDJs1aUtHEJDs32s9v/XG/kxZC/4UldPGP94yPTD7xbdcCARtm2QriUzod3gdn1l9wzILqXlse8xx1yU5uv2qTrant9cX5OwBBJi2wZpWzrz+lAfz/e1Uloep7hT5/WhPn55TAufu4PGWHL4/fn4cz0wgHnYhp++w982WIcM0U1htPRw2Da9MPfwn8oSSIytuvSt5q6rQ6+hq5LGVrWZTmWfazg895ZGFypLIEFzVFeuk8V9K1at5GDq0E9lqTWVJoQlkChjcMwYVGtbeqnQNYbhQKKMQ10tu9gP5x1i7aAUISyBZNkO2Zi7E72GuU8U8kFYAgkzNnsyqy6XOFHIB2EJJMy2UD2X6jKG4XeLsAQSl3N1aTtoeI1TjghLIHG5VpdrbGl0ISyBDNiqy5RvajQ2dRyL4+dGWAIZCD1kI3a2kA+5InhqhCWQidBDNmK15pZGF8ISyMTbvm5M83mpVZcxrKk0ISyBjFw25mPYUumMx7Km0oSwBDKScmc8pjWVJoQlkJlU113GOvxuEZZAZlKsLmMefrcISyBDKVWXN6dqF/Pwu0VYAhlKqbq0PaeYglKEsASylUJ1GduWRhfCEsiUbQH35hJ+F/hcYtvS6EJYAjmLeAtkjFsaXQhLIGO24Fl7KB7rlkYXwhLIWKyNntjXVJoQlkDmYmv0pLCm0oSwBDIXU3UZ+5ZGF8ISKEAs1WWKw+8WYQkUIIbqMtXhd4uwBAphqy6X+NqpbGl0ISyBQtiW5CxxknoqWxpdCEugJCssUk9pS6MLYQkUZI1F6iltaXT5be0nAMTEtLRFaXm8bKSJdWdJiLd93WxPVXNd6X0Mk5upv97tU3XUho+ri/yc+mvNTa39BIBY3JyqndLyYv0EJY26yM/UKqJrtu9TK7mb8g9CymsqTSYPy5tTtWtPNUnxB4Jy2d7cJu18W6qv8e2pevk2j6ikOe/ru8m+xnNlKirlfF8nWaRNOmd5+1QdlZYXreSglRxSu68YZbPdjGjSvsa3z5W+faqOax9MEWruReqpr6k0mTQsr/8qayWH1F5EQCit5KC0vGxP1UsqBcKci9RzG363Zu+GKy0vBCZS5l0Nadl1q83Yg3OuJoveyA/Tx1MOSpGpw9Lwl+r9w3EcNgq42Jobl4005/tahQwhr4fpUz3HKRnDa+SOnlzWVJpMOwy3nXCsZbc9VfYuIxALx9D09aE+nu9rpZXchQZnzKE5pRyH361Jw9K57IDARAJ8Gh9v+7ppg1NpefQNztybnrbvLaRxFrPp5ywtQ3ERITARvdB1hq8P9bEbnH2fn2uVmeI1EaEmD8vey4a07HJ7oSAzA7vEIcN0reSwPVXZND9TPqfS1yp7w3MfjiBtY9cgXg/THV9op7Qks9zIJsc1lSaTh6Vt/dY1AhOxmnIN4utDffSqMhMdmue6ptJklsrS995fAhOxmvLuat85zRTfDyUMv1uzhOXbvm5COoS5zNsgcyO3A35WmY6RV0pVZinD79Zsc5avD/XRZzguwqJ1xGeu7YCvD/XxvK/9GkARh2YO10SEmrXB4z2UYUkRIjTnnTWpD81zuCYi1KxhGTIcZ0kRYmNbHzjltFGKDaCctzS6zL50KGQ4zvwlorPA9bEhVWYMh3Tkck1EqEXWWYYcKMopRYjJ3Oc+dr0+1EffBe3t8Hzp0LR9vSlXD8RqsUXpWol/YNLwQSTmPPfR9vV8huYiy59sVMKWRpdFj3cPObZ/6iPugaGWurPGJOg9I/7d6JtTtVMiB9Pco+3ah9yuiQi1+DdpvPvDIudlCEjLEnfWuISGpoh8mW9tD/rVG/nR9/4zhV9JO3VsFg/L3hv0rizx1xvoY3vdLl1V3T5VR5/AG+P6eyIo3y1+kEbQciKh4YM42P5gL91g6S5qn2OpjukxS9rS6LLKqUMhy4lEaPggEobXrO2+mbmFnqPZS0mjldxdB2BpWxpdVpuYDR2Ol1byIz5rNnp8BM9rKmm0uDvZpqZOqe/FVbtYc3X6kK7uayLG3/fajZ4Q3emrzeXXc75spPEJd9v7M5Y/DktbveUf0h0XKfcXVQJj5eZR/Swp9upyKjR1vltlzrIr9C8yDZ98daufT5GdJr70IvW10NT5bvWwFAnb3SOS3wsT71y3AMZ0+s6SWyDXQFPHLIqwDF1OxJFuZYrl9B3bcNtYGSeG4bddFGEpEr6ciCPdyhVFlWlaRhS6wyZCDL/toglLkY/5y4DAjOJNg8mENEjWrjJtp+ykPBRn+O0WVViKhB/1RGBmJmR0Iev9/nNr9JR4TUSo6MIyeP5SCMyctAc+fPlYz9Y+reSwPVWLr5LIqdFT4jURoaILSxG/o/avccp6Hkwdcb2RH72viRWWGOVSXZZ6TUSoKMNSZEDDR1iDmTufvdBLjzJSry6tu+gKuCYiVLRhKTLsqHoCM23GJs9V1dNXZS4ZmKnv2rF1v0u4JiJU1GH5tq+b0AXrIukNg3DFMKK4/gPY3ldje4hFK8xEh+K2tcqlXBMRKuqwFOlp+CgxzhmxaD0/pgXfb/u6Od/XyjZd0zZ+5n5uKVZhrnlKht9m0YeliGP+0nUAB4vWk2UKH9e5ke1huJYH222fK83UzC+u074ISrskwlLEsWBdy85VWRCYZeibx5yzU+4zzxoT6zzlgCmvkiQTliKO4c77shHjfyMw0zM0fGJq/MTKtUuHeUq3pMLSNX+pN/KDwMybz1B6tcaPR1NqbRySMU5SYSniqB607PoCM7YXLxwC19h2xdL4iYltO6MI85S+kgtLkf6Gjy0wWYNZlrUbPzEd2Wa774pdOv6SDEsR+/ylVnK4bCxLioTATNmQ8Fmq8WPa077WzY/XXPOUVJX+kg1L14J1peVFizxaAzOBBcOlM4XPUEs0flynvK+J7YzTSTYsRdwNHyVycC03Km3OKgdjKjWfwIzhFPYpueYpY7yNMnZJh6WIe/7y9qk6upYb5fTGyM0cldpnp9zRPBoamjGutbSNoJinHCb5sBSxL1jXSg6bi+xsw3WWFJXnbV83Pifyd0MzxdcI2xmnl0VYirgbPh//l8BM3YSVmrNT3v2SSg7e1WYkay2Zp5yHWvsJTMn1Ijnv6zvXnlj+4sZn+1zp64+d7+tJX7NtAIZcNtaGbDtV8Lavm5tTtTMtz9FK7pbeGWP6ua31XHKSVViKjAvMkl9MN6dq112aE8MfDtObfq7fUfv9T31D49J/hLen6oXh9zyyGYa3+ho+rq5oqWswb5+qo9Ly0g45o5maGLGLJ9Tbvm58TmKPGfOU88ouLEXc85c3p2rnurKixMA0VVPRBOYKvoTmmMBecI6QY9fml2VY9i1YvzlVO1dHlEXr72IMzCW3EL4+1Me2ERRabSotj0uuZeTYtfllGZYiPQvWPybiWbT+oWfd4VqV9pS7eMZ4faiP3Wrzs+K8PqlfSaOV3J3va7VkNcexa8v4be0nMKfXh/q4PVU/TPM421P1ct7Xd1rkUYmhWvkITHY6fFbazdrPQ2T9/daxDWk5dm052VaWLWvYfYSh81K0Qnb59FZwK/0cYt1vHQuOXVtW9mEp4pi38QjMGOftpuYTSpwHGh+OXVtWEWHZVz22gclJ625RNL4ivttmSRy7trwiwlLELzBdazBzDkzvJsDCw3GaE2ZsZ1xHMWEp0h+YfYvWsx6Keq4nnHqHyxDZ/g48cOzaeooKS5GeS88+qkd2+byz/QwWXVa14C6eFHDs2nqKC0sR90GwBOZXtsvhSvn+Y8J2xnUVGZYi/oHp2hY56xNcmGmLqN7ID9ubcM1mT0wXgS2Fecr1FRuWIn6B6doWWcounzWry1h28azNup3RdhMAJld0WIoEBKbxEzLfFvkx5LNV2FEsJSqA7TXGdsZlFR+WIn6BmfsuH9ubrq0ejRUMc5ezY54yHoTlh77ALOIuH0fn+W1fG+9ip7qcD8euxYWw7CAwv+uGIdXlsjh2LS6E5RWfwMx1l48tDNvviepyORy7Fh/C0qAvMEXsi4BTDkzbm7D7PVFdzo9j1+JEWFq41lhqJYfLRpw7gVIND9c0w82p2lFdzot5yngRlg7Oqye0vLgCM9VdPj4nzPcN1zGc66rmpZ8LviIse/gEZm6Xn7mmIdrj7EzfcwyHbKSMY9fiRlh66AtMLfZbAFMdnvZdKWzbOUJ1OQzzlPEjLD0NDsyEd/nYdi61qwKoLqfB9RBpICwDeAWmScKB6Wr42L7fFKce1sT1EGkgLAO5Di5QIofctkX2NnzojI/CPGU6CMtAfaetuwIz1TWYroaP8U4c1l164di1tBCWA/gEZm6L1l3rTk2oLt24HiI9hOVAfYGpN/Ijt8AMehNzC6MT85TpISxHGBuYKQ5VQw5xGPv93Zyqnd7IjzGPESPmKdNEWI7UF5gi9mohxUXrrobPNSXDKuibU7XbnqoXpeUltwqVecp0qbWfQC5ce3rbcHEduZXaSTKu7/da+/27wuDmVO2UyMEnHFOtwG5O1c42/D7f17wXI8cvaEJ9gak38sMYBkqaVCf1Q0JzEgn/rLanylgppxr+pSEsJ1ZiYIosEJpKGnWRn6mGCtsZ00dYzqA3MB3/LfU3zva50pM+oJJGS9oH3rrmKVP+A1kaGjwz6D082HFOZopLir4IWIvZ9zhayd15Xyc3n9vlWk/JNbZpobKc0dChaYoNn5aridErgyryGvOU+SAsZ1ZiYJoCosRwYJ4yLwzDZ+bcV+2Q8nZB0/Ayx8XlLqynzA9huYBBgZnwsW7GiriwwzWYp8wPYbmQoYGZbMOn4KPbbH/kuMY2bYTlgl4f6mPI3mqRdDvkpV6Ze/tUHWno5ImwXJhzL7lFiodu2C4121zy2uvdxTW2eSMsV/C2r5vzfa2CzodM8NCN0ho9rr3/Sz8XTI+wXJHrTh+TLOb8Mh2KM0+ZP8JyZed9fefd+EmsQ17KUJx5yjIQlhEI6pQn1iFXF/m59nOYE/OU5SAsIxESmKl2yHPEPGU5CMuIhAZmjnN/KXFdD8E8ZX4Iy8iEBGaKHfJcsO+7PIRlhIICM4cOeYKYpywPYRkp790+iXXIc+Aafi/8VLAgwjJi3rt9EuuQp4zhd7kIy8j57vahQ74Mht/lIiwT4bPbhw75vBh+l+23tb7wzanahe7kuGz8twbmuHTjvK/v+k5e/7jSgRPwJ8bwG6uEZXvtgA58Syvt3/ndPleOB3q/VlXkPYBTCtbXh/p4+1RZh4Mi7z9fbg2cFsNvLB6Wt0/VUZvuzV7Se1DvRN4DePtcfQnQ2N8AvYH50fCJ/ftIxe1TdTTd78vwuyyLh+VlI01IhbiYToBun6uDyK83Q4zVZ19gfjR8og/+FDD8hsgKDZ7YQsdFKzloJQel5WX7XOntqXq5faqOsXSd+xav0yGfiKGxRlCWZ5U5S63kzudu6W4QBB8aO8dQP8Lq8/WhPt6cqsb286TCHE9d5Gf7exdh+F2q1bqmPvdpty/Kqd/obSdeb+TH5KG60tznzanauf4ArTVsNP2eUxzCtq+ZGKdksIxVl5jcnKqdEjn0Bdbcb67uMqY5AnTJ6rNdaWB7HkuGlO0PolZyR+AgNVGsx/OpMkWWfbN/CVCP5xZk5qVLsQSm8feqpGFZE1IURViKdIbGkYVmV9ssmWv4LvLrZPExIRrLkHz7XH1bcZPiEBwQiSgsW75Vpsj6b7xZq8+uAUHaF5hzV3i23+P5vo7uNQf4iPaFGxqaInEs55i1+jRxBGnvz1BJo2WeU72pKpGbaMOyFRKaIvG9IRerPk2UND6BPabhYjq4w9a0o6pEypJ58aYeml2LV58RiPn3AfhIJixbQ0JTJI4husu35Usi8yysXwlVJVKX7As4NDRF0q1uUg/SVH/uQFeyYdm6faqOocPZnN680Qcp6yqRieTDsvU5D5jhEH2oRYLUcMhEqmeFAi7ZhGVXSUP0UL3rL7uoCoFPWYZli2rTjMAEwmUdlq2QrZRdOVebodU3h1+gdEWEZdfQIbpIftWm68ANEwITJSsuLFtDhugi+VWbpm2JLrl9/4CvYsOyq+RqM2j+8gOBiRIRlh2lVpusHgD6EZYWpVWbofOXIgQmykJY9iip2iQwATvCMkDu1aZz/tJx3BtdcpSAsBxgTLUpEndwWv8gfNwbZPueCUzkjrAcaUi1KSKf4RNjcLpuZbTexslOH2SOsJzI0GpTRD6DM6aDJ4zzlx+BaJ3bJDCRMcJyBoOrzQ8xDNdt85dtQ8e2mJ2GD3JFWM5oVLX5Yc3gtFWQ5/tauZpBBCZyRFguZOhhHl1LB2dfdemqoGn4IDeE5UqGnPD+xULznK5mz9u+bghMlIKwjEDsw3Xj/GSnmeNabkTDB7kgLCMzRXCKyOd1D+0VDyLv1zyIiIRWe33VpYh7fjPkawGx4oUcsSnmOXsZQlXke7C6lhK1/9P0OQzFkQvCMhGfwTlmnnMMy3bHdvgvYq6G6YwjF4RloiYbrs+NeUtkgrDMQOzBybwlcsCLOEM3p2onItLeGd6a7e7wHoQlcvDb2k8A0+s0VBrHp4mIOVinDNXunCaQMv7iw8t1qH4b8n8sku9+KKaDQYCxCEsM8mWZEE0cALC7faqObcUJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPjl/wGrJJzTR2MRzwAAAABJRU5ErkJggg==";
              value.consignmentByIdresponse.data!.signature.toString();
          print("signature.length:${signature.length}");
          ApiCounter.consignmentSignImageBytes =
              Base64Decoder().convert(signature);

          return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Color(0xffFAFAFA),
              appBar: AppBar(
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  backgroundColor: Color(0xffFAFAFA),
                  centerTitle: false,
                  toolbarHeight: 96,
                  elevation: 0,
                  toolbarOpacity: 0.5,
                  actions: <Widget>[
                    Row(
                      children: [
                        Container(
                          child: IconButton(
                            alignment: Alignment.centerLeft,
                            icon: Image.asset(
                              "assets/images/ConsignmentIcon/print.png",
                              color: const Color(0xff999999),
                              height: 18,
                              width: 18,
                            ),
                            onPressed: () {
                              value.consignmentByIdresponse.data!.status == "2"
                                  ? value.isPdfFileSignGenerated = true
                                  : value.isPdfFileSignGenerated = false;

                              value.isPdfFileSignGenerated == true
                                  ? value.generatePdf(
                                      context,
                                      formatBookedDate,
                                      formatPickUpDate,
                                      formatrecieveddate,
                                      signature,
                                      customerCountryName,
                                      deliveredCountryName,
                                      toDelCustomerName,
                                      pickUpCustomerName,
                                      getGeoStartedLatitude,
                                      getGeoStartedLongitude,
                                      getGeoDeliveredLatitude,
                                      getGeoDeliveredLongitude,
                                      formatGeodelivereddate)
                                  : showDialog(
                                      context: context,
                                      barrierDismissible:
                                          false, // user must tap button!
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 80,
                                          child: AlertDialog(
                                              insetPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 40.0,
                                                vertical: Platform.isAndroid
                                                    ? 290.0
                                                    : 240,
                                              ),
                                              title: Text(
                                                "Download Consignment",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontName.interSemiBold,
                                                  fontSize: 16,
                                                  color: Color(0xff243444),
                                                ),
                                              ),
                                              content: Column(
                                                children: [
                                                  Text(
                                                    "Do you want to download consignment without signature?",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontName.interMedium,
                                                      fontSize: 14,
                                                      color: Color(0xff243444),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Expanded(
                                                          child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                          //onPrimary: Colors.black,
                                                        ),
                                                        child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                            fontFamily: FontName
                                                                .interMedium,
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                          child: ElevatedButton(
                                                        onPressed: () {
                                                          value.generatePdf(
                                                              context,
                                                              formatBookedDate,
                                                              formatPickUpDate,
                                                              formatrecieveddate,
                                                              signature,
                                                              customerCountryName,
                                                              deliveredCountryName,
                                                              toDelCustomerName,
                                                              pickUpCustomerName,
                                                              getGeoStartedLatitude,
                                                              getGeoStartedLongitude,
                                                              getGeoDeliveredLatitude,
                                                              getGeoDeliveredLongitude,
                                                              formatGeodelivereddate);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              ThemeColor
                                                                  .themeGreenColor,
                                                        ),
                                                        child: Text(
                                                          "Yes",
                                                          style: TextStyle(
                                                            fontFamily: FontName
                                                                .interMedium,
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ))
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        );
                                      });
                              // : null;
                            },
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          margin: const EdgeInsets.only(right: 18),
                          decoration: BoxDecoration(
                            color: const Color(0xff0AAC19),
                            borderRadius: BorderRadius.all(Radius.circular(28)),
                          ),
                          child: Center(
                            child: Text(
                              //  "R",
                              Environement.initialloginname.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'InterRegular',
                                  color: Color(0xffFFFFFF)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  leading: Builder(
                    builder: (context) => Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: IconButton(
                        alignment: Alignment.centerLeft,
                        icon: Image.asset(
                          "assets/images/AppBarIcon/backarrow.png",
                          color: const Color(0xff111111),
                          height: 24,
                          width: 12,
                        ),
                        onPressed: () {
                          // value.allpageNum = 0;
                          // value.bookedpageNum = 0;
                          // value.confirmedpageNum = 0;
                          // value.deliveredpageNum = 0;
                          Provider.of<Lttechprovider>(context, listen: false)
                              .navigatetoConsignmentJob(context);

                          // provider.signatureController.clear();
                        },
                      ),
                    ),
                  )),
              body: Column(
                children: [
                  value.isLoading
                      ? Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 150.0),
                          child: CircularProgressIndicator(
                            backgroundColor: ThemeColor.themeLightGrayColor,
                            color: ThemeColor.themeGreenColor,
                          ))
                      : Container(
                          height: Platform.isIOS
                              ? SizeConfig.safeBlockVertical * 75
                              : SizeConfig.safeBlockVertical * 74,
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xffFFFFFF),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xffEEEEEE),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Color(0xffEEEEEE),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 10, left: 21),
                                            padding: EdgeInsets.all(1.0),
                                            child: Text(
                                              value.consignmentByIdresponse
                                                  .data!.jobNumber
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'InterSemiBold',
                                                  color: Color(0xff0AAC19)),
                                            ),
                                          ),
                                          value.consignmentByIdresponse.data!
                                                      .status ==
                                                  "1"
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      top: 10, left: 14),
                                                  height: 20,
                                                  width: 70,
                                                  padding: EdgeInsets.all(1),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xfffeebf0),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  3))),
                                                  child: const Text(
                                                    "Confirmed",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'InterSemiBold',
                                                      fontSize: 12,
                                                      color: Color(0xffda496c),
                                                    ),
                                                  ),
                                                )
                                              : value.consignmentByIdresponse
                                                          .data!.status ==
                                                      "2"
                                                  ? Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10, left: 14),
                                                      height: 20,
                                                      width: 62,
                                                      padding:
                                                          EdgeInsets.all(1),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xffe0f7f4),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          3))),
                                                      child: const Text(
                                                        "Delivered",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'InterSemiBold',
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xff1ebb8c),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10, left: 14),
                                                      height: 20,
                                                      width: 55,
                                                      padding:
                                                          EdgeInsets.all(1),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xfffef7e0),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          3))),
                                                      child: const Text(
                                                        "Booked",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'InterSemiBold',
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xffe58c33),
                                                        ),
                                                      ),
                                                    ),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 21, top: 12),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          // "Recipient Ref#",
                                          "Recipient",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff000000),
                                              fontFamily: 'InterSemiBold'),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 21),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          //  "SRL LAV",
                                          value.consignmentByIdresponse.data!
                                                      .customerDeliveryDetails !=
                                                  null
                                              ? value
                                                  .consignmentByIdresponse
                                                  .data!
                                                  .customerDeliveryDetails!
                                                  .customerCompanyName
                                                  .toString()
                                              : " ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff000000),
                                              fontFamily: 'InterMedium'),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 21),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 12),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Booked Date",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff000000),
                                                        fontFamily:
                                                            'InterMedium'),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 3),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    formatBookedDate,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                            Color(0xff666666),
                                                        fontFamily:
                                                            'InterRegular'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 78, top: 12),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Pickup Date",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff000000),
                                                        fontFamily:
                                                            'InterMedium'),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 78, top: 3),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    formatPickUpDate,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                            Color(0xff666666),
                                                        fontFamily:
                                                            'InterRegular'),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin: const EdgeInsets.only(left: 23),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 12),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Manifest#",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff000000),
                                                        fontFamily:
                                                            'InterMedium'),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 3),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    value
                                                        .consignmentByIdresponse
                                                        .data!
                                                        .manifestNumber
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                            Color(0xff666666),
                                                        fontFamily:
                                                            'InterRegular'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 94, top: 12),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Consignment#",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff000000),
                                                        fontFamily:
                                                            'InterMedium'),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 92, top: 3),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    value
                                                        .consignmentByIdresponse
                                                        .data!
                                                        .jobNumber
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                            Color(0xff666666),
                                                        fontFamily:
                                                            'InterRegular'),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xffFFFFFF),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xffEEEEEE),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Color(0xffEEEEEE),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 12),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 10),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                        left: 21,
                                                        bottom: 60,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "From",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xff000000),
                                                            fontFamily:
                                                                'InterSemiBold'),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 21,
                                                              bottom: 45),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "To",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xff000000),
                                                            fontFamily:
                                                                'InterSemiBold'),
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10, top: 3),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 25),
                                                      height: 13,
                                                      width: 13,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Color(
                                                              0xff0AAC19)),
                                                    ),
                                                    Dash(
                                                        direction:
                                                            Axis.vertical,
                                                        length: 73,
                                                        dashLength: 5,
                                                        dashColor:
                                                            Color(0xff0AAC19)),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 57),
                                                      height: 13,
                                                      width: 13,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              width: 1,
                                                              color: Color(
                                                                  0xff0AAC19))),
                                                      child: Container(
                                                        height: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 12),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                        left: 9,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        pickUpCustomerName,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff000000),
                                                            fontFamily:
                                                                'InterMedium'),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 9, top: 8),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        value
                                                            .consignmentByIdresponse
                                                            .data!
                                                            .customerAddress
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Color(
                                                                0xff666666),
                                                            fontFamily:
                                                                'InterRegular'),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 9, top: 3),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "${value.consignmentByIdresponse.data!.suburb}, $customerCountryName, ${value.consignmentByIdresponse.data!.zipCode}",

                                                        // "60 Leather st \nPO Box 22 \nBreakwater, Australia, 3219 \n0352982677",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Color(
                                                                0xff666666),
                                                            fontFamily:
                                                                'InterRegular'),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 9, top: 20),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        toDelCustomerName,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff000000),
                                                            fontFamily:
                                                                'InterMedium'),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 9, top: 10),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        value
                                                            .consignmentByIdresponse
                                                            .data!
                                                            .deliveryAddres
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Color(
                                                                0xff666666),
                                                            fontFamily:
                                                                'InterRegular'),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 9, top: 3),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "${value.consignmentByIdresponse.data!.deliverySuburb}, $deliveredCountryName, ${value.consignmentByIdresponse.data!.deliveryZipCode}",

                                                        // "Scotts LAVERTON \n99-103 William Angliss Dr \nLaverton North, Australia, 3026",
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Color(
                                                                0xff666666),
                                                            fontFamily:
                                                                'InterRegular'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: value.consignmentByIdresponse.data
                                          ?.consignmentDetails?.length ??
                                      0,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Color(0xffFFFFFF),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0xffEEEEEE),
                                            blurRadius: 3.0,
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Color(0xffEEEEEE),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Column(
                                              children: [
                                                Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                          dividerColor: Colors
                                                              .transparent),
                                                  child: ExpansionTile(
                                                    key: Key(index.toString()),
                                                    collapsedIconColor:
                                                        ThemeColor
                                                            .themeGreenColor,
                                                    title: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "Senders Reference",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Color(
                                                                0xff000000),
                                                            fontFamily:
                                                                'InterSemiBold'),
                                                      ),
                                                    ),
                                                    subtitle: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        value
                                                            .consignmentByIdresponse
                                                            .data!
                                                            .consignmentDetails![
                                                                index]
                                                            .sendersNo
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff000000),
                                                            fontFamily:
                                                                'InterMedium'),
                                                      ),
                                                    ),
                                                    children: <Widget>[
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 21),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          value
                                                              .consignmentByIdresponse
                                                              .data!
                                                              .consignmentDetails![
                                                                  index]
                                                              .freightDesc
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xff666666),
                                                              fontFamily:
                                                                  'InterMedium'),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 21),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 12),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    "Items",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Color(
                                                                            0xff000000),
                                                                        fontFamily:
                                                                            'InterMedium'),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 3),
                                                                  child: Text(
                                                                    value
                                                                        .consignmentByIdresponse
                                                                        .data!
                                                                        .consignmentDetails![
                                                                            index]
                                                                        .noOfItems
                                                                        .toString(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .justify,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Color(
                                                                            0xff666666),
                                                                        fontFamily:
                                                                            'InterRegular'),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 85,
                                                                      top: 12),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    "Pallets",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Color(
                                                                            0xff000000),
                                                                        fontFamily:
                                                                            'InterMedium'),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 85,
                                                                      top: 3),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    value
                                                                        .consignmentByIdresponse
                                                                        .data!
                                                                        .consignmentDetails![
                                                                            index]
                                                                        .pallets
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Color(
                                                                            0xff666666),
                                                                        fontFamily:
                                                                            'InterRegular'),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 85,
                                                                      top: 12),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    "Spaces",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Color(
                                                                            0xff000000),
                                                                        fontFamily:
                                                                            'InterMedium'),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 85,
                                                                      top: 3),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    value
                                                                        .consignmentByIdresponse
                                                                        .data!
                                                                        .consignmentDetails![
                                                                            index]
                                                                        .spaces
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Color(
                                                                            0xff666666),
                                                                        fontFamily:
                                                                            'InterRegular'),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 21,
                                                            bottom: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 12),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    "Weight(KG)",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Color(
                                                                            0xff000000),
                                                                        fontFamily:
                                                                            'InterMedium'),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 3),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    value
                                                                        .consignmentByIdresponse
                                                                        .data!
                                                                        .consignmentDetails![
                                                                            index]
                                                                        .weight
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Color(
                                                                            0xff666666),
                                                                        fontFamily:
                                                                            'InterRegular'),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 45,
                                                                      top: 12),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    "Job Temp",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Color(
                                                                            0xff000000),
                                                                        fontFamily:
                                                                            'InterMedium'),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 45,
                                                                      top: 3),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    value
                                                                        .consignmentByIdresponse
                                                                        .data!
                                                                        .consignmentDetails![
                                                                            index]
                                                                        .jobTemp
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Color(
                                                                            0xff666666),
                                                                        fontFamily:
                                                                            'InterRegular'),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                    onExpansionChanged:
                                                        (bool expanding) {},
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Divider(
                                          //   height: 1,
                                          //   color: Color(0xff7A7A7A),
                                          // ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xffFFFFFF),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xffEEEEEE),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Color(0xffEEEEEE),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 21, top: 19),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Equipment",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff000000),
                                                    fontFamily:
                                                        'InterSemiBold'),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 21),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 12),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Chep",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontFamily:
                                                                  'InterMedium'),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 3),
                                                        child: Text(
                                                          value
                                                              .consignmentByIdresponse
                                                              .data!
                                                              .chep
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.justify,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Color(
                                                                  0xff666666),
                                                              fontFamily:
                                                                  'InterRegular'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 120, top: 12),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Loscom",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontFamily:
                                                                  'InterMedium'),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                          left: 120,
                                                          top: 3,
                                                        ),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          value
                                                              .consignmentByIdresponse
                                                              .data!
                                                              .loscom
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Color(
                                                                  0xff666666),
                                                              fontFamily:
                                                                  'InterRegular'),
                                                          softWrap: false,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 21),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 12),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Other",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontFamily:
                                                                  'InterMedium'),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 3),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          value
                                                              .consignmentByIdresponse
                                                              .data!
                                                              .plain
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Color(
                                                                  0xff666666),
                                                              fontFamily:
                                                                  'InterRegular'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Container(
                                  height:
                                      // provider.isSaveButtonVisible == true
                                      //     ? 210
                                      161,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xffFFFFFF),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xffEEEEEE),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Color(0xffEEEEEE),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 21, top: 19),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Received By",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff000000),
                                                    fontFamily:
                                                        'InterSemiBold'),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 21),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                toDelCustomerName,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xff000000),
                                                    fontFamily: 'InterMedium'),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 21),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 12),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Date",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontFamily:
                                                                  'InterMedium'),
                                                        ),
                                                      ),
                                                      value.consignmentByIdresponse
                                                                  .data!.status ==
                                                              "2"
                                                          ? Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 3),
                                                              child: Text(
                                                                formatrecieveddate,
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Color(
                                                                        0xff666666),
                                                                    fontFamily:
                                                                        'InterRegular'),
                                                              ),
                                                            )
                                                          : Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 3),
                                                              child: Text(
                                                                "-",
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Color(
                                                                        0xff666666),
                                                                    fontFamily:
                                                                        'InterRegular'),
                                                              ),
                                                            ),
                                                      value.consignmentByIdresponse
                                                                  .data!.status ==
                                                              "2"
                                                          ? Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 12),
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                "${value.consignmentByIdresponse.data!.endLatitude.toString() ?? "-"}\n${value.consignmentByIdresponse.data!.endLongitude.toString() ?? "-"}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        0xff000000),
                                                                    fontFamily:
                                                                        'InterMedium'),
                                                              ),
                                                            )
                                                          : Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 12),
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                "${"0.0"}\n${"0.0"}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        0xff000000),
                                                                    fontFamily:
                                                                        'InterMedium'),
                                                              ),
                                                            )
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 118,
                                                                  right: 12),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: value
                                                                      .consignmentByIdresponse
                                                                      .data!
                                                                      .status ==
                                                                  "2"
                                                              ? Container(
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child: Text(
                                                                    "Signature",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'InterMedium'),
                                                                  ),
                                                                )
                                                              : Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  height: 33.0,
                                                                  width: 105,
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    bottom: 5.0,
                                                                  ),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: ThemeColor
                                                                        .themeGreenColor,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey,
                                                                        blurRadius:
                                                                            3.0,
                                                                        offset: Offset(
                                                                            2,
                                                                            3.0),
                                                                      ),
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      TextButton(
                                                                        child:
                                                                            Text(
                                                                          "Signature",
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                              color: Colors.white,
                                                                              fontFamily: 'InterBold'),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          // value.isSaveButtonVisible =
                                                                          //     true;
                                                                          value.isConsignmentDetail =
                                                                              true;
                                                                          // value.addSignature(
                                                                          //     signature);

                                                                          Navigator.of(context).push(MaterialPageRoute(
                                                                              builder: (context) => lltechSignatureView(index: index)

                                                                              // SignatureWidget(
                                                                              // context:
                                                                              //     context,
                                                                              // index:
                                                                              //     index,
                                                                              // consignmentid: provider
                                                                              //     .consignmentByIdresponse
                                                                              //     .data!
                                                                              //     .consignmentId)
                                                                              ));
                                                                        },
                                                                      ),
                                                                      Icon(
                                                                          Icons
                                                                              .arrow_forward_outlined,
                                                                          color: Colors
                                                                              .white,
                                                                          size:
                                                                              16),
                                                                    ],
                                                                  ),
                                                                )),
                                                      Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 90,
                                                            right: 14),
                                                        child: ClipRRect(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50,
                                                            width: 105,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey)),
                                                            child: value
                                                                        .consignmentByIdresponse
                                                                        .data!
                                                                        .status ==
                                                                    "2"
                                                                // ? Text(bytesToHex(
                                                                //     uint8list))
                                                                // ? CustomPaint(
                                                                //     painter:
                                                                //         SignaturePainter(
                                                                //             signaturePoints),
                                                                // )

                                                                ? Image.memory(

                                                                    // base64.decode(value
                                                                    //         .consignmentByIdresponse
                                                                    //         .data!
                                                                    //         .signature
                                                                    //         .toString(),
                                                                    // ),
                                                                    // base64Decode(value
                                                                    //     .consignmentByIdresponse
                                                                    //     .data!
                                                                    //     .signature
                                                                    //     .toString()))

                                                                    ApiCounter
                                                                        .consignmentSignImageBytes)
                                                                //               ? Text(
                                                                //     signatureData,
                                                                //   textAlign:
                                                                //   TextAlign
                                                                //       .center,
                                                                //   style: TextStyle(
                                                                //       fontSize:
                                                                //       14,
                                                                //       color: Colors
                                                                //           .black,
                                                                //       fontFamily:
                                                                //       'InterMedium'),
                                                                // )
                                                                : Text(
                                                                    "No Signature",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'InterMedium'),
                                                                  ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                value.consignmentByIdresponse.data!.status ==
                                        "2"
                                    ? Container(
                                        height: 250,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Color(0xffFFFFFF),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0xffEEEEEE),
                                              blurRadius: 3.0,
                                            ),
                                          ],
                                          border: Border.all(
                                            color: Color(0xffEEEEEE),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 21, top: 19),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Geo Location Log",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Color(0xff000000),
                                                          fontFamily:
                                                              'InterSemiBold'),
                                                    ),
                                                  ),
                                                  if (provider.getGeoLocationobj
                                                      .data.rows.isEmpty)
                                                    Container(
                                                      margin:
                                                          EdgeInsets.all(70),
                                                      child: Center(
                                                        child: Text(
                                                            "No data available!",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: ThemeColor
                                                                    .themeGreenColor,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'InterMedium')),
                                                      ),
                                                    )
                                                  else
                                                    Container(
                                                      height: 200,
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemCount: provider
                                                              .getGeoLocationobj
                                                              .data
                                                              .rows
                                                              .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            delivereddate = provider
                                                                .getGeoLocationobj
                                                                .data
                                                                .rows[index]
                                                                .geoDate;

                                                            getGeoStartedLatitude =
                                                                double.tryParse(provider
                                                                    .getGeoLocationobj
                                                                    .data
                                                                    .rows[index]
                                                                    .startedLatitude
                                                                    .toString());

                                                            getGeoStartedLongitude =
                                                                double.tryParse(provider
                                                                    .getGeoLocationobj
                                                                    .data
                                                                    .rows[index]
                                                                    .startedLongitude
                                                                    .toString());

                                                            getGeoDeliveredLatitude =
                                                                double.tryParse(provider
                                                                    .getGeoLocationobj
                                                                    .data
                                                                    .rows[index]
                                                                    .deliveredLatitude
                                                                    .toString());

                                                            getGeoDeliveredLongitude =
                                                                double.tryParse(provider
                                                                    .getGeoLocationobj
                                                                    .data
                                                                    .rows[index]
                                                                    .deliveredLongitude
                                                                    .toString());
                                                            // print(
                                                            //     "getGeoStartedLatitude:$getGeoStartedLatitude");
                                                            // print(
                                                            //     "getGeoStartedLongitude:$getGeoStartedLongitude");
                                                            // print(
                                                            //"delivereddate:$delivereddate");
                                                            formatdelivereddate =
                                                                DateFormat(
                                                                        "dd MMMM,yyyy – kk:mm a")
                                                                    .format(
                                                                        delivereddate!);
                                                            formatGeodelivereddate =
                                                                DateFormat(
                                                                        "dd MMMM,yyyy \nkk:mm a")
                                                                    .format(
                                                                        delivereddate!);

                                                            //  print(
                                                            //     "formatdelivereddate:${formatdelivereddate}");
                                                            return Column(
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              21),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <Widget>[
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(top: 12),
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                Text(
                                                                              "${getGeoStartedLatitude ?? "${value.currentPosition.latitude}"}\n${getGeoStartedLongitude ?? "${value.currentPosition.longitude}"}",
                                                                              textAlign: TextAlign.justify,
                                                                              style: TextStyle(fontSize: 14, color: Color(0xff000000), fontFamily: 'InterMedium'),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: <Widget>[
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                      margin: const EdgeInsets.only(top: 12),
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Date & Time",
                                                                                        style: TextStyle(fontSize: 14, color: Color(0xff000000), fontFamily: 'InterMedium'),
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      margin: const EdgeInsets.only(top: 3),
                                                                                      child: Text(
                                                                                        formatdelivereddate.toString(),
                                                                                        //provider.getGeoLocationobj.data.rows[index].geoDate.toString(),
                                                                                        // currentDate,
                                                                                        textAlign: TextAlign.justify,
                                                                                        style: TextStyle(fontSize: 13, color: Color(0xff666666), fontFamily: 'InterRegular'),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Spacer(),
                                                                      getGeoStartedLatitude! > 0.0 &&
                                                                              getGeoStartedLongitude! > 0.0
                                                                          ? Container(
                                                                              child: IconButton(
                                                                                alignment: Alignment.centerLeft,
                                                                                icon: Image.asset(
                                                                                  "assets/images/ConsignmentIcon/geoloaction.png",
                                                                                  color: const Color(0xff0AAC19),
                                                                                  height: 24,
                                                                                  width: 27,
                                                                                ),
                                                                                onPressed: () {
                                                                                  // provider.navigatetolocation(context);
                                                                                  Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(builder: (context) => MapBoxLocation(latitude: getGeoStartedLatitude, longitude: getGeoStartedLongitude)),
                                                                                  );
                                                                                },
                                                                              ),
                                                                            )
                                                                          : Container(
                                                                              child: IconButton(
                                                                                alignment: Alignment.centerLeft,
                                                                                icon: Image.asset(
                                                                                  "assets/images/ConsignmentIcon/geoloaction.png",
                                                                                  color: Colors.grey,
                                                                                  height: 24,
                                                                                  width: 27,
                                                                                ),
                                                                                onPressed: () {
                                                                                  Fluttertoast.showToast(msg: "Location not found!", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 13.0);
                                                                                },
                                                                              ),
                                                                            ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              21),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <Widget>[
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(top: 12),
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                Text(
                                                                              "${getGeoDeliveredLatitude ?? "${value.currentPosition.latitude}"}\n${getGeoDeliveredLongitude ?? "${value.currentPosition.longitude}"}",
                                                                              textAlign: TextAlign.justify,
                                                                              style: TextStyle(fontSize: 14, color: Color(0xff000000), fontFamily: 'InterMedium'),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: <Widget>[
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                      margin: const EdgeInsets.only(top: 12),
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Date & Time",
                                                                                        style: TextStyle(fontSize: 14, color: Color(0xff000000), fontFamily: 'InterMedium'),
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      margin: const EdgeInsets.only(top: 3),
                                                                                      child: Text(
                                                                                        formatdelivereddate,
                                                                                        // provider.consignmentdeliveredDate ??
                                                                                        //     "-",
                                                                                        // provider.getGeoLocationobj.data!.rows![index].geoDate.toString(),
                                                                                        textAlign: TextAlign.justify,
                                                                                        style: TextStyle(fontSize: 13, color: Color(0xff666666), fontFamily: 'InterRegular'),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Spacer(),
                                                                      getGeoDeliveredLatitude! > 0.0 &&
                                                                              getGeoDeliveredLongitude! > 0.0
                                                                          ? Container(
                                                                              child: IconButton(
                                                                                alignment: Alignment.centerLeft,
                                                                                icon: Image.asset(
                                                                                  "assets/images/ConsignmentIcon/geoloaction.png",
                                                                                  color: const Color(0xff0AAC19),
                                                                                  height: 24,
                                                                                  width: 27,
                                                                                ),
                                                                                onPressed: () async {
                                                                                  //provider.navigatetolocation(context);
                                                                                  Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(builder: (context) => MapBoxLocation(latitude: getGeoDeliveredLatitude, longitude: getGeoDeliveredLongitude)),
                                                                                  );
                                                                                },
                                                                                // onPressed:value.openMap(value.destinationLatitude,value.destinationLongitude),
                                                                              ),
                                                                            )
                                                                          : Container(
                                                                              child: IconButton(
                                                                                alignment: Alignment.centerLeft,
                                                                                icon: Image.asset(
                                                                                  "assets/images/ConsignmentIcon/geoloaction.png",
                                                                                  color: Colors.grey,
                                                                                  height: 24,
                                                                                  width: 27,
                                                                                ),
                                                                                onPressed: () async {
                                                                                  Fluttertoast.showToast(msg: "Location not found!", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 13.0);
                                                                                },
                                                                                // onPressed:value.openMap(value.destinationLatitude,value.destinationLongitude),
                                                                              ),
                                                                            ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : value.consignmentByIdresponse.data!
                                                .status ==
                                            "0"
                                        ? Container(
                                            height: 250,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Color(0xffFFFFFF),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xffEEEEEE),
                                                  blurRadius: 3.0,
                                                ),
                                              ],
                                              border: Border.all(
                                                color: Color(0xffEEEEEE),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 21, top: 19),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Geo Location Log",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontFamily:
                                                                  'InterSemiBold'),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 21),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 12),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    "${provider.currentPosition.latitude ?? "-"}\n${provider.currentPosition.longitude ?? "-"}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .justify,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Color(
                                                                            0xff000000),
                                                                        fontFamily:
                                                                            'InterMedium'),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <Widget>[
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(top: 12),
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                Text(
                                                                              "Date & Time",
                                                                              style: TextStyle(fontSize: 14, color: Color(0xff000000), fontFamily: 'InterMedium'),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(top: 3),
                                                                            child:
                                                                                Text(
                                                                              formatGeoDate,
                                                                              textAlign: TextAlign.justify,
                                                                              style: TextStyle(fontSize: 13, color: Color(0xff666666), fontFamily: 'InterRegular'),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Spacer(),
                                                            provider.currentPosition!
                                                                            .latitude >
                                                                        0.0 &&
                                                                    provider.currentPosition!
                                                                            .longitude >
                                                                        0.0
                                                                ? Container(
                                                                    child:
                                                                        IconButton(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      icon: Image
                                                                          .asset(
                                                                        "assets/images/ConsignmentIcon/geoloaction.png",
                                                                        color: const Color(
                                                                            0xff0AAC19),
                                                                        height:
                                                                            24,
                                                                        width:
                                                                            27,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        // provider
                                                                        //     .navigatetolocation(
                                                                        //         context);
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => MapBoxLocation(latitude: provider.currentPosition.latitude, longitude: provider.currentPosition.longitude)),
                                                                        );
                                                                      },
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    child:
                                                                        IconButton(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      icon: Image
                                                                          .asset(
                                                                        "assets/images/ConsignmentIcon/geoloaction.png",
                                                                        color: Colors
                                                                            .grey,
                                                                        height:
                                                                            24,
                                                                        width:
                                                                            27,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                "Location not found!",
                                                                            toastLength: Toast
                                                                                .LENGTH_LONG,
                                                                            gravity: ToastGravity
                                                                                .BOTTOM,
                                                                            timeInSecForIosWeb:
                                                                                1,
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                            textColor: Colors.white,
                                                                            fontSize: 13.0);
                                                                      },
                                                                    ),
                                                                  ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 21),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 12),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    "${"0.0"}\n${"0.0"}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .justify,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Color(
                                                                            0xff000000),
                                                                        fontFamily:
                                                                            'InterMedium'),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <Widget>[
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(top: 12),
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                Text(
                                                                              "Date & Time",
                                                                              style: TextStyle(fontSize: 14, color: Color(0xff000000), fontFamily: 'InterMedium'),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(top: 3),
                                                                            child:
                                                                                Text(
                                                                              provider.consignmentdeliveredDate ?? "-",
                                                                              textAlign: TextAlign.justify,
                                                                              style: TextStyle(fontSize: 13, color: Color(0xff666666), fontFamily: 'InterRegular'),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Spacer(),
                                                            Container(
                                                              child: IconButton(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                icon:
                                                                    Image.asset(
                                                                  "assets/images/ConsignmentIcon/geoloaction.png",
                                                                  color: Colors
                                                                      .grey,
                                                                  height: 24,
                                                                  width: 27,
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  Fluttertoast.showToast(
                                                                      msg:
                                                                          "Please get the signature\nsigned first",
                                                                      toastLength:
                                                                          Toast
                                                                              .LENGTH_LONG,
                                                                      gravity: ToastGravity
                                                                          .BOTTOM,
                                                                      timeInSecForIosWeb:
                                                                          1,
                                                                      backgroundColor:
                                                                          ThemeColor
                                                                              .themeGreenColor,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          13.0);
                                                                },
                                                                // onPressed:value.openMap(value.destinationLatitude,value.destinationLongitude),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(
                                            height: 250,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Color(0xffFFFFFF),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xffEEEEEE),
                                                  blurRadius: 3.0,
                                                ),
                                              ],
                                              border: Border.all(
                                                color: Color(0xffEEEEEE),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 21, top: 19),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Geo Location Log",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontFamily:
                                                                  'InterSemiBold'),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 21),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 12),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    "${provider.currentPosition!.latitude ?? "-"}\n${provider.currentPosition!.longitude ?? "-"}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .justify,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Color(
                                                                            0xff000000),
                                                                        fontFamily:
                                                                            'InterMedium'),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <Widget>[
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(top: 12),
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                Text(
                                                                              "Date & Time",
                                                                              style: TextStyle(fontSize: 14, color: Color(0xff000000), fontFamily: 'InterMedium'),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(top: 3),
                                                                            child:
                                                                                Text(
                                                                              formatGeoDate,
                                                                              textAlign: TextAlign.justify,
                                                                              style: TextStyle(fontSize: 13, color: Color(0xff666666), fontFamily: 'InterRegular'),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Spacer(),
                                                            provider.currentPosition!
                                                                            .latitude >
                                                                        0.0 &&
                                                                    provider.currentPosition!
                                                                            .longitude >
                                                                        0.0
                                                                ? Container(
                                                                    child:
                                                                        IconButton(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      icon: Image
                                                                          .asset(
                                                                        "assets/images/ConsignmentIcon/geoloaction.png",
                                                                        color: const Color(
                                                                            0xff0AAC19),
                                                                        height:
                                                                            24,
                                                                        width:
                                                                            27,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        // provider
                                                                        //     .navigatetolocation(
                                                                        //         context);
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => MapBoxLocation(latitude: provider.currentPosition.latitude, longitude: provider.currentPosition.longitude)),
                                                                        );
                                                                      },
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    child:
                                                                        IconButton(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      icon: Image
                                                                          .asset(
                                                                        "assets/images/ConsignmentIcon/geoloaction.png",
                                                                        color: Colors
                                                                            .grey,
                                                                        height:
                                                                            24,
                                                                        width:
                                                                            27,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                "Location not found!",
                                                                            toastLength: Toast
                                                                                .LENGTH_LONG,
                                                                            gravity: ToastGravity
                                                                                .BOTTOM,
                                                                            timeInSecForIosWeb:
                                                                                1,
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                            textColor: Colors.white,
                                                                            fontSize: 13.0);
                                                                      },
                                                                    ),
                                                                  ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 21),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 12),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    "${value.deliveredLatitude ?? "-"}\n${value.deliveredLongitude ?? "-"}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .justify,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Color(
                                                                            0xff000000),
                                                                        fontFamily:
                                                                            'InterMedium'),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <Widget>[
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(top: 12),
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                Text(
                                                                              "Date & Time",
                                                                              style: TextStyle(fontSize: 14, color: Color(0xff000000), fontFamily: 'InterMedium'),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(top: 3),
                                                                            child:
                                                                                Text(
                                                                              provider.consignmentdeliveredDate ?? "-",
                                                                              textAlign: TextAlign.justify,
                                                                              style: TextStyle(fontSize: 13, color: Color(0xff666666), fontFamily: 'InterRegular'),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Spacer(),
                                                            Visibility(
                                                              visible: value
                                                                  .isDeliveredLocationOn,
                                                              child: Container(
                                                                child:
                                                                    IconButton(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  icon: Image
                                                                      .asset(
                                                                    "assets/images/ConsignmentIcon/geoloaction.png",
                                                                    color: const Color(
                                                                        0xff0AAC19),
                                                                    height: 24,
                                                                    width: 27,
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    // provider.initializeMap(
                                                                    //     value
                                                                    //         .deliveredLatitude,
                                                                    //     value
                                                                    //         .deliveredLongitude);

                                                                    provider.navigatetolocation(
                                                                        context);
                                                                  },
                                                                  // onPressed:value.openMap(value.destinationLatitude,value.destinationLongitude),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                SizedBox(
                                  height: 7,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xffFFFFFF),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xffEEEEEE),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Color(0xffEEEEEE),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 21, top: 15),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Additional Docs",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff000000),
                                                    fontFamily:
                                                        'InterSemiBold'),
                                              ),
                                            ),
                                            Container(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: value
                                                        .consignmentByIdresponse
                                                        .data
                                                        ?.truckDetails
                                                        .length ??
                                                    0,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  String? docFile = value
                                                      .consignmentByIdresponse
                                                      .data
                                                      ?.truckDetails[index]
                                                      .document;
                                                  print("docFile:$docFile");
                                                  String fileName =
                                                      docFile!.split('/').last;
                                                  print("fileName:$fileName");
                                                  String extension =
                                                      p.extension(docFile);
                                                  // print(
                                                  // "extension:$extension");
                                                  return Container(
                                                      margin: EdgeInsets.only(
                                                          left: 15, right: 15),
                                                      child:
                                                          docFile.isNotEmpty ==
                                                                  true
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <Widget>[
                                                                    extension ==
                                                                            ".pdf"
                                                                        ? Container(
                                                                            child:
                                                                                IconButton(
                                                                              alignment: Alignment.centerLeft,
                                                                              icon: Image.asset(
                                                                                "assets/images/pdf_icon.png",
                                                                                color: const Color(0xff0AAC19),
                                                                                height: 24,
                                                                                width: 27,
                                                                              ),
                                                                              onPressed: () {},
                                                                            ),
                                                                          )
                                                                        : Container(
                                                                            child:
                                                                                IconButton(
                                                                              alignment: Alignment.centerLeft,
                                                                              icon: SvgPicture.asset(
                                                                                "assets/images/jpeg.svg",
                                                                                color: const Color(0xff0AAC19),
                                                                                height: 24,
                                                                                width: 27,
                                                                              ),
                                                                              onPressed: () {},
                                                                            ),
                                                                          ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                10,
                                                                            bottom:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          fileName,
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Color(0xff000000),
                                                                              fontFamily: 'InterMedium'),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // Column(
                                                                    //   crossAxisAlignment:
                                                                    //       CrossAxisAlignment
                                                                    //           .start,
                                                                    //   children: [
                                                                    //
                                                                    //     // Container(
                                                                    //     //   margin: const EdgeInsets.only(
                                                                    //     //       top: 10,
                                                                    //     //       bottom: 5),
                                                                    //     //   width:
                                                                    //     //       200,
                                                                    //     //   alignment:
                                                                    //     //       Alignment.centerLeft,
                                                                    //     //   child:
                                                                    //     //
                                                                    //     // ),
                                                                    //     // Container(
                                                                    //     //   child:
                                                                    //     //       Text(
                                                                    //     //     "20 Jan, 2022 - 09:10 PM",
                                                                    //     //     textAlign:
                                                                    //     //         TextAlign.justify,
                                                                    //     //     style: TextStyle(
                                                                    //     //         fontSize: 13,
                                                                    //     //         color: Color(0xff666666),
                                                                    //     //         fontFamily: 'InterRegular'),
                                                                    //     //   ),
                                                                    //     // ),
                                                                    //   ],
                                                                    // ),
                                                                    Spacer(),
                                                                    Container(
                                                                      child: docFile.isNotEmpty ==
                                                                              true
                                                                          ? IconButton(
                                                                              alignment: Alignment.centerLeft,
                                                                              icon: Icon(Icons.remove_red_eye_outlined),
                                                                              onPressed: () {
                                                                                final docurl = Endpoints.docbaseurl + docFile;
                                                                                print("docurl:$docurl");

                                                                                Platform.isAndroid
                                                                                    ? provider.viewpdf(docurl, fileName)
                                                                                    : Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute<dynamic>(
                                                                                          builder: (_) => PDFViewerFromUrl(
                                                                                            url: docurl,
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                              },
                                                                            )
                                                                          : null,
                                                                    ),
                                                                  ],
                                                                )
                                                              : Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              6,
                                                                          top:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                  child: Text(
                                                                      "No document found!",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color: Colors
                                                                              .red,
                                                                          fontFamily:
                                                                              'InterMedium')),
                                                                ));
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
              bottomNavigationBar: bottomappbar(value, context));
        }),
      ),
    );
  }

  String bytesToHex(Uint8List bytes) {
    return bytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join('');
  }

  List<Point> convertToPoints(List<int> signaturePoints) {
    List<Point> points = [];
    for (int i = 0; i < signaturePoints.length; i += 2) {
      int x = signaturePoints[i];
      int y = signaturePoints[i + 1];
      points.add(Point(x.toDouble(), y.toDouble()));
    }
    //if signaturePoints list had odd length,add the last point separately
    if (signaturePoints.length % 2 != 0) {
      int lastX = signaturePoints.last;
      points.add(Point(lastX.toDouble(), 0));
    }
    return points;
  }

// addgeolocationapi(Lttechprovider value, BuildContext context) {
//   value.addGeoLocationRequestObj[].consignmentId =
//       value.consignmentByIdresponse[].data!.consignmentId.toString();
//   value.addGeoLocationRequestObj[].driverId = Environement.driverID;
//   value.addGeoLocationRequestObj[].startedLatitude =
//       value.currentPosition.latitude.toString();
//   value.addGeoLocationRequestObj[].startedLongitude =
//       value.currentPosition.longitude.toString();
//   value.addGeoLocationRequestObj[].deliveredLatitude =
//       value.deliveredLatitude.toString();
//   value.addGeoLocationRequestObj[].deliveredLongitude =
//       value.deliveredLongitude.toString();
//   value.addGeoLocationRequestObj[].geoDate = DateTime.now();
//
//   value.addGeoLocationRequest(value.addGeoLocationRequestObj, context);
// }
}

class SignaturePainter extends CustomPainter {
  final List<Point> signaturePoints;

  SignaturePainter(this.signaturePoints);

  @override
  void paint(Canvas canvas, Size size) {
    if (signaturePoints.length < 2) {
      return;
    }

    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    // double pointX = 0;
    // double pointY = size.height / 2;
    for (int i = 0; i < signaturePoints.length - 1; i++) {
      Point startPoint = signaturePoints[i];
      Point endPoint = signaturePoints[i + 1];

      double maxX = signaturePoints
          .map((e) => e.x)
          .reduce((curr, next) => curr > next ? curr : next);
      double maxY = signaturePoints
          .map((e) => e.y)
          .reduce((curr, next) => curr > next ? curr : next);

      Offset startOffset = Offset(
          startPoint.x * size.width / maxX, startPoint.y * size.height / maxY);
      Offset endOffset = Offset(
          endPoint.x * size.width / maxX, endPoint.y * size.height / maxY);
      // double offsetY = bytes / 255 * size.height;
      //  if (startPoint != null && endPoint != null) {
      canvas.drawLine(startOffset, endOffset, paint);
      // canvas.drawLine(startPoint, endPoint, paint);
      // }

      // pointX++;
      // pointY = offsetY;
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) {
    return oldDelegate.signaturePoints != signaturePoints;
  }
}

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);
}
