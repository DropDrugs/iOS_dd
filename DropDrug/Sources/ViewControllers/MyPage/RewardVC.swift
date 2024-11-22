// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya

class RewardVC : UIViewController {
    
    let PointProvider = MoyaProvider<PointAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  리워드 내역")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    let rewardView: RewardView = {
            let view = RewardView()
            view.isChevronHidden = true
            return view
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        setupViews()
        setConstraints()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        [rewardView].forEach {
            view.addSubview($0)
        }
        fetchPoint { success in
            if success {
                print("Profile updated successfully")
            } else {
                print("Failed to update profile")
            }
        }
    }
    
    func setConstraints() {
        rewardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(60)
        }
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.popViewController(animated: false)
    }
}
