// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya

class SignUpVC : UIViewController {
    let provider = MoyaProvider<LoginService>(plugins: [ NetworkLoggerPlugin() ])
    let MemberProvider = MoyaProvider<MemberAPI>(plugins: [ NetworkLoggerPlugin()])
    
    private lazy var usernameField = CustomLabelTextFieldView(textFieldPlaceholder: "이름을 입력해 주세요", validationText: "이름을 입력해 주세요")
    private lazy var emailField = CustomLabelTextFieldView(textFieldPlaceholder: "이메일을 입력해 주세요", validationText: "사용할 수 없는 이메일입니다")
    private lazy var passwordField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(textFieldPlaceholder: "비밀번호를 입력해 주세요", validationText: "8~20자 이내 영문자, 숫자, 특수문자의 조합")
        field.textField.isSecureTextEntry = true
        field.textField.textContentType = .newPassword
        return field
    }()
    private lazy var confirmPasswordField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(textFieldPlaceholder: "비밀번호를 다시 입력해 주세요", validationText: "비밀번호를 다시 한 번 확인해 주세요")
        field.textField.isSecureTextEntry = true
        field.textField.textContentType = .newPassword
        return field
    }()

    // MARK: - UI Properties
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
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
        [backButton, loginButton, titleLabel, usernameField, emailField, passwordField, confirmPasswordField, termsCheckBox, signUpButton, termsValidationLabel].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .white
    }
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(20)
        }
        loginButton.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
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
    @objc func didTapBackButton() {
        var currentVC: UIViewController? = self
            while let presentingVC = currentVC?.presentingViewController {
                if presentingVC is SelectLoginTypeVC {
                    presentingVC.dismiss(animated: true, completion: nil)
                    return
                }
                currentVC = presentingVC
            }
        print("SelectLoginTypeVC를 찾을 수 없습니다.")
    }
    
    @objc func signUpButtonTapped() {
        if isValid {
            let signUpRequest = setupSignUpDTO(emailField.textField.text!, passwordField.textField.text!, name: usernameField.textField.text!)
            callSignUpAPI(signUpRequest) { isSuccess in
                if isSuccess {
                    self.loginButtonTapped()
                } else {
                    print("회원 가입 실패")
                }
            }
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
    
    // MARK: validation Check
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
    
//    @objc func emailValidate(){
////        if let email = emailField.text, ValidationUtility.isValidEmail(email) {
////        TODO: 이메일 주소 유효성 확인 조건문
//        if let email = emailField.text, checkEmail() {
//            emailField.validationLabel.isHidden = true
//            emailField.textField.layer.borderColor = Constants.Colors.skyblue?.cgColor
//            isEmailValid = true
//        } else {
//            emailField.validationLabel.isHidden = false
//            emailField.textField.layer.borderColor = Constants.Colors.red?.cgColor
//            isEmailValid = false
//        }
//    }
    
    @objc func emailValidate() {
        guard let email = emailField.text, !email.isEmpty else {
            // 이메일이 비어있을 때 처리
            emailField.validationLabel.isHidden = false
            emailField.validationLabel.text = "이메일을 입력해 주세요"
            emailField.textField.layer.borderColor = Constants.Colors.red?.cgColor
            isEmailValid = false
            return
        }
        
        // 이메일 형식 확인
        if !ValidationUtility.isValidEmail(email) {
            emailField.validationLabel.isHidden = false
            emailField.validationLabel.text = "유효하지 않은 이메일 형식입니다"
            emailField.textField.layer.borderColor = Constants.Colors.red?.cgColor
            isEmailValid = false
            return
        }
        
        // 이메일 중복 검사 (네트워크 요청)
        checkEmail { [weak self] isDuplicate in
            DispatchQueue.main.async {
                if isDuplicate {
                    self?.emailField.validationLabel.isHidden = false
                    self?.emailField.validationLabel.text = "이미 사용 중인 이메일입니다"
                    self?.emailField.textField.layer.borderColor = Constants.Colors.red?.cgColor
                    self?.isEmailValid = false
                } else {
                    self?.emailField.validationLabel.isHidden = true
                    self?.emailField.textField.layer.borderColor = Constants.Colors.skyblue?.cgColor
                    self?.isEmailValid = true
                }
            }
        }
    }
    
    @objc func passwordValidate(){
//      if let password = passwordField.text, ValidationUtility.isValidPassword(password) {
//      TODO: 패스워드 유효성 확인 조건문
        if let password = passwordField.text {
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
    
    func checkEmail(completion: @escaping (Bool) -> Void) {
        guard let email = emailField.text, !email.isEmpty else {
            completion(false)
            return
        }
        
        MemberProvider.request(.checkDuplicateEmail(email: email)) { result in
            switch result {
            case .success(let response):
                let isDuplicate = response.statusCode != 200
                completion(isDuplicate)
            case .failure:
                completion(true)
            }
        }
    }
    
}
