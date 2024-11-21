// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class NotificationOptionCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let toggleSwitch = UISwitch()
    private var switchAction: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // 타이틀 라벨
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .darkGray
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleSwitch)
        
        // 레이아웃 설정
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        // 스위치 값 변경 시 동작 설정
        toggleSwitch.addTarget(self, action: #selector(didToggleSwitch), for: .valueChanged)
    }
    
    func configure(title: String, isSwitchOn: Bool, action: @escaping (Bool) -> Void) {
        titleLabel.text = title
        toggleSwitch.isOn = isSwitchOn
        self.switchAction = action
    }
    
    @objc private func didToggleSwitch() {
        switchAction?(toggleSwitch.isOn)
    }
}
