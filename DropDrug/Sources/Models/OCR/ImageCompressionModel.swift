// Copyright © 2024 RT4. All rights reserved

import UIKit

class ImageCompressionModel {
    
    // MARK: - Singleton Instance
    static let shared = ImageCompressionModel()
    private init() {}
    
    // MARK: - Public Method to Compress Image
    func compressImageToUnder50MB(image: UIImage, maxFileSize: Int = 50 * 1024 * 1024, completion: @escaping (Data?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            var compressionQuality: CGFloat = 1.0 // 초기 압축 품질 (1.0은 원본 품질)
            var resizedImage = image
            
            // 반복적으로 압축 및 크기 조정을 시도
            while let imageData = resizedImage.jpegData(compressionQuality: compressionQuality),
                  imageData.count > maxFileSize {
                
//                print("현재 크기: \(imageData.count / 1024 / 1024)MB, 압축률: \(compressionQuality)")
                
                // 압축률을 낮춰서 재시도
                compressionQuality -= 0.1
                
                // 최소 압축률까지 도달하면 크기 조정
                if compressionQuality < 0.1 {
                    compressionQuality = 0.9 // 압축률 초기화
                    let newSize = CGSize(width: resizedImage.size.width * 0.9,
                                         height: resizedImage.size.height * 0.9)
                    resizedImage = self.resizeImage(resizedImage, targetSize: newSize)
                }
            }
            
            let finalImageData = resizedImage.jpegData(compressionQuality: compressionQuality)
            
            DispatchQueue.main.async {
                completion(finalImageData)
            }
        }
    }
    
    // MARK: - Private Method to Resize Image
    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    func convertToBase64(data: Data) -> String {
        let base64String = data.base64EncodedString()
        return base64String
    }
}
