// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya

class PushNoticeVC: UIViewController {
    
    let provider = MoyaProvider<MemberAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    
    var NoticeList : [PushNoticeData] = [] // id 기준으로 역순
    
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  알림")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        self.callGetPushNotification { isSuccess in
            if isSuccess {
                self.tableView.reloadData()
            } else {
                print("알림 데이터 못가져옴")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        // 선택된 셀이 있다면 해제
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
//        self.callGetPushNotification { isSuccess in
//            if isSuccess {
//                self.tableView.reloadData()
//            } else {
//                print("알림 데이터 못가져옴")
//            }
//        }
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: false)
    }
    
    func callGetPushNotification(completion: @escaping (Bool) -> Void) {
        provider.request(.getPushNotificationList) { result in
            switch result {
            case .success(let response) :
                do {
                    let responsedata = try response.map([NotificationResponse].self)
                    self.NoticeList = []
                    for noticeData in responsedata {
                        self.NoticeList.append(PushNoticeData(id: noticeData.id, title: noticeData.title, content: noticeData.message, date: noticeData.createdAt))
                    }
                    self.NoticeList.sort(by: { $0.id > $1.id })
                    completion(true)
                } catch {
                    print("Failed to decode response: \(error)")
                    completion(false)
                }
            case .failure(let error) :
                print("Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(false)
            }
        }
    }

}

extension PushNoticeVC :  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.configure(with: NoticeList[indexPath.row].title, isRecent: Constants.Colors.pink!) // 비활성화면 gray300?
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row)")
    }
}
