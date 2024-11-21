// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class NotificationSettingsVC: UIViewController {
    
    // MARK: - UI Components
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  푸시 알림 설정")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private let tableView = UITableView()
    private let notificationOptions = [
        "리워드 적립",
        "공지사항",
        "폐기 안내",
        "푸시 알림"
    ]
    
    // 알림 설정 상태 (기본값은 false)
    private var notificationStates = Array(repeating: false, count: 4)
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        setupTableView()
    }
    
    // MARK: - Setup Methods
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.register(NotificationOptionCell.self, forCellReuseIdentifier: "NotificationOptionCell")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Actions
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
        
        // 셀 구성
        cell.configure(title: option, isSwitchOn: isEnabled) { [weak self] isOn in
            self?.notificationStates[indexPath.row] = isOn
            print("\(option) 설정 변경됨: \(isOn)")
        }
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationSettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 추가 함수
    }
}
