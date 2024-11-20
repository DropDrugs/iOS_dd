// Copyright © 2024 RT4. All rights reserved
import UIKit

public struct AppFontName {
    static let pThin = "Pretendard-Thin"
    static let pRegular = "Pretendard-Regular"
    static let pMedium = "Pretendard-Medium"
    static let pLight = "Pretendard-Light"
    static let pExtraLight = "Pretendard-ExtraLight"
    static let pExtraBold = "Pretendard-ExtraBold"
    static let pBold = "Pretendard-Bold"
    static let pSemiBold = "Pretendard-SemiBold"
    static let pBlack = "Pretendard-Black"
    static let roRegular = "RussoOne-Regular"
}

extension UIFont {
    // Pretendard Thin Font
    class func roRegularFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.roRegular, size: size)!
    }
    
    // Pretendard Thin Font
    class func ptdThinFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pThin, size: size)!
    }
    
    // Pretendard Regular Font
    class func ptdRegularFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pRegular, size: size)!
    }
    
    // Pretendard Medium Font
    class func ptdMediumFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pMedium, size: size)!
    }
    
    // Pretendard Light Font
    class func ptdLightFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pLight, size: size)!
    }
    
    // Pretendard ExtraLight Font
    class func ptdExtraLightFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pExtraLight, size: size)!
    }
    
    // Pretendard ExtraBold Font
    class func ptdExtraBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pExtraBold, size: size)!
    }
    
    // Pretendard Bold Font
    class func ptdBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pBold, size: size)!
    }
    
    // Pretendard SemiBold Font
    class func ptdSemiBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pSemiBold, size: size)!
    }
    
    // Pretendard Black Font
    class func ptdBlackFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pBlack, size: size)!
    }
}
