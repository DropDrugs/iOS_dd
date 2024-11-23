// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya

class MyPageVC : UIViewController {
    
    let MemberProvider = MoyaProvider<MemberAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.font = UIFont.ptdSemiBoldFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gearshape")?.withTintColor(Constants.Colors.black ?? .black , renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(settingTapped), for: .touchUpInside)
        return button
    }()
    
    let myPageProfileView = ProfileView()
    let rewardView = RewardView()
    private let dropCardLabel = SubLabelView()
    private let disposalStateLabel = SubLabelView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if navigationController == nil {
            let navigationController = UINavigationController(rootViewController: self)
            navigationController.modalPresentationStyle = .fullScreen
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.rootViewController?.present(navigationController, animated: true)
            }
        }
        
        self.navigationController?.isNavigationBarHidden = true
        setupViews()
        setConstraints()
        setComponents()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMemberInfo { success in
            if success {
                print("Profile updated successfully")
            } else {
                print("Failed to update profile")
            }
        }
    }
    
    func setComponents() {
        dropCardLabel.text = "나의 드롭카드"
        disposalStateLabel.text = "월별 폐기 현황"
    }
    
    func setupViews() {
        view.backgroundColor = .white
        [titleLabel, settingButton, myPageProfileView, rewardView, dropCardLabel, disposalStateLabel].forEach {
            view.addSubview($0)
        }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        settingButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(50)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        myPageProfileView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(superViewHeight * 0.07)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(25)
        }
        rewardView.snp.makeConstraints { make in
            make.top.equalTo(myPageProfileView.snp.bottom).offset(superViewHeight * 0.07)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(60)
        }
        dropCardLabel.snp.makeConstraints { make in
            make.top.equalTo(rewardView.snp.bottom).offset(superViewHeight * 0.05)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(25)
        }
        disposalStateLabel.snp.makeConstraints { make in
            make.top.equalTo(dropCardLabel.snp.bottom).offset(superViewHeight * 0.05)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(25)
        }
        
    }
    
    func setupGestures() {
            let rewardTapGesture = UITapGestureRecognizer(target: self, action: #selector(rewardViewTapped))
            rewardView.addGestureRecognizer(rewardTapGesture)
            rewardView.isUserInteractionEnabled = true
        }
    
    // MARK: Actions
    @objc func settingTapped() {
        self.navigationController?.isNavigationBarHidden = false
        let settingsVC = SettingsVC()
        navigationController?.pushViewController(settingsVC, animated: false)
        print("setting tapped")
    }
    
    @objc func rewardViewTapped() {
        self.navigationController?.isNavigationBarHidden = false
        let RewardVC = RewardVC()
        navigationController?.pushViewController(RewardVC, animated: false)
        print("Reward view tapped")
    }
    
}
