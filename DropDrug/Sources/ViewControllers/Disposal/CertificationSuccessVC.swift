// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class CertificationSuccessVC: UIViewController {
    
    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "IdentifySuccess")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "인증 완료!"
        label.font = UIFont.ptdBoldFont(ofSize: 24)
        label.textColor = Constants.Colors.gray800
        label.textAlignment = .center
        return label
    }()
    
    private let checkMessageLabel: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center // 모든 요소를 수직 중심에 정렬
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "올바르게 드롭했어요"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Constants.Colors.skyblue
        label.textAlignment = .center
        return label
    }()
    
    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = Constants.Colors.skyblue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료하기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Colors.skyblue
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
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
        [ checkImageView, messageLabel].forEach {
            checkMessageLabel.addArrangedSubview($0)
        }
        
        [imageView, titleLabel, checkMessageLabel, completeButton].forEach {
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
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(checkMessageLabel.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        
        checkMessageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(completeButton.snp.top).offset(-50)
            make.centerX.equalToSuperview() // 수평 가운데 정렬
        }
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
            make.centerX.equalToSuperview()
            make.width.equalTo(superViewWidth * 0.9)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    @objc private func completeButtonTapped() {
        print("완료 버튼 클릭됨!")
        dismiss(animated: true, completion: nil) // 팝업 닫기 동작
    }
}
