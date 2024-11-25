// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya

class NoticesVC: UIViewController {

    let boardProvider = MoyaProvider<BoardService>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    
    var NoticeList : [NoticeData] = [
        NoticeData(title: "신규 캐릭터 업데이트 안내", content: "신규 캐릭터를 업데이트하였으니 마이페이지 > 캐릭터 변경 창에서 확인하시길 바랍니다.", date: "2024-12-01T10:25:11.183Z")
    ]

    
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  공지사항")
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
        
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.separatorStyle = .none
        self.tableView.reloadData()
        
        self.callgetNotices { isSucces in
            if isSucces {
                self.tableView.reloadData()
            } else {
                print("getNotices 실패")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 선택된 셀이 있다면 해제
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        self.callgetNotices { isSuccess in
            if isSuccess {
                self.tableView.reloadData()
            } else {
                print("getNotices 실패")
            }
        }
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: false)
    }

}

extension NoticesVC :  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.configure(with: NoticeList[indexPath.row].title, isRecent: Constants.Colors.pink!) // 비활성화면 gray300?
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let titleString = self.NoticeList[indexPath.row].title
        let contentString = self.NoticeList[indexPath.row].content
        print(titleString)
        
        let alertView = CustomAlertView()
        alertView.configure(title: titleString, message: contentString)
        
        // Add to the current view and set constraints
        view.addSubview(alertView)
        view.bringSubviewToFront(alertView)
        
        alertView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NoticesVC {
    func callgetNotices(completion: @escaping (Bool) -> Void) {
        boardProvider.request(.getBoard) { result in
            switch result {
            case .success(let response) :
                do {
                    let responsedata = try response.map([BoardResponse].self)
                    print(responsedata)
                    self.NoticeList = []
                    for noticeData in responsedata {
                        self.NoticeList.append(NoticeData(title: noticeData.title, content: noticeData.content, date: noticeData.createdAt))
                    }
                    self.NoticeList.sort(by: { $0.date < $1.date })
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
