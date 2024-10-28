// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class PaddedTextField: UITextField {
    var padding: UIEdgeInsets
    
    init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

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
}

class CheckBoxButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        self.setImage(UIImage(systemName: "checkmark.square")?.withTintColor(Constants.Colors.skyblue ?? .blue, renderingMode: .alwaysOriginal), for: .selected)
        self.setImage(UIImage(systemName: "square")?.withTintColor(Constants.Colors.gray500 ?? .gray, renderingMode: .alwaysOriginal), for: .normal)
        self.setTitle(title, for: .normal)
        self.setTitleColor(Constants.Colors.gray500 ?? .gray , for: .normal)
        self.titleLabel?.font = UIFont.ptdRegularFont(ofSize: 13)
        
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        if let imageView = self.imageView, let titleLabel = self.titleLabel {
            imageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.equalTo(20)
                make.height.equalTo(20)
            }
            titleLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(10)
                make.centerY.equalTo(imageView)
            }
        }
        self.contentHorizontalAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SignUpVC : UIViewController {
    
    private lazy var usernameField = CustomLabelTextFieldView(textFieldPlaceholder: "이름을 입력해 주세요", validationText: "이름을 입력해 주세요")
    private lazy var emailField = CustomLabelTextFieldView(textFieldPlaceholder: "이메일을 입력해 주세요", validationText: "사용할 수 없는 이메일입니다")
    private lazy var passwordField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(textFieldPlaceholder: "비밀번호를 입력해 주세요", validationText: "8~20자 이내 영문자, 숫자, 특수문자의 조합")
        field.textField.isSecureTextEntry = true
        return field
    }()
    private lazy var confirmPasswordField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(textFieldPlaceholder: "비밀번호를 다시 입력해 주세요", validationText: "비밀번호를 다시 한 번 확인해 주세요")
        field.textField.isSecureTextEntry = true
        return field
    }()

    // MARK: - UI Properties
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(Constants.Colors.skyblue, for: .normal)
        button.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 14)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "DropDrug"
        label.font = UIFont.roRegularFont(ofSize: 30)
        label.textColor = Constants.Colors.skyblue
        label.textAlignment = .center
        return label
    }()
    
    private lazy var termsCheckBox = CheckBoxButton(title: " 개인정보 수집에 동의합니다.")
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 16)
        button.backgroundColor = Constants.Colors.gray600
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var termsValidationLabel: UILabel = {
        let label = UILabel()
        label.text = "이용 약관 및 개인정보 수집에 동의해주세요"
        label.textColor = Constants.Colors.red
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
        view.addSubview(loginButton)
        view.addSubview(titleLabel)
        
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(confirmPasswordField)
        
        view.addSubview(termsCheckBox)
        
        view.addSubview(signUpButton)
        view.addSubview(termsValidationLabel)
        
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        loginButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(superViewHeight * 0.07)
            make.trailing.equalToSuperview().offset(-superViewWidth * 0.07)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(superViewHeight * 0.01)
            make.centerX.equalToSuperview()
        }
        usernameField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        emailField.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(superViewHeight * 0.005)
            make.centerX.equalToSuperview()
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(superViewHeight * 0.005)
            make.centerX.equalToSuperview()
        }
        confirmPasswordField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(superViewHeight * 0.005)
            make.centerX.equalToSuperview()
        }
        termsValidationLabel.snp.makeConstraints { make in
            make.bottom.equalTo(termsCheckBox.snp.top).offset(-superViewWidth * 0.01)
            make.leading.equalToSuperview().inset(20)
        }
        termsCheckBox.snp.makeConstraints { make in
            make.bottom.equalTo(signUpButton.snp.top).offset(-superViewWidth * 0.03)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(superViewHeight * 0.1)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(superViewWidth * 0.15)
        }
    }
    
    private func setupActions() {
        usernameField.textField.addTarget(self, action: #selector(usernameValidate), for: .editingChanged)
        emailField.textField.addTarget(self, action: #selector(emailValidate), for: .editingChanged)
        passwordField.textField.addTarget(self, action: #selector(passwordValidate), for: .editingChanged)
        confirmPasswordField.textField.addTarget(self, action: #selector(confirmPasswordValidate), for: .editingChanged)
        
        termsCheckBox.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        }

    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - Actions

    
    @objc func signUpButtonTapped() {
        if isValid {
            //회원가입 버튼 클릭시 함수 추가 필요
        }
    }
    
    @objc func loginButtonTapped() {
        let loginVC = LoginVC()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc func termsTapped() {
        termsCheckBox.isSelected.toggle()
        
        if termsCheckBox.isSelected {
            termsValidationLabel.isHidden = true
        } else {
            termsValidationLabel.isHidden = false
        }
        termsAgreeValidate()
    }
    
    lazy var isUsernameValid = false
    lazy var isEmailValid = false
    lazy var isPasswordValid = false
    lazy var isConfirmPasswordValid = false
    lazy var isTermsAgreeValid = false
    
    @objc func usernameValidate(){
        if let username = usernameField.text, !username.isEmpty {
            usernameField.validationLabel.isHidden = true
            usernameField.textField.layer.borderColor = Constants.Colors.skyblue?.cgColor
            isUsernameValid = true
        } else {
            usernameField.validationLabel.isHidden = false
            usernameField.textField.layer.borderColor = Constants.Colors.red?.cgColor
            isUsernameValid = false
        }
        validateInputs()
    }
    
    @objc func emailValidate(){
//        if let email = emailField.text, isValidEmail(email) {
//        이메일 주소 유효성 확인 조건문
        if let email = emailField.text {
            emailField.validationLabel.isHidden = true
            emailField.textField.layer.borderColor = Constants.Colors.skyblue?.cgColor
            isEmailValid = true
        } else {
            emailField.validationLabel.isHidden = false
            emailField.textField.layer.borderColor = Constants.Colors.red?.cgColor
            isEmailValid = false
        }
    }
    
    @objc func passwordValidate(){
        if let password = passwordField.text {
//      if let password = passwordField.text, isValidPassword(password) {
//      패스워드 유효성 확인 조건문
            passwordField.validationLabel.isHidden = true
            passwordField.textField.layer.borderColor = Constants.Colors.skyblue?.cgColor
            isPasswordValid = true
        } else {
            passwordField.validationLabel.isHidden = false
            passwordField.textField.layer.borderColor = Constants.Colors.red?.cgColor
            isPasswordValid = false
        }
        validateInputs()
    }
    
    @objc func confirmPasswordValidate() {
        if let confirmPassword = confirmPasswordField.text, confirmPassword == passwordField.text, !confirmPassword.isEmpty {
            confirmPasswordField.validationLabel.isHidden = true
            confirmPasswordField.textField.layer.borderColor = Constants.Colors.skyblue?.cgColor
            isConfirmPasswordValid = true
        } else {
            confirmPasswordField.validationLabel.isHidden = false
            confirmPasswordField.textField.layer.borderColor = Constants.Colors.red?.cgColor
            isConfirmPasswordValid = false
        }
        validateInputs()
    }
    
    @objc func termsAgreeValidate() {
        if termsCheckBox.isSelected {
            termsValidationLabel.isHidden = true
            isTermsAgreeValid = true
        } else {
            termsValidationLabel.isHidden = false
            isTermsAgreeValid = false
        }
        validateInputs()
    }
    
    var isValid = false
    @objc func validateInputs() {
        isValid = isUsernameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid && isTermsAgreeValid
        signUpButton.isEnabled = isValid
        signUpButton.backgroundColor = isValid ? Constants.Colors.skyblue : Constants.Colors.gray600
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
