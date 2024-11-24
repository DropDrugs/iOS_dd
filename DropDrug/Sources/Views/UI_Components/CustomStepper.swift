// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class CustomStepper: UIView {
    
    // MARK: - UI Elements
    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.imageView?.tintColor = Constants.Colors.gray400
        button.backgroundColor = Constants.Colors.gray0
        button.layer.cornerRadius = 2
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.imageView?.tintColor = Constants.Colors.skyblue
        button.backgroundColor = Constants.Colors.gray0
        button.layer.cornerRadius = 2
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
        return button
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = Constants.Colors.gray900
        label.backgroundColor = Constants.Colors.gray100
        label.font = UIFont.ptdSemiBoldFont(ofSize: 22)
        label.textAlignment = .center
        label.layer.cornerRadius = 2
        return label
    }()
    
    // MARK: - Properties
    public var currentValue: Int = 0 {
        didSet {
            numberLabel.text = "\(currentValue)"
        }
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        addSubview(minusButton)
        addSubview(numberLabel)
        addSubview(plusButton)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        minusButton.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(35) // 버튼 고정 너비
            make.height.equalTo(35)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(minusButton.snp.trailing).offset(6)
            make.trailing.equalTo(plusButton.snp.leading).offset(-6)
            make.width.equalTo(90) // 최소 너비 보장
            make.height.equalTo(35)
        }
        
        plusButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(35) // 버튼 고정 너비
            make.height.equalTo(35)
        }
    }
    
    // MARK: - Actions
    @objc private func didTapMinus() {
        if currentValue > 0 {
            currentValue -= 1
        }
    }
    
    @objc private func didTapPlus() {
        currentValue += 1
    }
}
