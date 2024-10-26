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
                ]
            ),
            sources: ["DropDrug/Sources/**"],
            resources: ["DropDrug/Resources/**"],
            dependencies: [
                .external(name: "Moya"),
                .external(name: "SnapKit")
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
