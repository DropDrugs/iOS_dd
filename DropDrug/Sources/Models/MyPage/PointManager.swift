// Copyright © 2024 RT4. All rights reserved

import UIKit
import Moya

extension RewardVC {
    func fetchPoint(completion: @escaping (Bool) -> Void) {
        PointProvider.request(.getPointHistory) { result in
            switch result {
            case .success(let response):
                do {
                    // JSON 디코딩
                    let data = try response.map(PointHistoryResponse.self)
                    DispatchQueue.main.async {
                        self.rewardData = data.pointHistory
                        self.rewardView.pointsLabel.text = "\(data.totalPoint) P"
                        self.rewardTableView.reloadData()
                        completion(true)
                    }
                } catch {
                    print("JSON 파싱 에러: \(error)")
                    completion(false)
                }
            case .failure(let error):
                print("네트워크 에러: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}

extension MyPageVC {
    func fetchPoint(completion: @escaping (Bool) -> Void) {
        PointProvider.request(.getPointHistory) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(MonthlyStatsResponse.self)
                    completion(true)
                } catch {
                    print("JSON 파싱 에러: \(error)")
                    completion(false)
                }
            case .failure(let error):
                print("네트워크 에러: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
