// Copyright © 2024 RT4. All rights reserved

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
    
    func configure(with item: PointDetail) {
        dateLabel.text = formatDate(item.date)
        
        switch item.type {
        case "CHARACTER_PURCHASE":
            descriptionLabel.text = "캐릭터 구매"
        case "PHOTO_CERTIFICATION":
            descriptionLabel.text = "사진 인증 성공"
        case "폐기 장소 문의":
            descriptionLabel.text = "장소 문의 완료"
        default:
            descriptionLabel.text = item.type
        }
        
        pointsLabel.text = "\(item.point > 0 ? "+" : "")\(item.point) P"
    }
    
    private func formatDate(
        _ isoDate: String,
        to outputFormat: String = "yyyy/MM/dd",
        defaultString: String = "Invalid Date"
    ) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = isoFormatter.date(from: isoDate) {
            return outputFormatter.string(from: date)
        } else {
            let flexibleFormatter = DateFormatter()
            flexibleFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            if let date = flexibleFormatter.date(from: isoDate) {
                return outputFormatter.string(from: date)
            }
        }
        
        return defaultString
    }
}
