// Copyright © 2024 RT4. All rights reserved

import Foundation

struct QuitRequest : Codable {
    let accessToken : String
    let authCode : String?
}
