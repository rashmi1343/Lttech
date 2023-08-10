import 'package:latlong2/latlong.dart';
import '../entity/GetTimeSheetByIdResponse.dart';

class Environement {
//local client_id
  //static final String CLIENT_ID = 'flutter-client';

  //static final String CLIENT_ID = 'lttech-mobile-app';
  // static final String CLIENT_ID = 'lttech-platform';
  static final String CLIENT_ID = "lttech-driver";
  // static final String CLIENT_SECRET = 'oAL3xjdO5xuRg1PwebvAvPd2lNjNkyH9';
  static final String CLIENT_SECRET =
      //live client secret
      // 'wzzAX9HIwv9XlDqTrjHyLGF7Aui7nvP9';
// demo client secret
      'lS6nbmre5rDS0oJpq0kenfRArcvgqteK';

  static final String SSO_URL =
      // LIVE sso_url
      //   'auth/realms/LTTECH/protocol/openid-connect/token';
// demo sso_url
      'auth/realms/LttechLocal/protocol/openid-connect/token';

  static final String Logout =
      'auth/realms/LttechLocal/protocol/openid-connect/logout';

  // static final String username = 'managment@gmail.com';
  static final String username = //'salman.k@broadwayinfotech.com';
      // live driver
      //'vawitak746@anomgo.com';
      // demo driver
      'wadoke3940@edulena.com';

  static final String password =
      // live
      //'password';
      // demo
      'Test@123';
  // static final String password = 'Ajay@123';
  static int indexPstConsignmentListing = 0;
  static String consignmentId = "0";

  static String ACCESS_TOKEN = "";
  static String REFRESH_TOKEN = "";

  static String driverID = "";
  static String companyID = "";
  static String userID = "";
  static String driverfirstname = '';
  static String driverlastname = '';
  static String driverselectedCompany = '';
  static String updatedDriverMobileNo = '';

  static String googleApiKey = "AIzaSyCcLgRIDZsVGKCMB-YHDiEMvhB-DDW6MR4";
  static int indexrestdetail = 0;

  static Restdetail? restdetail = Restdetail();

  static const String mapBoxAccessToken =
      // 'pk.eyJ1IjoiYndpdCIsImEiOiJjbGoyaXphb3AxNGNlM2ZwOWU2a3ZuYmczIn0.ADwZVl22OiKrjb4vIbmUPg';
      'sk.eyJ1IjoiYndpdCIsImEiOiJjbGozeHZnMmMxaWtmM2ZwOXU2ZzZ4dnM2In0.IIxOotcBkF9jZdSyMpYLgg';
  static const String mapBoxStyleId =
      'mapbox://styles/bwit/clj2t9uj800g801pb6jcyc850';

  static final myLocation = LatLng(28.626631, 77.365471);

  static String initialloginname = '';

  static bool isremuser=false;
  static String remusername='';
  static String remuserpwd = '';
  static bool istimesheetcreated = false;
  static String timesheetcreatedid ='';
  static int editrestdetailcounter=0;


}

extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([E? Function(T?)? transform]) =>
      map(transform ?? (e) => e).where((e) => e != null).cast();
}
