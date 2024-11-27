// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class CustomAlertView: UIView {
    var onDismiss: (() -> Void)?
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .center
        textView.textColor = .gray
        textView.isEditable = false
        textView.isScrollEnabled = true // 긴 텍스트 스크롤 가능
        textView.showsVerticalScrollIndicator = true
        textView.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        textView.backgroundColor = .clear
        return textView
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(Constants.Colors.skyblue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = Constants.Colors.black?.withAlphaComponent(0.5)
        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageTextView)
        containerView.addSubview(confirmButton)
        
        setupConstraints()
        
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // containerView 외부는 터치 이벤트를 무시
        if !containerView.frame.contains(point) {
            return false
        }
        return true
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(24)
            make.leading.equalTo(containerView).offset(16)
            make.trailing.equalTo(containerView).offset(-16)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalTo(containerView).offset(16)
            make.trailing.equalTo(containerView).offset(-16)
            make.height.lessThanOrEqualTo(160) // 최대 높이 제한
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(messageTextView.snp.bottom).offset(24)
            make.bottom.equalTo(containerView).offset(-16)
            make.centerX.equalTo(containerView)
        }
    }
    
    // MARK: - Public Configuration Method
    func configure(title: String, message: String) {
        titleLabel.text = title
        messageTextView.text = message

        // 강제 레이아웃 업데이트
        layoutIfNeeded()
    }
    
    // MARK: - Actions
    @objc private func didTapConfirmButton() {
        // 팝업 닫기
        self.removeFromSuperview()
        onDismiss?()
    }
}
