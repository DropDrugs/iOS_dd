// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class DrugTypeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.ptdSemiBoldFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        
        let padding : CGFloat = (UIScreen.main.bounds.width - 48)/20
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-padding)
        }
        imageView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(-padding)
            make.centerX.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    // MARK: - Configuration Method
    func configure(title: String, assetName: String, backgroundColor: UIColor) {
        titleLabel.text = title
        imageView.image = UIImage(named: assetName)
        contentView.backgroundColor = backgroundColor
    }
}
