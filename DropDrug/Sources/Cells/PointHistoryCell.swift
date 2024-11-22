// Copyright © 2024 RT4. All rights reserved

import Foundation
import UIKit
import SnapKit

class PointHistoryCell: UITableViewCell {
    static let identifier = "PointHistoryCell"
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.ptdRegularFont(ofSize: 15)
        label.textColor = Constants.Colors.gray800
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.ptdRegularFont(ofSize: 15)
        label.textColor = Constants.Colors.gray800
        label.textAlignment = .center
        return label
    }()
    
    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.ptdRegularFont(ofSize: 15)
        label.textColor = Constants.Colors.gray800
        label.textAlignment = .right
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.gray100 // 원하는 색상으로 설정
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel, descriptionLabel, pointsLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        contentView.addSubview(stackView)
        contentView.addSubview(separatorView) // 구분선 추가
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: PointDetail) {
        dateLabel.text = item.date
        descriptionLabel.text = item.type
        pointsLabel.text = "\(item.point > 0 ? "+" : "")\(item.point) P"
    }
}
