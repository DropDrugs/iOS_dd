// Copyright © 2024 RT4. All rights reserved

import UIKit
import Moya

extension AccountSettingsVC {
    func fetchMemberInfo() {
        provider.request(.fetchMemberInfo) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(MemberInfo.self)
                    self.nickname = data.nickname
                    self.userId = data.email
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("JSON 파싱 에러: \(error)")
                }
            case .failure(let error):
                print("네트워크 에러: \(error.localizedDescription)")
            }
        }
    }
}

extension ProfileView {
    // TODO: 프로필 이미지 parsing 후 적용
    func fetchMemberInfo() {
        provider.request(.fetchMemberInfo) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(MemberInfo.self)
                    self.nameLabel.text = data.nickname
                    self.emailLabel.text = data.email
                } catch {
                    print("JSON 파싱 에러: \(error)")
                }
            case .failure(let error):
                print("네트워크 에러: \(error.localizedDescription)")
            }
        }
    }
}

extension RewardView {
    func fetchMemberInfo() {
        provider.request(.fetchMemberInfo) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(MemberInfo.self)
                    self.pointsLabel.text = "\(data.point) P"
                } catch {
                    print("JSON 파싱 에러: \(error)")
                }
            case .failure(let error):
                print("네트워크 에러: \(error.localizedDescription)")
            }
        }
    }
}
