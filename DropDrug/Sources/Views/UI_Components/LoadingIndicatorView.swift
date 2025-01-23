// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Then

final class LoadingIndicatorView: UIView {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large).then {
        $0.color = .white
        $0.hidesWhenStopped = true // 애니메이션 중지 시 숨김
    }
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        $0.layer.cornerRadius = 10 // 모서리 둥글게
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(backgroundView)
        backgroundView.addSubview(activityIndicator)
        
        backgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    /// 로딩 시작
    func startLoading() {
        activityIndicator.startAnimating()
        isHidden = false
    }
    
    /// 로딩 중지
    func stopLoading() {
        activityIndicator.stopAnimating()
        isHidden = true
    }
}
