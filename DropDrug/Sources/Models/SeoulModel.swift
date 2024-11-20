// Copyright © 2024 RT4. All rights reserved

import UIKit

struct SeoulModel {
    let image: String
    let name: String
}

extension SeoulModel {
    static func list() ->  [SeoulModel] {
        return [
            SeoulModel(image: "강남구", name: "강남구"),
            SeoulModel(image: "강동구", name: "강동구"),
            SeoulModel(image: "강북구", name: "강북구"),
            SeoulModel(image: "강서구", name: "강서구"),
            SeoulModel(image: "관악구", name: "관악구"),
            SeoulModel(image: "광진구", name: "광진구"),
            SeoulModel(image: "구로구", name: "구로구"),
            SeoulModel(image: "금천구", name: "금천구"),
            SeoulModel(image: "노원구", name: "노원구"),
            SeoulModel(image: "도봉구", name: "도봉구"),
            SeoulModel(image: "동대문구", name: "동대문구"),
            SeoulModel(image: "동작구", name: "동작구"),
            SeoulModel(image: "마포구", name: "마포구"),
            SeoulModel(image: "서대문구", name: "서대문구"),
            SeoulModel(image: "서초구", name: "서초구"),
            SeoulModel(image: "성북구", name: "성북구"),
            SeoulModel(image: "송파구", name: "송파구"),
            SeoulModel(image: "양천구", name: "양천구"),
            SeoulModel(image: "영등포구", name: "영등포구"),
            SeoulModel(image: "용산구", name: "용산구"),
            SeoulModel(image: "은평구", name: "은평구"),
            SeoulModel(image: "종로구", name: "종로구"),
            SeoulModel(image: "중구", name: "중구"),
            SeoulModel(image: "중랑구", name: "중랑구"),
        ]
    }
}
