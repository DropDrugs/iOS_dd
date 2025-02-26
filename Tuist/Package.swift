// swift-tools-version: 6.0
@preconcurrency import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: ["Moya" : .framework,
                       "SnapKit": .framework,
                       "KeychainSwift" : .framework,
                       "KakaoSDK": .staticLibrary,
                       "FirebaseCore" : .staticLibrary,
                       "FirebaseAuth" : .staticLibrary,
                       "FirebaseAnalytics" : .staticLibrary,
                       "NaverMapSDK" : .framework,
//                       "NMapsMap" : .staticLibrary,
//                       "NMapsGeometry" : .staticLibrary
                       "SDWebImage" : .framework,
                       "Lottie" : .framework,
                       "SwiftyToaster" : .framework,
                       "Then" : .framework,
                       "NVActivityIndicatorView" : .framework,
                      ]
    )
#endif

let package = Package(
    name: "DropDrug",
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0"),
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", from: "2.23.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.4.0"),
        .package(url: "https://github.com/slr-09/Naver-Map-iOS-SPM.git", from: "0.1.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.19.7"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.0"),
        .package(url: "https://github.com/noeyiz/SwiftyToaster.git", from: "1.0.2"),
        .package(url: "https://github.com/devxoul/Then", from: "3.0.0"),
        .package(url: "https://github.com/ninjaprox/NVActivityIndicatorView.git", from: "5.2.0"),
    ]
)
