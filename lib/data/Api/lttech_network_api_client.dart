import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lttechapp/data/shared_preferences/preferences.dart';
import 'package:lttechapp/entity/AddGeoLocationResponse.dart';
import 'package:lttechapp/entity/ApiRequests/AddGeoLocationRequest.dart';
import 'package:lttechapp/entity/ApiRequests/UpdateDocManagerRequest.dart';
import 'package:lttechapp/entity/AuthenticationResponse.dart';
import 'package:lttechapp/entity/Filltimesheetresponse.dart';
import 'package:lttechapp/entity/FitnessVehicleChecklistApiResponse.dart';
import 'package:lttechapp/entity/GetParticularCustomerAllAddressByCustomerId.dart';
import 'package:lttechapp/entity/UpdateDocManagerResponse.dart';
import 'package:lttechapp/entity/Updatetimesheetresponse.dart';
import 'package:lttechapp/entity/getalltimesheetresponse.dart';
import 'package:lttechapp/entity/submitfilltimesheetresponse.dart';
import 'package:lttechapp/entity/trucktyperesponse.dart';
import 'package:lttechapp/view/login_page.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:lttechapp/utility/Constant/endpoints.dart';
import 'package:lttechapp/utility/env.dart';
import 'package:provider/provider.dart';

import '../../entity/AddConsignmentResponse.dart';
import '../../entity/ApiRequests/AddConsignmentRequest.dart';
import '../../entity/ApiRequests/AddDocumentRequest.dart';
import '../../entity/ApiRequests/DeleteDocManagerRequest.dart';
import '../../entity/ApiRequests/DeleteTimesheetRequest.dart';
import '../../entity/ApiRequests/FaultReportingRequest.dart';
import '../../entity/ApiRequests/SignOnConsignmentRequest.dart';
import '../../entity/ApiRequests/SubmitDriverFitnessRequest.dart';
import '../../entity/ApiRequests/SubmitVehicleFitnessRequest.dart';
import '../../entity/ApiRequests/UpdateConsignmentrequest.dart';
import '../../entity/ApiRequests/Updatetimesheetrequest.dart';
import '../../entity/CompanyDriverList.dart';
import '../../entity/CountriesResponse.dart';
import '../../entity/CustomerCompanyAddressResponse.dart';
import '../../entity/CustomersResponse.dart';
import '../../entity/DefaultAddressByCustomerIdResponse.dart';
import '../../entity/DeleteDocManagerResponse.dart';
import '../../entity/DriverProfileResponse.dart';
import '../../entity/Driverjobresponse.dart';
import '../../entity/FitnessSubmittedResponse.dart';
import '../../entity/GetAllCustomerResponse.dart';
import '../../entity/GetAllManifest.dart';
import '../../entity/GetDocManagerResponse.dart';
import '../../entity/ConsignmentByIdResponse.dart';
import '../../entity/DriverUploadDocResponse.dart';
import '../../entity/AddTimeSheetResponse.dart';
import '../../entity/ApiRequests/AddTimeSheetRequest.dart';
import '../../entity/GetAllConsignmentResponse.dart';
import '../../entity/GetDocTypeResponse.dart';
import '../../entity/GetGeoLocationResponse.dart';
import '../../entity/GetTimeSheetByIdResponse.dart';
import '../../entity/SignOnConsignmentResponse.dart';
import '../../entity/StatesResponse.dart';
import '../../entity/UpdateConsignmentResponse.dart';
import '../../entity/UploadDocumentResponse.dart';
import '../../entity/VehicleRegistrationResponseList.dart';
import '../../entity/VerifyTokenResponse.dart';
import '../../main.dart';
import '../shared_preferences/helper.dart';

class lttechNetworkApiClient {
  Future<AuthenticationResponse> loginApi(
      String username, String password) async {
    String url = Endpoints.authurl + Environement.SSO_URL;

    AuthenticationResponse objauthresponse = AuthenticationResponse(
        accessToken: '',
        expiresIn: 0,
        refreshExpiresIn: 0,
        refreshToken: '',
        tokenType: '',
        notBeforePolicy: 0,
        sessionState: '',
        scope: '');
    try {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
        'cache-control': 'no-cache',
      };

      Map<String, String> data = {
        // 'username': Environement.username,
        // 'password': Environement.password,
        'username': username,
        'password': password,
        'grant_type': 'password',
        'client_id': Environement.CLIENT_ID,
        'client_secret': Environement.CLIENT_SECRET
      };

      http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: data);

      print(response.body);

      print(response.statusCode);

      if (response.statusCode == 200) {
        // dynamic authresponse = json.decode(response.body);
        objauthresponse = authFromJson(response.body);

        Environement.ACCESS_TOKEN = '';
        Environement.ACCESS_TOKEN = objauthresponse.accessToken ?? "";
        Environement.REFRESH_TOKEN = objauthresponse.refreshToken ?? "";

        await SharedPreferenceHelper.saveAuthToken(Environement.ACCESS_TOKEN);
        await SharedPreferenceHelper.saveRefreshToken(
            Environement.REFRESH_TOKEN);

        print(objauthresponse);
        //  return objauthresponse;
      } else if (response.statusCode == 401) {
        /*objauthresponse = AuthenticationResponse(accessToken: '',
            expiresIn: 0,
            refreshExpiresIn: 0,
            refreshToken: '',
            tokenType: '',
            notBeforePolicy: 0,
            sessionState: '',
            scope: '');*/
        print('Not_Authorized');
        Environement.ACCESS_TOKEN = '';
        //   await SharedPreferenceHelper.saveAuthToken(Environement.ACCESS_TOKEN);
        //  return objauthresponse;
      } else if (response.statusCode == 400) {
        /*objauthresponse = AuthenticationResponse(accessToken: '',
            expiresIn: 0,
            refreshExpiresIn: 0,
            refreshToken: '',
            tokenType: '',
            notBeforePolicy: 0,
            sessionState: '',
            scope: '');*/

        print('Need_Email_Verification');

        //   return objauthresponse;
      } else {
        /*  objauthresponse = AuthenticationResponse(accessToken: '',
            expiresIn: 0,
            refreshExpiresIn: 0,
            refreshToken: '',
            tokenType: '',
            notBeforePolicy: 0,
            sessionState: '',
            scope: '');*/

        print('Server Error');
        //  return objauthresponse;
      }
    } catch (e) {
      print("Exception_loginapi $e");
    }
    return objauthresponse;
  }

  Future<AuthenticationResponse> getaccesstokenfromrefreshtokenApi(
      String refreshtoken) async {
    String url = Endpoints.authurl + Environement.SSO_URL;

    AuthenticationResponse objauthresponse = AuthenticationResponse(
        accessToken: '',
        expiresIn: 0,
        refreshExpiresIn: 0,
        refreshToken: '',
        tokenType: '',
        notBeforePolicy: 0,
        sessionState: '',
        scope: '');
    try {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
        'cache-control': 'no-cache',
      };

      Map<String, String> data = {
        'grant_type': 'refresh_token',
        'client_id': Environement.CLIENT_ID,
        'refresh_token': Environement.REFRESH_TOKEN,
        'client_secret': Environement.CLIENT_SECRET
      };

      http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: data);

      print(response.body);

      print(response.statusCode);

      if (response.statusCode == 200) {
        objauthresponse = authFromJson(response.body);

        Environement.ACCESS_TOKEN = '';
        Environement.ACCESS_TOKEN = objauthresponse.accessToken ?? "";
        Environement.REFRESH_TOKEN = objauthresponse.refreshToken ?? "";

        await SharedPreferenceHelper.saveAuthToken(Environement.ACCESS_TOKEN);
        await SharedPreferenceHelper.saveRefreshToken(
            Environement.REFRESH_TOKEN);

        print(objauthresponse);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print('Not_Authorized');
        navigatorKey.currentState!.pushNamed('/login');
        //  return objauthresponse;
      } else if (response.statusCode == 400) {
        print('Need_Email_Verification');

        //   return objauthresponse;
      } else {
        print('Server Error');
        //  return objauthresponse;
      }
    } catch (e) {
      print("Exception_loginapi $e");
    }
    return objauthresponse;
  }

  String getFileName(String _path) {
    return path.basename(_path);
  }

  // API FOR VERIFY TOKEN
  Future<VerifyTokenResponse?> VerifyTokenAPI() async {
    VerifyTokenResponse objtokenresponse = VerifyTokenResponse();
    String url = Endpoints.baseurl + Endpoints.verifyToken;

    print('url: $url');

    Map<String, String> data = {
      'access_token': Environement.ACCESS_TOKEN,
      'user_type': "4"
    };
    // print(data);

    // Map<String, String> headers = {
    //   'content-type': 'application/json',
    //   'cache-control': 'no-cache',
    //   "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
    // };
    try {
      var response = await http.post(Uri.parse(url), body: data);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        // String status = data["status"];
        if (data["status"] == 1) {
          final verifyTokenResponse =
              verifyTokenResponseFromJson(response.body);

          return verifyTokenResponse;
        } else if (data["status"] == 0) {
          objtokenresponse.status = 0;
          objtokenresponse.data = VeriftTokenData();
        }
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 403 ||
          response.statusCode == 404) {
        objtokenresponse.status = 2;
        objtokenresponse.data = VeriftTokenData();
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException VerifyTokenAPI: $e");
    } on SocketException catch (e) {
      // Other exception
      print("SocketException VerifyTokenAPI: $e");
    } catch (e) {
      print("Exception VerifyTokenAPI: $e");
    }
    return objtokenresponse;
    // return updatetiesheetresponsedataObj;
  }

  // API FOR VERIFY TOKEN
  Future<bool> forgetPasswordApi(String email) async {
    String url = Endpoints.baseurl + Endpoints.resetpassword;

    Map<String, String> data = {'email': email};
    print('url: $url \n $data');

    try {
      var response = await http.post(Uri.parse(url), body: data);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        // String status = data["status"];
        if (data["status"] == 1) {
          return true;
        } else if (data["status"] == 0) {
          return false;
        }
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException forgetPasswordApi: $e");
    } on SocketException catch (e) {
      // Other exception
      print("SocketException forgetPasswordApi: $e");
    } catch (e) {
      print("Exception forgetPasswordApi: $e");
    }
    return false;
  }

