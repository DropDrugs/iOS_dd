// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class AddDrugView: UIView {
    
    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "OB1") // TODO: 이미지 에셋 변경
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [Constants.Colors.gray500?.withAlphaComponent(0.3).cgColor ?? UIColor.gray, UIColor.black.withAlphaComponent(0.3).cgColor]
        layer.locations = [0.0, 1.0]
        return layer
    }()
    
    public lazy var addDrugLabel: UILabel = {
        let label = UILabel()
        label.text = "의약품 등록하기"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.ptdSemiBoldFont(ofSize: 17)
        return label
    }()

    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.Colors.coralpink
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(headerImageView)
        headerImageView.layer.addSublayer(gradientLayer)
        
        [addDrugLabel, chevronImageView].forEach {
            addSubview($0)
        }
        
    }
    
    private func setConstraints() {
        headerImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addDrugLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalTo(addDrugLabel)
            make.leading.equalTo(addDrugLabel.snp.trailing).offset(10)
        }
        gradientLayer.frame = headerImageView.bounds
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = headerImageView.bounds // Gradient Layer의 프레임 갱신
    }
}
