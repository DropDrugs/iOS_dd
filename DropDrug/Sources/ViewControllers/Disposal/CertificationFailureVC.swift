// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya

class CertificationFailureVC: UIViewController {
//    let provider = MoyaProvider<PointAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    
    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "IdentifyFailure")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let failureAlertLabel: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center // 모든 요소를 수직 중심에 정렬
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "인증에 실패했어요"
        label.font = UIFont.ptdBoldFont(ofSize: 24)
        label.textColor = Constants.Colors.red
        label.textAlignment = .center
        return label
    }()
    
    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.circle")
        imageView.tintColor = Constants.Colors.red
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "1분 후에 다시 시도해 주세요"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Constants.Colors.gray600
        label.textAlignment = .center
        return label
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다시 시도하기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Colors.black
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        [ checkImageView, titleLabel].forEach {
            failureAlertLabel.addArrangedSubview($0)
        }
        
        [imageView, messageLabel, failureAlertLabel, retryButton].forEach {
            view.addSubview($0)
        }
        
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(superViewHeight * 0.1)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(superViewWidth * 0.9)
        }
        
        failureAlertLabel.snp.makeConstraints { make in
            make.bottom.equalTo(messageLabel.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(retryButton.snp.top).offset(-50)
            make.centerX.equalToSuperview() // 수평 가운데 정렬
        }
        retryButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
            make.centerX.equalToSuperview()
            make.width.equalTo(superViewWidth * 0.9)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    @objc private func retryButtonTapped() {
        var currentVC: UIViewController? = self
        while let presentingVC = currentVC?.presentingViewController {
            if presentingVC is SelectDrugTypeVC {
                presentingVC.dismiss(animated: true, completion: nil)
                return
            }
            currentVC = presentingVC
        }
    }
}
