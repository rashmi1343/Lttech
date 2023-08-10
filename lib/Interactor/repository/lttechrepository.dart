import 'package:lttechapp/data/Api/lttech_network_api_client.dart';
import 'package:lttechapp/entity/ApiRequests/AddConsignmentRequest.dart';
import 'package:lttechapp/entity/ApiRequests/AddGeoLocationRequest.dart';
import 'package:lttechapp/entity/ApiRequests/UpdateDocManagerRequest.dart';
import 'package:lttechapp/entity/AuthenticationResponse.dart';
import 'package:lttechapp/entity/Filltimesheetresponse.dart';
import 'package:lttechapp/entity/GetDocTypeResponse.dart';
import 'package:lttechapp/entity/GetParticularCustomerAllAddressByCustomerId.dart';
import 'package:lttechapp/entity/getalltimesheetresponse.dart';
import 'package:lttechapp/entity/submitfilltimesheetresponse.dart';
import 'package:lttechapp/entity/trucktyperesponse.dart';

import '../../entity/AddConsignmentResponse.dart';
import '../../entity/AddGeoLocationResponse.dart';
import '../../entity/AddTimeSheetResponse.dart';
import '../../entity/ApiRequests/AddDocumentRequest.dart';
import '../../entity/ApiRequests/AddTimeSheetRequest.dart';

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
import '../../entity/DriverProfileResponse.dart';
import '../../entity/Driverjobresponse.dart';
import '../../entity/FitnessSubmittedResponse.dart';
import '../../entity/FitnessVehicleChecklistApiResponse.dart';
import '../../entity/GetAllCustomerResponse.dart';
import '../../entity/GetAllManifest.dart';
import '../../entity/GetDocManagerResponse.dart';
import '../../entity/ConsignmentByIdResponse.dart';
import '../../entity/DriverUploadDocResponse.dart';
import '../../entity/GetAllConsignmentResponse.dart';
import '../../entity/GetGeoLocationResponse.dart';
import '../../entity/GetTimeSheetByIdResponse.dart';
import '../../entity/SignOnConsignmentResponse.dart';
import '../../entity/StatesResponse.dart';
import '../../entity/UpdateConsignmentResponse.dart';
import '../../entity/Updatetimesheetresponse.dart';
import '../../entity/UploadDocumentResponse.dart';
import '../../entity/VehicleRegistrationResponseList.dart';
import '../../entity/VerifyTokenResponse.dart';

class LttechRepository {
  final lttechNetworkApiClient _lltechnetworkapiclient =
      lttechNetworkApiClient();

  Future<AuthenticationResponse> checkuserAuthentication(
      String email, String pwd) async {
    try {
      final authresponse = await _lltechnetworkapiclient.loginApi(email, pwd);
      return authresponse;
    } catch (e) {
      //  final errorMessage = DioExceptions.fromDioError(e);
      print("llttechrepository_auth $e");
      rethrow;
    }
  }

  Future<VerifyTokenResponse?> verifyTokenRepo() async {
    try {
      final authresponse = await _lltechnetworkapiclient.VerifyTokenAPI();
      return authresponse;
    } catch (e) {
      //  final errorMessage = DioExceptions.fromDioError(e);
      print("llttechrepository_VerifyTokenRepo $e");
      rethrow;
    }
  }

  Future<bool> forgetPasswordRepo(String email) async {
    try {
      final authresponse =
          await _lltechnetworkapiclient.forgetPasswordApi(email);
      return authresponse;
    } catch (e) {
      //  final errorMessage = DioExceptions.fromDioError(e);
      print("llttechrepository_VerifyTokenRepo $e");
      rethrow;
    }
  }

  Future<bool?> logOutRepo() async {
    try {
      final authresponse = await _lltechnetworkapiclient.logOutApi();
      return authresponse;
    } catch (e) {
      //  final errorMessage = DioExceptions.fromDioError(e);
      print("llttechrepository_logOutRepo $e");
      rethrow;
    }
  }

  Future<DriverUploadDocResponse?> docUpload() async {
    try {
      final docresponse = await _lltechnetworkapiclient.uploadDoc();
      return docresponse;
    } catch (e) {
      print("llttechrepository_auth $e");
      rethrow;
    }
  }

  Future<AddTimeSheetResponse> addTimesheetApiRepo(
      AddTimeSheetRequest addTimeSheetRequestObj) async {
    try {
      final responsedataObj =
          await _lltechnetworkapiclient.addTimesheetApi(addTimeSheetRequestObj);
      return responsedataObj;
    } catch (e) {
      //  final errorMessage = DioExceptions.fromDioError(e);
      print("llttechrepository_auth $e");
      rethrow;
    }
  }

