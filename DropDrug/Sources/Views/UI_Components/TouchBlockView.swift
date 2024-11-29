// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class TouchBlockView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.Colors.black?.withAlphaComponent(0.5) // 반투명 블랙
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 터치 이벤트를 모두 막음
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return true // 터치를 모두 소비하여 아래로 전달하지 않음
    }
}
