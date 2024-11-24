// Copyright © 2024 RT4. All rights reserved

import Foundation

//MARK: - Request

struct OCRRequest : Codable {
    let images: [images]
    
    let version : String
    let requestId : String
    let timestamp : Int
    var lang : String = "ko"
}

struct images: Codable {
    let format: String
    let name: String
    let data: String // base64
}

//MARK: - Response
struct OCRResponse: Codable {
    let version : String
    let requestID: String
    let timestamp: Int
    let images: [Image]

    enum CodingKeys: String, CodingKey {
        case version
        case requestID = "requestId"
        case timestamp, images
    }
}

struct Image: Codable {
    let uid, name, inferResult, message: String
    let validationResult: ValidationResult
    let convertedImageInfo: ConvertedImageInfo
    let fields: [Field]
}

struct ConvertedImageInfo: Codable {
    let width, height, pageIndex: Int
    let longImage: Bool
}

struct Field: Codable {
    let valueType: String
    let boundingPoly: BoundingPoly
    let inferText: String
    let inferConfidence: Double
    let type: String
    let lineBreak: Bool
}

struct BoundingPoly: Codable {
    let vertices: [Vertex]
}

struct Vertex: Codable {
    let x, y: Int
}

struct ValidationResult: Codable {
    let result: String
}
