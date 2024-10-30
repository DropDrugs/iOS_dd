// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class KindCollectionViewCell: UICollectionViewCell {
    
    private let background: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor(named: "gray500")?.withAlphaComponent(0.6).cgColor ?? UIColor.gray, UIColor.black.withAlphaComponent(0.6).cgColor]
        layer.locations = [0.0, 1.0]
        return layer
    }()
    
    private let name: UILabel = {
        let l = UILabel()
        l.font = UIFont.ptdSemiBoldFont(ofSize: 16)
        l.textColor = .white
        return l
    }()
    
    private let arrow: UIImageView = {
        let a = UIImageView()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium) // 원하는 크기와 굵기
        a.image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        a.backgroundColor = .clear
        return a
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //레이아웃까지
    private func setupUI() {
        self.contentView.addSubview(background)
        self.contentView.addSubview(name)
        self.contentView.addSubview(arrow)
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        name.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        arrow.snp.makeConstraints { make in
            make.leading.equalTo(name.snp.trailing).offset(8)
            make.centerY.equalTo(name)
        }
        
        background.layer.addSublayer(gradientLayer)
        gradientLayer.frame = contentView.bounds
    }
    
    func configure(backgroundImg: String, name: String) {
        background.image = UIImage(named: backgroundImg)
        self.name.text = name
    }
}
