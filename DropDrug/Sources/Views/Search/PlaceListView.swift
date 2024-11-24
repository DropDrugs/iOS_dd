// Copyright © 2024 RT4. All rights reserved

import UIKit

class PlaceListView: UIView {
    
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
    
    public lazy var mapBtn: UIButton = {
        let b = UIButton()
        var configuration = UIButton.Configuration.plain()
        // 이미지 설정
        let symbolConfig = UIImage.SymbolConfiguration(weight: .bold)
        configuration.image = UIImage(systemName: "map.fill", withConfiguration: symbolConfig)?.withRenderingMode(.alwaysOriginal).withTintColor(Constants.Colors.gray500 ?? .gray)
        configuration.imagePlacement = .top
        configuration.imagePadding = 2

        // 타이틀 속성 설정
        let attributes: AttributeContainer = AttributeContainer([
            .font: UIFont.ptdSemiBoldFont(ofSize: 10), .foregroundColor: Constants.Colors.gray500 ?? .gray])
        configuration.attributedTitle = AttributedString("지도", attributes: attributes)
        configuration.titleAlignment = .center
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 2) // 여백 설정

        // 버튼 설정
        b.configuration = configuration
        b.backgroundColor = .clear
        return b
    }()
    
    public lazy var title: UILabel = {
        let l = UILabel()
        //l.text = "폐의약품 수거장소 리스트"
        l.font = UIFont.ptdSemiBoldFont(ofSize: 20)
        l.textColor = Constants.Colors.gray900
        return l
    }()
    
    public lazy var placeListTableView: UITableView = {
        let t = UITableView()
        t.register(PlaceListTableViewCell.self, forCellReuseIdentifier: "PlaceListTableViewCell")
        t.separatorStyle = .singleLine
        return t
    }()
    
    private func addComponents() {
        [topView, placeListTableView].forEach{ self.addSubview($0) }
        [mapBtn, title].forEach{ topView.addSubview($0) }
    }

    private func constraints() {
        topView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
        
        mapBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.width.height.equalTo(30)
        }
        
        title.snp.makeConstraints { make in
            make.centerY.equalTo(mapBtn)
            make.leading.equalTo(mapBtn.snp.trailing).offset(15)
        }
        
        placeListTableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
