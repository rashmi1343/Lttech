import 'package:lttechapp/router/routes.dart';
import 'package:lttechapp/utility/env.dart';
import 'package:lttechapp/view/Splash/SplashScreen.dart';
import 'package:lttechapp/view/addconsignment_page.dart';
import 'package:lttechapp/view/addjobdetail_page.dart';
import 'package:lttechapp/view/consignment_details_page.dart';
import 'package:lttechapp/view/consignment_job_page.dart';
import 'package:lttechapp/view/login_page.dart';
import 'package:lttechapp/view/widgets/AddConsignment/AddConsignmentViewPageSix.dart';
import 'package:lttechapp/view/widgets/AddConsignment/AddConsignmentViewPagefive.dart';
import 'package:lttechapp/view/widgets/AddConsignment/AddConsignmentViewPagefour.dart';
import 'package:lttechapp/view/widgets/AddConsignment/AddConsignmentViewPagethree.dart';
import 'package:lttechapp/view/widgets/AddConsignment/AddConsignmentViewPagetwo.dart';
import 'package:lttechapp/view/widgets/FillTimesheet/EditRestDetails.dart';
import 'package:lttechapp/view/widgets/Jobdetail/JobdetailView.dart';
import 'package:lttechapp/view/widgets/FillTimesheet/FillTimesheet.dart';
import 'package:lttechapp/view/widgets/FillTimesheet/RestDetails.dart';
import 'package:lttechapp/view/widgets/FillTimesheet/VehicleChecklist.dart';
import 'package:lttechapp/view/widgets/ListTimesheet/TimesheetList.dart';

import '../view/dashboard_page.dart';
import '../view/fault_reporting_page.dart';
import '../view/fitness_checklist_page.dart';

import '../view/widgets/DocManager/AddDocument.dart';
import '../view/widgets/DocManager/DocManager.dart';
import '../view/widgets/ForgetPassword.dart';
import '../view/widgets/Location/MapBoxLocation.dart';

import '../view/widgets/Profile/Profile.dart';
import '../view/widgets/Settings/Settings.dart';
import '../view/widgets/SignatureView/SignatureView.dart';

class AppRoutes {
  static final routes = {
    // Routes.home : (context) =>const MyHomePage(title: 'Lttech',),
    Routes.splash: (context) => SplashScreen(),
    Routes.login: (context) => LoginPage(),
    Routes.forgetpassword: (context) => ForgetPassword(),
   // Routes.addjobdetail: (context) => AddJobdetailPage(),
    Routes.addjobdetail: (context) => JobdetailView(),
    Routes.fitnessChecklist: (context) => FitnessCheckListPage(),
    Routes.dashboard: (context) => DashboardPage(),

    Routes.fillTimesheet: (context) => FillTimesheet(),
    Routes.vehicleChecklist: (context) => VehicleChecklist(),
    Routes.consignmentJob: (context) => ConsignmentJobPage(),
    Routes.restDetails: (context) => RestDetails(),
    Routes.consignmentDetails: (context) => ConsignmentDetailsPage(
          index: Environement.indexPstConsignmentListing,
          consignmentId: Environement.consignmentId,
        ),

    Routes.signatureview: (context) => lltechSignatureView(
          index: Environement.indexPstConsignmentListing,
        ),
    Routes.addconsignment: (context) => AddConsignmentPage(),
    Routes.addconsignmenttwo: (context) => AddConsignmentViewPagetwo(),
    Routes.addconsignmentthree: (context) => AddConsignmentViewPagethree(),
    Routes.addconsignmentfour: (context) => AddConsignmentViewPagefour(),
    Routes.addconsignmentfive: (context) => AddConsignmentViewPagefive(),
    Routes.addconsignmentsix: (context) => AddConsignmentViewPageSix(),
    Routes.faultReporting: (context) => FaultReportingPage(),

    Routes.listtimesheet: (context) => TimesheetList(),
    Routes.docmanager: (context) => DocManager(),

    Routes.adddocument: (context) => AddDocument(),
    Routes.settings: (context) => Settings(),
    Routes.profile: (context) => Profile(),
    Routes.location: (context) => MapBoxLocation(),
    Routes.editrestdetail: (context) => EditRestDetails(
          indexrestdetail: 0,
          restdetail: null,
        ),
  };
}
