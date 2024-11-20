// Copyright © 2024 RT4. All rights reserved

import UIKit
import PinLayout

class SubLabelView: UIView {

    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.ptdSemiBoldFont(ofSize: 17)
        label.textColor = Constants.Colors.gray900
        return label
    }()
    
    var text: String? {
        get { return label.text }
        set { label.text = newValue }
    }
    
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
            .top()
            .left()
            .sizeToFit()
    }
}
