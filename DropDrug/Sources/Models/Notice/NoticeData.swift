// Copyright © 2024 RT4. All rights reserved

import Foundation

struct NoticeData : Codable {
    let title : String
    let content : String
    let date : String
}

struct PushNoticeData : Codable {
    let id : Int
    let title : String
    let content : String
    let date : String
}
