// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import MapKit
import CoreLocation

class HomeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Constants.Colors.lightblue
        self.setUpUI()
        self.setUpConstaraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var selectedCharacterNum: Int = 0
    public var points = 100
    public var name = "김드롭"
    public var presentLocation = "서비스 이용 가능 지역이 아닙니다"
    
    public lazy var floatingBtn: UIButton = {
        let fb = UIButton()
        fb.backgroundColor = UIColor(hex: "#212526")
        fb.layer.cornerRadius = 20
        fb.layer.shadowColor = UIColor.black.cgColor
        fb.layer.shadowOpacity = 0.3
        fb.layer.shadowOffset = CGSize(width: 0, height: 5)
        fb.layer.shadowRadius = 5
        
        var configuration = UIButton.Configuration.plain()
        // 이미지 설정
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .medium) // 원하는 크기와 굵기
        configuration.image = UIImage(systemName: "plus", withConfiguration: imageConfig)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(UIColor.white)
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8

        // 타이틀 속성 설정
        let attributes: AttributeContainer = AttributeContainer([
            .font: UIFont.ptdSemiBoldFont(ofSize: 14), .foregroundColor: UIColor.white])
        configuration.attributedTitle = AttributedString("의약품 폐기하기", attributes: attributes)
        configuration.titleAlignment = .center
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8) // 여백 설정

        // 버튼 설정
        fb.configuration = configuration
        
        return fb
    }()

    public lazy var mapView: MKMapView = {
        let m = MKMapView()
        m.layer.cornerRadius = 7
        return m
    }()
    
    public lazy var locationBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        v.clipsToBounds = true
        v.layer.cornerRadius = 10
        v.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        return v
    }()
    
    public lazy var appTitle: UILabel = {
        let l = UILabel()
        l.text = "DropDrug"
        l.font = UIFont.roRegularFont(ofSize: 26)
        l.textColor = Constants.Colors.skyblue
        return l
    }()
    
    public lazy var alarmBtn: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "alarm"), for: .normal)
        b.backgroundColor = .clear
        b.contentMode = .scaleAspectFill
        return b
    }()
    
    public lazy var starter: UIButton = {
        let b = UIButton()
        b.backgroundColor = .systemBackground
        b.layer.cornerRadius = 20
        let attributedString = NSMutableAttributedString(string: "스타터  \(name)")
        attributedString.addAttributes([.foregroundColor: Constants.Colors.gray700 ?? .gray, .font: UIFont.ptdRegularFont(ofSize: 12)], range: ("스타터  \(name)" as NSString).range(of: "스타터"))
        attributedString.addAttributes([.foregroundColor: UIColor.black, .font: UIFont.ptdSemiBoldFont(ofSize: 18)], range: ("스타터  \(name)" as NSString).range(of: "\(name)"))
        b.setAttributedTitle(attributedString, for: .normal)
        b.titleLabel?.lineBreakMode = .byClipping
        return b
    }()
    
    public lazy var point: UIButton = {
        let b = UIButton()
        b.backgroundColor = .systemBackground
        b.layer.cornerRadius = 20
        b.setTitle("\(points) P", for: .normal)
        b.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 14)
        b.setTitleColor(Constants.Colors.gray700, for: .normal)
        return b
    }()
    
    public lazy var location: UILabel = {
        let l = UILabel()
        l.text = "현 위치"
        l.textColor = Constants.Colors.gray700
        l.font = UIFont.ptdRegularFont(ofSize: 13)
        l.numberOfLines = 0
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
        l.textColor = Constants.Colors.gray900
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
            .font: UIFont.ptdSemiBoldFont(ofSize: 14), .foregroundColor: Constants.Colors.skyblue ?? .blue])
        configuration.attributedTitle = AttributedString("내 지역 드롭 방법 확인하기", attributes: attributes)
        configuration.titleAlignment = .center
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8) // 여백 설정

        // 버튼 설정
        b.configuration = configuration

        b.backgroundColor = .clear
        return b
        
    }()
    
    public lazy var characterView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    public lazy var character: UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFill
        i.backgroundColor = .clear
        i.isUserInteractionEnabled = true
        return i
    }()

    func setUpUI() {
        characterView.addSubview(character)
        [appTitle, alarmBtn, starter, point, locationBackground, floatingBtn, characterView].forEach {
            addSubview($0)
        }
        [mapView, location, resetBtn, presLoca, goToSearchPlaceBtn].forEach {
            locationBackground.addSubview($0)
        }
    }
    
    private func setUpConstaraints() {
        appTitle.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        alarmBtn.snp.makeConstraints { make in
            make.centerY.equalTo(appTitle)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(24)
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
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.22)
        }
        
        floatingBtn.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(locationBackground.snp.top).offset(-32)
            make.width.equalTo(146)
            make.height.equalTo(40)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(locationBackground).inset(20)
            make.width.equalTo(mapView.snp.height)
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
        
        characterView.snp.makeConstraints { make in
            make.top.equalTo(point.snp.bottom)
            make.bottom.equalTo(floatingBtn.snp.top)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        character.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(characterView)
            make.height.equalTo(characterView.snp.height).multipliedBy(0.7)
        }
    }
    
    public func updateStarter() {
        let attributedString = NSMutableAttributedString(string: "스타터  \(name)")
        attributedString.addAttributes([.foregroundColor: Constants.Colors.gray700 ?? .gray, .font: UIFont.ptdRegularFont(ofSize: 12)], range: ("스타터  \(name)" as NSString).range(of: "스타터"))
        attributedString.addAttributes([.foregroundColor: Constants.Colors.black ?? .black, .font: UIFont.ptdSemiBoldFont(ofSize: 18)], range: ("스타터  \(name)" as NSString).range(of: "\(name)"))
        starter.setAttributedTitle(attributedString, for: .normal)
    }
    
    public func updatePoints() {
        point.setTitle("\(points) P", for: .normal)
    }
    
    public func updateChar() {
        character.image = UIImage(named: "body\(selectedCharacterNum)")
    }
}
