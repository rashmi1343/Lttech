// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:lttechapp/utility/appbarWidget.dart';
// import 'package:lttechapp/utility/env.dart';
// import 'package:provider/provider.dart';

// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';

// import '../../../presenter/Lttechprovider.dart';
// import '../../../utility/CustomTextStyle.dart';
// import '../../../utility/SizeConfig.dart';
// import '../../../utility/StatefulWrapper.dart';

// // class Location extends StatelessWidget {
// //   Location({Key? key}) : super(key: key);
// //   Set<Marker> markers = {};

// //   BuildContext? _context;

// //   String googleApikey = Environement.googleApiKey;
// //   GoogleMapController? mapController; //contrller for Google map
// //   CameraPosition? cameraPosition;
// //   LatLng startLocation = LatLng(28.626631, 77.365471);
// //   String location = "Search Location";

// //   final startLatitude = 28.626631;
// //   final startLongitude = 77.365471;

// //   final destinationLatitude = 28.636631;
// //   final destinationLongitude = 77.368382;

// //   final Completer<GoogleMapController> _controller =
// //       Completer<GoogleMapController>();

// //   static const CameraPosition _kGooglePlex = CameraPosition(
// //     target: LatLng(28.626631, 77.365471),
// //     zoom: 14.4746,
// //   );
// //   String startCoordinatesString = '';
// //   String destinationCoordinatesString = '';

// //   @override
// //   Widget build(BuildContext context) {
// //     SizeConfig().init(context);
// //     _context = context;

// //     return StatefulWrapper(
// //       onInit: () async {
// //         startCoordinatesString = '($startLatitude, $startLongitude)';
// //         destinationCoordinatesString =
// //             '($destinationLatitude, $destinationLongitude)';
// //         // Start Location Marker
// //         Marker startMarker = Marker(
// //           markerId: MarkerId('startCoordinatesString'),
// //           position: LatLng(startLatitude, startLongitude),
// //           infoWindow: InfoWindow(
// //             title: 'Start $startCoordinatesString',
// //             snippet: 'Start Address',
// //           ),
// //           icon: BitmapDescriptor.defaultMarker,
// //         );

// // // Destination Location Marker
// //         Marker destinationMarker = Marker(
// //           markerId: MarkerId('destinationCoordinatesString'),
// //           position: LatLng(destinationLatitude, destinationLongitude),
// //           infoWindow: InfoWindow(
// //             title: 'Destination $destinationCoordinatesString',
// //             snippet: 'Destination Address',
// //           ),
// //           icon: BitmapDescriptor.defaultMarker,
// //         );
// //         // Add the markers to the list
// //         markers.add(startMarker);
// //         markers.add(destinationMarker);
// //       },
// //       child: WillPopScope(
// //         onWillPop: onWillPop,
// //         child: Consumer<Lttechprovider>(
// //           builder: (context, provider, child) {
// //             return Scaffold(
// //               appBar: defaultAppBar(),
// //               body: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Container(
// //                     margin: Platform.isAndroid
// //                         ? const EdgeInsets.only(left: 12, top: 22, bottom: 9)
// //                         : const EdgeInsets.only(left: 12, top: 12, bottom: 9),
// //                     height: 29,
// //                     width: 217,
// //                     child: Text(
// //                       "Location",
// //                       style: TextStyle(
// //                           fontSize: 24,
// //                           color: Color(0xff000000),
// //                           fontFamily: 'InterBold'),
// //                     ),
// //                   ),
// //                   Stack(
// //                     children: [
// //                       SizedBox(
// //                         height: Platform.isIOS
// //                             ? SizeConfig.safeBlockVertical * 79
// //                             : SizeConfig.safeBlockVertical * 79,
// //                         child: GoogleMap(
// //                           markers: Set<Marker>.from(markers),
// //                           myLocationEnabled: true,
// //                           zoomGesturesEnabled: true,
// //                           zoomControlsEnabled: false,
// //                           mapType: MapType.hybrid,
// //                           initialCameraPosition: _kGooglePlex,
// //                           onMapCreated: (GoogleMapController controller) {
// //                             _controller.complete(controller);
// //                           },
// //                         ),
// //                       ),

// //                       Positioned(
// //                           //search input bar
// //                           top: 10,
// //                           child: InkWell(
// //                               onTap: () async {
// //                                 var place = await PlacesAutocomplete.show(
// //                                     context: context,
// //                                     apiKey: googleApikey,
// //                                     mode: Mode.overlay,
// //                                     types: [],
// //                                     strictbounds: false,
// //                                     components: [
// //                                       Component(Component.country, 'np')
// //                                     ],
// //                                     //google_map_webservice package
// //                                     onError: (err) {
// //                                       print(err);
// //                                     });

// //                                 print(place?.description.toString());
// //                                 if (place != null) {
// //                                   location = place.description.toString();

