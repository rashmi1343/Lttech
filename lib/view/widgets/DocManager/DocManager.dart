import 'dart:io';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';

import 'package:lttechapp/utility/CustomTextStyle.dart';
import 'package:lttechapp/utility/SizeConfig.dart';
import 'package:lttechapp/utility/appbarWidget.dart';

import 'package:provider/provider.dart';

import '../../../entity/ApiRequests/DeleteDocManagerRequest.dart';
import '../../../entity/GetDocManagerResponse.dart';
import '../../../router/routes.dart';
import '../../../utility/ColorTheme.dart';
import '../../../utility/Constant/endpoints.dart';
import '../../../utility/PDFViewerFromUrl.dart';
import '../../../utility/StatefulWrapper.dart';

class DocManager extends StatelessWidget {
  const DocManager({super.key});

  Future getDocList(BuildContext context) async {
    await Future.delayed(Duration.zero, () {
      final provider = Provider.of<Lttechprovider>(context, listen: false);
      provider.getDocManagerListRequest();
      provider.setUpdateView = true;

      print(
          "Total Documents count:${provider.getDocManagerResponseObj.data?.count}");
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Future<bool> _onWillPop() async {
      print("back called");
      Provider.of<Lttechprovider>(context, listen: false)
          .navigatetodashboard(context);

      return true;
    }

    return StatefulWrapper(
      onInit: () {
        getDocList(context);
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Color(0xffFAFAFA),
            appBar: commonAppBarWithoutSearchIcon('/Dashboard'),
            body: Consumer<Lttechprovider>(
              builder: (context, value, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: Platform.isAndroid
                              ? const EdgeInsets.only(
                                  left: 1, top: 22, bottom: 9, right: 135)
                              : const EdgeInsets.only(
                                  left: 1, top: 12, bottom: 9, right: 135),
                          height: 29,
                          width: 217,
                          child: Text(
                            "Doc Manager",
                            style: TextStyle(
                                fontSize: 24,
                                color: Color(0xff000000),
                                fontFamily: 'InterBold'),
                          ),
                        ),
                        // Container(
                        //   margin: const EdgeInsets.only(
                        //       top: 12, bottom: 9, right: 5),
                        //   child: IconButton(
                        //     onPressed: () {
                        //       Provider.of<Lttechprovider>(context,
                        //               listen: false)
                        //           .navigatetoAddDocument(context);
                        //     },
                        //     icon: Image.asset(
                        //       "assets/images/ConsignmentIcon/add.png",
                        //       height: 24,
                        //       width: 24,
                        //     ),
                        //     color: Color(0xff0AAC19),
                        //   ),
                        // )
                      ],
                    ),
                    Expanded(
                      child: Container(
                        // padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            value.isLoading
                                ? Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 150.0),
                                    child: CircularProgressIndicator(
                                      backgroundColor:
                                          ThemeColor.themeLightGrayColor,
                                      color: ThemeColor.themeGreenColor,
                                    ))
                                : Expanded(
                                    child: SizedBox(
                                        height: Platform.isIOS
                                            ? SizeConfig.safeBlockVertical * 61
                                            : SizeConfig.safeBlockVertical * 74,
                                        child: value.getDocManagerResponseObj
                                                    .data?.rows ==
                                                null
                                            ? Center(
                                                child: Text('No Document Found',
                                                    style: TextStyle(
                                                      color: ThemeColor
                                                          .themeGreenColor,
                                                      fontFamily:
                                                          FontName.interMedium,
                                                      fontSize: 15,
                                                    )),
                                              )
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: value
                                                        .getDocManagerResponseObj
                                                        .data
                                                        ?.rows
                                                        ?.length ??
                                                    0,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  String? docFile = value
                                                      .getDocManagerResponseObj
                                                      .data
                                                      ?.rows?[index]
                                                      .documentFile;
                                                  print("docFile:$docFile");
                                                  String fileName =
                                                      docFile!.split('/').last;
                                                  print("fileName:$fileName");
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      final getDocRow = value
                                                          .getDocManagerResponseObj
                                                          .data
                                                          ?.rows?[index];
                                                      final docurl = Endpoints
                                                              .docbaseurl +
                                                          getDocRow!
                                                              .documentFile!;
                                                      if (getDocRow
                                                                  .documentFileType ==
                                                              "jpeg" ||
                                                          getDocRow
                                                                  .documentFileType ==
                                                              "jpg") {
                                                        final imageProvider =
                                                            Image.network(
                                                                    docurl)
                                                                .image;
                                                        showImageViewer(context,
                                                            imageProvider,
                                                            onViewerDismissed:
                                                                () {
                                                          print("dismissed");
                                                        });
                                                      } else if (getDocRow
                                                              .documentFileType ==
                                                          "png") {
                                                        final imageProvider =
                                                            Image.network(
                                                                    docurl)
                                                                .image;
                                                        showImageViewer(context,
                                                            imageProvider,
                                                            onViewerDismissed:
                                                                () {
                                                          print("dismissed");
                                                        });
                                                      } else if (getDocRow
                                                              .documentFileType ==
                                                          "pdf") {
                                                        Platform.isAndroid
                                                            ? value.viewpdf(
                                                                docurl,
                                                                fileName)
                                                            : Navigator.push(
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
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0xffEEEEEE),
                                                            blurRadius: 3.0,
                                                          ),
                                                        ],
                                                        border: Border.all(
                                                          color:
                                                              Color(0xffEEEEEE),
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 10, 0, 10),
                                                      margin: EdgeInsets.only(
                                                          top: 5, bottom: 3),
                                                      child: childWidget(
                                                          context,
                                                          index,
                                                          value.getDocManagerResponseObj
                                                                      .data?.rows?[
                                                                  index] ??
                                                              GetDocRow(),
                                                          value),
                                                    ),
                                                  );
                                                },
                                                // separatorBuilder:
                                                //     (BuildContext context, int index) {
                                                //   return Divider(
                                                //     height: 0,
                                                //   );
                                                // },
                                              )),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            bottomNavigationBar: bottomappbar(context)),
      ),
    );
  }

  Widget childWidget(BuildContext context, int index, GetDocRow getDocRow,
      Lttechprovider value) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  right: 12,
                  left: 12,
                ),
                child: getDocRow.documentFileType == "pdf"
                    ? Image.asset(
                        "assets/images/pdf_icon.png",
                        width: 27,
                        color: ThemeColor.themeGreenColor,
                      )
                    : SvgPicture.asset(
                        "assets/images/jpeg.svg",
                        color: ThemeColor.themeGreenColor,
                        width: 27,
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      bottom: 5,
                      top: 5,
                    ),
                    child: Text(
                      getDocRow.documentNumber ?? "",
                      style: TextStyle(
                          fontSize: 14,
                          color: ThemeColor.themeGreenColor,
                          height: 1,
                          fontFamily: FontName.interMedium),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${getDocRow.docManagerType?.documentType ?? ""} (${getDocRow.documentFileType ?? ""})",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff000000),
                          fontFamily: FontName.interSemiBold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      bottom: 2,
                    ),
                    child: Text(
                      DateFormat('MMM d, yyyy')
                          .format(getDocRow.createdAt ?? DateTime.now()),
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff666666),
                          fontFamily: FontName.interRegular),
                    ),
                  ),
                ],
              ),
              Spacer(),
              // PopupMenuButton(
              //   icon: Icon(
              //     Icons.more_vert,
              //   ),
              //   itemBuilder: (ctx) => [
              //     PopupMenuItem(
              //         value: 'edit',
              //         child: ElevatedButton.icon(
              //             icon: Icon(
              //               Icons.edit,
              //               color: ThemeColor.themeGreenColor,
              //               size: 20.0,
              //             ),
              //             label: Text('Edit',
              //                 style: TextStyle(
              //                   fontFamily: 'InterRegular',
              //                   fontSize: 13,
              //                   color: Colors.black,
              //                 )),
              //             style: ButtonStyle(
              //               backgroundColor:
              //                   MaterialStateProperty.all(Colors.white),
              //               shadowColor:
              //                   MaterialStateProperty.all(Colors.transparent),
              //             ),
              //             onPressed: () {
              //               print('Edit Button Pressed');
              //               value.isUpdateDocumentType = true;
              //               Provider.of<Lttechprovider>(context, listen: false)
              //                   .navigatetoAddDocument(context);
              //               // //Navigate to Consignment Screen One
              //               // Provider.of<Lttechprovider>(context,
              //               //     listen: false)
              //               //     .navigatetoAddConsignmentOne(
              //               //     context);
              //               // // Navigator.pop(context);
              //             })),
              //     PopupMenuItem(
              //         value: 'delete',
              //         child: ElevatedButton.icon(
              //             icon: Icon(
              //               Icons.delete,
              //               color: Colors.red,
              //               size: 20.0,
              //             ),
              //             label: Text('Delete',
              //                 style: TextStyle(
              //                   fontFamily: 'InterRegular',
              //                   fontSize: 13,
              //                   color: Colors.black,
              //                 )),
              //             style: ButtonStyle(
              //               backgroundColor:
              //                   MaterialStateProperty.all(Colors.white),
              //               shadowColor:
              //                   MaterialStateProperty.all(Colors.transparent),
              //             ),
              //             onPressed: () {
              //               print('Delete Document Button Pressed');
              //               var deleteDocTypeRequestObj =
              //                   DeleteDocManagerRequest(id: [
              //                 "${getDocRow.docManagerType?.documentId.toString()}"
              //               ]);
              //
              //               print(deleteDocTypeRequestObj.toJson());
              //
              //               value.deleteDocumentType(deleteDocTypeRequestObj);
              //               Navigator.pop(context);
              //             })),
              //   ],
              //   onSelected: (String value) {
              //     print('Clicked on popup menu item : $value');
              //   },
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
