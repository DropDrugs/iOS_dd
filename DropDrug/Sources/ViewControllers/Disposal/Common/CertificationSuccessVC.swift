// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya

class CertificationSuccessVC: UIViewController {
    let provider = MoyaProvider<PointAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    let DrugProvider = MoyaProvider<DrugAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    
    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "IdentifySuccess")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "인증 완료!"
        label.font = UIFont.ptdBoldFont(ofSize: 24)
        label.textColor = Constants.Colors.gray800
        label.textAlignment = .center
        return label
    }()
    
    private let checkMessageLabel: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center // 모든 요소를 수직 중심에 정렬
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "올바르게 드롭했어요"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Constants.Colors.skyblue
        label.textAlignment = .center
        return label
    }()
    
    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = Constants.Colors.skyblue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료하기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Colors.skyblue
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectPrescriptionId = SelectDiscardPrescriptionDrugVC.targetDrugId {
            self.deleteDrugs(self.setupDeleteDrugDTO([selectPrescriptionId])) { isSuccess in
                if isSuccess {
                    SelectDiscardPrescriptionDrugVC.targetDrugId = nil
                    self.postSuccessPoint(data: self.setupData(point: 150, type: "DRUG_PHOTO_CERTIFICATION", location: Constants.currentPosition)) { isSuccess, getBadge  in
                        if isSuccess {
                            if let getBadge = getBadge {
                            }
                        } else {
                            // 포인트 적립 실패
                        }
                    }
                } else {
                    // 처방약 데이터 삭제 실패..
                }
            }
        } else {
            postSuccessPoint(data: setupData(point: 100, type: "GENERAL_PHOTO_CERTIFICATION", location: Constants.currentPosition)) { isSuccess, _  in
                if isSuccess {
                    print("포인트 적립 성공")
                } else {
                    print("포인트 적립 실패")
                }
            }
        }
    }
    
    func goToMyPage() {
        let vc = MyPageVC()
        present(vc, animated: true)
    }
    func goToRewardPage() {
        let vc = RewardVC()
        present(vc, animated: true)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = Constants.Colors.white
        [ checkImageView, messageLabel].forEach {
            checkMessageLabel.addArrangedSubview($0)
        }
        
        [imageView, titleLabel, checkMessageLabel, completeButton].forEach {
            view.addSubview($0)
        }
        
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(superViewHeight * 0.1)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(superViewWidth * 0.9)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(checkMessageLabel.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        
        checkMessageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(completeButton.snp.top).offset(-50)
            make.centerX.equalToSuperview() // 수평 가운데 정렬
        }
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(superViewHeight * 0.1)
            make.centerX.equalToSuperview()
            make.width.equalTo(superViewWidth * 0.9)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    @objc private func completeButtonTapped() {
        var currentVC: UIViewController? = self
        while let parentVC = currentVC?.navigationController?.viewControllers.first(where: { $0 is HomeViewController }) {
            
            if parentVC is HomeViewController {
                if let navigationController = parentVC.navigationController {
                    navigationController.popToViewController(parentVC, animated: true)
                    return
                }
                currentVC = parentVC
            }
            print("SelectDrugTypeVC not found")
        }
    }

    private func resetToMainTabBar() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        
        let mainTabBarVC = MainTabBarController()
        let navigationController = UINavigationController(rootViewController: mainTabBarVC)
        navigationController.navigationBar.isHidden = true
            
        keyWindow.rootViewController = navigationController
        keyWindow.makeKeyAndVisible()
    }
}
