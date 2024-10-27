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
                    "NSLocationUsageDescription" : "지도 기능을 사용하기 위해서 위치정보 권한이 필요합니다.",
                    "NSLocationAlwaysUsageDescription" : "지도 기능을 사용하기 위해서 위치정보 권한이 필요합니다.",
                    "NSLocationAlwaysAndWhenInUseUsageDescription" : "지도 기능을 사용하기 위해서 위치정보 권한이 필요합니다."
                    // 새로운 거 추가
                ]
            ),
            sources: ["DropDrug/Sources/**"],
            resources: ["DropDrug/Resources/**"],
            dependencies: [
                .external(name: "Moya"),
                .external(name: "SnapKit"),
                .external(name: "PinLayout"),
                .external(name: "FlexLayout")
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
