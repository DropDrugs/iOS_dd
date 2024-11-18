// Copyright © 2024 RT4. All rights reserved

import Foundation
import UIKit

class AccountOptionCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let editButton = UIButton(type: .system)
    
    var editAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // 타이틀 라벨
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = Constants.Colors.gray700
        
        // 상세 라벨
        detailLabel.font = .systemFont(ofSize: 16)
        detailLabel.textColor = Constants.Colors.gray600
        detailLabel.textAlignment = .right
        
        // 수정 버튼
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.tintColor = Constants.Colors.gray400
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(editButton)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        detailLabel.snp.makeConstraints { make in
            make.trailing.equalTo(editButton.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    func configure(title: String, detail: String?, showEditButton: Bool) {
        titleLabel.text = title
        detailLabel.text = detail
        editButton.isHidden = !showEditButton
    }
    
    @objc private func didTapEditButton() {
        editAction?()
    }
}
