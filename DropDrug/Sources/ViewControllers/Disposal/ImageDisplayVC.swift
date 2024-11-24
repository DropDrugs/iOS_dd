// Copyright © 2024 RT4. All rights reserved

import UIKit
import SDWebImage
import Moya

class ImageDisplayVC: UIViewController {
    
    private let imageView = UIImageView()
    var imageURL: URL?
    
    var extractedTexts : [String] = []
    
    let provider = MoyaProvider<OCRService>(plugins: [ NetworkLoggerPlugin() ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupImageView()
        loadImage()
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    private func loadImage() {
        // URL of the PNG image
        guard let url = self.imageURL else { return }
        
        // Load image using SDWebImage
        imageView.sd_setImage(with: url, placeholderImage: nil, options: .continueInBackground, completed: { image, error, cacheType, url in
            if let error = error {
                print("Failed to load image: \(error.localizedDescription)")
            } else {
                print("Image loaded successfully!")
                self.compressImage(image!)
            }
        })
    }
    
    private func compressImage(_ image: UIImage) {
        ImageCompressionModel.shared.compressImageToUnder50MB(image: image) { [weak self] compressedData in
            guard let self = self, let compressedData = compressedData else {
                print("압축 실패")
                return
            }
            print("압축된 이미지 크기: \(compressedData.count / 1024 / 1024)MB")
            
            // 압축된 이미지를 저장하거나 다른 작업 수행
            let imageString = ImageCompressionModel.shared.convertToBase64(data: compressedData)
            let requestData = setOCRRequestData(imageData: imageString)
            sendCompressedImage(requestData: requestData) { isSuccess in
                if isSuccess {
                    let combinedString = self.extractedTexts.joined().replacingOccurrences(of: " ", with: "")
                    print(combinedString)
                    if combinedString.contains("폐의약품") {
                        print("텍스트 추출 성공 -> 성공 페이지로 이동")
                    }
                } else {
                    print("실패 -> 실패 페이지로 이동")
                }
            }
            
        }
    }
}

extension ImageDisplayVC {
    func setOCRRequestData(imageData: String) -> OCRRequest {
        let image = images(format: "jpeg", name: "ocrImage", data: imageData)
        let timestamp = Int(Date().timeIntervalSince1970)
        let requestId = UUID().uuidString
        
        return OCRRequest(images: [image], version: "V2", requestId: requestId, timestamp: timestamp)
    }
    
    private func sendCompressedImage(requestData : OCRRequest, completion: @escaping (Bool) -> Void) {
        provider.request(.postImage(data: requestData)) { result in
            switch result {
            case .success(let response) :
                do {
                    let reponseData = try JSONDecoder().decode(OCRResponse.self, from: response.data)
                    for image in reponseData.images {
                        if image.inferResult == "SUCCESS" {
                            for field in image.fields {
                                if field.inferConfidence > 0.8 {
                                    self.extractedTexts.append(field.inferText)
                                } else { continue }
                            }
                            // 모든 텍스트 추출 완료
                        }
                    }
                    completion(true)
                } catch {
                    print("Failed to decode response: \(error)")
                    completion(false)
                }
            case .failure(let error) :
                print("Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(false)
            }
        }
    }
    
    
}
