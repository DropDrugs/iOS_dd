// Copyright © 2024 RT4. All rights reserved

import UIKit

class EnrollDetailViewController: UIViewController {
    
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  의약품 등록하기")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    public lazy var selectStartDateLabel: UILabel = {
        let label = UILabel()
        label.text = "복용 시작 날짜 선택"
        label.textColor = Constants.Colors.gray900
        label.textAlignment = .left
        label.font = UIFont.ptdSemiBoldFont(ofSize: 17)
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date // 날짜 선택 모드
        picker.preferredDatePickerStyle = .inline
        picker.tintColor = Constants.Colors.skyblue
        picker.locale = Locale(identifier: "ko_KR") // 한국어로 표시
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    public lazy var selectDateCountLabel: UILabel = {
        let label = UILabel()
        label.text = "복용 일수 선택"
        label.textColor = Constants.Colors.gray900
        label.textAlignment = .left
        label.font = UIFont.ptdSemiBoldFont(ofSize: 17)
        return label
    }()
    
    private lazy var customStepper: CustomStepper = {
        let stepper = CustomStepper()
        return stepper
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        button.backgroundColor = Constants.Colors.skyblue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        setupLayout()
    }
    
    func setupLayout() {
        let views = [selectStartDateLabel, selectDateCountLabel, customStepper, datePicker, completeButton]
        views.forEach { view.addSubview($0) }
        
        selectStartDateLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(20) // 좌측 여백
            make.height.equalTo(48) // 고정 높이
        }

        datePicker.snp.makeConstraints { make in
            make.top.equalTo(selectStartDateLabel.snp.bottom).offset(8) // 위 레이블과의 간격
            make.leading.equalToSuperview().offset(30) // 좌측 여백
            make.trailing.equalToSuperview().offset(-30) // 우측 여백
            make.height.equalTo(datePicker.snp.width) // 정사각형
        }

        selectDateCountLabel.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(16) // 데이트 피커와의 간격
            make.leading.equalTo(selectStartDateLabel.snp.leading) // 레이블 정렬
            make.height.equalTo(48) // 고정 높이
        }
        
        customStepper.snp.makeConstraints { make in
            make.top.equalTo(selectDateCountLabel.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
        }
        
        completeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc private func didTapCompleteButton() {
        
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ko_KR")
//        selectedDateLabel.text = "선택된 날짜: \(formatter.string(from: sender.date))"
    }
    

}
