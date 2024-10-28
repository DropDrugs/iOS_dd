// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class OnboardingVC2 : UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = Constants.Colors.skyblue
            super.viewDidLoad()
            setupGradientBackground()
            setupUI()
        }
        
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [
            (Constants.Colors.coralpink?.withAlphaComponent(0.7) ?? UIColor.systemPink.withAlphaComponent(0.7)).cgColor,
            (Constants.Colors.skyblue ?? UIColor.systemTeal).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        let diameter: CGFloat = 500
        gradientLayer.frame = CGRect(x: (view.bounds.width - diameter) / 2,
                                     y: (view.bounds.height - diameter) / 2,
                                     width: diameter,
                                     height: diameter)
        gradientLayer.cornerRadius = diameter / 2
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
        
        private func setupUI() {
            let label = UILabel()
            label.text = "드롭드럭에서\n올바른 의약품 폐기를 함께하고\n나와 지구를 치료해요!"
            label.textColor = .white
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 22)
            
            let startButton = UIButton(type: .system)
            startButton.setTitle("시작하기", for: .normal)
            startButton.setTitleColor(Constants.Colors.skyblue, for: .normal)
            startButton.backgroundColor = .white
            startButton.layer.cornerRadius = 30
            startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
            
            view.addSubview(label)
            view.addSubview(startButton)
        
            label.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(superViewWidth * 0.1)
            }
            
            startButton.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(20)
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(superViewHeight * 0.05)
                make.height.equalTo(superViewWidth * 0.15)
            }
        }
    
    @objc func startTapped() {
        let SignUpVC = SignUpVC()
        SignUpVC.modalPresentationStyle = .fullScreen
        present(SignUpVC, animated: true, completion: nil)
    }
}
