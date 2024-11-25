// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya
import UIKit

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
                        print(data)
                        self.myPageProfileView.nameLabel.text = data.nickname
                        self.myPageProfileView.emailLabel.text = data.email
                        if let character = self.findCharacter(by: data.selectedChar) {
                            self.myPageProfileView.profileImageView.image = UIImage(named: character.image)
                        }
                        self.rewardView.pointsLabel.text = "\(data.point) P"
                        print(data.point)
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
    
    private func findCharacter(by id: Int) -> CharacterModel? {
        return Constants.CharacterList.first { $0.id == id }
    }
}

