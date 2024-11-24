// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya

class PrescriptionDrugVC: UIViewController {
    
    let DrugProvider = MoyaProvider<DrugAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])

    var drugs: [PrescriptionDrug] = []
    
    // MARK: - UI Elements
    private lazy var logoLabelView: UILabel = {
        let label = UILabel()
        label.text = "DropDrug"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.roRegularFont(ofSize: 26)
        label.textColor = Constants.Colors.skyblue
        return label
    }()
    
    private var addDrugView = AddDrugView()
    
    public lazy var registeredDrugLabel: UILabel = {
        let label = UILabel()
        label.text = "등록된 의약품"
        label.textColor = Constants.Colors.gray900
        label.textAlignment = .left
        label.font = UIFont.ptdSemiBoldFont(ofSize: 17)
        return label
    }()
    
    private lazy var discardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash.fill")?.withTintColor(Constants.Colors.gray500 ?? .systemGray , renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(discardButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var drugsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PrescriptionDrugCell.self, forCellReuseIdentifier: PrescriptionDrugCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if navigationController == nil {
            let navigationController = UINavigationController(rootViewController: self)
            navigationController.modalPresentationStyle = .fullScreen
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.rootViewController?.present(navigationController, animated: true)
            }
        }
        
        self.navigationController?.isNavigationBarHidden = true
        self.getDrugsList { isSuccess in
            if isSuccess {
                self.drugsTableView.reloadData()
            } else {
            }
        }
        setupView()
        setConstraints()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Setup Methods
    
    func setupView() {
        [logoLabelView, addDrugView, registeredDrugLabel, discardButton, drugsTableView].forEach {
            view.addSubview($0)
        }
    }
    
    func setConstraints() {
        logoLabelView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        addDrugView.snp.makeConstraints { make in
            make.top.equalTo(logoLabelView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(superViewHeight * 0.25)
        }
        registeredDrugLabel.snp.makeConstraints { make in
            make.top.equalTo(addDrugView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        discardButton.snp.makeConstraints { make in
            make.centerY.equalTo(registeredDrugLabel)
            make.width.height.equalTo(50)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        drugsTableView.snp.makeConstraints { make in
            make.top.equalTo(registeredDrugLabel.snp.bottom).offset(20)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func setupGestures() {
        let addDrugTapGesture = UITapGestureRecognizer(target: self, action: #selector(addDrugViewTapped))
        addDrugView.addGestureRecognizer(addDrugTapGesture)
        addDrugView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    
    @objc func addDrugViewTapped() {
        self.navigationController?.isNavigationBarHidden = false
        let detailVC = EnrollDetailViewController()
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: false)
    }
    
    @objc func discardButtonTapped(){
        self.navigationController?.isNavigationBarHidden = false
        let DiscardPrescriptionDrugVC = DiscardPrescriptionDrugVC()
        DiscardPrescriptionDrugVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(DiscardPrescriptionDrugVC, animated: false)
    }
}



// MARK: - UITableViewDataSource & UITableViewDelegate

extension PrescriptionDrugVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrescriptionDrugCell.identifier, for: indexPath) as? PrescriptionDrugCell else {
            return UITableViewCell()
        }
        let drug = drugs[indexPath.row]
        cell.configure(date: drug.date, duration: drug.duration)
        cell.selectionStyle = .none
        return cell
    }
}

struct PrescriptionDrug {
    let date: String
    let duration: String
}
