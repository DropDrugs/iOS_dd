// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

extension UIView {
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

class PaddedTextField: UITextField {
    var padding: UIEdgeInsets
    
    init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 텍스트 영역의 위치를 조정
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    // 편집 시 텍스트 영역의 위치를 조정
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    // 플레이스홀더 텍스트 영역의 위치를 조정
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class CustomLabelTextFieldView2: UIView {
    // Components
    let label: UILabel
    let textField: PaddedTextField
    let validationLabel: UILabel

    // Public property to access the text field's text
    var text: String? {
        return textField.text
    }

    // Initializer
    init(labelText: String, textFieldPlaceholder: String, validationText: String) {
        self.label = UILabel()
        self.textField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        self.validationLabel = UILabel()

        super.init(frame: .zero)

        // Label setup
        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left

        // TextField setup
        textField.placeholder = textFieldPlaceholder
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = UIColor(hex: "#FFFFFF")
        
        textField.layer.borderColor = UIColor(hex: "#D8D8D8")?.cgColor
        textField.layer.borderWidth = 1.0  // 원하는 테두리 두께로 설정
        textField.layer.cornerRadius = 5.0  // 테두리에 둥근 모서리를 주고 싶을 때 설정
        
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.1 // 투명도 설정 (0.0 ~ 1.0)
        textField.layer.shadowOffset = CGSize(width: 3, height: 3) // 섀도우의 위치 설정
        textField.layer.shadowRadius = 5.0 // 섀도우의 블러 정도 설정

        // ValidationLabel setup
        validationLabel.text = validationText
        validationLabel.textColor = UIColor(hex: "#FD2D69")
        validationLabel.font = UIFont.systemFont(ofSize: 12)
        validationLabel.isHidden = true // Initially hidden

        // Add subviews
        addSubview(label)
        addSubview(textField)
        addSubview(validationLabel)

        // Set constraints
        label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        validationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(label.snp.centerY)
            make.trailing.lessThanOrEqualToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
    }

    // Required initializer for NSCoder (not used in this example)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CheckBoxButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        self.setImage(UIImage(named: "uncheckedBox"), for: .normal)
        self.setImage(UIImage(named: "checkedBox"), for: .selected)
        self.setTitle(title, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
                self.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        if let imageView = self.imageView, let titleLabel = self.titleLabel {
            imageView.snp.makeConstraints { make in
                            make.leading.equalToSuperview()
                            make.centerY.equalToSuperview()
                            make.width.equalTo(20)
                            make.height.equalTo(20)
                        }
                        titleLabel.snp.makeConstraints { make in
                            make.leading.equalTo(imageView.snp.trailing).offset(10)
                            make.trailing.equalToSuperview()
                            make.centerY.equalToSuperview()
                        }
        }
        self.contentHorizontalAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SignUpVC : UIViewController {

    var userInfo: [String: Any] = [:]
    
    private lazy var usernameField = CustomLabelTextFieldView2(labelText: "이름", textFieldPlaceholder: "| 이름을 입력해 주세요", validationText: "이름을 입력해주세요")
    private lazy var emailField = CustomLabelTextFieldView2(labelText: "이메일", textFieldPlaceholder: "| 사용할 이메일 주소를 입력해 주세요", validationText: "사용할 수 없는 이메일입니다")
    private lazy var passwordField: CustomLabelTextFieldView2 = {
        let field = CustomLabelTextFieldView2(labelText: "비밀번호", textFieldPlaceholder: "| 8~20자 이내 영문자, 숫자, 특수문자의 조합", validationText: "올바르지 않은 형식입니다")
        field.textField.isSecureTextEntry = true
        return field
    }()
    private lazy var confirmPasswordField: CustomLabelTextFieldView2 = {
        let field = CustomLabelTextFieldView2(labelText: "비밀번호 확인", textFieldPlaceholder: "| 비밀번호를 다시 입력해 주세요", validationText: "비밀번호를 다시 한 번 확인해 주세요")
        field.textField.isSecureTextEntry = true
        return field
    }()

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Drop Drug"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor(named: "skyblue")
        label.textAlignment = .center
        return label
    }()
     
    private lazy var termsCheckBox: CheckBoxButton = {
        return CheckBoxButton(title: " 이용약관 (필수)")
    }()

    private lazy var privacyCheckBox: CheckBoxButton = {
        return CheckBoxButton(title: " 개인정보 수집 및 이용 (필수)")
    }()

    private lazy var allAgreeCheckBox: CheckBoxButton = {
        return CheckBoxButton(title: " 전체동의")
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.systemGray
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var termsValidationLabel: UILabel = {
        let label = UILabel()
        label.text = "이용 약관 및 개인정보 수집에 동의해주세요"
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    // MARK: - Initialization
    override func viewDidLoad() {
            super.viewDidLoad()
        setupView()
        setupConstraints()
        setupActions()
        validateInputs()
        }
    
    // MARK: - Setup Methods
    private func setupView() {
        
        view.addSubview(titleLabel)
        
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(confirmPasswordField)
        
        view.addSubview(termsCheckBox)
        view.addSubview(privacyCheckBox)
        view.addSubview(allAgreeCheckBox)
        
        view.addSubview(signUpButton)
        view.addSubview(termsValidationLabel)
        
        view.backgroundColor = UIColor(hex: "#F8F8F8")
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
        
        usernameField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
                    make.leading.trailing.equalToSuperview().inset(20)
                }

        signUpButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        emailField.snp.makeConstraints { make in
                    make.top.equalTo(usernameField.snp.bottom).offset(20)
                    make.leading.trailing.equalToSuperview().inset(20)
                }
        passwordField.snp.makeConstraints { make in
                    make.top.equalTo(emailField.snp.bottom).offset(20)
                    make.leading.trailing.equalToSuperview().inset(20)
                }
        confirmPasswordField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        termsValidationLabel.snp.makeConstraints { make in
                    make.bottom.equalTo(confirmPasswordField.snp.bottom).offset(40)
                    make.leading.equalToSuperview().inset(20)
                }
        termsCheckBox.snp.makeConstraints { make in
            make.top.equalTo(termsValidationLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        privacyCheckBox.snp.makeConstraints { make in
            make.top.equalTo(termsCheckBox.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        allAgreeCheckBox.snp.makeConstraints { make in
            make.top.equalTo(privacyCheckBox.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
    }
    
    private func setupActions() {
        usernameField.textField.addTarget(self, action: #selector(usernameValidate), for: .editingChanged)
        emailField.textField.addTarget(self, action: #selector(emailValidate), for: .editingChanged)
        passwordField.textField.addTarget(self, action: #selector(passwordValidate), for: .editingChanged)
        confirmPasswordField.textField.addTarget(self, action: #selector(confirmPasswordValidate), for: .editingChanged)
        
        termsCheckBox.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        privacyCheckBox.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//            self.addGestureRecognizer(tapGesture)
        }
//
//        @objc private func dismissKeyboard() {
//            self.endEditing(true)
//    }
//    
    // MARK: - Actions
    @objc func signUpButtonTapped() {
        if isValid {
            print("회원가입 버튼 클릭")
            userInfo["name"] = usernameField.text
            userInfo["email"] = emailField.text
            userInfo["password"] = passwordField.text
//            if let currentViewController = self.findViewController() {
//                let userInfoVC = ProfileViewController()
//                userInfoVC.userInfo = userInfo
//                print(userInfo)
//                userInfoVC.modalPresentationStyle = .fullScreen
//                currentViewController.present(userInfoVC, animated: true, completion: nil)
//            } else {
//                print("조건값 확인 필요")
//            }
        }
    }
    
    @objc func termsTapped() {
        termsCheckBox.isSelected.toggle()
        updateAllAgreeState()
        if allAgreeCheckBox.isSelected {
            termsValidationLabel.isHidden = true
        } else {
            termsValidationLabel.isHidden = false
        }
        termsAgreeValidate()
    }
    
    @objc func privacyTapped() {
        privacyCheckBox.isSelected.toggle()
        updateAllAgreeState()
        if allAgreeCheckBox.isSelected {
            termsValidationLabel.isHidden = true
        } else {
            termsValidationLabel.isHidden = false
        }
        termsAgreeValidate()
    }
    
    func updateAllAgreeState() {
        allAgreeCheckBox.isSelected = termsCheckBox.isSelected && privacyCheckBox.isSelected
    }
    
    lazy var isUsernameValid = false
    lazy var isEmailValid = false
    lazy var isPasswordValid = false
    lazy var isConfirmPasswordValid = false
    lazy var isTermsAgreeValid = false
    
    @objc func usernameValidate(){
        if let username = usernameField.text, !username.isEmpty {
            usernameField.validationLabel.isHidden = true
            usernameField.textField.layer.borderColor = UIColor.systemGray.cgColor
            isUsernameValid = true
        } else {
            usernameField.validationLabel.isHidden = false
            usernameField.textField.layer.borderColor = UIColor(hex: "#FE2494")?.cgColor
        }
        validateInputs()
    }
    
    @objc func emailValidate(){
        if let email = emailField.text, isValidEmail(email) {
            emailField.validationLabel.isHidden = true
            emailField.textField.layer.borderColor = UIColor.systemGray.cgColor
            isEmailValid = true
        } else {
            emailField.validationLabel.isHidden = false
            emailField.textField.layer.borderColor = UIColor(hex: "#FE2494")?.cgColor
        }
    }
    
    @objc func passwordValidate(){
        if let password = passwordField.text, isValidPassword(password) {
            passwordField.validationLabel.isHidden = true
            passwordField.textField.layer.borderColor = UIColor.systemGray.cgColor
            isPasswordValid = true
        } else {
            passwordField.validationLabel.isHidden = false
            passwordField.textField.layer.borderColor = UIColor(hex: "#FE2494")?.cgColor
        }
        validateInputs()
    }
    
    @objc func confirmPasswordValidate() {
        if let confirmPassword = confirmPasswordField.text, confirmPassword == passwordField.text {
            confirmPasswordField.validationLabel.isHidden = true
            confirmPasswordField.textField.layer.borderColor = UIColor.systemGray.cgColor
            isConfirmPasswordValid = true
        } else {
            confirmPasswordField.validationLabel.isHidden = false
            confirmPasswordField.textField.layer.borderColor = UIColor.systemGray.cgColor
        }
        validateInputs()
    }
    
    @objc func termsAgreeValidate() {
        if allAgreeCheckBox.isSelected {
            termsValidationLabel.isHidden = true
            isTermsAgreeValid = true
        } else {
            termsValidationLabel.isHidden = false
        }
        validateInputs()
    }
    
    var isValid = false
    @objc func validateInputs() {
        isValid = isUsernameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid && isTermsAgreeValid
        signUpButton.isEnabled = isValid
        signUpButton.backgroundColor = isValid ? UIColor.systemGray : UIColor(named: "skyblue")
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=?.,<>]).{8,15}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
}
