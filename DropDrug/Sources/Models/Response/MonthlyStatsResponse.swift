// Copyright © 2024 RT4. All rights reserved

import Foundation

struct MonthlyStatsResponse: Identifiable, Codable {
    var id: String { month }
    let disposalCount: Int
    let month: String
}
