//  <uses-permission android:name="android.permission.INTERNET"/>
//  <uses-permission android:name="android.permission.READ_CONTACTS" />  
// <uses-permission android:name="android.permission.WRITE_CONTACTS" />
//   <uses-permission android:name="android.permission.USE_BIOMETRIC"/>
//com.impalapay.mobileV2View


// else if (data["error"] == true) {
//         if (data["message"] == "Use the the link to continue with your KYC" ||
//             data["message"] == "Use the the link to upload your kyc details") {
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return const Verification(
//                 data:
//                     "https://links.usesmileid.com/6482/1667ecc2-02d9-422b-b7a3-a833709e8e22");
//             // return Verification(data: data["url"]);
//           }));
//           // kycwebpage(data["url"]);
//         } else if (data["message"] == "Awaiting KYC verification") {
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return const PVerification();
//           }));
//         } else if (data["message"] ==
//             "KYC verification failed, use the link to try again") {
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return const RVerification(
//                 data:
//                     "https://links.usesmileid.com/6482/1667ecc2-02d9-422b-b7a3-a833709e8e22");
//             // return RVerification(data: data["url"]);
//           }));
//         }
//       }