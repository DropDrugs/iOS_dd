// Copyright © 2024 RT4. All rights reserved

import UIKit
import SDWebImage
import Moya
import SwiftyToaster

class ImageDisplayVC: UIViewController {
//    lazy var progressBar: CircularProgressBar = CircularProgressBar()
//    var currentProgress: CGFloat = 0.0
    var imageURL: URL?
    var extractedTexts : [String] = []
    
    let provider = MoyaProvider<OCRService>(plugins: [ NetworkLoggerPlugin() ])
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
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
        view.backgroundColor = Constants.Colors.white
        
        setupProgressBar()
        startProcessing()
//        testProcessing()
    }
    
    private func setupProgressBar() {
        // Add progress bar to the view
        view.addSubview(activityIndicator)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        // SnapKit Constraints
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(superViewWidth*0.8) // 크기 200x200
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(activityIndicator.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        // Configure progress bar properties
        activityIndicator.color = Constants.Colors.skyblue! // 색상 설정
        activityIndicator.hidesWhenStopped = true
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    
    private func testProcessing() {
        activityIndicator.startAnimating() // 인디케이터 시작
        
        // 테스트용: 10초 뒤에 activityIndicator를 중지
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            print("Activity Indicator Stopped after 10 seconds (Test)")
        }
    }
    
    private func startProcessing() {
        activityIndicator.startAnimating()  // 인디케이터 시작
        
        // loadImage
        guard let url = imageURL else {
            activityIndicator.stopAnimating()
            Toaster.shared.makeToast("Image를 변환할 수 없습니다.")
            return
        }
        
        compressImage(UIImage(contentsOfFile: url.path)!) { [weak self] compressedData in
            guard let self = self else { return }
            guard let compressedData = compressedData else {
                self.activityIndicator.stopAnimating()
                Toaster.shared.makeToast("Image를 변환할 수 없습니다.")
                return
            }
            
            let imageString = ImageCompressionModel.shared.convertToBase64(data: compressedData)
            let requestData = self.setOCRRequestData(imageData: imageString)
            
            self.sendCompressedImage(requestData: requestData) { isSuccess in
                self.activityIndicator.stopAnimating() // 작업 완료 시 중지
                if isSuccess {
                    self.presentCertificationSuccessVC()
                } else {
                    self.presentCertificationFailureVC()
                }
            }
        }
        
    }
    
//    func loadImage() {
//        // URL of the PNG image
//        guard let url = self.imageURL else { return }
//        self.compressImage(UIImage(contentsOfFile: url.path)!)
//    }
    
    private func compressImage(_ image: UIImage, completion: @escaping (Data?) -> Void) {
            ImageCompressionModel.shared.compressImageToUnder50MB(image: image, completion: completion)
        }
    
//    func compressImage(_ image: UIImage) {
//        ImageCompressionModel.shared.compressImageToUnder50MB(image: image) { [weak self] compressedData in
//            guard let self = self else { return }
//            guard let compressedData = compressedData else {
//                self.presentCertificationFailureVC()
//                return
//            }
//            print("압축된 이미지 크기: \(compressedData.count / 1024 / 1024)MB")
//            
//            // 압축된 이미지를 저장하거나 다른 작업 수행
//            let imageString = ImageCompressionModel.shared.convertToBase64(data: compressedData)
//            let requestData = setOCRRequestData(imageData: imageString)
//            sendCompressedImage(requestData: requestData) { isSuccess in
//                if isSuccess {
//                    let combinedString = self.extractedTexts.joined().replacingOccurrences(of: " ", with: "")
//                    if combinedString.contains("폐의약품") {
//                        self.presentCertificationSuccessVC()
//                    } else {
//                        self.presentCertificationFailureVC()
//                    }
//                } else {
//                    self.presentCertificationFailureVC()
//                }
//            }
//            
//        }
//    }
    
    func presentCertificationFailureVC() {
//        let failureVC = CertificationFailureVC()
//        failureVC.modalPresentationStyle = .fullScreen
//        present(failureVC, animated: true)
        
        let loadingVC = CertificationFailureVC()
        loadingVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(loadingVC, animated: true)
    }
    
    func presentCertificationSuccessVC() {
//        let successVC = CertificationSuccessVC()
//        successVC.modalPresentationStyle = .fullScreen
//        present(successVC, animated: true)
        
        let loadingVC = CertificationSuccessVC()
        loadingVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(loadingVC, animated: true)
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
//                    print("Failed to decode response: \(error)")
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
