// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya
import KeychainSwift
import KakaoSDKUser
import SwiftyToaster

class AccountSettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let provider = MoyaProvider<MemberAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    let Authprovider = MoyaProvider<LoginService>(plugins: [NetworkLoggerPlugin(), BearerTokenPlugin()])
    static var isApple : Bool = false
    
    lazy var kakaoAuthVM: KakaoAuthVM = KakaoAuthVM()
    
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  계정 관리")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    let tableView = UITableView()
    private let accountOptions = ["닉네임", "아이디", /*"비밀번호 변경",*/ "캐릭터 변경", "로그아웃", "계정 삭제"]
    
    // 가상 데이터
    var nickname: String = ""
    var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        setupView()
        fetchMemberInfo { isSucess, isApple  in
            if isSucess {
                self.tableView.reloadData()
            } else {
                // 토스트 메세지 띄워서 에러 알려주기
            }
            AccountSettingsVC.isApple = isApple
        }
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        // TableView 설정
        tableView.rowHeight = view.bounds.height * 0.06
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AccountOptionCell.self, forCellReuseIdentifier: "AccountOptionCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = accountOptions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountOptionCell", for: indexPath) as! AccountOptionCell
        
        if option == "계정 삭제" {
            cell.configure(title: option, detail: nil, showEditButton: false, titleColor: Constants.Colors.red ?? .red)
        } else if option == "닉네임" {
                cell.configure(title: option, detail: nickname, showEditButton: true)
                cell.editAction = { [weak self] in
                    self?.showEditAlert(title: "닉네임 수정", currentValue: self?.nickname ?? "") { newName in
                        self?.nickname = newName
                        self?.tableView.reloadData()
                    }
                }
            } else if option == "아이디" {
                cell.configure(title: option, detail: userId, showEditButton: false)
            } else {
                cell.configure(title: option, detail: nil, showEditButton: false)
            }
            cell.selectionStyle = .none
            return cell
    }

    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch accountOptions[indexPath.row] {
//            case "비밀번호 변경":
//                print("비밀번호 변경 화면 이동")
            case "캐릭터 변경":
                navigationController?.pushViewController(CharacterSettingsVC(), animated: true)
            case "로그아웃":
                logoutButtonTapped()
            case "계정 삭제":
                showDeleteAccountAlert()
            default:
                break
            }
        }
    }
    
    // MARK: - Alerts
    private func showEditAlert(title: String, currentValue: String, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = currentValue
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "저장", style: .default, handler: {_ in
            if let newNickname = alert.textFields?.first?.text, !newNickname.isEmpty {
                self.updateNickname(newNickname: newNickname) { isSuccess in
                    if isSuccess {
                        Toaster.shared.makeToast("닉네임 변경 성공")
                        self.nickname = newNickname
                        self.tableView.reloadData()
                    } else {
                        Toaster.shared.makeToast("닉네임 변경 성공")
                    }
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func showDeleteAccountAlert() {
        let alert = UIAlertController(title: "계정 삭제", message: "계정을 정말 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            if AccountSettingsVC.isApple {
                print("애플 탈퇴")
                self.reAuthenticateWithApple()
            } else {
                print("일반, 카카오 탈퇴")
                self.callQuit { isSuccess in
                    if isSuccess {
                        Toaster.shared.makeToast("계정 삭제 완료")
                        self.showSplashScreen()
                    } else {
                        Toaster.shared.makeToast("계정 삭제 실패 - 다시 시도해주세요")
                    }
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: false)
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
    
    @objc func logoutButtonTapped() {
        guard let accessToken = SelectLoginTypeVC.keychain.get("serverAccessToken") else {
            print("Access Token 없음")
            return
        }
        
        Authprovider.request(.postLogOut(accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                SelectLoginTypeVC.keychain.delete("serverAccessToken")
                SelectLoginTypeVC.keychain.delete("serverRefreshToken")
                Toaster.shared.makeToast("로그아웃")
                self.showSplashScreen()
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
            }
        }
    }
    
    func callQuit(completion: @escaping (Bool) -> Void) {
        guard let accessToken = SelectLoginTypeVC.keychain.get("serverAccessToken") else {
            print("Access Token 없음")
            return
        }

        Authprovider.request(.postQuit(param: QuitRequest(accessToken: accessToken, authCode: nil))) { result in
            switch result {
            case .success(let response):
                let hasKakaoTokens = SelectLoginTypeVC.keychain.get("KakaoAccessToken") != nil || SelectLoginTypeVC.keychain.get("KakaoRefreshToken") != nil || SelectLoginTypeVC.keychain.get("KakaoIdToken") != nil
                
                SelectLoginTypeVC.keychain.clear()
                
                // 카카오 연동 해제
                if hasKakaoTokens {
                    self.kakaoAuthVM.unlinkKakaoAccount { success in
                        if success {
                            print("카카오 계정 연동 해제 성공")
                        } else {
                            print("카카오 계정 연동 해제 실패")
                        }
                    }
                }
                
                completion(true)
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
    
    func callAppleQuit(_ authCode: String, completion: @escaping (Bool) -> Void) {
        guard let accessToken = SelectLoginTypeVC.keychain.get("serverAccessToken") else {
            print("Access Token 없음")
            return
        }
        print("authCode: \(authCode)")

        Authprovider.request(.postQuit(param: QuitRequest(accessToken: accessToken, authCode: authCode))) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    SelectLoginTypeVC.keychain.clear()
                    completion(true)
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(false)
            }
        }
    }
    
    func showSplashScreen() {
        let splashViewController = SplashVC()

        // 현재 윈도우 가져오기
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first else {
            print("윈도우를 가져올 수 없습니다.")
            return
        }

        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = splashViewController
        }, completion: nil)
    }
}
