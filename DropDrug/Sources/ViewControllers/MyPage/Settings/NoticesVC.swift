// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya
import SwiftyToaster

class NoticesVC: UIViewController {

    let boardProvider = MoyaProvider<BoardService>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    
    var NoticeList : [NoticeData] = [
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
        view.backgroundColor = .systemBackground
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
                    self.NoticeList = []
                    for noticeData in responsedata {
                        self.NoticeList.append(NoticeData(title: noticeData.title, content: noticeData.content, date: noticeData.createdAt))
                    }
                    self.NoticeList.sort(by: { $0.date < $1.date })
                    completion(true)
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(false)
                }
            case .failure(let error) :
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
}
