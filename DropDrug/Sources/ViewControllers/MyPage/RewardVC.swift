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
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        
        let dateLabel = UILabel()
        dateLabel.text = "일시"
        dateLabel.font = UIFont.ptdRegularFont(ofSize: 16)
        dateLabel.textColor = Constants.Colors.gray500
        dateLabel.textAlignment = .left
        
        let detailLabel = UILabel()
        detailLabel.text = "내역"
        detailLabel.font = UIFont.ptdRegularFont(ofSize:16)
        detailLabel.textColor = Constants.Colors.gray500
        detailLabel.textAlignment = .center
        
        let rewardLabel = UILabel()
        rewardLabel.text = "리워드"
        rewardLabel.font = UIFont.ptdRegularFont(ofSize: 16)
        rewardLabel.textColor = Constants.Colors.gray500
        rewardLabel.textAlignment = .right
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel, detailLabel, rewardLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        let separatorView = UIView()
        separatorView.backgroundColor = Constants.Colors.gray100
        
        view.addSubview(stackView)
        view.addSubview(separatorView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        return view
    }()
    
    let rewardTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PointHistoryCell.self, forCellReuseIdentifier: PointHistoryCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var rewardData: [PointDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        setupViews()
        setConstraints()
        
        // 데이터 로드
        rewardTableView.delegate = self
        rewardTableView.dataSource = self
        rewardTableView.reloadData()
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        [rewardView, headerView, rewardTableView].forEach {
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(60)
        }
        headerView.snp.makeConstraints { make in
            make.top.equalTo(rewardView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        rewardTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.popViewController(animated: false)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension RewardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PointHistoryCell.identifier, for: indexPath) as? PointHistoryCell else {
            return UITableViewCell()
        }
        let reverseIndex = rewardData.count - 1 - indexPath.row
        let item = rewardData[reverseIndex]
        cell.configure(with: item)
        cell.selectionStyle = .none
        return cell
    }
}
