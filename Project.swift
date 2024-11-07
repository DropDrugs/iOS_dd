import ProjectDescription

let project = Project(
    name: "DropDrug",
    targets: [
        .target(
            name: "DropDrug",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.DropDrug",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
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
                    "NSLocationAlwaysAndWhenInUseUsageDescription" : "위치 권한을 항상 혹은 앱 활성 시에만 허용하시겠습니까?",
                    "NSLocationWhenInUseUsageDescription" : "위치 권한을 앱 활성 시에만 허용하시겠습니까?",
                    "NSLocationAlwaysUsageDescription" : "위치 권한을 항상 허용하시겠습니까?",
                    "NSCameraUsageDescription" : "카메라 사용 권한을 허용하시겠습니까?",
                    "NSAppTransportSecurity" : [
                        "NSAllowsArbitraryLoads" : true
                    ],
                    "CFBundleURLTypes" : [
                        "CFBundleTypeRole" : "Editor",
                        "CFBundleURLSchemes" : ["com.googleusercontent.apps.793354407959-u9dhnjv92uuntv276pktnucura72o3j0"]
                    ]
                    // 새로운 거 추가
                ]
            ),
            sources: ["DropDrug/Sources/**"],
            resources: ["DropDrug/Resources/**"],
            dependencies: [
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
//                .external(name: "GoogleSignIn-iOS"),
                .external(name: "GoogleSignIn"),
//                .package(product: "KakaoSDK"),
//                .package(product: "KakaoSDKAuth"),
//                .package(product: "KakaoSDKCert"),
//                .package(product: "KakaoSDKCertCore"),
//                .package(product: "KakaoSDKCommon"),
                .package(product: "FirebaseAuth"),
//                .external(name: "kakao-ios-sdk")
//                .sdk(name: "kakao-ios-sdk", type: .library),
//                .xcframework(path: <#T##Path#>, status: <#T##LinkingStatus#>, condition: <#T##PlatformCondition?#>)
            ]
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
