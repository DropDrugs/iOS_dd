// Copyright © 2024 RT4. All rights reserved

import UIKit
import SDWebImage
import Moya
import SwiftyToaster

class ImageDisplayVC: UIViewController {
    lazy var progressBar: CircularProgressBar = CircularProgressBar()
    var currentProgress: CGFloat = 0.0
    
    var imageURL: URL?
    
    var extractedTexts : [String] = []
    
    let provider = MoyaProvider<OCRService>(plugins: [ NetworkLoggerPlugin() ])
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "인증 사진을\n확인하고 있어요"
        label.textAlignment = .center
        label.font = UIFont.ptdBoldFont(ofSize: 24)
        label.textColor = Constants.Colors.gray800
        label.numberOfLines = 2
        return label
    }()
    
    public lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "3분 이내로 인증을 완료할게요"
        label.textAlignment = .center
        label.font = UIFont.ptdRegularFont(ofSize: 15)
        label.textColor = Constants.Colors.gray500
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupProgressBar()
        loadImage()
        
    }
    
    private func setupProgressBar() {
        // Add progress bar to the view
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(progressBar)
        
        // SnapKit Constraints
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(superViewWidth*0.8) // 크기 200x200
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        // Configure progress bar properties
        progressBar.innerProgressColor = Constants.Colors.skyblue! // 색상 설정
        progressBar.innerThickness = 25
        progressBar.showProgressText = true // 중앙에 텍스트 표시
    }
    
    func loadImage() {
        // URL of the PNG image
        updateProgressManually(to: 0.1)
        guard let url = self.imageURL else { return }
        self.compressImage(UIImage(contentsOfFile: url.path)!)
    }
    
    func updateProgressManually(to value: CGFloat) {
        progressBar.updateProgress(to: value)
    }
    
    func compressImage(_ image: UIImage) {
        ImageCompressionModel.shared.compressImageToUnder50MB(image: image) { [weak self] compressedData in
            guard let self = self else { return }
            guard let compressedData = compressedData else {
                self.presentCertificationFailureVC()
                return
            }
            print("압축된 이미지 크기: \(compressedData.count / 1024 / 1024)MB")
            updateProgressManually(to: 0.25)
            
            // 압축된 이미지를 저장하거나 다른 작업 수행
            let imageString = ImageCompressionModel.shared.convertToBase64(data: compressedData)
            let requestData = setOCRRequestData(imageData: imageString)
            updateProgressManually(to: 0.5)
            sendCompressedImage(requestData: requestData) { isSuccess in
                self.updateProgressManually(to: 0.6)
                if isSuccess {
                    let combinedString = self.extractedTexts.joined().replacingOccurrences(of: " ", with: "")
                    print(combinedString)
                    self.updateProgressManually(to: 0.75)
                    if combinedString.contains("폐의약품") {
                        self.updateProgressManually(to: 0.99)
                        self.presentCertificationSuccessVC()
                    } else {
                        self.presentCertificationFailureVC()
                    }
                } else {
                    self.presentCertificationFailureVC()
                }
            }
            
        }
    }
    
    func presentCertificationFailureVC() {
        let failureVC = CertificationFailureVC()
        failureVC.modalPresentationStyle = .fullScreen
        present(failureVC, animated: true)
    }
    
    func presentCertificationSuccessVC() {
        let successVC = CertificationSuccessVC()
        successVC.modalPresentationStyle = .fullScreen
        present(successVC, animated: true)
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
                        }
                    }
                    completion(true)
                } catch {
                    print("Failed to decode response: \(error)")
                    completion(false)
                }
            case .failure(let error) :
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
    
}