// GetAllConsignment Api
  GetAllConsignmentResponse responseData =
      GetAllConsignmentResponse(status: 0, data: Data(count: 0, rows: []));

  Future<GetAllConsignmentResponse> getAllConsignmentApi(
      int pageNum, String consignmentTypestatus, String pageSize) async {
    print(
        ("getAllConsignment by id:${Endpoints.baseurl}${Endpoints.getAllDriverConsignmentUrl}/${Environement.companyID}/${Environement.driverID}?keyword=&status=$consignmentTypestatus&sortkey=&sortvalue=desc&page=$pageNum&size=$pageSize"));
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      final response = await http.get(
          Uri.parse(
              "${Endpoints.baseurl}${Endpoints.getAllDriverConsignmentUrl}/${Environement.companyID}/${Environement.driverID}?keyword=&status=$consignmentTypestatus&sortkey=&sortvalue=desc&page=$pageNum&size=$pageSize"),
          headers: headers);
      if (response.statusCode == 200) {
        print("responseData:${response.body}");
        final item = json.decode(response.body);
        responseData = GetAllConsignmentResponse.fromJson(item);

        print("responseData:$responseData");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("get all consignment request failed:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else {
        print("else");
      }
    } catch (e) {
      log(e.toString());
    }

    return responseData;
  }

