// Copyright © 2024 RT4. All rights reserved

import Foundation

struct MemberInfo: Codable {
    let email: String?
    let nickname: String?
    let notificationSetting: NotificationSetting
    let ownedChars: [Int]
    let point: Int
    let selectedChar: Int
}

struct NotificationSetting: Codable {
    let disposal: Bool
    let noticeboard: Bool
    let reward: Bool
    var takeDrug : Bool = true
    var lastIntake : Bool = true
}

struct NotificationResponse: Codable {
    let id : Int
    let title : String
    let message  : String
    let createdAt : String
}
