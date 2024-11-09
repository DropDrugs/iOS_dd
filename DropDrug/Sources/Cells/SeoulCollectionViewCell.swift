// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class SeoulCollectionViewCell: UICollectionViewCell {
    
//    public lazy var circleView: UIView = {
//        let v = UIView()
//        v.backgroundColor = .white
//        v.layer.borderColor = Constants.Colors.gray300?.cgColor
//        v.layer.borderWidth = 1
//        v.layer.cornerRadius = 34
//        v.layer.masksToBounds = true
//        return v
//    }()
    
    public lazy var image: UIImageView = {
        let i = UIImageView()
        i.backgroundColor = .white
        i.contentMode = .scaleAspectFit
        i.layer.borderColor = Constants.Colors.gray300?.cgColor
        i.layer.borderWidth = 1
        i.layer.cornerRadius = 20
        i.layer.masksToBounds = true
        return i
    }()
    
    public lazy var name: UILabel = {
        let l = UILabel()
        l.font = UIFont.ptdRegularFont(ofSize: 13)
        l.textColor = Constants.Colors.gray800
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.image.image = nil
        self.name.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 강제로 레이아웃을 적용하여 실제 frame을 얻음
        image.layoutIfNeeded()
        
        // 크기가 결정된 이후에 cornerRadius 설정
        image.layer.cornerRadius = image.frame.width / 2
    }
    
    //레이아웃까지
    private func setupUI() {
        self.contentView.addSubview(image)
        self.contentView.addSubview(name)
        
        image.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(image.snp.width).multipliedBy(1.0)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
}