//GetConsignmentById APi
  ConsignmentByIdResponse consignmentByIdlist = ConsignmentByIdResponse(
      status: 0,
      data: ConsignmentByIdData(
        consignmentId: '',
        companyId: '',
        jobNumber: '',
        bookedDate: DateTime.now(),
        pickupDate: DateTime.now(),
        deliveryDate: DateTime.now(),
        specialInstruction: '',
        manifestNumber: '',
        billingCustomer: '',
        billingAddressId: '',
        billingAddress: '',
        customerAddress: '',
        suburb: '',
        zipCode: '',
        stateId: 1,
        countryId: 2,
        chep: '',
        loscom: '',
        plain: '',
        deliveryName: '',
        deliveryAddres: '',
        deliverySuburb: '',
        deliveryZipCode: '',
        deliveryStateId: 1,
        deliveryCountryId: 2,
        driverId: '',
        driverMobileNumber: '',
        totalItems: 1,
        totalPallets: 1,
        totalSpaces: 1,
        totalWeight: 1,
        createdBy: 1,
        consignmentDetails: [],
        truckDetails: [],
        customerId: '',
        status: '',
        customerPickupDetails: CustomerPickUpDetails(customerCompanyName: ''),
        customerDeliveryDetails: CustomerPickUpDetails(customerCompanyName: ''),
        pickupCustomerId: '',
        signature: "",
        endLatitude: "",
        endLongitude: "0.0",
        signatureDate: DateTime.now(),
      ));

  Future<ConsignmentByIdResponse> ConsignmentByIdApi(
      String consignmentId) async {
    print("${Endpoints.baseurl}${Endpoints.consignmentByIdUrl}/$consignmentId");
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      final response = await http.get(
          Uri.parse(
              "${Endpoints.baseurl}${Endpoints.consignmentByIdUrl}/$consignmentId"),
          headers: headers);
      if (response.statusCode == 200) {
        print("consignmentByIdlist:${response.body}");
        final item = json.decode(response.body);
        consignmentByIdlist = ConsignmentByIdResponse.fromJson(item);
        print("consignmentByIdlist:$consignmentByIdlist");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("consignment by id request failed:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else {
        print("else");
      }
    } catch (e) {
      log(e.toString());
    }

    return consignmentByIdlist;
  }

  //1.GetAllCustomerList APi
  GetAllCustomerResponse getAllCustomerResponse = GetAllCustomerResponse(
      status: 0, data: GetAllCustomerList(count: 3, rows: []));

  Future<GetAllCustomerResponse> getAllCustomerCompanyNameApi() async {
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      final response = await http.get(
          Uri.parse(
              "${Endpoints.baseurl}${Endpoints.getAllCustomerUrl}/${Environement.companyID}?keyword=&sortkey=&sortvalue=desc&page=1&size=12"),
          headers: headers);
      if (response.statusCode == 200) {
        print("getAllCustomerResponse:${response.body}");
        final item = json.decode(response.body);
        getAllCustomerResponse = GetAllCustomerResponse.fromJson(item);

        print("getAllCustomerResponse:$getAllCustomerResponse");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("getAllCustomerResponse statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else {
        print("else");
      }
    } catch (e) {
      log(e.toString());
    }

    return getAllCustomerResponse;
  }

  //2.GetCustomerCompanyAddress Api
  CustomerCompanyAddressResponse customerCompanyAddressResponse =
      CustomerCompanyAddressResponse(status: 0, objcustomerbilladdressdata: []);

  Future<CustomerCompanyAddressResponse> getCustomerCompanyAddressApi(
      String customerid) async {
    print(
        "${Endpoints.baseurl}${Endpoints.getCustomerCompanyAddressUrl}/$customerid");
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      final response = await http.get(
          Uri.parse(
              "${Endpoints.baseurl}${Endpoints.getCustomerCompanyAddressUrl}/$customerid"),
          headers: headers);
      if (response.statusCode == 200) {
        print("BillingAddressCustomer:${response.body}");
        //final item = json.decode(response.body);
        customerCompanyAddressResponse =
            customerCompanyAddressResponseFromJson(response.body);

        print("customerCompanyAddressResponse:" +
            customerCompanyAddressResponse.objcustomerbilladdressdata.length
                .toString());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("BillingAddressCustomer statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else {
        print("else");
      }
    } catch (e) {
      log(e.toString());
    }

    return customerCompanyAddressResponse;
  }

  /*
  //3.GetCustomerList
  CustomersResponse customersResponse=CustomersResponse(status: 0, data: []);

  Future<CustomersResponse> getCustomerListApi(
      String customerid) async {
    try {
      final response = await http.get(Uri.parse(
          "${Endpoints.baseurl}${Endpoints.getCustomerListUrl}/85121810-512e-4366-95dd-4d660cffa206/${customerid}"));
      if (response.statusCode == 200) {
        print("customersResponse:${response.body}");
        final item = json.decode(response.body);
        customersResponse =
            CustomersResponse.fromJson(item);

        print(
            "customersResponse:$customersResponse");
      } else {
        print("else");
      }
    } catch (e) {
      log(e.toString());
    }

    return customersResponse;
  }*/

  //api not used now
  /*
  //4. GetDefaultAddressByCustomerId
  DefaultAddressByCustomerIdResponse defaultAddressByCustomerIdResponse = DefaultAddressByCustomerIdResponse(status: 0, customerdefaultaddressdata: []);

  Future<DefaultAddressByCustomerIdResponse> getDefaultAddressByCompanyIdApi(
      String customerid) async {
    try {
      final response = await http.get(Uri.parse(
          "${Endpoints.baseurl}${Endpoints.getDefaultAddressByCustomerIdUrl}/${customerid}/85121810-512e-4366-95dd-4d660cffa206"));
      if (response.statusCode == 200) {
        print("DefaultAddressByCustomerId:${response.body}");
        final item = json.decode(response.body);
        defaultAddressByCustomerIdResponse =
            DefaultAddressByCustomerIdResponse.fromJson(item);

        print(
            "defaultAddressByCustomerIdResponse:$defaultAddressByCustomerIdResponse");
      } else {
        print("else");
      }
    } catch (e) {
      log(e.toString());
    }

    return defaultAddressByCustomerIdResponse;
  }*/

  //5. GetParticularCustomerAllAddressByCustomerId
  GetParticularCustomerAllAddressByCustomerId objparticularcustomeralladdress =
      GetParticularCustomerAllAddressByCustomerId(
          status: 0, data: ParticularCustomerData(count: 0, rows: []));

  Future<GetParticularCustomerAllAddressByCustomerId>
      getparticularcustomeralladdress(String customerid) async {
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      print(
          "alladdressurl+${Endpoints.baseurl}${Endpoints.getParticularcustomeralladdress}/$customerid/${Environement.companyID}/");
      final response = await http.get(
          Uri.parse(
              "${Endpoints.baseurl}${Endpoints.getParticularcustomeralladdress}/$customerid/${Environement.companyID}"),
          headers: headers);

      if (response.statusCode == 200) {
        print("Particularcustomeralladdress:${response.body}");
        objparticularcustomeralladdress =
            ParticularCustomerAllAddressResponseFromJson(response.body);
        print(
            'objparticularcustomeralladdress:$objparticularcustomeralladdress');
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("Particularcustomeralladdress statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else {
        print("getparticularcustomeralladdress error");
      }
    } catch (e) {
      log(e.toString());
    }

    return objparticularcustomeralladdress;
  }

  //GetAllManifests
  GetAllManifestResponse getAllManifestListResponse = GetAllManifestResponse(
      status: 0, data: GetAllManifestData(count: 0, rows: []));

  Future<GetAllManifestResponse> getAllManifestApi() async {
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };

      final url =
          "${Endpoints.baseurl}${Endpoints.getAllManifestsUrl}/${Environement.companyID}?keyword=&status=&sortkey=&sortvalue=desc&page=1&size=10";
      print(url);

      final response = await http.get(Uri.parse(url), headers: headers);
      print(response.statusCode);
      print("getAllManifestListResponse:${response.body}");
      if (response.statusCode == 200) {
        // final item = json.decode(response.body);
        getAllManifestListResponse =
            GetAllManifestResponse.fromJson(json.decode(response.body));

        // print("getAllManifestListResponse:$getAllManifestListResponse");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("getAllManifestListResponse statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else {
        print("else");
      }
    } catch (e) {
      log(e.toString());
    }

    return getAllManifestListResponse;
  }

  //GetStates APi
  StatesResponse statesList = StatesResponse(status: 0, data: []);

  Future<StatesResponse> getStatesApi(int countryid) async {
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      final response = await http.get(
          Uri.parse("${Endpoints.baseurl}${Endpoints.getStatesUrl}"),
          headers: headers);
      if (response.statusCode == 200) {
        print("statesList:${response.body}");
        final item = json.decode(response.body);
        statesList = StatesResponse.fromJson(item);

        print("statesList:$statesList");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("statesList statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else {
        print("else");
      }
    } catch (e) {
      log(e.toString());
    }

    return statesList;
  }

//GetCountries Api
  CountriesResponse countriesList = CountriesResponse(status: 0, data: []);

  Future<CountriesResponse> getCountriesApi(String countries) async {
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      final response = await http.get(
          Uri.parse("${Endpoints.baseurl}${Endpoints.getCountriesUrl}"),
          headers: headers);
      if (response.statusCode == 200) {
        print("countriesList:${response.body}");
        final item = json.decode(response.body);
        countriesList = CountriesResponse.fromJson(item);
        print("countriesList:$countriesList");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("countriesList statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else {
        print("else");
      }
    } catch (e) {
      log(e.toString());
    }

    return countriesList;
  }

//Add Consignment APi
  Future<AddConsignmentResponse?> AddConsignmentApi(
      AddConsignmentRequest addConsignmentRequestObj) async {
    String url = Endpoints.baseurl + Endpoints.addConsignmentUrl;
    var consignmntresponsedataObj = AddConsignmentResponse();

    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };

      print('AddConsignmentRequestObj: ${addConsignmentRequestObj.toJson()}');

      var body = utf8.encode(json.encode(addConsignmentRequestObj));

      var response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .catchError((error) {
        print("Exception CreateConsignmentApi: $error");
      }).timeout(const Duration(seconds: Endpoints.connectionTimeout));
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        consignmntresponsedataObj =
            addConsignmentResponseFromJson(response.body);
        // print(dataObj);
        return consignmntresponsedataObj;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("add consignmnt statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException AddConsignmentApi: $e");
    } on SocketException catch (e) {
      // Other exception
      print("SocketException AddConsignmentApi: $e");
    } catch (e) {
      print("Exception AddConsignmentApi: $e");
    }
    return consignmntresponsedataObj;
  }

