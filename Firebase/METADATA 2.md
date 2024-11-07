## Dependency Graph

"(~> X)" below means that the SDK requires all of the xcframeworks from X. You
should make sure to include all of the xcframeworks from X when including the
SDK.

## FirebaseAnalytics
- FBLPromises.xcframework
- FirebaseAnalytics.xcframework
- FirebaseCore.xcframework
- FirebaseCoreInternal.xcframework
- FirebaseInstallations.xcframework
- GoogleAppMeasurement.xcframework
- GoogleAppMeasurementIdentitySupport.xcframework
- GoogleUtilities.xcframework
- nanopb.xcframework

## FirebaseABTesting (~> FirebaseAnalytics)
- FirebaseABTesting.xcframework

## FirebaseAnalyticsOnDeviceConversion (~> FirebaseAnalytics)
- FirebaseAnalyticsOnDeviceConversion.xcframework
- GoogleAppMeasurementOnDeviceConversion.xcframework

## FirebaseAppCheck (~> FirebaseAnalytics)
- AppCheckCore.xcframework
- FirebaseAppCheck.xcframework
- FirebaseAppCheckInterop.xcframework

## FirebaseAppDistribution (~> FirebaseAnalytics)
- FirebaseAppDistribution.xcframework

## FirebaseAuth (~> FirebaseAnalytics)
- FirebaseAppCheckInterop.xcframework
- FirebaseAuth.xcframework
- FirebaseAuthInterop.xcframework
- FirebaseCoreExtension.xcframework
- GTMSessionFetcher.xcframework
- RecaptchaInterop.xcframework

## FirebaseCrashlytics (~> FirebaseAnalytics)
- FirebaseCoreExtension.xcframework
- FirebaseCrashlytics.xcframework
- FirebaseRemoteConfigInterop.xcframework
- FirebaseSessions.xcframework
- GoogleDataTransport.xcframework
- Promises.xcframework

## FirebaseDatabase (~> FirebaseAnalytics)
- FirebaseAppCheckInterop.xcframework
- FirebaseDatabase.xcframework
- FirebaseSharedSwift.xcframework
- leveldb.xcframework

## FirebaseDynamicLinks (~> FirebaseAnalytics)
- FirebaseDynamicLinks.xcframework

## FirebaseFirestore (~> FirebaseAnalytics)
- FirebaseAppCheckInterop.xcframework
- FirebaseCoreExtension.xcframework
- FirebaseFirestore.xcframework
- FirebaseFirestoreInternal.xcframework
- FirebaseSharedSwift.xcframework
- absl.xcframework
- grpc.xcframework
- grpcpp.xcframework
- leveldb.xcframework
- openssl_grpc.xcframework

## FirebaseFunctions (~> FirebaseAnalytics)
- FirebaseAppCheckInterop.xcframework
- FirebaseAuthInterop.xcframework
- FirebaseCoreExtension.xcframework
- FirebaseFunctions.xcframework
- FirebaseMessagingInterop.xcframework
- FirebaseSharedSwift.xcframework
- GTMSessionFetcher.xcframework

## FirebaseInAppMessaging (~> FirebaseAnalytics)
- FirebaseABTesting.xcframework
- FirebaseInAppMessaging.xcframework

## FirebaseMLModelDownloader (~> FirebaseAnalytics)
- FirebaseCoreExtension.xcframework
- FirebaseMLModelDownloader.xcframework
- GoogleDataTransport.xcframework
- SwiftProtobuf.xcframework

## FirebaseMessaging (~> FirebaseAnalytics)
- FirebaseMessaging.xcframework
- GoogleDataTransport.xcframework

## FirebasePerformance (~> FirebaseAnalytics)
- FirebaseABTesting.xcframework
- FirebaseCoreExtension.xcframework
- FirebasePerformance.xcframework
- FirebaseRemoteConfig.xcframework
- FirebaseRemoteConfigInterop.xcframework
- FirebaseSessions.xcframework
- FirebaseSharedSwift.xcframework
- GoogleDataTransport.xcframework
- Promises.xcframework

## FirebaseRemoteConfig (~> FirebaseAnalytics)
- FirebaseABTesting.xcframework
- FirebaseRemoteConfig.xcframework
- FirebaseRemoteConfigInterop.xcframework
- FirebaseSharedSwift.xcframework

## FirebaseStorage (~> FirebaseAnalytics)
- FirebaseAppCheckInterop.xcframework
- FirebaseAuthInterop.xcframework
- FirebaseCoreExtension.xcframework
- FirebaseStorage.xcframework
- GTMSessionFetcher.xcframework

## Google-Mobile-Ads-SDK (~> FirebaseAnalytics)
- GoogleMobileAds.xcframework
- UserMessagingPlatform.xcframework

## GoogleSignIn
- AppAuth.xcframework
- AppCheckCore.xcframework
- GTMAppAuth.xcframework
- GTMSessionFetcher.xcframework
- GoogleSignIn.xcframework



## Versions

The xcframeworks in this directory map to these versions of the Firebase SDKs in
CocoaPods.

               CocoaPod                | Version
---------------------------------------|---------
AppAuth                                | 1.7.5
AppCheckCore                           | 11.1.0
BoringSSL-GRPC                         | 0.0.36
Firebase                               | 11.4.0
FirebaseABTesting                      | 11.4.0
FirebaseAnalytics                      | 11.4.0
FirebaseAnalyticsOnDeviceConversion    | 11.4.0
FirebaseAppCheck                       | 11.4.0
FirebaseAppCheckInterop                | 11.4.0
FirebaseAppDistribution                | 11.4.0-beta
FirebaseAuth                           | 11.4.0
FirebaseAuthInterop                    | 11.4.0
FirebaseCore                           | 11.4.0
FirebaseCoreExtension                  | 11.4.0
FirebaseCoreInternal                   | 11.4.0
FirebaseCrashlytics                    | 11.4.0
FirebaseDatabase                       | 11.4.0
FirebaseDynamicLinks                   | 11.4.0
FirebaseFirestore                      | 11.4.0
FirebaseFirestoreInternal              | 11.4.0
FirebaseFunctions                      | 11.4.0
FirebaseInAppMessaging                 | 11.4.0-beta
FirebaseInstallations                  | 11.4.0
FirebaseMLModelDownloader              | 11.4.0-beta
FirebaseMessaging                      | 11.4.0
FirebaseMessagingInterop               | 11.4.0
FirebasePerformance                    | 11.4.0
FirebaseRemoteConfig                   | 11.4.0
FirebaseRemoteConfigInterop            | 11.4.0
FirebaseSessions                       | 11.4.0
FirebaseSharedSwift                    | 11.4.0
FirebaseStorage                        | 11.4.0
FirebaseVertexAI                       | 11.4.0
GTMAppAuth                             | 4.1.1
GTMSessionFetcher                      | 3.5.0
Google-Mobile-Ads-SDK                  | 11.10.0
GoogleAppMeasurement                   | 11.4.0
GoogleAppMeasurementOnDeviceConversion | 11.4.0
GoogleDataTransport                    | 10.1.0
GoogleSignIn                           | 8.0.0
GoogleUserMessagingPlatform            | 2.6.0
GoogleUtilities                        | 8.0.2
PromisesObjC                           | 2.4.0
PromisesSwift                          | 2.4.0
RecaptchaInterop                       | 100.0.0
SwiftProtobuf                          | 1.28.2
abseil                                 | 1.20240116.2
gRPC-C++                               | 1.65.5
gRPC-Core                              | 1.65.5
leveldb-library                        | 1.22.5
nanopb                                 | 3.30910.0

