// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya
import SwiftyToaster

class NotificationSettingsVC: UIViewController {
    
    // MARK: - Moya Provider
    let provider = MoyaProvider<MemberAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    
    // MARK: - UI Components
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  푸시 알림 설정")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private let tableView = UITableView()
    private let notificationOptions = [
        "푸시 알림",  // 마스터 토글
        "리워드 적립",
        "공지사항",
        "폐기 안내"
    ]
    
    private var notificationStates = Array(repeating: false, count: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        setupTableView()
        fetchNotificationSettings()
    }
    
    // MARK: - UI 설정
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(NotificationOptionCell.self, forCellReuseIdentifier: "NotificationOptionCell")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - API 호출
    private func fetchNotificationSettings() {
        provider.request(.fetchMemberInfo) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let memberInfo = try JSONDecoder().decode(MemberInfo.self, from: response.data)
                    
                    self?.notificationStates = [
                        memberInfo.notificationSetting.reward ||
                        memberInfo.notificationSetting.noticeboard ||
                        memberInfo.notificationSetting.disposal,
                        memberInfo.notificationSetting.reward,
                        memberInfo.notificationSetting.noticeboard,
                        memberInfo.notificationSetting.disposal
                    ]
                    self?.tableView.reloadData()
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func updateNotificationSetting() {
        let updatedSettings = NotificationSetting(
            disposal: notificationStates[3],
            noticeboard: notificationStates[2],
            reward: notificationStates[1]
        )
        
        provider.request(.updateNotificationSettings(param: updatedSettings)) { result in
            switch result {
            case .success: break
                // 성공
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - 액션
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension NotificationSettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationOptionCell", for: indexPath) as! NotificationOptionCell

        let option = notificationOptions[indexPath.row]
        let isEnabled = notificationStates[indexPath.row]
        let isPushEnabled = notificationStates[0]

        cell.configure(title: option, isSwitchOn: isEnabled, isSwitchEnabled: indexPath.row == 0 || isPushEnabled) { [weak self] isOn in
            guard let self = self else { return }

            if indexPath.row == 0 {
                self.notificationStates = self.notificationStates.map { _ in isOn }
                self.tableView.reloadData()
            } else {
                self.notificationStates[indexPath.row] = isOn
                self.notificationStates[0] = self.notificationStates[1...3].contains(true)
            }

            self.updateNotificationSetting()
        }
        cell.selectionStyle = .none

        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationSettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
