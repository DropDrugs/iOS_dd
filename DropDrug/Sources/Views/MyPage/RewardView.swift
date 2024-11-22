// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya

class RewardView: UIView {
    
    let provider = MoyaProvider<MemberAPI>(plugins: [NetworkLoggerPlugin()])
    
    private let rewardLabel: UILabel = {
        let label = UILabel()
        label.text = "리워드"
        label.font = UIFont.ptdSemiBoldFont(ofSize: 17)
        label.textColor = Constants.Colors.gray800
        return label
    }()
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.text = "1,200 P"
        label.font = UIFont.ptdSemiBoldFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = Constants.Colors.gray700
        return imageView
    }()
    
    private let gradientLayer = CAGradientLayer()
    
    var isChevronHidden: Bool = false {
        didSet {
            chevronImageView.isHidden = isChevronHidden
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        fetchMemberInfo()
        setupGradientBackground()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupGradientBackground()
    }
    
    private func setupView() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        // Add subviews
        addSubview(rewardLabel)
        addSubview(pointsLabel)
        addSubview(chevronImageView)
        
        // Apply constraints using SnapKit
        rewardLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        pointsLabel.snp.makeConstraints { make in
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupGradientBackground() {
        gradientLayer.colors = [
                (Constants.Colors.lightblue ?? UIColor.systemBlue).cgColor,
                (Constants.Colors.coralpink ?? UIColor.systemPink).cgColor
            ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 12
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
