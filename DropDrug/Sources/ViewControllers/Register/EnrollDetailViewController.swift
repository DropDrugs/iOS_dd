// Copyright © 2024 RT4. All rights reserved

import UIKit

class EnrollDetailViewController: UIViewController {
    
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  의약품 삭제하기")
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func setupLayout() {
        let views = [selectStartDateLabel, selectDateCountLabel, datePicker]
        views.forEach { view.addSubview($0) }
        
        selectStartDateLabel.snp.makeConstraints { l in
            l.top.equalToSuperview().offset(12)
            l.leading.equalToSuperview().offset(20)
            l.height.equalTo(48)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(selectStartDateLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(datePicker.snp.width)
        }
        
        selectDateCountLabel.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(16)
            make.leading.equalTo(selectStartDateLabel.snp.leading)
            make.height.equalTo(48)
        }
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ko_KR")
//        selectedDateLabel.text = "선택된 날짜: \(formatter.string(from: sender.date))"
    }

}
