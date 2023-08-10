import 'dart:async';
import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lttechapp/entity/ApiRequests/AddConsignmentRequest.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/ColorTheme.dart';
import 'package:lttechapp/utility/CustomTextStyle.dart';
import 'package:lttechapp/utility/SizeConfig.dart';
import 'package:lttechapp/utility/appbarWidget.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../entity/ApiRequests/AddDocumentRequest.dart';
import '../../../entity/GetDocTypeResponse.dart';
import '../../../utility/Constant/endpoints.dart';
import '../../../utility/PDFViewerFromUrl.dart';
import '../../../utility/StatefulWrapper.dart';
import '../../../utility/env.dart';

String getFileName(String _path) {
  String fileName = path.basename(_path);
  print("fileName:$fileName");

  return fileName;
}

class AddDocument extends StatelessWidget {
  AddDocument({super.key});

  final _formKey = GlobalKey<FormState>();
  var _email;
  String fileext = path.split('/').last;
  String docUrl = '';
  String fileName = '';
  DocTypeData? _docTypeData; //"Aadhar Card";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SizeConfig().init(context);
    Future<bool> _onWillPop() async {
      print("back called");
      Provider.of<Lttechprovider>(context, listen: false)
          .navigatetoDocManager(context);

      return true;
    }

    return StatefulWrapper(
      onInit: () {
        Future.delayed(Duration.zero, () {
          final provider = Provider.of<Lttechprovider>(context, listen: false);
          provider.getDocTypeListRequest(
            companyID: Environement.companyID,
          );
          // provider.getDocManagerListRequest();
        });
      },
      child: WillPopScope(
        onWillPop: null, //_onWillPop,
        child: Scaffold(
            appBar: defaultAppBar(),
            body: Consumer<Lttechprovider>(builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  provider.isUpdateDocumentType
                      ? Container(
                          margin: const EdgeInsets.only(
                              left: 20, top: 5, bottom: 27),
                          height: 29,
                          width: 270,
                          child: Text(
                            "Edit Document",
                            style: TextStyle(
                                fontSize: 24,
                                color: Color(0xff000000),
                                fontFamily: FontName.interBold),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(
                              left: 20, top: 5, bottom: 27),
                          height: 29,
                          width: 270,
                          child: Text(
                            "Add Document",
                            style: TextStyle(
                                fontSize: 24,
                                color: Color(0xff000000),
                                fontFamily: FontName.interBold),
                          ),
                        ),
                  provider.isLoading
                      ? Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 150.0),
                          child: CircularProgressIndicator(
                            backgroundColor: ThemeColor.themeLightGrayColor,
                            color: ThemeColor.themeGreenColor,
                          ))
                      : Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
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
                            width: double.infinity,
                            height: Platform.isIOS
                                ? SizeConfig.safeBlockVertical * 75
                                : SizeConfig.safeBlockVertical * 74,
                            child: CustomScrollView(
                              slivers: [
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: const Text(
                                            "Document Details",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontFamily: FontName.interBold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 15, bottom: 5),
                                          child: const Text(
                                            "Document Type",
                                            textAlign: TextAlign.left,
                                            style: FillTimeSheetCustomTS
                                                .tfTitleLabelTS,
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0xffD4D4D4),
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: Color(0xffFAFAFA),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 5),
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 10),
                                          child: provider.getDocTypeResponseObj
                                                      .data !=
                                                  null
                                              ? DropdownButton(
                                                  isExpanded: true,
                                                  value: _docTypeData,
                                                  hint: _docTypeData == null
                                                      ? Text(
                                                          "Select document type")
                                                      : Text(_docTypeData
                                                              ?.documentType ??
                                                          ""),
                                                  // Down Arrow Icon
                                                  icon: const Icon(Icons
                                                      .keyboard_arrow_down),
                                                  underline: SizedBox(),
                                                  items: provider
                                                      .getDocTypeResponseObj
                                                      .data!
                                                      .map((doc) {
                                                    return DropdownMenuItem<
                                                        DocTypeData>(
                                                      value: doc,
                                                      child: Text(
                                                        doc.documentType ?? "",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            height: 1,
                                                            fontFamily: FontName
                                                                .interRegular),
                                                      ), //value of item
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    _docTypeData = value!;
                                                    provider.docTypeDataObj =
                                                        value;
                                                    provider.setUpdateView =
                                                        true;
                                                  },
                                                )
                                              : SizedBox(),
                                        ),
                                        const Text(
                                          "Document Number",
                                          textAlign: TextAlign.left,
                                          style: FillTimeSheetCustomTS
                                              .tfTitleLabelTS,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 5, bottom: 15),
                                          child: TextFormField(
                                            autocorrect: false,
                                            keyboardType: TextInputType.text,
                                            controller:
                                                provider.docNumberController,
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: const InputDecoration(
                                              filled: true,
                                              fillColor: ThemeColor
                                                  .themeLightWhiteColor,
                                              isDense: true,
                                              //contentPadding:
                                              // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ThemeColor
                                                        .themeLightGrayColor),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ThemeColor
                                                        .themeLightGrayColor),
                                              ),
                                            ),
                                            onSaved: (String? value) {},
                                            validator: (input) => input!
                                                    .isNotEmpty
                                                ? null
                                                : "Please enter Document Number",
                                          ),
                                        ),
                                        const Text(
                                          "Upload Document (Jpg,png,jpeg,pdf)",
                                          textAlign: TextAlign.left,
                                          style: FillTimeSheetCustomTS
                                              .tfTitleLabelTS,
                                        ),
                                        Container(
                                          height: 80,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0xffD4D4D4),
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: Color(0xffFAFAFA),
                                          ),
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 13),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xffFAFAFA),
                                              foregroundColor: ThemeColor
                                                  .themeLightGrayColor,
                                              elevation: 0,
                                            ),
                                            onPressed: () {
                                              // Provider.of<Lttechprovider>(context,
                                              //         listen: false)
                                              //     .uploadDocApiRequest(context);
                                              provider.pickFiles();
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                  "assets/images/browse_file_icon.png",
                                                  width: 28,
                                                  height: 22,
                                                  color: ThemeColor
                                                      .themeDarkGreyColor,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ), // icon
                                                Text(
                                                  "Browse files",
                                                  textAlign: TextAlign.center,
                                                  style: FillTimeSheetCustomTS
                                                      .tfTitleLabelTS,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Files uploading",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontFamily: FontName.interMedium,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    final docurl =
                                                        Endpoints.docbaseurl +
                                                            docUrl;
                                                    print(
                                                        path.extension(docUrl));
                                                    if (path.extension(
                                                                docUrl) ==
                                                            ".jpeg" ||
                                                        path.extension(
                                                                docUrl) ==
                                                            ".png") {
                                                      final imageProvider =
                                                          Image.network(docurl)
                                                              .image;
                                                      showImageViewer(context,
                                                          imageProvider,
                                                          onViewerDismissed:
                                                              () {
                                                        print("dismissed");
                                                      });
                                                    } else if (path.extension(
                                                            docUrl) ==
                                                        ".pdf") {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute<
                                                            dynamic>(
                                                          builder: (_) =>
                                                              PDFViewerFromUrl(
                                                            url: docurl,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Row(
                                                    children: [
                                                      provider.uploadedFilename
                                                              .isNotEmpty
                                                          ? // in Add Consignment Mode
                                                          path.extension(provider
                                                                      .uploadedFilename) ==
                                                                  '.pdf'
                                                              ? Image.asset(
                                                                  "assets/images/pdf_icon.png",
                                                                  height: 37,
                                                                  width: 27,
                                                                  color: Color(
                                                                      0xffFE5100),
                                                                )
                                                              : path.extension(
                                                                          provider
                                                                              .uploadedFilename) ==
                                                                      '.docx'
                                                                  ? Image.asset(
                                                                      "assets/images/docx_icon.png",
                                                                      height:
                                                                          37,
                                                                      width: 27,
                                                                      color: Color(
                                                                          0xff4A8AFB),
                                                                    )
                                                                  : path.extension(provider.uploadedFilename) == '.jpeg' ||
                                                                          path.extension(provider.uploadedFilename) ==
                                                                              '.png'
                                                                      ? SvgPicture
                                                                          .asset(
                                                                          "assets/images/jpeg.svg",
                                                                          height:
                                                                              37,
                                                                          width:
                                                                              27,
                                                                          color:
                                                                              Color(0xff4A8AFB),
                                                                        )
                                                                      : SizedBox()
                                                          : path.extension(
                                                                      // In Edit Consignment Mode
                                                                      docUrl) ==
                                                                  '.pdf'
                                                              ? Image.asset(
                                                                  "assets/images/pdf_icon.png",
                                                                  height: 37,
                                                                  width: 27,
                                                                  color: Color(
                                                                      0xffFE5100),
                                                                )
                                                              : path.extension(
                                                                          docUrl) ==
                                                                      '.docx'
                                                                  ? Image.asset(
                                                                      "assets/images/docx_icon.png",
                                                                      height:
                                                                          37,
                                                                      width: 27,
                                                                      color: Color(
                                                                          0xff4A8AFB),
                                                                    )
                                                                  : path.extension(docUrl) ==
                                                                              '.jpeg' ||
                                                                          path.extension(docUrl) ==
                                                                              '.png'
                                                                      ? SvgPicture.asset(
                                                                          "assets/images/jpeg.svg",
                                                                          height:
                                                                              37,
                                                                          width:
                                                                              27,
                                                                          color:
                                                                              Color(0xff4A8AFB),
                                                                        )
                                                                      : SizedBox(),
                                                      SizedBox(
                                                        width: 28,
                                                      ),
                                                      Text(
                                                        provider.uploadedFilename
                                                                .isNotEmpty
                                                            ? provider
                                                                .uploadedFilename
                                                            : fileName,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontFamily: FontName
                                                              .interRegular,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        child: docUrl
                                                                    .isNotEmpty ||
                                                                provider
                                                                    .uploadedFilename
                                                                    .isNotEmpty
                                                            ? Icon(
                                                                Icons
                                                                    .remove_red_eye_outlined,
                                                                size: 25,
                                                              )
                                                            : null,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              height: 46,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<Color>(
                                                              ThemeColor
                                                                  .themeGreenColor),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      6.0),
                                                              side: const BorderSide(
                                                                  color: ThemeColor
                                                                      .themeGreenColor)))),
                                                  onPressed: () {
                                                    print(provider.docNumber);

                                                    var addDocumentRequestObj =
                                                        AddDocumentRequest();
                                                    var docManagerDetailObj =
                                                        DocManagerDetail();
                                                    List<DocManagerDetail>
                                                        docManagerDetailArr =
                                                        [];

                                                    docManagerDetailObj
                                                        .documentType = provider
                                                            .docTypeDataObj
                                                            ?.documentId ??
                                                        "";
                                                    docManagerDetailObj
                                                            .documentNumber =
                                                        provider.docNumber;
                                                    docManagerDetailObj
                                                            .documentFile =
                                                        provider
                                                            .uploadedFilename;
                                                    docManagerDetailObj
                                                        .docManagerId = "";
                                                    docManagerDetailObj
                                                        .companyId = provider
                                                            .docTypeDataObj
                                                            ?.companyId ??
                                                        "";

                                                    docManagerDetailArr.add(
                                                        docManagerDetailObj);

                                                    addDocumentRequestObj
                                                            .docManagerDetails =
                                                        docManagerDetailArr;

                                                    provider
                                                        .addDocumentApiRequest(
                                                      reqdata:
                                                          addDocumentRequestObj,
                                                      context: context,
                                                    );
                                                    print(addDocumentRequestObj
                                                        .toJson());
                                                    provider
                                                        .clearAddDocumentData();
                                                  },
                                                  child: const Text(
                                                    "Submit",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily:
                                                          FontName.interBold,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              );
            })),
      ),
    );
  }
}
