// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class HomeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "Lightblue")
        self.addComponenets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var points = 100
    public var name = "김드롭"
    public var presentLocation = "서울특별시 성동구 연무장길 103"
    
    public lazy var locationBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.clipsToBounds = true
        v.layer.cornerRadius = 10
        v.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        return v
    }()
    
    public lazy var appTitle: UILabel = {
        let l = UILabel()
        l.text = "DropDrug"
        l.font = UIFont.roRegularFont(ofSize: 20)
        l.textColor = UIColor(named: "skyblue")
        return l
    }()
    
    public lazy var starter: UIButton = {
        let b = UIButton()
        b.backgroundColor = .white
        b.layer.cornerRadius = 50
        let attributedString = NSMutableAttributedString(string: "스타터 \(name)")
        attributedString.addAttributes([.foregroundColor: UIColor(named: "Gray700") ?? .gray, .font: UIFont.ptdRegularFont(ofSize: 12)], range: ("스타터 \(name)" as NSString).range(of: "스타터"))
        attributedString.addAttributes([.foregroundColor: UIColor.black, .font: UIFont.ptdSemiBoldFont(ofSize: 18)], range: ("스타터 \(name)" as NSString).range(of: "\(name)"))
        b.setAttributedTitle(attributedString, for: .normal)
        return b
    }()
    
    public lazy var point: UIButton = {
        let b = UIButton()
        b.backgroundColor = .white
        b.layer.cornerRadius = 50
        b.setTitle("\(points) P", for: .normal)
        b.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 14)
        b.setTitleColor(UIColor(named: "Gray700"), for: .normal)
        return b
    }()
    
    public lazy var location: UILabel = {
        let l = UILabel()
        l.text = "현 위치"
        l.textColor = UIColor(named: "Gray700")
        l.font = UIFont.ptdRegularFont(ofSize: 13)
        return l
    }()
    
    public lazy var resetBtn: UIButton = {
        let b = UIButton()
        b.backgroundColor = .clear
        b.setImage(UIImage(named: "Refresh"), for: .normal)
        return b
    }()
    
    public lazy var presLoca: UILabel = {
        let l = UILabel()
        l.text = presentLocation
        l.textColor = UIColor(named: "Gray900")
        l.font = UIFont.ptdRegularFont(ofSize: 16)
        return l
    }()
    
    public lazy var goToSearchPlaceBtn: UIButton = {
        let b = UIButton()
        b.backgroundColor = .clear
        b.setTitle("내 주변 드롭 장소 탐색", for: .normal)
        b.setTitleColor(UIColor(named: "skyblue"), for: .normal)
        b.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 14)
        b.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return b
    }()

    private func addComponenets() {
        addSubview(appTitle)
        addSubview(starter)
        addSubview(point)
        addSubview(locationBackground)
        locationBackground.addSubview(location)
        locationBackground.addSubview(resetBtn)
        locationBackground.addSubview(presLoca)
        locationBackground.addSubview(goToSearchPlaceBtn)
        
        appTitle.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        starter.snp.makeConstraints { make in
            make.top.equalTo(appTitle.snp.bottom).offset(28)
            make.leading.equalTo(appTitle.snp.leading)
            make.height.equalTo(40)
            make.width.equalTo(<#T##other: any ConstraintRelatableTarget##any ConstraintRelatableTarget#>)
        }
        
        point.snp.makeConstraints { make in
            make.top.equalTo(starter.snp.top)
            make.leading.equalTo(starter.snp.trailing).offset(13)
            make.height.equalTo(40)
            make.width.equalTo(<#T##other: any ConstraintRelatableTarget##any ConstraintRelatableTarget#>)
        }
        
        locationBackground.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.37)
        }
        
        location.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.
        }
    }

}
