// Copyright © 2024 RT4. All rights reserved

import Foundation

struct MemberInfo: Codable {
    let email: String
    let nickname: String
    let notificationSetting: NotificationSetting
    let ownedChars: [Int]
    let point: Int
    let selectedChar: Int
}

struct NotificationSetting: Codable {
    let disposal: Bool
    let noticeboard: Bool
    let reward: Bool
}