  Future<Updatetimesheetresponse> updatetimesheetRepo(
      Updatetimesheetrequest updatetimesheetrequestobj,
      String selectedtimesheetId) async {
    try {
      final updatetimesheetResponse = await _lltechnetworkapiclient
          .updatetimesheetapi(updatetimesheetrequestobj, selectedtimesheetId);
      return updatetimesheetResponse;
    } catch (e) {
      print("UpdatetimesheetResponse $e");
      rethrow;
    }
  }

  Future<int> deleteTimesheetApiRepo(
      DeleteTimesheetRequest deleteTimesheetRequest, String companyID) async {
    try {
      final responsedataObj = await _lltechnetworkapiclient.deletedTimesheetApi(
          deleteTimesheetRequest, companyID);
      return responsedataObj;
    } catch (e) {
      //  final errorMessage = DioExceptions.fromDioError(e);
      print("llttechrepository_auth $e");
      rethrow;
    }
  }

  Future<GetAllConsignmentResponse> getAllConsignment(
      int pageNum, String consignmentTypestatus, String pageSize) async {
    try {
      final getAllConsignmntresponse = await _lltechnetworkapiclient
          .getAllConsignmentApi(pageNum, consignmentTypestatus, pageSize);
      return getAllConsignmntresponse;
    } catch (e) {
      print("getAllConsignmntresponse $e");
      rethrow;
    }
  }

  Future<ConsignmentByIdResponse> ConsignmentByIdRepo(
      String consignmentId) async {
    try {
      final consignmntByIdresponse =
          await _lltechnetworkapiclient.ConsignmentByIdApi(consignmentId);
      return consignmntByIdresponse;
    } catch (e) {
      print("ConsignmntByIdresponse $e");
      rethrow;
    }
  }

  Future<AddConsignmentResponse?> AddConsignmentRepo(
      AddConsignmentRequest addConsignmentRequestObj) async {
    try {
      final addConsignmentResponse =
          await _lltechnetworkapiclient.AddConsignmentApi(
              addConsignmentRequestObj);
      return addConsignmentResponse;
    } catch (e) {
      print("AddConsignmentResponse $e");
      rethrow;
    }
  }

  Future<UpdateConsignmentResponse?> updateConsignmentRepo(
      Updateconsignmentrequest updateConsignmentRequestObj,
      String selectedConsignmentId) async {
    try {
      final updateConsignmentResponse =
          await _lltechnetworkapiclient.UpdateConsignmentApi(
              updateConsignmentRequestObj, selectedConsignmentId);
      return updateConsignmentResponse;
    } catch (e) {
      print("UpdateConsignmentResponse $e");
      rethrow;
    }
  }

  Future<GetDocManagerResponse> getDocManagerApiRepo() async {
    try {
      final responsedataObj =
          await _lltechnetworkapiclient.getDocManagerListApi();
      return responsedataObj;
    } catch (e) {
      //  final errorMessage = DioExceptions.fromDioError(e);
      print("llttechrepository_auth $e");
      rethrow;
    }
  }

  Future<GetDocTypeResponse> getDocTypeApiRepo(
      {required String companyID}) async {
    try {
      final responsedataObj = await _lltechnetworkapiclient.GetDocumentTypeApi(
          companyID: companyID);
      return responsedataObj;
    } catch (e) {
      //  final errorMessage = DioExceptions.fromDioError(e);
      print("llttechrepository_auth $e");
      rethrow;
    }
  }

  Future<UploadDocumentResponse> addDocumentApiRepo(
      {required AddDocumentRequest reqdata}) async {
    try {
      final responsedataObj =
          await _lltechnetworkapiclient.addDocumentApi(reqdata);
      return responsedataObj;
    } catch (e) {
      //  final errorMessage = DioExceptions.fromDioError(e);
      print("llttechrepository_auth $e");
      rethrow;
    }
  }

  Future<CountriesResponse> getAllCountries(String countries) async {
    try {
      final getAllCountriesresponse =
          await _lltechnetworkapiclient.getCountriesApi(countries);
      return getAllCountriesresponse;
    } catch (e) {
      print("getAllCountriesresponse $e");
      rethrow;
    }
  }

  Future<StatesResponse> getAllStates(int countryid) async {
    try {
      final getAllStatesresponse =
          await _lltechnetworkapiclient.getStatesApi(countryid);
      return getAllStatesresponse;
    } catch (e) {
      print("lltechrepository_vehicletype $e");
      rethrow;
    }
  }

