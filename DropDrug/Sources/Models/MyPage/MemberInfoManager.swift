// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya

extension AccountSettingsVC {
    func fetchMemberInfo(completion: @escaping (Bool) -> Void) {
        provider.request(.fetchMemberInfo) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(MemberInfo.self)
                    self.nickname = data.nickname
                    self.userId = data.email
                    completion(true)
                } catch {
                    completion(false)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
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
                        self.rewardView.pointsLabel.text = "\(data.point) P"
                    }
                    completion(true)
                } catch {
                    completion(false)
                }
            case .failure(let error):
                completion(false)
            }
        }
    }
}

extension CharacterSettingsVC {
    func fetchMemberInfo(completion: @escaping (Bool) -> Void) {
        MemberProvider.request(.fetchMemberInfo) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(MemberInfo.self)
                    DispatchQueue.main.async {
                        self.ownedCharCount = data.ownedChars.count
                    }
                    completion(true)
                } catch {
                    completion(false)
                }
            case .failure(let error):
                completion(false)
            }
        }
    }
}
