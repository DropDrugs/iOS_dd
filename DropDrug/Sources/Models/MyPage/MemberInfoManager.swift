// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya
import UIKit
import SwiftyToaster

extension AccountSettingsVC {
    func fetchMemberInfo(completion: @escaping (Bool) -> Void) {
        provider.request(.fetchMemberInfo) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(MemberInfo.self)
                    self.nickname = data.nickname
                    let hasKakaoTokens = SelectLoginTypeVC.keychain.get("KakaoAccessToken") != nil || SelectLoginTypeVC.keychain.get("KakaoRefreshToken") != nil || SelectLoginTypeVC.keychain.get("KakaoIdToken") != nil
                    self.userId = data.email
                    completion(true)
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(false)
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
}

extension MyPageVC {
    func fetchMemberInfo(completion: @escaping (Bool) -> Void) {
        MemberProvider.request(.fetchMemberInfo) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(MemberInfo.self)
                    DispatchQueue.main.async {
                        self.myPageProfileView.nameLabel.text = data.nickname
                        self.myPageProfileView.emailLabel.text = data.email
                        if let character = self.findCharacter(by: data.selectedChar) {
                            self.myPageProfileView.profileImageView.image = UIImage(named: character.image)
                        }
                        self.rewardView.pointsLabel.text = "\(data.point) P"
                    }
                    completion(true)
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(false)
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
    
    private func findCharacter(by id: Int) -> CharacterModel? {
        return Constants.CharacterList.first { $0.id == id }
    }
}

