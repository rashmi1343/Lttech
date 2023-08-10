import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lttechapp/utility/appbarWidget.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';

import '../../../presenter/Lttechprovider.dart';
import '../../../utility/ColorTheme.dart';
import '../../../utility/Constant/endpoints.dart';
import '../../../utility/StatefulWrapper.dart';

import 'package:latlong2/latlong.dart';

class MapBoxLocation extends StatelessWidget {
  BuildContext? _context;
  double? latitude;
  double? longitude;
  MapBoxLocation({this.latitude, this.longitude});
  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      Provider.of<Lttechprovider>(context, listen: false)
          .navigatetodashboard(context);
      return true;
    }

    return StatefulWrapper(
      onInit: () async {
        _context = context;
        final provider = Provider.of<Lttechprovider>(context!, listen: false);
      },
      child: WillPopScope(
        //onWillPop: onWillPop,
        onWillPop: () async => false,
        child: Consumer<Lttechprovider>(
          builder: (context, provider, child) {
            return Scaffold(
              appBar: defaultAppBar(),
              body: Stack(children: [
                provider.isLoading
                    ? Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 150.0),
                        child: CircularProgressIndicator(
                          backgroundColor: ThemeColor.themeLightGrayColor,
                          color: ThemeColor.themeGreenColor,
                        ))
                    : SizedBox(
                        width: double.infinity,
                        height: 800,
                        //  child: Container()
                        child: FlutterMap(
                          mapController: provider.mapcontroller,
                          options: MapOptions(
                            minZoom: 5,
                            maxZoom: 18,
                            zoom: 14,
                            // center: LatLng(provider.currentPosition.latitude,
                            //     provider.currentPosition.longitude),
                            center: LatLng(latitude!, longitude!),
                          ),
                          layers: [
                            TileLayerOptions(
                              urlTemplate:
                                  "https://api.mapbox.com/styles/v1/rashmi281/clj871h12007x01p939w22q9a/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicmFzaG1pMjgxIiwiYSI6ImNsajg2eng4czB4cHYzcnF4cmUzOGx5NXIifQ.zUq1YdSQfZcASs1rRymKDw",
                              additionalOptions: {
                                'mapStyleId': AppConstants.mapBoxStyleId,
                                'accessToken': AppConstants.mapBoxAccessToken,
                              },
                            ),
                            MarkerLayerOptions(
                              markers: [
                                Marker(
                                    height: 60,
                                    width: 60,
                                    // point: LatLng(
                                    //     provider.currentPosition.latitude,
                                    //     provider.currentPosition.longitude),
                                    point: LatLng(latitude!, longitude!),
                                    builder: (_) => GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(25.0),
                                                  ),
                                                ),
                                                backgroundColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                builder: (context) {
                                                  return Container(
                                                    margin: EdgeInsets.all(10),
                                                    child: Wrap(
                                                      children: [
                                                        ListTile(
                                                            leading: Container(
                                                              margin: EdgeInsets
                                                                  .all(10),
                                                              child: Icon(
                                                                Icons
                                                                    .location_history,
                                                                color: ThemeColor
                                                                    .themeGreenColor,
                                                                size: 30,
                                                              ),
                                                            ),
                                                            trailing:
                                                                IconButton(
                                                              onPressed: () {
                                                                // MapsLauncher.launchCoordinates(
                                                                //     provider
                                                                //         .currentPosition
                                                                //         .latitude,
                                                                //     provider
                                                                //         .currentPosition
                                                                //         .longitude,
                                                                //     provider
                                                                //         .currentAddress);
                                                                MapsLauncher.launchCoordinates(
                                                                    latitude!,
                                                                    longitude!,
                                                                    provider
                                                                        .currentAddress);
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .directions,
                                                                size: 30,
                                                                color: ThemeColor
                                                                    .themeGreenColor,
                                                              ),
                                                            ),
                                                            title: Text(
                                                                provider
                                                                    .currentAddress
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'InterMedium',
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                ))),
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Container(
                                            child: Icon(
                                              Icons.location_on,
                                              size: 35,
                                              color: Colors.red,
                                            ),
                                          ),
                                        )),
                              ],
                            ),
                          ],
                        ),
                        // MapBoxNavigationView(
                        //   options: provider.options,
                        //   onRouteEvent: provider.onRouteEvent,
                        //   onCreated: (MapBoxNavigationViewController
                        //       controller) async {
                        //     provider.controller = controller;
                        //
                        //     // provider.controller!
                        //     //     .startNavigation(options: provider.options);
                        //
                        //     // provider.controller!.buildRoute(
                        //     //     wayPoints: provider.wayPoints,
                        //     //     options: provider.options);
                        //   },
                        // ),
                      ),
              ]),
            );
          },
        ),
      ),
    );
  }
}
