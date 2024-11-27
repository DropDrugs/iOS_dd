// Copyright © 2024 RT4. All rights reserved

import Foundation
import UIKit

class CustomBackButton: UIButton {
    
    // MARK: - Initializer
    init(title: String) {
        super.init(frame: .zero)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton(title: "")
    }
    
    // MARK: - Setup Method
    private func setupButton(title: String) {
        self.setImage(UIImage(systemName: "chevron.left")?
            .withTintColor(Constants.Colors.gray500 ?? .systemGray, renderingMode: .alwaysOriginal),
                      for: .normal)
        self.setTitle("\(title)", for: .normal)
        self.setTitleColor(Constants.Colors.black, for: .normal)
        self.titleLabel?.font = UIFont.ptdBoldFont(ofSize: 21)
    }
}
