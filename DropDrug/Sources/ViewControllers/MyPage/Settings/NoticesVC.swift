// Copyright © 2024 RT4. All rights reserved

import UIKit

class NoticesVC: UIViewController {
    
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  공지사항")
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
