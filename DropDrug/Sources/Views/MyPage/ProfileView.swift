// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya

class ProfileView: UIView {

    let provider = MoyaProvider<MemberAPI>(plugins: [NetworkLoggerPlugin()])
    
    // MARK: - UI Components
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "profileExample")
        view.backgroundColor = .gray
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "김드롭"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.label
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "kimdrop@gmail.com"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.systemGray
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        fetchMemberInfo()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(emailLabel)
        
        // SnapKit을 사용한 레이아웃 설정
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.top.equalTo(profileImageView).offset(4)
            make.trailing.equalToSuperview()
        }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview()
        }
    }
}
