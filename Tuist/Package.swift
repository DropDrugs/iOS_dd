// swift-tools-version: 6.0
@preconcurrency import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: ["Moya" : .framework,
                       "SnapKit": .framework,
                       "PinLayout": .framework,
                       "FlexLayout": .framework,
                       "KeychainSwift" : .framework,
                       "KakaoSDK": .staticLibrary,
                       "KakaoSDKAuth": .staticLibrary,
                       "KakaoSDKCert": .staticLibrary,
                       "KakaoSDKCertCore": .staticLibrary,
                       "KakaoSDKCommon": .staticLibrary,
//                       "GoogleSignIn" : .staticLibrary,
                       "FirebaseCore" : .staticLibrary,
                       "FirebaseAuth" : .staticLibrary,
                       "FirebaseMessaging" : .staticLibrary,
                       "FirebaseFirestore" : .staticLibrary,
//                       "FirebaseAnalytics" : .staticLibrary,
                       "NaverMapSDK" : .framework,
//                       "NMapsMap" : .staticLibrary,
//                       "NMapsGeometry" : .staticLibrary
                       "SDWebImage" : .framework,
                       "Toast" : .framework,
                       "Lottie" : .framework
//                       "Charts" : .framework
                      ]
    )
#endif

let package = Package(
    name: "DropDrug",
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0"),
        .package(url: "https://github.com/layoutBox/PinLayout.git", from: "1.10.5"),
        .package(url: "https://github.com/layoutBox/FlexLayout.git", from: "2.0.10"),
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", from: "2.23.0"),
//        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "8.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.4.0"),
        .package(url: "https://github.com/slr-09/Naver-Map-iOS-SPM.git", from: "0.1.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.19.7"),
        .package(url: "https://github.com/scalessec/Toast-Swift.git", from: "5.1.1"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.0"),
        
//        .package(url: "https://github.com/danielgindi/Charts.git", from: "5.1.0")
    ]
)
