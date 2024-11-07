// Copyright © 2024 RT4. All rights reserved

import Foundation
import UIKit
import SnapKit

class SelectDropTypeVC : UIViewController {
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left")?.withTintColor(UIColor(named: "gray500") ?? .systemGray , renderingMode: .alwaysOriginal), for: .normal)
        button.setTitle("  의약품 드롭하기", for: .normal) // 필요시 제목 설정
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.ptdBoldFont(ofSize: 24)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        backButton.snp.makeConstraints { make in
            make.left.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
    }
    
    private func setupView() {
        view.addSubview(backButton)
        view.backgroundColor = .white
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
