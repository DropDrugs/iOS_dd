// Copyright © 2024 RT4. All rights reserved

import UIKit
import NMapsMap

class MapView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var topView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    public lazy var listBtn: UIButton = {
        let b = UIButton()
        var configuration = UIButton.Configuration.plain()
        // 이미지 설정
        let symbolConfig = UIImage.SymbolConfiguration(weight: .bold)
        configuration.image = UIImage(systemName: "list.bullet", withConfiguration: symbolConfig)?.withRenderingMode(.alwaysOriginal).withTintColor(Constants.Colors.gray500 ?? .gray)
        configuration.imagePlacement = .top
        configuration.imagePadding = 2

        // 타이틀 속성 설정
        let attributes: AttributeContainer = AttributeContainer([
            .font: UIFont.ptdSemiBoldFont(ofSize: 10), .foregroundColor: Constants.Colors.gray500 ?? .gray])
        configuration.attributedTitle = AttributedString("목록", attributes: attributes)
        configuration.titleAlignment = .center
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 2) // 여백 설정

        // 버튼 설정
        b.configuration = configuration
        b.backgroundColor = .clear
        return b
    }()
    
    public lazy var title: UILabel = {
        let l = UILabel()
        l.text = "폐의약품 수거장소 찾기"
        l.font = UIFont.ptdSemiBoldFont(ofSize: 20)
        l.textColor = Constants.Colors.gray900
        return l
    }()

    public lazy var backgroundMap: NMFNaverMapView = {
        let m = NMFNaverMapView()
        m.showLocationButton = true
        m.showZoomControls = true
        return m
    }()
    
    public lazy var resetLocaBtn: UIButton = {
        let fb = UIButton()
        fb.backgroundColor = .white
        fb.layer.cornerRadius = 15
        fb.layer.shadowColor = UIColor.black.cgColor
        fb.layer.shadowOpacity = 0.3
        fb.layer.shadowOffset = CGSize(width: 0, height: 5)
        fb.layer.shadowRadius = 5

        var configuration = UIButton.Configuration.plain()
        // 이미지 설정
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .regular) // 원하는 크기와 굵기
        configuration.image = UIImage(systemName: "arrow.clockwise", withConfiguration: imageConfig)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(Constants.Colors.skyblue ?? .blue)
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8

        // 타이틀 속성 설정
        let attributes: AttributeContainer = AttributeContainer([
            .font: UIFont.ptdRegularFont(ofSize: 14), .foregroundColor: Constants.Colors.skyblue ?? .blue])
        configuration.attributedTitle = AttributedString("현 위치에서 검색", attributes: attributes)
        configuration.titleAlignment = .center
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8) // 여백 설정

        // 버튼 설정
        fb.configuration = configuration
        
        return fb
    }()
    
    public lazy var scrollView: UIScrollView = {
        let s = UIScrollView()
        s.backgroundColor = .clear
        s.showsHorizontalScrollIndicator = false
        return s
    }()
    
    public lazy var townOfficeFltBtn: UIButton = makeFltBtn(image: "officeBtnNSelect")
    
    public lazy var mailboxFltBtn: UIButton = makeFltBtn(image: "mailBtnNSelect")
    
    public lazy var pharmFltBtn: UIButton = makeFltBtn(image: "pharmBtnNSelect")
    
    public lazy var healthCenterFltBtn: UIButton = makeFltBtn(image: "healthBtnNSelect")
    
    public lazy var etcFltBtn: UIButton = makeFltBtn(image: "etcBtnNSelect")
        
    private func makeFltBtn(image: String) -> UIButton {
        let b = UIButton(type: .custom)
        b.setImage(UIImage(named: image)?.withRenderingMode(.alwaysOriginal), for: .normal)
        b.backgroundColor = .clear
        b.imageView?.contentMode = .scaleAspectFit
        b.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        b.sizeToFit()
        return b
    }
    
    private func addComponents() {
        [topView, scrollView, backgroundMap, resetLocaBtn].forEach{ self.addSubview($0) }
        [scrollView, resetLocaBtn].forEach{ self.bringSubviewToFront($0) }
        [townOfficeFltBtn, mailboxFltBtn, pharmFltBtn, healthCenterFltBtn, etcFltBtn].forEach{ scrollView.addSubview($0) }
        [listBtn, title].forEach{ topView.addSubview($0) }
    }
    
    private func constraints() {
        
        topView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
        
        listBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.width.height.equalTo(30)
        }
        
        title.snp.makeConstraints { make in
            make.centerY.equalTo(listBtn)
            make.leading.equalTo(listBtn.snp.trailing).offset(15)
        }
        
        scrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(80)
        }
        
        backgroundMap.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        resetLocaBtn.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-30)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        townOfficeFltBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
        }
        
        mailboxFltBtn.snp.makeConstraints { make in
            make.leading.equalTo(townOfficeFltBtn.snp.trailing).offset(15)
            make.centerY.equalTo(townOfficeFltBtn)
        }
        
        pharmFltBtn.snp.makeConstraints { make in
            make.leading.equalTo(mailboxFltBtn.snp.trailing).offset(15)
            make.centerY.equalTo(mailboxFltBtn)
        }
        
        healthCenterFltBtn.snp.makeConstraints { make in
            make.leading.equalTo(pharmFltBtn.snp.trailing).offset(15)
            make.centerY.equalTo(pharmFltBtn)
        }
        
        etcFltBtn.snp.makeConstraints { make in
            make.leading.equalTo(healthCenterFltBtn.snp.trailing).offset(15)
            make.centerY.equalTo(healthCenterFltBtn)
            make.trailing.equalToSuperview().inset(15)
        }
    }

}
