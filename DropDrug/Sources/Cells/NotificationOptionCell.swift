// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class NotificationOptionCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let toggleSwitch = UISwitch()
    private var toggleAction: ((Bool) -> Void)?
    
    func configure(title: String, isSwitchOn: Bool, isSwitchEnabled: Bool, onToggle: @escaping (Bool) -> Void) {
        titleLabel.text = title
        toggleSwitch.isOn = isSwitchOn
        toggleSwitch.isEnabled = isSwitchEnabled
        
        toggleSwitch.onTintColor = Constants.Colors.skyblue // 켜졌을 때 배경색
        toggleSwitch.thumbTintColor = Constants.Colors.white
        
        toggleAction = onToggle

        toggleSwitch.removeTarget(self, action: #selector(handleToggle(_:)), for: .valueChanged)
        toggleSwitch.addTarget(self, action: #selector(handleToggle(_:)), for: .valueChanged)

        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleSwitch)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        toggleSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    @objc private func handleToggle(_ sender: UISwitch) {
        toggleAction?(sender.isOn)
    }
}
