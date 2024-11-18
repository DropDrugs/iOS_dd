// Copyright © 2024 RT4. All rights reserved

import Foundation

struct MemberInfo: Decodable {
    let email: String
    let nickname: String
    let notificationSetting: NotificationSetting
    let ownedChars: [Int]
    let point: Int
    let selectedChar: Int
}

struct NotificationSetting: Decodable {
    let disposal: Bool
    let noticeboard: Bool
    let reward: Bool
}
