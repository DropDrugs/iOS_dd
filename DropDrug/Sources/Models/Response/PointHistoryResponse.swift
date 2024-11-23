// Copyright © 2024 RT4. All rights reserved

import Foundation

struct PointHistoryResponse: Codable {
    let totalPoint: Int
    let pointHistory : [PointDetail]
}

struct PointDetail: Codable {
    let date: String
    let point: Int
    let type: String
}
