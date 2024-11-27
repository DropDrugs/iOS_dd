// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya
import SwiftyToaster

class EnterNickNameVC: UIViewController, UITextFieldDelegate {
    let provider = MoyaProvider<MemberAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    
    public lazy var appTitle: UILabel = {
        let l = UILabel()
        l.text = "DropDrug"
        l.font = UIFont.roRegularFont(ofSize: 26)
        l.textColor = Constants.Colors.skyblue
        return l
    }()
    
    private lazy var usernameField = CustomLabelTextFieldView(textFieldPlaceholder: "이름을 입력해 주세요", validationText: "이름을 입력해 주세요")
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(Constants.Colors.gray900, for: .normal)
        button.backgroundColor = Constants.Colors.skyblue
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.addSubview(appTitle)
        view.addSubview(usernameField)
        view.addSubview(saveButton)
        
        appTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        usernameField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(appTitle.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Setup Actions
    
    private func setupActions() {
        // TextField Delegate 설정
        // 저장 버튼 액션
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Action
    
    @objc private func saveButtonTapped() {
        guard let nickname = usernameField.text, !nickname.isEmpty else {
            return
        }
        
        print("저장된 닉네임: \(nickname)")

        self.updateNickname(newNickname: nickname) { isSuccess in
            if isSuccess {
                self.handleNickNameSaveSuccess()
            } else {
                Toaster.shared.makeToast("닉네임을 다시 저장해주세요.")
            }
        }
    }
    
    private func handleNickNameSaveSuccess() {
        let mainVC = MainTabBarController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true, completion: nil)
    }
    
    private func updateNickname(newNickname: String, completion: @escaping (Bool) -> Void) {
        guard let accessToken = SelectLoginTypeVC.keychain.get("serverAccessToken") else {
            completion(false)
            return
        }
        
        provider.request(.updateNickname(newNickname: newNickname)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(true) // 성공
                } else {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(false)
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드 내리기
        return true
    }
}
