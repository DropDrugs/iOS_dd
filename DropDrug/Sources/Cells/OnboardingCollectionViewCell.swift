// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let textOverlayView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with page: OnboardingPage) {
        titleLabel.text = page.title
        descriptionLabel.text = page.description
        imageView.image = UIImage(named: page.imageName)
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .black
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        textOverlayView.layer.cornerRadius = 10
        textOverlayView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        contentView.addSubview(textOverlayView)
        textOverlayView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        titleLabel.textColor = Constants.Colors.pink ?? UIColor.systemPink
        titleLabel.font = UIFont.ptdSemiBoldFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        textOverlayView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(textOverlayView.snp.top).offset(superViewHeight * 0.04)
            make.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.ptdRegularFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        textOverlayView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(superViewHeight * 0.04)
            make.leading.trailing.equalToSuperview().inset(superViewWidth * 0.1)
        }
    }
}
