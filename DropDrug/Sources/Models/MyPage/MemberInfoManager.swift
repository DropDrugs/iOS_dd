// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya
import UIKit
import SwiftyToaster

extension AccountSettingsVC {
    func fetchMemberInfo(completion: @escaping (Bool, Bool) -> Void) {
        provider.request(.fetchMemberInfo) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(MemberInfo.self)
                    self.nickname = data.nickname ?? ""
                    self.userId = data.email ?? "애플 로그인 상태입니다."
                    if data.email == nil {
                        // 애플로그인
                        completion(true, true)
                        return
                    }
                    completion(true, false)
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(false, false)
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false, false)
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
                        self.myPageProfileView.emailLabel.text = data.email ?? "애플 로그인 상태입니다."
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

