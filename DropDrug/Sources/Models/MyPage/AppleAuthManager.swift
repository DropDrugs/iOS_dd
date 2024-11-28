// Copyright © 2024 RT4. All rights reserved

import UIKit
import AuthenticationServices
import SwiftyToaster

extension AccountSettingsVC : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func reAuthenticateWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [] // 재인증 시 추가 정보는 필요 없으므로 빈 배열
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let authorizationCodeData = appleIDCredential.authorizationCode,
               let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) {
                self.callAppleQuit(authorizationCode) { isSuccess in
                    if isSuccess {
                        Toaster.shared.makeToast("계정 삭제 완료")
                        self.showSplashScreen()
                    } else {
                        Toaster.shared.makeToast("계정 삭제 실패 - 다시 시도해주세요")
                    }
                }
            } else {
                print("Authorization Code is nil")
            }
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Re-Authentication Failed: \(error.localizedDescription)")
    }
    
}
