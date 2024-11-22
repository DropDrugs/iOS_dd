// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya
import KeychainSwift

class AccountSettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let provider = MoyaProvider<MemberAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    let Authprovider = MoyaProvider<LoginService>(plugins: [NetworkLoggerPlugin(), BearerTokenPlugin()])
    
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  계정 관리")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    let tableView = UITableView()
    private let accountOptions = ["닉네임", "아이디", "비밀번호 변경", "캐릭터 변경", "로그아웃", "계정 삭제"]
    
    // 가상 데이터
    var nickname: String = "김드롭"
    var userId: String = "kimdrop@gmail.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        setupView()
        fetchMemberInfo()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        // TableView 설정
        tableView.rowHeight = view.bounds.height * 0.06
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AccountOptionCell.self, forCellReuseIdentifier: "AccountOptionCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
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
            case "비밀번호 변경":
                print("비밀번호 변경 화면 이동")
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
                        print("닉네임 변경 성공")
                        self.nickname = newNickname
                        self.tableView.reloadData()
                    } else {
                        print("닉네임 변경 실패")
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
            self.callQuit { isSuccess in
                if isSuccess {
                    print("계정 삭제 완료")
                    self.showSplashScreen()
                } else {
                    print("계정 삭제 실패 - 다시 시도해주세요")
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc func logoutButtonTapped() {
        guard let accessToken = SelectLoginTypeVC.keychain.get("serverAccessToken") else {
            print("Access Token 없음")
            return
        }
        
        Authprovider.request(.postLogOut(accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                print("로그아웃 성공")
                SelectLoginTypeVC.keychain.delete("serverAccessToken")
                SelectLoginTypeVC.keychain.delete("serverRefreshToken")
                print("로그아웃 처리")
                self.showSplashScreen()
            case .failure(let error):
                print("로그아웃 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func callQuit(completion: @escaping (Bool) -> Void) {
        guard let accessToken = SelectLoginTypeVC.keychain.get("serverAccessToken") else {
            print("Access Token 없음")
            return
        }
        Authprovider.request(.postQuit(token: accessToken)) { result in
            switch result {
            case .success(let response) :
                SelectLoginTypeVC.keychain.clear()
                completion(true)
            case .failure(let error) :
                print("Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(false)
            }
        }
    }
    
    private func updateNickname(newNickname: String, completion: @escaping (Bool) -> Void) {
        guard let accessToken = SelectLoginTypeVC.keychain.get("serverAccessToken") else {
            print("Access Token 없음")
            completion(false)
            return
        }
        
        provider.request(.updateNickname(newNickname: newNickname)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(true) // 성공
                } else {
                    print("서버 응답 오류: \(response.statusCode)")
                    completion(false)
                }
            case .failure(let error):
                print("네트워크 오류: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    private func showSplashScreen() {
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
