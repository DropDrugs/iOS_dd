// Copyright © 2024 RT4. All rights reserved

import Foundation

struct MonthlyStats: Codable {
    let data: [MonthlyStatsResponse]
}

struct MonthlyStatsResponse: Codable {
    let disposalCount: Int // 폐기 횟수
    let monthData : [Stats]
}

struct Stats: Codable {
    let leapYear : Bool
    let month: String // 예: "2024-03"
    let monthValue: Int
    let year: Int
}
