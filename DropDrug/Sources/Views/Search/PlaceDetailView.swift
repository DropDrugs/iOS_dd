// Copyright © 2024 RT4. All rights reserved

import UIKit

class PlaceDetailView: UIView {
    
    var imageURL: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var photo: UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFill
        i.layer.cornerRadius = 10
        i.layer.masksToBounds = true
        i.image = UIImage(named: "OB1")
//        if let imageUrl = imageURL, let url = URL(string: imageUrl) {
//            i.sd_setImage(with: url, placeholderImage: UIImage(named: "OB1"))
//        } else {
//            i.image = UIImage(named: "OB1")
//        }
        return i
    }()
    
    public lazy var name: UILabel = {
        let l = UILabel()
        l.font = UIFont.ptdSemiBoldFont(ofSize: 20)
        l.numberOfLines = 0
        l.textColor = Constants.Colors.gray900
        return l
    }()
    
    public lazy var address: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.ptdRegularFont(ofSize: 15)
        l.textColor = Constants.Colors.gray700
        return l
    }()
    
    private func addComponents() {
        [photo, name, address].forEach{ self.addSubview($0) }
    }

    private func constraints() {
        
        photo.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(100)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(photo.snp.top)
            make.leading.equalTo(photo.snp.trailing).offset(10)
        }
        
        address.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(5)
            make.leading.equalTo(name.snp.leading)
        }
    }
}