//Update Consignment APi
  //update request parameters are same as add consignment request params
  // that is why AddConsignmentRequest is used.
  Future<UpdateConsignmentResponse?> UpdateConsignmentApi(
      Updateconsignmentrequest updateConsignmentRequestObj,
      String selectedConsignmentId) async {
    String url = Endpoints.baseurl +
        Endpoints.updateConsignmentUrl +
        selectedConsignmentId;
    print("updateconsignmenturl " + url);
    var updateconsignmntresponsedataObj = UpdateConsignmentResponse();

    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };

      // print(
      //     'UpdateConsignmentRequestObj: ${updateConsignmentRequestObj.toJson()}');

      //var body = utf8.encode(json.encode(updateConsignmentRequestObj));
      var body = json.encode(updateConsignmentRequestObj);
      print('UpdateConsignmentRequestObj: $body');

      var response = await http.put(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
        },
        body: body,
      );
      //  .catchError((error) {
      // print("Exception UpdateConsignmentApi: $error");
      // })
      //   .timeout(const Duration(seconds: Endpoints.connectionTimeout));
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        updateconsignmntresponsedataObj =
            updateConsignmentResponseFromJson(response.body);
        // print(dataObj);
        return updateconsignmntresponsedataObj;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("updateconsignmntre statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException updateConsignmentApi: ${e.message}");
    } on SocketException catch (e) {
      // Other exception
      print(
          "SockupdateconsignmntresponsedataObjetException updateConsignmentApi: $e");
    } catch (e) {
      print("Exception updateConsignmentApi: $e");
    }
    return updateconsignmntresponsedataObj;
  }

  Future<DriverUploadDocResponse?> uploadDoc() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
    );
    if (result != null) {
      List<MultipartFile> files = result.paths
          .map((path) => MultipartFile.fromFileSync(
                path!,
                filename: getFileName(path),
                contentType: MediaType(
                  lookupMimeType(getFileName(path))!.split('/')[0],
                  lookupMimeType(getFileName(path))!.split('/')[1],
                ),
              ))
          .toList();
      var dio = Dio();
      var formData = FormData.fromMap({
        'driver_doc': files,
      });

      print("DocUploadParam:$formData");

      var uploadDocResponse = await dio.post(
        Endpoints.baseurl + Endpoints.uploadDocUrl,
        data: formData,
        onSendProgress: (received, total) {
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + '%');
          }
        },
      );
      print("DocResponse:$uploadDocResponse");
      // check response status code
      if (uploadDocResponse.statusCode == 201) {
        var map = uploadDocResponse.data as Map;
        print('success');
        return uploadDocResponse.data;
      } else if (uploadDocResponse.statusCode == 401 ||
          uploadDocResponse.statusCode == 403) {
        print("uploadDocResponse statusCode:${uploadDocResponse.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      }
    }
  }

  Future<AddTimeSheetResponse> addTimesheetApi(
      AddTimeSheetRequest addTimeSheetRequestObj) async {
    String url = Endpoints.baseurl + Endpoints.addTimesheet;

    print(url);
    var responsedataObj = AddTimeSheetResponse();

    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };

      print('AddTimeSheetRequestObj: ${addTimeSheetRequestObj.toJson()}');

      var body = utf8.encode(json.encode(addTimeSheetRequestObj));

      var response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .catchError((error) {
        print("Exception CreateTimesheetApi: $error");
      }).timeout(const Duration(seconds: Endpoints.connectionTimeout));
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        responsedataObj = addTimeSheetResponseFromJson(response.body);
        // print(dataObj);
        return responsedataObj;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("CreateTimesheetApi statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      }
      //   else if (response.statusCode == 401) {
      //     print('Not_Authorized');
      //     //  return objauthresponse;
      //   } else if (response.statusCode == 400) {
      //     print('Need_Email_Verification');

      //     //   return objauthresponse;
      //   } else {
      //     print('Server Error');
      //     //  return objauthresponse;
      //   }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException CreateTimesheetApi: $e");
    } on SocketException catch (e) {
      // Other exception
      print("SocketException CreateTimesheetApi: $e");
    } catch (e) {
      print("Exception CreateTimesheetApi: $e");
    }
    return responsedataObj;
  }

  Future<Updatetimesheetresponse> updatetimesheetapi(
      Updatetimesheetrequest updatetimesheetobj, String timesheetid) async {
    String url = Endpoints.baseurl +
        Endpoints.updatetimesheet +
        "/" +
        Environement.companyID +
        "/" +
        timesheetid;
    var updatetiesheetresponsedataObj = Updatetimesheetresponse(
        status: 0,
        rootdata: Rootdata(
            success: false,
            subdata: Subdata(
                timesheetDate: '',
                startTime: '',
                startOdometer: '',
                endTime: '',
                endOdometer: '',
                driverId: '',
                driverMobile: '',
                truck: '',
                trailer: '',
                updatedAt: '')));
    print(url);

    print('UpdatetimesheetRequestObj: ${updatetimesheetobj.toJson()}');
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      var body = utf8.encode(json.encode(updatetimesheetobj));

      var response = await http.put(Uri.parse(url),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
          },
          body: body);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        updatetiesheetresponsedataObj =
            updatetimesheetResponseFromJson(response.body);
        return updatetiesheetresponsedataObj;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("Update TimesheetApi statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException updateConsignmentApi: $e");
    } on SocketException catch (e) {
      // Other exception
      print(
          "SockupdateconsignmntresponsedataObjetException updateConsignmentApi: $e");
    } catch (e) {
      print("Exception updateConsignmentApi: $e");
    }
    return updatetiesheetresponsedataObj;
  }

  Future<GetDocManagerResponse> getDocManagerListApi() async {
    var companyID = Environement.companyID;

    var responsedataObj = GetDocManagerResponse();
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };

      Map<String, String> qParams = {
        'keyword': "",
        'sortkey': "",
        'sortvalue': "asc",
        'page': "1",
        'size': "12",
      };
      final Uri uri = Uri.parse(
          "${Endpoints.baseurl}${Endpoints.getAllDocManager}/$companyID?$qParams");

      print("uri:$uri");

      final response =
          await http.get(uri, headers: headers).catchError((error) {
        print("Exception GetDocManager: $error");
      }).timeout(const Duration(seconds: Endpoints.connectionTimeout));

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        responsedataObj = getDocManagerResponseFromJson(response.body);
        // print(dataObj);
        return responsedataObj;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("GetDocManager statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException CreateTimesheetApi: $e");
    } on SocketException catch (e) {
      // Other exception
      print("SocketException CreateTimesheetApi: $e");
    } catch (e) {
      print("Exception CreateTimesheetApi: $e");
    }
    return responsedataObj;
  }

  Future<GetDocTypeResponse> GetDocumentTypeApi(
      {required String companyID}) async {
    var docTypelist = GetDocTypeResponse();

    var url = "${Endpoints.baseurl}${Endpoints.getDocTypeList}/$companyID";
    print(url);
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      print(response.statusCode);
      if (response.statusCode == 200) {
        docTypelist = getDocTypeResponseFromJson(response.body);
        print("docTypelist:$docTypelist");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("docTypelist statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else {
        print("else");
      }
    } catch (e) {
      log(e.toString());
    }

    return docTypelist;
  }

