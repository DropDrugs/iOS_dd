import UIKit
import SnapKit
import SafariServices

class SettingsVC: UIViewController {
    
    // MARK: - UI Components
    private let tableView = UITableView()
    
    private let menuItems = [
        "계정 관리",
        "푸시 알림 설정",
        "공지사항",
        "문의하기",
        "개인정보 처리방침",
        "위치서비스 이용약관"
    ]
    
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  설정")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        // TableView setup
        tableView.rowHeight = view.bounds.height * 0.09
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - UITableViewDataSource
extension SettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 17)
        cell.textLabel?.textColor = .black
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = menuItems[indexPath.row]
        
        switch selectedItem {
        case "계정 관리":
            navigationController?.pushViewController(AccountSettingsVC(), animated: true)
        case "푸시 알림 설정":
            navigationController?.pushViewController(NotificationSettingsVC(), animated: true)
        case "공지사항":
            navigationController?.pushViewController(NoticesVC(), animated: true)
//            navigationController?.pushViewController(BoardPostTestVC(), animated: true) - 관리자 페이지에서 공지사항 등록할ㄸ 때 사용
        case "문의하기":
            // TODO: 메일 전송 플로우
            openWebPage(urlString: "https://www.example.com/privacy-policy")
        case "개인정보 처리방침":
            // TODO: 페이지 설정
            openWebPage(urlString: "https://www.example.com/privacy-policy")
        case "위치서비스 이용약관":
            openWebPage(urlString: "https://www.example.com/location-terms")
        default:
            return
        }
    }
    
    // MARK: - Open Web Page
    private func openWebPage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
}