  //GetAllCustomer
  Future<GetAllCustomerResponse> getAllCustomerRepo() async {
    try {
      final getAllCustomer =
          await _lltechnetworkapiclient.getAllCustomerCompanyNameApi();
      return getAllCustomer;
    } catch (e) {
      print("lltechrepository_type $e");
      rethrow;
    }
  }

// Customer Billing Address
  Future<CustomerCompanyAddressResponse>
      getcustomercompanyaddressRepobyclientid(String customerid) async {
    try {
      final repocustomeraddress = await _lltechnetworkapiclient
          .getCustomerCompanyAddressApi(customerid);
      print("getCustomerCompanyAddressresponse:$repocustomeraddress");

      return repocustomeraddress;
    } catch (e) {
      print("lltechrepository_type $e");
      rethrow;
    }
  }

  //api not used now
  /*
  Future<DefaultAddressByCustomerIdResponse> getdefaultaddressRepobycustomerid(String clientid) async {
    try
    {
      final repodefaultcustomeraddress = await _lltechnetworkapiclient.getDefaultAddressByCompanyIdApi(clientid);
      return repodefaultcustomeraddress;
    }
    catch(e) {
      print("lltechrepository_type $e");
      rethrow;
    }
  }*/

  Future<GetParticularCustomerAllAddressByCustomerId>
      repogetparticularcustomeralladdress(String customerid) async {
    try {
      final repoparticularcustomeralladdress = await _lltechnetworkapiclient
          .getparticularcustomeralladdress(customerid);
      return repoparticularcustomeralladdress;
    } catch (e) {
      print("lltechrepository $e");
      rethrow;
    }
  }

  //GetAll Manifest List
  Future<GetAllManifestResponse> getAllManifestListRepo() async {
    try {
      final getAllManifestRes =
          await _lltechnetworkapiclient.getAllManifestApi();
      print("getAllManifestRes:$getAllManifestRes");

      return getAllManifestRes;
    } catch (e) {
      print("lltechrepository_type $e");
      rethrow;
    }
  }

  /*Repository function to get all timesheet response*/
  Future<getalltimesheetresponse> repogetalltimesheet(
      String companyid, String driverid, int pageNum) async {
    try {
      final objgetalltimesheetresponse = await _lltechnetworkapiclient
          .getalltimesheetapi(companyid, driverid, pageNum);
      return objgetalltimesheetresponse;
    } catch (e) {
      print("lltechrepository_alltimesheet $e");
      rethrow;
    }
  }

/*Repository function to get timesheet by timesheet id & company id*/

  Future<Filltimesheetresponse> repogetfilltimesheetresponse(
      String companyid, String driverid) async {
    try {
      final objfillgettimesheetresponse = await _lltechnetworkapiclient
          .getfilltimesheetapi(companyid, driverid);
      return objfillgettimesheetresponse;
    } catch (e) {
      print("lltechrepository_alltimesheet $e");
      rethrow;
    }
  }

  /* Repository function to get vehicle type or trailer */
  Future<TruckTypeResponse> repogetallvehicleresponse(String trucktype) async {
    try {
      final objgettrucktyperesponse =
          await _lltechnetworkapiclient.getvehicletype(trucktype);
      return objgettrucktyperesponse;
    } catch (e) {
      print("lltechrepository_vehicletype $e");
      rethrow;
    }
  }

  /* Repository function to get reg vehicle or trailer */
  Future<VehicleRegistrationResponseList> repogetallregvehicleresponse(
      String trucktype) async {
    try {
      final objgettrucktyperesponse =
          await _lltechnetworkapiclient.getvehicleregistrationlist(trucktype);
      return objgettrucktyperesponse;
    } catch (e) {
      print("lltechrepository_vehicleregistration $e");
      rethrow;
    }
  }

  /* Repository function to submit fill timesheet api */
  Future<submitfilltimesheetresponse> reposubmitfilltimesheet(
      String companyid, String timesheetid) async {
    try {
      final objsubmittimesheet =
          await _lltechnetworkapiclient.Submitfilltimesheet(
              companyid, timesheetid);
      return objsubmittimesheet;
    } catch (e) {
      print("lltechrepository_submittimesheet $e");
      rethrow;
    }
  }

  /* Repository function to Get timesheet by ID api */
  Future<GetTimeSheetByIdResponse> getTimesheetByIdRepo(
      String companyid, String timesheetid) async {
    try {
      final objgettimesheet = await _lltechnetworkapiclient.getTimesheetByIdApi(
          companyid, timesheetid);
      return objgettimesheet;
    } catch (e) {
      print("lltechrepository_submittimesheet $e");
      rethrow;
    }
  }

  /*Repository function to get driver jobs by driverid */

  Future<Driverjobsresponse> getdriverjobsrepo(
      String? driverid, String pickupdate, String companyid) async {
    try {
      final objdriverresponse = await _lltechnetworkapiclient.getdriverjob(
          driverid, pickupdate, companyid);
      return objdriverresponse;
    } catch (e) {
      print("lltechrepository_getdriverjobs $e");
      rethrow;
    }
  }

