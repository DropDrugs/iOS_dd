// Copyright © 2024 RT4. All rights reserved

import UIKit

class CustomLabelTextFieldView: UIView {
    let textField: PaddedTextField
    let validationLabel: UILabel

    var text: String? {
        return textField.text
    }

    init(textFieldPlaceholder: String, validationText: String) {
        self.textField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        self.validationLabel = UILabel()

        super.init(frame: .zero)
        
        textField.placeholder = textFieldPlaceholder
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = .white
        textField
        
        textField.layer.borderColor = Constants.Colors.gray300?.cgColor
        textField.layer.borderWidth = 1.0  // 원하는 테두리 두께로 설정
        textField.layer.cornerRadius = 8.0  // 테두리에 둥근 모서리를 주고 싶을 때 설정

        let placeholderColor = Constants.Colors.gray500
        textField.attributedPlaceholder = NSAttributedString(
            string: textFieldPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor ?? UIColor.systemGray]
        )
        
        validationLabel.text = validationText
        validationLabel.textColor = Constants.Colors.red
        validationLabel.font = UIFont.systemFont(ofSize: 12)
        validationLabel.isHidden = true // Initially hidden

        addSubview(textField)
        addSubview(validationLabel)

        validationLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(validationLabel.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(superViewWidth * 0.13)
            make.width.equalTo(superViewWidth * 0.9)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateValidationText(_ text: String, isHidden: Bool) {
        validationLabel.text = text
        validationLabel.isHidden = isHidden
    }
}
