
// import 'package:vendor/utility/network.dart';

// class AccountManagementBloc
//     extends Bloc<AccountManagementEvent, AccountManagementState> {
//   AccountManagementBloc() : super(AccountManagementIntialState());

//   @override
//   Stream<AccountManagementState> mapEventToState(
//       AccountManagementEvent event) async* {
//     if (event is GetAccountManagementEvent) {
//       if (event.mobile.length != 10) {
//         yield GetAccountManagementFailureState(
//             message: "Mobile Number Invalid", succes: false);
//       } else {
//         yield* getAccountManagement(
//           event.mobile,
//         );
//       }
//     }
//     if (event is GetVendorCategoryEvent) {
//       yield* getVendorCategoryByIdResponse();
//     }
//     // if(event is)
//   }

//   Stream<> getAccountManagement(mobile) async* {
//     if (await Network.isConnected()) {
//       yield GetAccountManagementLoadingstate();
//       try {
//         AccountManagement result =
//             await apiProvider.getCustomerCoins(mobile);
//         log("$result");
//         if (result.success) {
//           yield GetAccountManagementState(
//               message: result.message,
//               data: result.data!.walletBalance,
//               succes: result.success);
//         } else {
//           yield GetAccountManagementFailureState(
//               message: result.message, succes: result.success);
//         }
//       } catch (error) {
//         yield GetAccountManagementFailureState(
//             message: "internal Server error", succes: false);
//       }
//     } else {
//       Fluttertoast.showToast(msg: "Turn on the internet");
//     }
//   }
