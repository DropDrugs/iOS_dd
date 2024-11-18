// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class MyPageVC : UIViewController {
    
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
        button.backgroundColor = .red
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(settingTapped), for: .touchUpInside)
        return button
    }()
    
    private let myPageProfileView = ProfileView()
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
        addSafeAreaColor()
        setupViews()
        setConstraints()
        setComponents()
        }
    
    func addSafeAreaColor() {
        let safeAreaView = UIView()
//        safeAreaView.backgroundColor = UIColor.red.withAlphaComponent(0.2) // Safe Area를 강조하기 위한 반투명 빨간색
        view.addSubview(safeAreaView)
        
        // Safe Area의 제약 조건 추가
        safeAreaView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
            make.top.equalTo(view.snp.top).inset(superViewHeight * 0.08)
            make.leading.equalToSuperview().inset(20)
        }
        settingButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(50)
            make.trailing.equalToSuperview()
        }
        myPageProfileView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(superViewHeight * 0.05)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(25)
        }
        rewardView.snp.makeConstraints { make in
            make.top.equalTo(myPageProfileView.snp.bottom).offset(superViewHeight * 0.05)
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
    
    @objc func settingTapped() {
        let settingsVC = SettingsVC()
        navigationController?.pushViewController(settingsVC, animated: true)
        print("setting tapped")
    }
    
}