  Future<FitnessVehicleChecklistApiResponse> getchklistapirepo(
      String type) async {
    try {
      final objchklist =
          await _lltechnetworkapiclient.getfitnessvehiclelist(type);
      return objchklist;
    } catch (e) {
      print("lltechrepository_getdriverjobs $e");
      rethrow;
    }
  }

  Future<FitnessSubmittedResponse> submitdriverfitnessrepo(String chklisttype,
      SubmitDriverFitnessRequest objdriverfitnessdata) async {
    try {
      final objfitnesssubmitresponse = await _lltechnetworkapiclient
          .submitdriverfitness(chklisttype, objdriverfitnessdata);
      return objfitnesssubmitresponse;
    } catch (e) {
      print("lltechrepository_getdriverjobs $e");
      rethrow;
    }
  }

  Future<FitnessSubmittedResponse> submitvehiclefitnessrepo(String chklisttype,
      SubmitVehicleFitnessRequest objvehiclefitnessdata) async {
    try {
      final objfitnesssubmitresponse = await _lltechnetworkapiclient
          .submitvehiclefitness(chklisttype, objvehiclefitnessdata);
      return objfitnesssubmitresponse;
    } catch (e) {
      print("lltechrepository_getdriverjobs $e");
      rethrow;
    }
  }

  Future<SignOnConsignmentResponse?> signConsignmentRepo(
      SignOnConsignmentRequest signConsignmentRequestObj,
      String selectedConsignmentId,
      String driverId) async {
    try {
      final signConsignmentResponse =
          await _lltechnetworkapiclient.signOnConsignmentApi(
              signConsignmentRequestObj, selectedConsignmentId, driverId);
      return signConsignmentResponse;
    } catch (e) {
      print("signConsignmentResponse $e");
      rethrow;
    }
  }

  //addGeoLocation
  Future<AddGeoLocationResponse?> addGeoLocationRepo(
    List<GeoDetail> addGeoLocationRequestObj,
  ) async {
    try {
      final addGeoLocationResponse = await _lltechnetworkapiclient
          .addGeoLocationApi(addGeoLocationRequestObj);
      return addGeoLocationResponse;
    } catch (e) {
      print("addGeoLocationResponse $e");
      rethrow;
    }
  }

  //get GeoLocation
  Future<GetGeoLocationResponse?> getGeoLocationRepo(
      String selectedConsignmentId) async {
    try {
      final getGeoLocationResponse = await _lltechnetworkapiclient
          .getGeoLocationApi(selectedConsignmentId);
      return getGeoLocationResponse;
    } catch (e) {
      print("getGeoLocationResponse $e");
      rethrow;
    }
  }

  /*Repository function for adding fault report*/
  Future<int> addFaultReportRepo(FaultReportingRequest reqdata) async {
    try {
      final objfaultresponse =
          await _lltechnetworkapiclient.addFaultReportApi(reqdata);
      return objfaultresponse;
    } catch (e) {
      print("lltechrepository_objfaultresponse $e");
      rethrow;
    }
  }

  /*Repository function for driver profile*/
  Future<DriverProfileResponse> getDriverProfileRepo() async {
    try {
      final objresponse = await _lltechnetworkapiclient.getDriverProfileApi();
      return objresponse;
    } catch (e) {
      print("lltechrepository_DriverProfileRepo $e");
      rethrow;
    }
  }

  Future<CompanyDriverList> getcompanydriverlist(
      String userid, String usertype) async {
    try {
      final objdrivercompanylist =
          await _lltechnetworkapiclient.getcompanybydriverid(userid, usertype);
      return objdrivercompanylist;
    } catch (e) {
      print("lltechrepository_getcompanydriverlist $e");
      rethrow;
    }
  }

  Future<int> deleteDocumentTypeRepo(
      DeleteDocManagerRequest deleteDocumentTypeRequest) async {
    try {
      final responsedataObj = await _lltechnetworkapiclient
          .deleteDocumentTypeApi(deleteDocumentTypeRequest);
      return responsedataObj;
    } catch (e) {
      //  final errorMessage = DioExceptions.fromDioError(e);
      print("llttechrepository_auth $e");
      rethrow;
    }
  }

  Future<int> updateDocumentTypeRepo(
      UpdateDocManagerRequest updateDocManagerRequest,
      String docManagerId) async {
    try {
      final responsedataObj = await _lltechnetworkapiclient
          .updateDocumentTypeApi(updateDocManagerRequest, docManagerId);
      return responsedataObj;
    } catch (e) {
      //  final errorMessage = DioExceptions.fromDioError(e);
      print("llttechrepository_auth $e");
      rethrow;
    }
  }
}
