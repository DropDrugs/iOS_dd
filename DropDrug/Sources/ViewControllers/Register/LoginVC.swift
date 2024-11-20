// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya

// TODO : 토큰 저장 매니저 따로 만들기

class LoginVC : UIViewController {

    let provider = MoyaProvider<LoginService>(plugins: [ NetworkLoggerPlugin() ])
    
    private lazy var emailField = CustomLabelTextFieldView(textFieldPlaceholder: "이메일을 입력해 주세요", validationText: "아이디 혹은 비밀번호를 확인해 주세요")
    private lazy var passwordField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(textFieldPlaceholder: "비밀번호를 입력해 주세요", validationText: " ")
        field.textField.isSecureTextEntry = true
        return field
    }()

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.font = UIFont.ptdSemiBoldFont(ofSize: 22)
        label.textColor = Constants.Colors.skyblue
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailSaveCheckBox = CheckBoxButton(title: " 아이디 저장하기")
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 16)
        button.backgroundColor = UIColor.systemGray
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
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
        
        view.addSubview(emailField)
        view.addSubview(passwordField)
        
        view.addSubview(emailSaveCheckBox)
        
        view.addSubview(loginButton)
        
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(superViewHeight * 0.1)
            make.centerX.equalToSuperview()
        }
        emailField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(superViewHeight * 0.005)
            make.centerX.equalToSuperview()
        }
        emailSaveCheckBox.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(superViewHeight * 0.02)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(emailSaveCheckBox.snp.bottom).offset(superViewHeight * 0.1)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(superViewWidth * 0.15)
        }
    }
    
    private func setupActions() {
        emailField.textField.addTarget(self, action: #selector(checkFormValidity), for: .editingChanged)
        passwordField.textField.addTarget(self, action: #selector(checkFormValidity), for: .editingChanged)
        emailSaveCheckBox.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        }

    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - Actions
    @objc func loginButtonTapped() {
        if isValid {
            if let loginRequest = setupLoginDTO(emailField.textField.text!, passwordField.textField.text!) {
                callLoginAPI(loginRequest) { isSuccess in
                    if isSuccess {
                        self.proceedLoginSuccessful()
                    } else {
                        print("로그인 실패")
                    }
                }
            }
        }
    }
    
    func proceedLoginSuccessful() {
            let tabBarController = MainTabBarController()
            tabBarController.modalPresentationStyle = .fullScreen
            present(tabBarController, animated: true, completion: nil)
    }
    
    @objc func termsTapped() {
        // TODO : 아이디 저장 api?
        emailSaveCheckBox.isSelected.toggle()
        if emailSaveCheckBox.isSelected {
            isTermsAgreeValid = true
        } else {
            isTermsAgreeValid = false
        }
        validateInputs()
    }
    
    lazy var isTermsAgreeValid = false
    lazy var isFormValid = false
    lazy var isValid = false
    
    @objc func checkFormValidity() {
        let email = emailField.textField.text ?? ""
        let password = passwordField.textField.text ?? ""
//        isFormValid = (ValidationUtility.isValidEmail(email)) && (ValidationUtility.isValidPassword(password))
        isFormValid = !email.isEmpty && !password.isEmpty
        validateInputs()
    }
    
    @objc func validateInputs() {
        isValid = isFormValid
        loginButton.isEnabled = isValid
        loginButton.backgroundColor = isValid ? Constants.Colors.skyblue : Constants.Colors.gray600
    }
}
