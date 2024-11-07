// Copyright © 2024 RT4. All rights reserved

import Foundation
import AuthenticationServices
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

class AppleAuthManager: NSObject, ASAuthorizationControllerDelegate {
    var isSignedIn = false
//    var currentUser: UserModel?
    
    // 상태 변경을 알리기 위한 클로저
//    var didChangeSignInStatus: ((Bool, UserModel?) -> Void)?
    
    
    //애플로그인 컨트롤
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("ID 토큰을 가져올 수 없습니다.")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("데이터에서 토큰 문자열을 String반환 실패: \(appleIDToken.debugDescription)")
                return
            }
            
            // Apple ID 자격증명
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nil, fullName: appleIDCredential.fullName) // Nonce필요 없을것같아 nil
            
            //  Firebase에 사용자 인증 요청
            Auth.auth().signIn(with: credential) { (authResult, error) in
                
                if let error = error {
                    print("Firebase 로그인 실패: \(error.localizedDescription)")
                    
                    DispatchQueue.main.async {
                        self.didChangeSignInStatus?(false, nil)
                    }
                    
                    return
                }
                
                if let user = authResult?.user{
                    let newUser = UserModel(
                        id: user.uid, // Firebase에서 제공하는 UID를 사용
                        loginId: appleIDCredential.email,
                        nickname: (appleIDCredential.fullName?.givenName ?? "") + " " + (appleIDCredential.fullName?.familyName ?? ""),
                        fcmToken: idTokenString
                    )
                    
                    DispatchQueue.main.async {
                        self.currentUser = newUser
                        self.isSignedIn = true
                        self.didChangeSignInStatus?(true, newUser)
                        
                        //FireStore저장
                        FirestoreService.shared.saveUserToFirestore(user: newUser)
                    }
                }
            }
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("Apple Login Failed: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.didChangeSignInStatus?(false, nil)
            }
        }
    }
}
