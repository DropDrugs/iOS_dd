// Copyright © 2024 RT4. All rights reserved

import Foundation

struct AddBoardRequest: Codable {
    let content : String
    let title : String
}

struct BoardUpdateRequest : Codable {
    let boardId : Int
    let title : String
    let content : String
}
