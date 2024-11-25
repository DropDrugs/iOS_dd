// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya

class NoticesVC: UIViewController {

    let boardProvider = MoyaProvider<BoardService>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    
    var NoticeList : [NoticeData] = [

    ] // 날짜 기준으로 소팅 필수 (Get 호출 후)
//    NoticeData(title: "폐의약품 정보 페이지 안내", content: "현재 일부 지자체에서 폐의약품 분리배출 방법에 대한 공식 안내 홈페이지를 운영하지 않고 있습니다. 해당 지역들은 기본 구청 홈페이지로 연결되며, 관련 홈페이지 생성에 대한 민원 제안을 드렸습니다. 이 부분 참고하시어 <정보> 페이지에서 서울특별시 공통 폐기 방법 안내 페이지를 이용하시기 바랍니다.", date: "2024-11-13T16:25:11.183Z"),
//    NoticeData(title: "의약품 드롭하기 사진 인증 안내", content: "현재 네이버 클로바 AI의 OCR 분석을 통한 Text 인식을 통해 정확도가 높은 단어만 검출합니다. 의약품 드롭 인증에 실패하신 경우 손글씨로 작성하신 단어의 명확함을 재조정하시어 인증하시길 바랍니다.", date: "2024-11-23T12:25:11.183Z"),
//    NoticeData(title: "신규 캐릭터 업데이트 안내", content: "신규 캐릭터를 업데이트하였으니 마이페이지 > 캐릭터 변경 창에서 확인하시길 바랍니다.", date: "2024-12-01T10:25:11.183Z"),
    
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
        cell.configure(with: NoticeList[indexPath.row].title, isRecent: Constants.Colors.pink!) // 비활성화면 gray300?
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row)")
        // 팝업 생성
    }
}

extension NoticesVC {
    func callgetNotices(completion: @escaping (Bool) -> Void) {
        boardProvider.request(.getBoard) { result in
            switch result {
            case .success(let response) :
                do {
                    let response = try response.map([BoardResponse].self)
                    self.NoticeList = []
                    for noticeData in response {
                        self.NoticeList.append(NoticeData(title: noticeData.title, content: noticeData.content, date: noticeData.createdAt))
                    }
                    self.NoticeList.sort(by: { $0.date > $1.date }) // 시간 역순으로
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
