// Copyright © 2024 RT4. All rights reserved

import UIKit
import NMapsMap

class MapView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var backgroundMap: NMFMapView = {
        let m = NMFMapView()
        return m
    }()
    
    public lazy var townOfficeFltBtn: UIButton = makeFltBtn("동사무소", image: "nSelectOffice")
    
    public lazy var mailboxFltBtn: UIButton = makeFltBtn("우체통", image: "nSelectMail")
    
    public lazy var pharmFltBtn: UIButton = makeFltBtn("약국", image: "nSelectPharm")
    
//    public lazy var fltBtnStackView: UIStackView = {
//        let s = UIStackView(arrangedSubviews: [townOfficeFltBtn, mailboxFltBtn, pharmFltBtn])
//        s.axis = .horizontal
//        s.spacing = 15
//        s.alignment = .fill
//        s.distribution = .fillEqually
//        return s
//    }()
    
    private func makeFltBtn(_ title: String, image: String) -> UIButton {
        let b = UIButton(type: .custom)
        var configuration = UIButton.Configuration.plain()
        // 이미지 설정
        configuration.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        configuration.imagePlacement = .leading
        configuration.imagePadding = 4

        // 타이틀 속성 설정
        let attributes: AttributeContainer = AttributeContainer([
            .font: UIFont.ptdRegularFont(ofSize: 14), .foregroundColor: UIColor.black])
        configuration.attributedTitle = AttributedString(title, attributes: attributes)
        configuration.titleAlignment = .center
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4) // 여백 설정

        // 버튼 설정
        b.configuration = configuration
        b.backgroundColor = .white
        b.layer.cornerRadius = 15
        b.layer.shadowColor = UIColor.black.cgColor
        b.layer.shadowOpacity = 0.3
        b.layer.shadowOffset = CGSize(width: 0, height: 5)
        b.layer.shadowRadius = 5
        return b
    }
    
    private func addComponents() {
        addSubview(backgroundMap)
        [townOfficeFltBtn, mailboxFltBtn, pharmFltBtn].forEach{ self.addSubview($0)
            self.bringSubviewToFront($0) }
    }
    
    private func constraints() {
        backgroundMap.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        townOfficeFltBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(23)
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(93)
        }
        
        mailboxFltBtn.snp.makeConstraints { make in
            make.leading.equalTo(townOfficeFltBtn.snp.trailing).offset(15)
            make.centerY.equalTo(townOfficeFltBtn)
            make.height.equalTo(30)
            make.width.equalTo(81)
        }
        
        pharmFltBtn.snp.makeConstraints { make in
            make.leading.equalTo(mailboxFltBtn.snp.trailing).offset(15)
            make.centerY.equalTo(mailboxFltBtn)
            make.height.equalTo(30)
            make.width.equalTo(69)
        }
    }

}