// //                                   //form google_maps_webservice package
// //                                   final plist = GoogleMapsPlaces(
// //                                     apiKey: googleApikey,
// //                                     apiHeaders:
// //                                         await GoogleApiHeaders().getHeaders(),
// //                                     //from google_api_headers package
// //                                   );
// //                                   String placeid = place.placeId ?? "0";
// //                                   final detail =
// //                                       await plist.getDetailsByPlaceId(placeid);
// //                                   final geometry = detail.result.geometry!;
// //                                   final lat = geometry.location.lat;
// //                                   final lang = geometry.location.lng;
// //                                   var newlatlang = LatLng(lat, lang);

// //                                   //move map camera to selected place with animation
// //                                   mapController?.animateCamera(
// //                                       CameraUpdate.newCameraPosition(
// //                                           CameraPosition(
// //                                               target: newlatlang, zoom: 17)));

// //                                   provider.setUpdateView = true;
// //                                 }
// //                               },
// //                               child: Padding(
// //                                 padding: EdgeInsets.all(15),
// //                                 child: Card(
// //                                   child: Container(
// //                                       padding: EdgeInsets.all(0),
// //                                       width: MediaQuery.of(context).size.width -
// //                                           40,
// //                                       child: ListTile(
// //                                         title: Text(
// //                                           location,
// //                                           style: TextStyle(fontSize: 18),
// //                                         ),
// //                                         trailing: Icon(Icons.search),
// //                                         dense: true,
// //                                       )),
// //                                 ),
// //                               ))),
// //                       // Expanded(
// //                       //   child:
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }
// class Location extends StatelessWidget {
//   Location({super.key});

//   String googleApikey = Environement.googleApiKey;
//   GoogleMapController? mapController; //contrller for Google map
//   CameraPosition? cameraPosition;
//   final startLatitude = 28.626631;
//   final startLongitude = 77.365471;
//   LatLng startLocation = LatLng(28.626631, 77.365471);
//   String location = "Search Location";

//   @override
//   Widget build(BuildContext context) {
//     Future<bool> onWillPop() async {
//       Provider.of<Lttechprovider>(context, listen: false)
//           .navigatetodashboard(context);
//       return true;
//     }

//     return StatefulWrapper(
//       onInit: () async {},
//       child: WillPopScope(
//         onWillPop: onWillPop,
//         child: Consumer<Lttechprovider>(
//           builder: (context, provider, child) {
//             return Scaffold(
//               appBar: defaultAppBar(),
//               body: Stack(children: [
//                 GoogleMap(
//                   //Map widget from google_maps_flutter package
//                   zoomGesturesEnabled: true, //enable Zoom in, out on map
//                   initialCameraPosition: CameraPosition(
//                     //innital position in map
//                     target: startLocation, //initial position
//                     zoom: 14.0, //initial zoom level
//                   ),
//                   mapType: MapType.normal, //map type
//                   onMapCreated: (controller) {
//                     //method called when map is created
//                     // setState(() {
//                     mapController = controller;
//                     // });
//                   },
//                 ),

//                 //search autoconplete input
//                 Positioned(
//                     //search input bar
//                     top: 10,
//                     child: InkWell(
//                         onTap: () async {
//                           var place = await PlacesAutocomplete.show(
//                               context: context,
//                               apiKey: googleApikey,
//                               mode: Mode.overlay,
//                               types: [],
//                               strictbounds: false,
//                               components: [
//                                 Component(Component.country, 'aus')
//                               ], // It is country specific search. in for IND, aus for Australlia

//                               onError: (err) {
//                                 print(err);
//                               });

//                           if (place != null) {
//                             location = place.description.toString();
//                             provider.setUpdateView = true;

//                             //form google_maps_webservice package
//                             final plist = GoogleMapsPlaces(
//                               apiKey: googleApikey,
//                               apiHeaders: await GoogleApiHeaders().getHeaders(),
//                               //from google_api_headers package
//                             );
//                             String placeid = place.placeId ?? "0";
//                             final detail =
//                                 await plist.getDetailsByPlaceId(placeid);
//                             final geometry = detail.result.geometry!;
//                             final lat = geometry.location.lat;
//                             final lang = geometry.location.lng;
//                             var newlatlang = LatLng(lat, lang);

//                             //move map camera to selected place with animation
//                             mapController?.animateCamera(
//                                 CameraUpdate.newCameraPosition(CameraPosition(
//                                     target: newlatlang, zoom: 17)));
//                           }
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.all(15),
//                           child: Card(
//                             child: Container(
//                                 padding: EdgeInsets.all(0),
//                                 width: MediaQuery.of(context).size.width - 40,
//                                 child: ListTile(
//                                   title: Text(
//                                     location,
//                                     style: TextStyle(fontSize: 18),
//                                   ),
//                                   trailing: Icon(Icons.search),
//                                   dense: true,
//                                 )),
//                           ),
//                         )))
//               ]),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
