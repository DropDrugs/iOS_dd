// Copyright © 2024 RT4. All rights reserved

import UIKit
import PinLayout

class LogoLabelView: UIView {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "DropDrug"
        label.textAlignment = .center
        label.font = UIFont.roRegularFont(ofSize: 26)
        label.textColor = Constants.Colors.skyblue
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // PinLayout을 사용해 왼쪽에서 20포인트 띄우기
        label.pin
            .top(20)
            .left(20)
            .sizeToFit()
    }
}

