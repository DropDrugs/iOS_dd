import UIKit
import SnapKit
import SafariServices
import MessageUI

class SettingsVC: UIViewController {
    
    // MARK: - UI Components
    private let tableView = UITableView()
    
    private let menuItems = [
        "계정 관리",
        "푸시 알림 설정",
        "공지사항",
        "문의하기",
        "개인정보 처리방침",
        "위치기반서비스 이용약관"
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
        view.backgroundColor = .systemBackground
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        // TableView setup
        tableView.rowHeight = view.bounds.height * 0.09
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
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
        cell.textLabel?.textColor = Constants.Colors.black
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsVC: UITableViewDelegate, MFMailComposeViewControllerDelegate {
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
            sendMail()
        case "개인정보 처리방침":
            openWebPage(urlString: "https://wobbly-session-4ae.notion.site/1491b64c5f28801ebc1fc346082c6547?pvs=4")
        case "위치기반서비스 이용약관":
            openWebPage(urlString: "https://wobbly-session-4ae.notion.site/1491b64c5f28803e9854e98979072a71?pvs=4")
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
    
    @objc func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as?String ?? "Unknown"
            let osVersion = UIDevice.current.systemVersion
            let deviceModel = UIDevice.current.model
                
            let bodyString = """
                            이곳에 내용을 작성해 주세요.
                            
                            
                            ================================
                            App Version : \(appVersion)
                            Device OS : \(osVersion)
                            Device Model : \(deviceModel)
                            ================================
                            """
            composeVC.setToRecipients(["dropdrug.cs@gmail.com"])
            composeVC.setSubject("문의 사항")
            composeVC.setMessageBody(bodyString, isHTML: false)
                
            self.present(composeVC, animated: true)
        } else {
            // 만약, 디바이스에 email 기능이 비활성화 일 때, 사용자에게 알림
            let alertController = UIAlertController(title: "메일 계정 활성화 필요",
                                                    message: "Mail 앱에서 사용자의 Email을 계정을 설정해 주세요.",
                                                        preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .default) { _ in
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        let alertTitle: String
        let alertMessage: String
        
        switch result {
        case .sent:
            alertTitle = "성공"
            alertMessage = "메일을 성공적으로 보냈습니다."
        case .cancelled:
            alertTitle = "취소됨"
            alertMessage = "메일 작성을 취소했습니다."
        case .saved:
            alertTitle = "임시 저장"
            alertMessage = "메일이 임시 저장되었습니다."
        case .failed:
            alertTitle = "실패"
            alertMessage = "메일 전송에 실패했습니다."
        @unknown default:
            alertTitle = "알 수 없음"
            alertMessage = "예기치 않은 결과가 발생했습니다."
        }
        
        // 알림 표시
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        controller.dismiss(animated: true) { [weak self] in
            self?.present(alertController, animated: true)
        }
    }
}
