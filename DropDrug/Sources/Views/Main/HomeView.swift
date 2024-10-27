// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import MapKit
import CoreLocation

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
    public var presentLocation = "기본 주소"

    public lazy var mapView: MKMapView = {
        let m = MKMapView()
        m.layer.cornerRadius = 7
        return m
    }()
    
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
        l.font = UIFont.roRegularFont(ofSize: 26)
        l.textColor = UIColor(named: "skyblue")
        return l
    }()
    
    public lazy var starter: UIButton = {
        let b = UIButton()
        b.backgroundColor = .white
        b.layer.cornerRadius = 20
        let attributedString = NSMutableAttributedString(string: "스타터  \(name)")
        attributedString.addAttributes([.foregroundColor: UIColor(named: "Gray700") ?? .gray, .font: UIFont.ptdRegularFont(ofSize: 12)], range: ("스타터  \(name)" as NSString).range(of: "스타터"))
        attributedString.addAttributes([.foregroundColor: UIColor.black, .font: UIFont.ptdSemiBoldFont(ofSize: 18)], range: ("스타터  \(name)" as NSString).range(of: "\(name)"))
        b.setAttributedTitle(attributedString, for: .normal)
        return b
    }()
    
    public lazy var point: UIButton = {
        let b = UIButton()
        b.backgroundColor = .white
        b.layer.cornerRadius = 20
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
        l.numberOfLines = 0
        l.textColor = UIColor(named: "Gray900")
        l.font = UIFont.ptdRegularFont(ofSize: 16)
        return l
    }()
    
    public lazy var goToSearchPlaceBtn: UIButton = {
        let b = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        // 이미지 설정
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .medium) // 원하는 크기와 굵기
        configuration.image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(Constants.Colors.skyblue ?? .blue)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 8

        // 타이틀 속성 설정
        let attributes: AttributeContainer = AttributeContainer([
            .font: UIFont.ptdSemiBoldFont(ofSize: 14), .foregroundColor: UIColor(named: "skyblue") ?? .blue])
        configuration.attributedTitle = AttributedString("내 주변 드롭 장소 탐색", attributes: attributes)
        configuration.titleAlignment = .center
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8) // 여백 설정

        // 버튼 설정
        b.configuration = configuration

        b.backgroundColor = .clear
        return b
        
    }()

    private func addComponenets() {
        addSubview(appTitle)
        addSubview(starter)
        addSubview(point)
        addSubview(locationBackground)
        locationBackground.addSubview(mapView)
        locationBackground.addSubview(location)
        locationBackground.addSubview(resetBtn)
        locationBackground.addSubview(presLoca)
        locationBackground.addSubview(goToSearchPlaceBtn)
        
        appTitle.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        starter.snp.makeConstraints { make in
            make.top.equalTo(appTitle.snp.bottom).offset(28)
            make.leading.equalTo(appTitle.snp.leading)
            make.height.equalTo(40)
            make.width.equalTo(127)
        }
        
        point.snp.makeConstraints { make in
            make.top.equalTo(starter.snp.top)
            make.leading.equalTo(starter.snp.trailing).offset(13)
            make.height.equalTo(40)
            make.width.equalTo(77)
        }
        
        locationBackground.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.25)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(110)
        }
        
        location.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.top)
            make.leading.equalTo(mapView.snp.trailing).offset(24)
        }
        
        resetBtn.snp.makeConstraints { make in
            make.centerY.equalTo(location)
            make.leading.equalTo(location.snp.trailing).offset(8)
        }
        
        presLoca.snp.makeConstraints { make in
            make.top.equalTo(location.snp.bottom).offset(8)
            make.leading.equalTo(location.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        goToSearchPlaceBtn.snp.makeConstraints { make in
            make.top.equalTo(presLoca.snp.bottom).offset(14)
            make.leading.equalTo(presLoca.snp.leading)
        }
    }
}