/*Network client request for get all time sheet */
  Future<getalltimesheetresponse> getalltimesheetapi(
      String companyid, String driverid, int pageNum) async {
    Alltimesheetdata objalltimesheetdata = Alltimesheetdata(0, []);

    getalltimesheetresponse objalltimesheetdataresponse =
        getalltimesheetresponse(0, objalltimesheetdata);

    // companyid = '85121810-512e-4366-95dd-4d660cffa206';
    // driverid = '8c9c3fe8-4a7f-4861-80fd-c4065f0dd87b';
    String url =
        "${Endpoints.baseurl}${Endpoints.getalltimesheet}$companyid/${Environement.driverID}?keyword=&sortkey=&sortvalue=desc&page=$pageNum&size=12";
    print(url);
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      final params = {'company_id': companyid, 'id': driverid};
      final Uri uri = Uri.parse(url);
      //  final headers = {HttpHeaders.acceptHeader: '/'};
      final response = await http.get(uri, headers: headers);

      print(response.body);

      print(response.statusCode);
      if (response.statusCode == 200) {
        objalltimesheetdataresponse = getalltimesheetFromJson(response.body);

        print("getalltimesheet: " + objalltimesheetdataresponse.toString());
        return objalltimesheetdataresponse;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("getalltimesheet statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else if (response.statusCode == 400) {
        print('Need_Email_Verification');

        //   return objauthresponse;
      } else {
        print('Server Error');
        //  return objauthresponse;
      }
    } catch (e) {
      print("Exception_alltimesheetapi $e");
    }
    return objalltimesheetdataresponse;
  }

  /* Network client request for get time sheet by timesheet id*/
  Future<Filltimesheetresponse> getfilltimesheetapi(
      String companyid, String driverid) async {
    filltimesheetData objfilltimesheetdata = filltimesheetData('0', '0', '0',
        '0', '0', '0', '0', '0', '0', '0', '0', [], 'sdiugdyfgiu', [], []);

    Filltimesheetresponse objfilltimesheetdataresponse =
        Filltimesheetresponse(0, objfilltimesheetdata);

    companyid = Environement.companyID;
    // driverid = 'e1514425-f73c-4825-87dd-f3bd4776008c';
    driverid = Environement.driverID;

    // String url = Endpoints.apibaseUrl + Endpoints.getalltimesheet;
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      final Uri uri = Uri.parse(Endpoints.baseurl +
          Endpoints.filltimesheet +
          companyid +
          "/" +
          driverid);
      // final headers = {HttpHeaders.acceptHeader: '/'};
      final response = await http.get(uri, headers: headers);

      print(response.body);

      print(response.statusCode);
      if (response.statusCode == 200) {
        objfilltimesheetdataresponse = filltimesheetFromJson(response.body);

        print("filltimesheet: " + objfilltimesheetdataresponse.toString());
        return objfilltimesheetdataresponse;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("filltimesheet statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else if (response.statusCode == 400) {
        print('Need_Email_Verification');

        //   return objauthresponse;
      } else {
        print('Server Error');
        //  return objauthresponse;
      }
    } catch (e) {
      print("Exception_loginapi $e");
    }
    return objfilltimesheetdataresponse;
  }

