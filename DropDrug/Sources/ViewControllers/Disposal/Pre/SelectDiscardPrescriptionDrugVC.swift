// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya
import SwiftyToaster

class SelectDiscardPrescriptionDrugVC: UIViewController {
    let DrugProvider = MoyaProvider<DrugAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    public static var targetDrugId : Int?
    
    // MARK: - UI Elements
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  내 처방약 폐기하기")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PrescriptionDrugCell.self, forCellReuseIdentifier: PrescriptionDrugCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        return tableView
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("폐기하기", for: .normal)
        button.backgroundColor = Constants.Colors.skyblue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    var drugList : [DrugResponse] = []
    var selectedIndexPath: IndexPath?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        setupView()
        setConstraints()
        
        getDrugsList { isSuccess in
            if isSuccess {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Setup Methods
    func setupView() {
        [tableView, completeButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(completeButton.snp.top).offset(-16)
        }
        completeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc private func didTapCompleteButton() {
        if selectedIndexPath == nil || SelectDiscardPrescriptionDrugVC.targetDrugId == nil {
            showAlert(title: "오류", message: "삭제할 항목을 선택해주세요.")
            return
        } else {
            let SelectDrugTypeVC = SelectDrugTypeVC()
            navigationController?.pushViewController(SelectDrugTypeVC, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SelectDiscardPrescriptionDrugVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrescriptionDrugCell.identifier, for: indexPath) as? PrescriptionDrugCell else {
            return UITableViewCell()
        }
        
        let drug = drugList[indexPath.row]
        cell.configure(date: drug.date, duration: "\(drug.count)일치")

        // 선택 상태에 따라 체크마크 또는 빈 동그라미 설정
        if selectedIndexPath == indexPath {
            let checkmarkIcon = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
            checkmarkIcon.tintColor = Constants.Colors.skyblue
            cell.accessoryView = checkmarkIcon
        } else {
            let emptyCircleIcon = UIImageView(image: UIImage(systemName: "circle"))
            emptyCircleIcon.tintColor = .lightGray
            cell.accessoryView = emptyCircleIcon
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        SelectDiscardPrescriptionDrugVC.targetDrugId = self.drugList[indexPath.row].id
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedIndexPath = nil
        SelectDiscardPrescriptionDrugVC.targetDrugId = nil
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
