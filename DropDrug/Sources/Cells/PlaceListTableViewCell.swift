// Copyright © 2024 RT4. All rights reserved

import UIKit

class PlaceListTableViewCell: UITableViewCell {
    
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
        l.font = UIFont.ptdRegularFont(ofSize: 16)
        l.numberOfLines = 0
        l.textColor = .black
        l.text = "정다운 약국"
        return l
    }()
    
    public lazy var address: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.ptdRegularFont(ofSize: 13)
        l.textColor = Constants.Colors.gray600
        l.text = "경기도 남양주시 경춘로 000"
        return l
    }()
    
    public lazy var labelSV: UIStackView = {
        let s = UIStackView(arrangedSubviews: [name, address])
        s.axis = .vertical // 수직으로 배치
        s.spacing = 0 // 레이블과 텍스트필드 사이 간격
        s.alignment = .fill
        s.distribution = .fill
        return s
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        [photo, labelSV].forEach{ self.addSubview($0) }
        
        photo.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(13)
            make.bottom.equalToSuperview().inset(14)
            make.width.height.equalTo(72)
        }
        
        labelSV.snp.makeConstraints { make in
            make.centerY.equalTo(photo)
            make.leading.equalTo(photo.snp.trailing).offset(13)
        }
    }
    
    public func configure(place: MapResponse) {
        name.text = place.name
        address.text = place.address
    }
}
