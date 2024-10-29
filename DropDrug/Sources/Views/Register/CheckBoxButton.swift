// Copyright © 2024 RT4. All rights reserved

import UIKit

class CheckBoxButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        self.setImage(UIImage(systemName: "checkmark.square")?.withTintColor(Constants.Colors.skyblue ?? .blue, renderingMode: .alwaysOriginal), for: .selected)
        self.setImage(UIImage(systemName: "square")?.withTintColor(Constants.Colors.gray500 ?? .gray, renderingMode: .alwaysOriginal), for: .normal)
        self.setTitle(title, for: .normal)
        self.setTitleColor(Constants.Colors.gray500 ?? .gray , for: .normal)
        self.titleLabel?.font = UIFont.ptdRegularFont(ofSize: 13)
        
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        if let imageView = self.imageView, let titleLabel = self.titleLabel {
            imageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.equalTo(20)
                make.height.equalTo(20)
            }
            titleLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(10)
                make.centerY.equalTo(imageView)
            }
        }
        self.contentHorizontalAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
