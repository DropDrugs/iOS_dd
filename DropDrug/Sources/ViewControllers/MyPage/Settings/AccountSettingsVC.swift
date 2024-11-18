// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya
import KeychainSwift

class AccountSettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let provider = MoyaProvider<MemberAPI>(plugins: [NetworkLoggerPlugin()])
    
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  계정 관리")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    private let accountOptions = ["닉네임", "아이디", "비밀번호 변경", "캐릭터 변경", "로그아웃"]
    private let accountActions = ["계정 삭제"] // 계정 삭제는 별도 섹션으로 처리
    
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AccountOptionCell.self, forCellReuseIdentifier: "AccountOptionCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 계정 정보 + 계정 삭제
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? accountOptions.count : accountActions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // 계정 정보 및 옵션 섹션
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountOptionCell", for: indexPath) as! AccountOptionCell
            
            let option = accountOptions[indexPath.row]
            if option == "닉네임" {
                cell.configure(title: option, detail: nickname, showEditButton: true)
                cell.editAction = { [weak self] in
                    self?.showEditAlert(title: "닉네임 수정", currentValue: self?.nickname ?? "") { newName in
                        self?.nickname = newName
                        self?.tableView.reloadData()
                    }
                }
            } else if option == "아이디" {
                cell.configure(title: option, detail: userId, showEditButton: true)
                cell.editAction = { [weak self] in
                    self?.showEditAlert(title: "아이디 수정", currentValue: self?.userId ?? "") { newId in
                        self?.userId = newId
                        self?.tableView.reloadData()
                    }
                }
            } else {
                cell.configure(title: option, detail: nil, showEditButton: false)
            }
            return cell
        } else {
            // 계정 삭제 섹션
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = accountActions[indexPath.row]
            cell.textLabel?.textColor = .red
            cell.textLabel?.textAlignment = .left
            cell.selectionStyle = .none
            return cell
        }
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
            default:
                break
            }
        } else if indexPath.section == 1 {
            // TODO: 계정 삭제 동작
            showDeleteAccountAlert()
        }
    }
    
    // MARK: - Alerts
    private func showEditAlert(title: String, currentValue: String, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = currentValue
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "저장", style: .default, handler: { _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                completion(text)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func showDeleteAccountAlert() {
        let alert = UIAlertController(title: "계정 삭제", message: "계정을 정말 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            print("계정 삭제 처리")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc func logoutButtonTapped() {
        let keychain = KeychainSwift()
        guard let accessToken = keychain.get("serverAccessToken") else {
            print("Access Token 없음")
            return
        }
        let provider = MoyaProvider<LoginService>()
        provider.request(.postLogOut(accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                print("로그아웃 성공")
                keychain.delete("serverAccessToken")
                keychain.delete("serverRefreshToken")
                print("로그아웃 처리")
                self.navigateToSplashScreen()
            case .failure(let error):
                print("로그아웃 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func navigateToSplashScreen() {
        let SplashVC = SplashVC()
        SplashVC.modalPresentationStyle = .fullScreen
        present(SplashVC, animated: true)
    }
}
