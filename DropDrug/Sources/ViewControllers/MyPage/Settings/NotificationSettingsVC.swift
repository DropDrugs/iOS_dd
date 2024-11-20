// Copyright © 2024 RT4. All rights reserved

import UIKit

class NotificationSettingsVC: UIViewController {
    
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  푸시 알림 설정")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: false)
    }
}