// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class NotificationCell: UITableViewCell {
    // UI Components
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill") // SF Symbol 설정
        imageView.contentMode = .scaleAspectFit // 적절한 크기 유지
        imageView.tintColor = Constants.Colors.pink
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title Label" // 기본 텍스트
        label.textColor = Constants.Colors.gray700
        label.font = UIFont.ptdRegularFont(ofSize: 16)
        label.numberOfLines = 1 // 한 줄로 제한
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(16) // safeArea Top + 16
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20) // safeArea Leading + 20
            make.width.height.equalTo(10) // 정사각형 크기 설정
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView) // 이미지뷰와 동일한 Top
            make.leading.equalTo(iconImageView.snp.trailing).offset(8) // 이미지뷰의 trailing + 8
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-20) // safeArea Trailing - 20
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).offset(-16)
        }
    }
    
    // MARK: - Configure Method
    
    func configure(with title: String, isRecent color : UIColor) {
        titleLabel.text = title
        iconImageView.tintColor = color
    }
    
}
