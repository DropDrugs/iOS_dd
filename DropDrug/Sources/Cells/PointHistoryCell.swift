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
        view.backgroundColor = Constants.Colors.gray100
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel, descriptionLabel, pointsLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        contentView.addSubview(stackView)
        contentView.addSubview(separatorView)
        
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
    
    // 업데이트된 configure 메서드
    func configure(with item: PointDetail) {
        dateLabel.text = formatDate(item.date)
        
        // type에 따라 descriptionLabel과 pointsLabel 스타일 조정
        switch item.type {
        case "캐릭터 구매":
            descriptionLabel.text = "캐릭터 구매"
            descriptionLabel.textColor = Constants.Colors.gray800
        case "PHOTO_CERTIFICATION":
            descriptionLabel.text = "사진 인증 성공"
            descriptionLabel.textColor = Constants.Colors.gray800
        case "폐기 장소 문의":
            descriptionLabel.text = "장소 문의 완료"
            descriptionLabel.textColor = Constants.Colors.gray800
        default:
            descriptionLabel.text = item.type
            descriptionLabel.textColor = Constants.Colors.gray800
        }
        
        pointsLabel.text = "\(item.point > 0 ? "+" : "")\(item.point) P"
    }
    
    private func formatDate(_ isoDate: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: isoDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "yyyy/MM/dd"
            return displayFormatter.string(from: date)
        }
        return isoDate
    }
}
