// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class NoticesVC: UIViewController {
    
    let NoticeList : [NoticeData] = [
        NoticeData(title: "테스트용 공지사항 1", content: "테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.", date: "2024-11-23T16:25:11.183Z"),
        NoticeData(title: "테스트용 공지사항 2", content: "테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.", date: "2024-11-23T16:25:11.183Z"),
        NoticeData(title: "테스트용 공지사항 3", content: "테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.테스트용 공지사항입니다.", date: "2024-11-23T16:25:11.183Z"),
    ] // 날짜 기준으로 소팅 필수 (Get 호출 후)
    
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
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 선택된 셀이 있다면 해제
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
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
        cell.configure(with: NoticeList[indexPath.row].title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row)")
    }
}
