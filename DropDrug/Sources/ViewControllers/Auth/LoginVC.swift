// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya
import SwiftyToaster

class LoginVC : UIViewController {

    let provider = MoyaProvider<LoginService>(plugins: [ NetworkLoggerPlugin() ])
    
    var textFields: [UITextField] = []
    
    private lazy var emailField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(textFieldPlaceholder: "이메일을 입력해 주세요", validationText: "아이디 혹은 비밀번호를 확인해 주세요")
        field.textField.keyboardType = .emailAddress
        return field
    }()
    private lazy var passwordField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(textFieldPlaceholder: "비밀번호를 입력해 주세요", validationText: " ")
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
        button.backgroundColor = Constants.Colors.gray600
        button.layer.cornerRadius = superViewWidth * 0.075
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupActions()
        fillSavedEmail()
        validateInputs()
        
        textFields = [emailField.textField, passwordField.textField]
        
        for textField in textFields {
            textField.delegate = self
        }
    }
    
    func fillSavedEmail() {
        if let email = SelectLoginTypeVC.keychain.get("savedUserEmail") {
            emailField.textField.text = email
        }
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        [backButton, titleLabel, emailField, passwordField, emailSaveCheckBox, loginButton].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = Constants.Colors.white
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(superViewWidth * 0.03)
            make.leading.equalToSuperview().inset(superViewWidth * 0.07)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(20)
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
        emailSaveCheckBox.addTarget(self, action: #selector(emailSaveButtonTapped), for: .touchUpInside)
        
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
    
    @objc func loginButtonTapped() {
        if isValid {
            if let loginRequest = setupLoginDTO(emailField.textField.text!, passwordField.textField.text!) {
                callLoginAPI(loginRequest) { isSuccess in
                    if isSuccess {
                        self.proceedLoginSuccessful()
                        if self.isEmailSaveValid {
                            SelectLoginTypeVC.keychain.set(self.emailField.textField.text!, forKey: "savedUserEmail")
                        }
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
    
    @objc func emailSaveButtonTapped() {
        emailSaveCheckBox.isSelected.toggle()
        if emailSaveCheckBox.isSelected{
            isEmailSaveValid = true
        } else {
            isEmailSaveValid = false
        }
        validateInputs()
    }
    
    lazy var isEmailSaveValid = false
    lazy var isFormValid = false
    lazy var isValid = false
    
    @objc func checkFormValidity() {
        let email = emailField.textField.text ?? ""
        let password = passwordField.textField.text ?? ""
        isFormValid = (ValidationUtility.isValidEmail(email)) && (ValidationUtility.isValidPassword(password))
        validateInputs()
    }
    
    @objc func validateInputs() {
        isValid = isFormValid
        loginButton.isEnabled = isValid
        loginButton.backgroundColor = isValid ? Constants.Colors.skyblue : Constants.Colors.gray600
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let index = textFields.firstIndex(of: textField), index < textFields.count - 1 {
            textFields[index + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
