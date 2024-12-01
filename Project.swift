import ProjectDescription

let project = Project(
    name: "DropDrug",
    targets: [
        .target(
            name: "DropDrug",
            destinations: .init([.iPhone, .iPad]),
            product: .app,
            bundleId: "io.tuist.DropDrug",
            deploymentTargets: .iOS("16.6"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "",
                    "CFBundleDisplayName" : "드롭드락",
                    "CFBundleShortVersionString" : "1.0",
                    "UIUserInterfaceStyle" : "Light",
                    "CFBundleDevelopmentRegion" : "ko_KR",
                    "CFBundleVersion" : "3",
                    "CFBundleIcons": [
                                "CFBundlePrimaryIcon": [
                                    "CFBundleIconFiles": ["AppIcon"],
                                    "UIPrerenderedIcon": true
                                ]
                            ],
                    "UISupportedInterfaceOrientations" : ["UIInterfaceOrientationPortrait"
                                                         ],
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ],
                            ]
                        ]
                    ],
                    "UIAppFonts": ["Pretendard-Black.otf",
                                   "Pretendard-Bold.otf",
                                   "Pretendard-ExtraBold.otf",
                                   "Pretendard-ExtraLight.otf",
                                   "Pretendard-Light.otf",
                                   "Pretendard-Medium.otf",
                                   "Pretendard-Regular.otf",
                                   "Pretendard-SemiBold.otf",
                                   "Pretendard-Thin.otf",
                                   "RussoOne-Regular.ttf"
                    ],
                    "NSUserTrackingUsageDescription" : "사용자 맞춤 정보 제공 및 서비스 개선을 위해 데이터를 사용합니다.",
                    "KAKAO_NATIVE_APP_KEY" : "74177ce7b14b89614c47ac7d51464b95",
                    "NSLocationAlwaysAndWhenInUseUsageDescription" : "주변 폐의약품 수거함 정보 제공을 위한 위치 권한을 항상 혹은 앱 활성 시에만 허용하시겠습니까?",
                    "NSLocationWhenInUseUsageDescription" : "주변 폐의약품 수거함 정보 제공을 위한 위치 권한을 앱 활성 시에만 허용하시겠습니까?",
                    "NSLocationAlwaysUsageDescription" : "주변 폐의약품 수거함 정보 제공을 위한 위치 권한을 항상 허용하시겠습니까?",
                    "NSCameraUsageDescription" : "폐의약품 사진 인증을 위한 카메라 사용 권한을 허용하시겠습니까?",
                    "NSAppTransportSecurity" : [
                        "NSAllowsArbitraryLoads" : true
                    ],
                    "CFBundleURLTypes" : [
                        [
                        "CFBundleTypeRole" : "Editor",
                        "CFBundleURLName" : "googleLogin",
                        "CFBundleURLSchemes" : ["com.googleusercontent.apps.793354407959-u9dhnjv92uuntv276pktnucura72o3j0"]
                        ],
                        [
                        "CFBundleTypeRole" : "Editor",
                        "CFBundleURLName" : "kakaologin",
                        "CFBundleURLSchemes" : ["kakao74177ce7b14b89614c47ac7d51464b95"]
                        ],
                    ],
                    "LSApplicationQueriesSchemes" : ["kakaokompassauth" , "kakaolink"],
                    "NMFClientId" : "a97eb0xf24",
                    "FirebaseAppDelegateProxyEnabled" : false,
                    "NSRemoteNotificationUsageDescription" : "푸시 알림을 통해 개인화된 최신 소식을 받아보세요.",
                    "UIBackgroundModes" : ["remote-notification"],
                    "ITSAppUsesNonExemptEncryption" : false,
                    // 새로운 거 추가
                ]
            ),
            sources: ["DropDrug/Sources/**"],
            resources: ["DropDrug/Resources/**"],
            entitlements: "DropDrug/DropDrug.entitlements",
            dependencies: [
                .xcframework(path: "DropDrug/Frameworks/SwiftUI_ChartView.xcframework", status: .required),
                .external(name: "Moya"),
                .external(name: "SnapKit"),
                .external(name: "PinLayout"),
                .external(name: "FlexLayout"),
                .external(name: "KeychainSwift"),
                
                .external(name: "KakaoSDK"),
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKCert"),
                .external(name: "KakaoSDKCertCore"),
                .external(name: "KakaoSDKCommon"),
                
                .external(name: "FirebaseAuth"),
                .external(name: "FirebaseCore"),
                .external(name: "FirebaseMessaging"),
                .external(name: "FirebaseFirestore"),
//                .external(name: "FirebaseAnalytics"),
                
                .external(name: "NaverMapSDK"),
                .external(name: "SDWebImage"),
//                .external(name: "Toast"),
                .external(name: "SwiftyToaster"),
                .external(name: "Lottie"),
//                .external(name: "Charts")
//                .sdk(name: "Charts", type: .framework)
//                .external(name: "GoogleSignIn"),
//                .external(name: "NMapsGeometry"),
//                .external(name: "NMapsMap")
            ],
            settings: .settings(base: SettingsDictionary().merging(["OTHER_LDFLAGS" : "-framework SwiftUI_ChartView", "SWIFT_VERSION" : "5.0",
                                                                                "DEVELOPMENT_TEAM" : "7L9YFLK4UM", "CODE_SIGN_STYLE" : "Automatic"]))
        ),
        .target(
            name: "DropDrugTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.DropDrugTests",
            infoPlist: .default,
            sources: ["DropDrug/Tests/**"],
            resources: [],
            dependencies: [.target(name: "DropDrug")]
        ),
    ],
    fileHeaderTemplate: "Copyright © 2024 RT4. All rights reserved"
)
