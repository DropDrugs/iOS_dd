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
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [headerImageView, addDrugLabel, chevronImageView].forEach {
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
    }
}