/* Network client request for getting vehicle type / trailer */
  Future<TruckTypeResponse> getvehicletype(String type) async {
    TruckTypeResponse objgetalltrucktype = TruckTypeResponse(0, []);
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      final Uri uri =
          Uri.parse(Endpoints.baseurl + Endpoints.gettrucktype + type);

      final response = await http.get(uri, headers: headers);

      print(response.body);

      print(response.statusCode);

      if (response.statusCode == 200) {
        objgetalltrucktype = getalltrucktypeFromJson(response.body);

        print("trucktype: " + objgetalltrucktype.toString());
        return objgetalltrucktype;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("trucktype statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else if (response.statusCode == 400) {
        print('Need_Email_Verification');

        //   return objauthresponse;
      } else {
        print('Server Error');
      }
    } catch (e) {
      print("Exception_vehicletype" + e.toString());
    }
    return objgetalltrucktype;
  }

  /*Network client request for Vehicle Registration List*/
  Future<VehicleRegistrationResponseList> getvehicleregistrationlist(
      String type) async {
    VehicleRegistrationResponseList objgetallregistvehicle =
        VehicleRegistrationResponseList(status: 0, data: []);
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      final Uri uri = Uri.parse(Endpoints.baseurl +
          Endpoints.getvehiclereglist +
          Environement.companyID +
          "/" +
          type);

      print("url: " + uri.toString());

      final response = await http.get(uri, headers: headers);

      print(response.body);

      print(response.statusCode);

      if (response.statusCode == 200) {
        objgetallregistvehicle = getallregvehiclelistFromJson(response.body);

        print("truckreg: " + objgetallregistvehicle.toString());
        return objgetallregistvehicle;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("truckreg statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else if (response.statusCode == 400) {
        print('Need_Email_Verification');

        //   return objauthresponse;
      } else {
        print('Server Error');
      }
    } catch (e) {
      print("Exception_vehicletype" + e.toString());
    }
    return objgetallregistvehicle;
  }

  /*Network client request for fitness vehcile checklist api*/
  Future<FitnessVehicleChecklistApiResponse> getfitnessvehiclelist(
      String type) async {
    FitnessVehicleChecklistApiResponse objchecklistresponse =
        FitnessVehicleChecklistApiResponse(status: 0, fcdata: []);

    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };

      final Uri uri = Uri.parse(
          Endpoints.baseurl + Endpoints.fitnessvehcilecheklist + "/" + type);

      //final Uri uri = Uri.parse("https://api.jsonbin.io/v3/qs/64a7d906b89b1e2299bb1bf3");

      print("url: " + uri.toString());

      final response = await http.get(uri, headers: headers);

      print(response.body);

      print(response.statusCode);

      if (response.statusCode == 200) {
        objchecklistresponse = getallfitnesschklistFromJson(response.body);

        print("getfitnessvehiclelist: " + objchecklistresponse.toString());
        return objchecklistresponse;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("getfitnessvehiclelist statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else if (response.statusCode == 400) {
        print('Need_Email_Verification');

        //   return objauthresponse;
      } else {
        print('Server Error');
      }
    } catch (e) {
      print("Exception_fitness :" + e.toString());
    }
    return objchecklistresponse;
  }

  Future<FitnessSubmittedResponse> submitdriverfitness(String chklisttype,
      SubmitDriverFitnessRequest objdriverfitnessdata) async {
    FitnessSubmittedResponse objfitnesssubmittedresponse =
        FitnessSubmittedResponse(
            status: 0, data: fitnessData(success: false, data: ''));

    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };

      print("url:" + Endpoints.baseurl + Endpoints.addchecklist);

      print('drivefitnessparam: ${objdriverfitnessdata.toJson()}');

      var response = await http
          .post(Uri.parse(Endpoints.baseurl + Endpoints.addchecklist),
              headers: headers,
              body: utf8.encode(json.encode(objdriverfitnessdata)))
          .catchError((error) {
        print("Exception submitdriverfitness: $error");
      }).timeout(const Duration(seconds: Endpoints.connectionTimeout));

      print(response.statusCode);

      if (response.statusCode == 201) {
        print(response.body);
        objfitnesssubmittedresponse = fitnesssubmittedFromJson(response.body);

        print("submitresponsfitnessdriver: " +
            objfitnesssubmittedresponse.toString());
        return objfitnesssubmittedresponse;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("submitresponsfitnessdriver statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException CreateTimesheetApi: $e");
    } on SocketException catch (e) {
      // Other exception
      print("SocketException CreateTimesheetApi: $e");
    } catch (e) {
      print("Exception_submitdriverfitness" + e.toString());
    }
    return objfitnesssubmittedresponse;
  }

  Future<FitnessSubmittedResponse> submitvehiclefitness(String chklisttype,
      SubmitVehicleFitnessRequest objvehiclefitnessdata) async {
    FitnessSubmittedResponse objfitnesssubmittedresponse =
        FitnessSubmittedResponse(
            status: 0, data: fitnessData(success: false, data: ''));

    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };

      print("url:" + Endpoints.baseurl + Endpoints.addchecklist);

      var response = await http
          .post(Uri.parse(Endpoints.baseurl + Endpoints.addchecklist),
              headers: headers,
              body: utf8.encode(json.encode(objvehiclefitnessdata)))
          .catchError((error) {
        print("Exception submitvehiclefitness: $error");
      }).timeout(const Duration(seconds: Endpoints.connectionTimeout));

      print(response.statusCode);

      if (response.statusCode == 201) {
        print(response.body);
        objfitnesssubmittedresponse = fitnesssubmittedFromJson(response.body);

        print(
            "submitvehiclefitness: " + objfitnesssubmittedresponse.toString());
        return objfitnesssubmittedresponse;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("submitvehiclefitness statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException CreateTimesheetApi: $e");
    } on SocketException catch (e) {
      // Other exception
      print("SocketException CreateTimesheetApi: $e");
    } catch (e) {
      print("Exception_submitdriverfitness" + e.toString());
    }
    return objfitnesssubmittedresponse;
  }

  /*Network client request for submit filltime sheet*/

  Future<submitfilltimesheetresponse> Submitfilltimesheet(
      String companyid, String timesheetid) async {
    submitfilltimesheetresponse objfilltimesheetresponse =
        submitfilltimesheetresponse(0, submittimesheetdata(false));
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      final Uri uri = Uri.parse(Endpoints.baseurl +
          Endpoints.submitfilltimesheet +
          companyid +
          "/" +
          timesheetid);

      final response = await http.get(uri, headers: headers);

      print(response.body);

      print(response.statusCode);

      if (response.statusCode == 200) {
        objfilltimesheetresponse = submitfilltimesheetFromJson(response.body);

        print("submittimesheet: " + objfilltimesheetresponse.toString());
        return objfilltimesheetresponse;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("submittimesheet statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else if (response.statusCode == 400) {
        print('Need_Email_Verification');

        //   return objauthresponse;
      } else {
        print('Server Error');
      }
    } catch (e) {
      print("Exception_updatetimesheet" + e.toString());
    }
    return objfilltimesheetresponse;
  }

  Future<UploadDocumentResponse> addDocumentApi(
      AddDocumentRequest reqdata) async {
    String url = Endpoints.baseurl + Endpoints.addDocManager;

    print(url);
    var responsedataObj = UploadDocumentResponse();

    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };

      print('addDocumentApi: $reqdata');

      var body = utf8.encode(json.encode(reqdata));

      var response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .catchError((error) {
        print("Exception addDocumentApi: $error");
      }).timeout(const Duration(seconds: Endpoints.connectionTimeout));
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        responsedataObj = uploadDocumentResponseFromJson(response.body);
        // print(dataObj);
        return responsedataObj;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("addDocumentApi statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException CreateTimesheetApi: $e");
    } on SocketException catch (e) {
      // Other exception
      print("SocketException CreateTimesheetApi: $e");
    } catch (e) {
      print("Exception CreateTimesheetApi: $e");
    }
    return responsedataObj;
  }

  Future<GetTimeSheetByIdResponse> getTimesheetByIdApi(
      String companyID, String timesheetID) async {
    var getTimeSheetByIdResponse = GetTimeSheetByIdResponse();

    final url =
        "${Endpoints.baseurl}${Endpoints.getTimesheetByIDUrl}/$companyID/$timesheetID";
    print(url);

    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("response_timesheetbyid:" + response.body);
        // getTimeSheetByIdResponse =
        //   getTimeSheetByIdResponseFromJson(response.body);

        //print("GetTimeSheetByIdResponse:${getTimeSheetByIdResponse.toJson()}");
        Map<String, dynamic> data = jsonDecode(response.body);
        int status = data["status"];
        print("Status:" + status.toString());
        print("timesheetdate:" + data["data"]["timesheet_date"].toString());

        // List<String> arrtrailerlist = List<String>.from(json.decode(data["data"]["trailer"]));

        List<String>? arrtrailerlist = [];
        List<Timesheetjob>? arrtimesheetjob = [];
        List<Restdetail>? arrrestdetail = [];
        List<objchecklist>? arrchecklist = [];
        // Map maptrailerlist = json.decode(data["data"]["trailer"]);
        for (var strtrailer in data["data"]["trailer"]) {
          print("strtrailer:" + strtrailer.toString());
          arrtrailerlist.add(strtrailer.toString());
        }
        print("arrtrailerlist:" + arrtrailerlist.length.toString());

        for (var objtimesheetjob in data["data"]["timesheetjobs"]) {
          Timesheetjob itemtimesheetjob = Timesheetjob(
              timesheetJobId: objtimesheetjob["timesheet_job_id"],
              timesheetId: objtimesheetjob["timesheet_id"],
              companyId: objtimesheetjob["company_id"],
              consignmentId: objtimesheetjob["consignment_id"],
              jobName: objtimesheetjob["job_name"],
              customerName: objtimesheetjob["customer_name"],
              address: objtimesheetjob["address"],
              suburb: objtimesheetjob["suburb"],
              arrivalTime: objtimesheetjob["arrival_time"],
              departTime: objtimesheetjob["depart_time"],
              pickup: objtimesheetjob["pickup"],
              delivery: objtimesheetjob["delivery"],
              referenceNumber: objtimesheetjob["reference_number"],
              temp: objtimesheetjob["temp"],
              deliveredChep: objtimesheetjob["delivered_chep"],
              deliveredLoscomp: objtimesheetjob["delivered_loscomp"],
              deliveredPlain: objtimesheetjob["delivered_plain"],
              pickedUpChep: objtimesheetjob["picked_up_chep"],
              pickedUpLoscomp: objtimesheetjob["picked_up_loscomp"],
              pickedUpPlain: objtimesheetjob["picked_up_plain"],
              weight: objtimesheetjob["weight"]);
          arrtimesheetjob.add(itemtimesheetjob);
        }

        String reststarttime = '';
        for (var objrestdetail in data["data"]["restdetails"]) {
          DateTime now = DateTime.now();
          DateTime? parsedstrtTime;
          DateTime? parsedendtime;
          String formattedDate = DateFormat('yyyy-MM-dd').format(now);
          if (objrestdetail["start_time"] == '') {
            parsedstrtTime = DateTime.parse(formattedDate +
                " " +
                DateFormat("HH:mm:ss").format(DateTime.now()));
          } else {
            parsedstrtTime = DateTime.tryParse(objrestdetail["start_time"]);
          }

          if (objrestdetail["end_time"] == '') {
            parsedendtime = DateTime.parse(formattedDate +
                " " +
                DateFormat("HH:mm:ss").format(DateTime.now()));
          } else {
            parsedendtime = DateTime.tryParse(objrestdetail["end_time"]);
          }

          Restdetail itemrestdetail = Restdetail(
              restId: objrestdetail["rest_id"],
              timesheetId: objrestdetail["timesheet_id"],
              companyId: objrestdetail["company_id"],
              description: objrestdetail["description"],
              startTime: parsedstrtTime,
              endTime: parsedendtime);
          arrrestdetail.add(itemrestdetail);
        }

        for (var objchklist in data["data"]["checklist"]) {
          objchecklist itemchklist = objchecklist(
              id: objchklist["id"],
              timesheetid: objchklist["timesheet_id"],
              driverid: objchklist["driver_id"],
              companyid: objchklist["company_id"],
              checklistdate: objchklist["checklist_date"],
              checklisttype: objchklist["checklist_type"],
              checklistvalue: objchklist["checklist_value"],
              status: objchklist["status"]);
          arrchecklist.add(itemchklist);
        }

        try {
          List<String> timesheetdate;
          String strtimesheetdate = '';

          if (data["data"]["timesheet_date"].toString().contains("T")) {
            timesheetdate =
                data["data"]["timesheet_date"].toString().split("T");
            strtimesheetdate = timesheetdate[0];
          }
          /* else if (data["data"]["timesheet_date"].toString().contains(" ")) {
            timesheetdate =
                data["data"]["timesheet_date"].toString().split(" ");
            strtimesheetdate = timesheetdate[0];
          }*/

          getTimeSheetByIdResponse = GetTimeSheetByIdResponse(
              status: status,
              data: GetTimeSheetByIdData(
                  timeId: data["data"]["time_id"],
                  timesheetId: data["data"]["timesheet_id"],
                  companyId: data["data"]["company_id"],
                  // timesheetDate:data["data"]["timesheet_date"],
                  timesheetDate: DateTime.tryParse(strtimesheetdate),
                  startTime: data["data"]["start_time"],
                  startOdometer: data["data"]["start_odometer"],
                  endTime: data["data"]["end_time"],
                  endOdometer: data["data"]["end_odometer"],
                  driverId: data["data"]["driver_id"],
                  truck: data["data"]["truck"],
                  trailer: arrtrailerlist,
                  signature: data["data"]["signature"],
                  timesheetjobs: arrtimesheetjob,
                  restdetails: arrrestdetail,
                  checklist: arrchecklist));
        } catch (e) {
          print("timesheetdate_Exception:" + e.toString());
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("GetTimeSheetByIdResponse statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else {
        print("else");
      }
    } catch (e) {
      print("getTimesheetByIdApi:" + e.toString());
    }
    return getTimeSheetByIdResponse;
  }

  Future<Driverjobsresponse> getdriverjob(
      String? driverid, String pickupdate, String companyid) async {
    var objdriverjobs = Driverjobsresponse(data: Driverjobsdata(data: []));

    String url = Endpoints.baseurl + Endpoints.getdriverjob;

    print(url);
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      //var body = utf8.encode(json.encode({'driver_id':driverid, 'pickup_date':pickupdate}));
      var body = json.encode({
        'driver_id': driverid,
        'pickup_date': pickupdate,
        'company_id': companyid
      });
      print("driverjobrequest: " + body.toString());
      var response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .catchError((error) {
        print("Exception addDocumentApi: $error");
      }).timeout(const Duration(seconds: Endpoints.connectionTimeout));
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        objdriverjobs = driverjobsResponseFromJson(response.body);
        // print(dataObj);
        return objdriverjobs;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("getdriverjob statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      } else if (response.statusCode == 400) {
        print('Need_Email_Verification');

        //   return objauthresponse;
      } else {
        print('Server Error');
      }
    } catch (e) {
      log('getdriverjob' + e.toString());
    }

    return objdriverjobs;
  }

  Future<int> deletedTimesheetApi(
      DeleteTimesheetRequest deleteTimesheetRequest, String companyID) async {
    String url = Endpoints.baseurl + Endpoints.deletetimesheet + companyID;

    print(url);
    int status = 0;

    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };

      print('DeleteTimesheetRequest: ${deleteTimesheetRequest.toJson()}');

      var body = utf8.encode(json.encode(deleteTimesheetRequest));

      var response = await http
          .put(Uri.parse(url), headers: headers, body: body)
          .catchError((error) {
        print("Exception deletedTimesheetApi: $error");
      }).timeout(const Duration(seconds: Endpoints.connectionTimeout));
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        status = data["status"];
        // print(dataObj);
        return status;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("deletedTimesheetApi statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      }
      //   else if (response.statusCode == 401) {
      //     print('Not_Authorized');
      //     //  return objauthresponse;
      //   } else if (response.statusCode == 400) {
      //     print('Need_Email_Verification');

      //     //   return objauthresponse;
      //   } else {
      //     print('Server Error');
      //     //  return objauthresponse;
      //   }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException CreateTimesheetApi: $e");
    } on SocketException catch (e) {
      // Other exception
      print("SocketException CreateTimesheetApi: $e");
    } catch (e) {
      print("Exception CreateTimesheetApi: $e");
    }
    return status;
  }

  Future<bool> logOutApi() async {
    String url = Endpoints.authurl + Environement.Logout;
    final authToken = await SharedPreferenceHelper.authToken;
    final refreshToken = await SharedPreferenceHelper.refreshToken;

    try {
      Map<String, String> headers = {
        'cache-control': 'no-cache',
        'content-type': 'application/x-www-form-urlencoded',
        "Authorization": "Bearer $authToken"
      };

      Map<String, String> data = {
        "refresh_token": refreshToken,
        "client_id": Environement.CLIENT_ID,
        "client_secret": Environement.CLIENT_SECRET,
      };

      // print(url);
      // print(data);

      var response = await http
          .post(Uri.parse(url), headers: headers, body: data)
          .catchError((error) {
        print("Exception logOutApi: $error");
      }).timeout(const Duration(seconds: Endpoints.connectionTimeout));
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 204) {
        print("Logout Successfulyy");
        return true;
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException logOutApi: $e");
    } on SocketException catch (e) {
      // Other exception
      print("SocketException logOutApi: $e");
    } catch (e) {
      print("Exception logOutApi: $e");
    }
    return false;
  }

