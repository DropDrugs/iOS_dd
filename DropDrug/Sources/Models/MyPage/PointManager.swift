// Copyright © 2024 RT4. All rights reserved

import UIKit
import Moya
import SwiftyToaster

extension RewardVC {
    func fetchPoint(completion: @escaping (Bool) -> Void) {
        PointProvider.request(.getPointHistory) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(PointHistoryResponse.self)
                    DispatchQueue.main.async {
                        self.rewardData = data.pointHistory
                        self.rewardView.pointsLabel.text = "\(data.totalPoint) P"
                        self.rewardTableView.reloadData()
                        completion(true)
                    }
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
    func fetchPoint(completion: @escaping (Bool) -> Void) {
        PointProvider.request(.getMonthlyStats) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map([MonthlyStatsResponse].self)
                    self.viewModel.stats = data
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