//for Signature in Consignment detail Screen
  Future<SignOnConsignmentResponse?> signOnConsignmentApi(
      SignOnConsignmentRequest signConsignmentRequestObj,
      String selectedConsignmentId,
      String driverId) async {
    String url =
        "${Endpoints.baseurl}${Endpoints.getSignOnConsignmentUrl}/$selectedConsignmentId/${Environement.companyID}";

    print("getSignOnConsignmentUrl: $url");
    var signconsignmntresponsedataObj = SignOnConsignmentResponse();

    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };

      var body = utf8.encode(json.encode(signConsignmentRequestObj));

      print('signConsignmentRequestObj: $body');

      var response =
          await http.put(Uri.parse(url), headers: headers, body: body);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        signconsignmntresponsedataObj =
            signOnConsignmentResponseFromJson(response.body);
        // print(dataObj);
        print("signconsignmntresponsedataObj:$signconsignmntresponsedataObj");
        return signconsignmntresponsedataObj;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print(" sign consignment status code:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException signConsignmentApi: ${e.message}");
    } on SocketException catch (e) {
      // Other exception
      print(
          "SockupdateconsignmntresponsedataObjetException signConsignmentApi: $e");
    } catch (e) {
      print("Exception signConsignmentApi: $e");
    }
    return signconsignmntresponsedataObj;
  }

  //Add Geo Location
  Future<AddGeoLocationResponse?> addGeoLocationApi(
    List<GeoDetail> addGeoLocationRequestObj,
  ) async {
    String url = "${Endpoints.baseurl}${Endpoints.addGeoLocationUrl}";

    print("addGeoLocationUrl: $url");
    var addGeoLocationresponsedataObj = AddGeoLocationResponse();

    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      Map<String, dynamic> addgeoparamrequest = {
        "geo_details": addGeoLocationRequestObj
            .map((geoDetails) => geoDetails.toJson())
            .toList()
      };
      // List jsonList = [];
      // addGeoLocationRequestObj
      //     .map((item) => jsonList.add(item.toJson()))
      //     .toList();
      var body = utf8.encode(json.encode(addGeoLocationRequestObj));

      print('addGeoLocationRequestObj: $body');

      var response = await http.post(Uri.parse(url),
          headers: headers,
          //  body: (json.encode({"geo_details": jsonList}["geo_details"])));
          body: json.encode(addgeoparamrequest));
      //body: body);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        addGeoLocationresponsedataObj =
            AddGeoLocationResponse.fromJson(jsonResponse);
        // print(dataObj);
        print(
            "addGeoLocationresponsedataObj status:${addGeoLocationresponsedataObj.status}");
        print(
            "addGeoLocationresponsedataObj data:${addGeoLocationresponsedataObj.data}");
        return addGeoLocationresponsedataObj;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("add geo location status code:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
        // return AddGeoLocationResponse(status: 0, data: '');
      } else {
        print("request failed");
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException addGeoLocationApi: ${e.message}");
    } on SocketException catch (e) {
      // Other exception
      print(
          "SockupdateconsignmntresponsedataObjetException addGeoLocationApi: $e");
    } catch (e) {
      print("Exception addGeoLocationApi: $e");
    }
    return addGeoLocationresponsedataObj;
  }

  //Get Geo Location

  GetGeoLocationResponse getGeoLocationData =
      GetGeoLocationResponse(data: GeoLocationData(rows: []));

  // List<GeoLocationRow> getGeoLocationData = [];
  Future<GetGeoLocationResponse> getGeoLocationApi(String consignmentid) async {
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };
      print(
          "${Endpoints.baseurl}${Endpoints.getGeoLocationUrl}/$consignmentid/${Environement.driverID}");
      final response = await http.get(
          Uri.parse(
              "${Endpoints.baseurl}${Endpoints.getGeoLocationUrl}/$consignmentid/${Environement.driverID}"),
          headers: headers);
      print("geo statuscode:${response.statusCode}");
      if (response.statusCode == 200) {
        print("getgeoresponseData:${response.body}");

        getGeoLocationData = getGeoLocationResponseFromJson(response.body);

        print(
            "getGeoLocationData:${getGeoLocationData.data.rows.map((e) => e.geoId)}");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("get geo location statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
        // return GetGeoLocationResponse(
        //     status: 0, data: GeoLocationData(count: 0, rows: []));
      } else {
        print("Get Geo location Request failed");
      }
    } catch (e) {
      log(e.toString());
    }
    return getGeoLocationData;
  }

  Future<int> addFaultReportApi(FaultReportingRequest reqdata) async {
    String url = Endpoints.baseurl + Endpoints.addfaultreport;

    print(url);

    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };

      print('FaultReportingRequest: $reqdata');

      var body = utf8.encode(json.encode(reqdata));

      var response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .catchError((error) {
        print("Exception FaultReportingRequest: $error");
      }).timeout(const Duration(seconds: Endpoints.connectionTimeout));
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        final resdata = json.decode(response.body);
        return resdata['status'];
      } else if (response.statusCode == 401) {
        return 401;
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException CreateTimesheetApi: $e");
    } on SocketException catch (e) {
      // Other exception
      print("SocketException CreateTimesheetApi: $e");
    } catch (e) {
      print("Exception CreateTimesheetApi: $e");
    }
    return 0;
  }

  Future<DriverProfileResponse> getDriverProfileApi() async {
    String url =
        Endpoints.baseurl + Endpoints.driverprofile + Environement.driverID;

    print(url);

    var driverProfileResponseObj = DriverProfileResponse();

    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };

      final response =
          await http.get(Uri.parse(url), headers: headers).catchError((error) {
        print("Exception addDocumentApi: $error");
      }).timeout(const Duration(seconds: Endpoints.connectionTimeout));
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201 || response.statusCode == 200) {
        driverProfileResponseObj = driverProfileResponseFromJson(response.body);
        return driverProfileResponseObj;
      } else if (response.statusCode == 401) {
        driverProfileResponseObj.status = 401;
        return driverProfileResponseObj;
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException CreateTimesheetApi: $e");
    } on SocketException catch (e) {
      // Other exception
      print("SocketException CreateTimesheetApi: $e");
    } catch (e) {
      print("Exception CreateTimesheetApi: $e");
    }
    return driverProfileResponseObj;
  }

  Future<CompanyDriverList> getcompanybydriverid(
      String userid, String usertype) async {
    String url = Endpoints.baseurl + Endpoints.getalldrivercompany;

    print(url);

    print("param:{$userid :$usertype}");

    var body =
        utf8.encode(json.encode({"user_id": userid, "user_type": usertype}));

    var objcompanydriverlist = CompanyDriverList(status: 0, data: []);
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };

      final response = await http
          .post(Uri.parse(url), body: body, headers: headers)
          .catchError((error) {
        print("Exception getcompanybydriverid: $error");
      }).timeout(const Duration(seconds: Endpoints.connectionTimeout));
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201 || response.statusCode == 200) {
        objcompanydriverlist = companydriverFromJson(response.body);
        return objcompanydriverlist;
      } else if (response.statusCode == 401) {
        objcompanydriverlist.status = 401;
        return objcompanydriverlist;
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException CreateTimesheetApi: $e");
    } on SocketException catch (e) {
      // Other exception
      print("SocketException CreateTimesheetApi: $e");
    } catch (e) {
      print("Exception getcompanybydriver:$e");
    }

    return objcompanydriverlist;
  }

  Future<int> deleteDocumentTypeApi(
      DeleteDocManagerRequest deleteDocumentTypeRequest) async {
    String url = Endpoints.baseurl + Endpoints.deleteDocManager;

    print(url);
    int status = 0;

    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };

      print('deleteDocumentTypeRequest: ${deleteDocumentTypeRequest.toJson()}');

      var body = utf8.encode(json.encode(deleteDocumentTypeRequest));

      var response = await http
          .put(Uri.parse(url), headers: headers, body: body)
          .catchError((error) {
        print("Exception deleteDocumentTypeRequest: $error");
      }).timeout(const Duration(seconds: Endpoints.connectionTimeout));
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        status = data["status"];
        // print(dataObj);
        return status;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("deleteDocumentTypeApi statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException : $e");
    } on SocketException catch (e) {
      // Other exception
      print("SocketException : $e");
    } catch (e) {
      print("Exception : $e");
    }
    return status;
  }

  Future<int> updateDocumentTypeApi(
      UpdateDocManagerRequest updateDocManagerRequest,
      String docManagerId) async {
    String url = Endpoints.baseurl + Endpoints.updateDocManager + docManagerId;

    print("updateDocManager url:$url");
    int status = 0;

    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
        "Authorization": "Bearer ${Environement.ACCESS_TOKEN}"
      };

      print('updateDocManagerRequest: ${updateDocManagerRequest.toJson()}');

      var body = utf8.encode(json.encode(updateDocManagerRequest));

      var response = await http
          .put(Uri.parse(url), headers: headers, body: body)
          .catchError((error) {
        print("Exception updateDocManagerRequest: $error");
      }).timeout(const Duration(seconds: Endpoints.connectionTimeout));
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        status = data["status"];
        // print(dataObj);
        return status;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("updateDocManagerapi statusCode:${response.statusCode}");
        navigatorKey.currentState!.pushNamed('/login');
      }
    } on TimeoutException catch (e) {
      // A timeout occurred.
      print("TimeoutException : $e");
    } on SocketException catch (e) {
      // Other exception
      print("SocketException : $e");
    } catch (e) {
      print("Exception : $e");
    }
    return status;
  }
}
