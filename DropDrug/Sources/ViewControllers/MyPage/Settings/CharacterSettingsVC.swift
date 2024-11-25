// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya

class CharacterSettingsVC: UIViewController {
    //TODO: 캐릭터 불러오기 api 연결
    let MemberProvider = MoyaProvider<MemberAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    
    var ownedChar : [Int] = []
    
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  캐릭터 설정")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    public lazy var contentView: UIView = {
        let v = UIView()
        return v
    }()
    
    private let ownedCharLabel = SubLabelView()
    private let allCharLabel = SubLabelView()
    
    private lazy var ownedCharCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(SeoulCollectionViewCell.self, forCellWithReuseIdentifier: "SeoulCollectionViewCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.tag = 0
        return collectionView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "보유한 캐릭터가 없습니다."
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var allCharCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(SeoulCollectionViewCell.self, forCellWithReuseIdentifier: "SeoulCollectionViewCell")
        collectionView.tag = 1
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationController?.navigationBar.isTranslucent = false
        
        let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground() // 불투명한 배경 설정
            appearance.backgroundColor = .white        // 원하는 배경색 설정
            appearance.shadowImage = UIImage()         // 구분선 이미지 제거
            appearance.shadowColor = nil
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        setupUI()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMemberInfo { success in
            if success {
                self.ownedCharCollectionView.reloadData()
                print(" \(self.ownedChar)")
            } else {
                print("Failed to update profile")
            }
        }
    }
    
    func setupUI() {
        ownedCharLabel.text = "보유 캐릭터"
        allCharLabel.text = "전체 캐릭터"
        [contentView].forEach {
            view.addSubview($0)
        }
        [ownedCharLabel, ownedCharCollectionView, emptyStateLabel, allCharLabel, allCharCollectionView].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(superViewWidth)
        }
        
        ownedCharLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        ownedCharCollectionView.snp.makeConstraints { make in
            make.top.equalTo(ownedCharLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(superViewHeight * 0.2)
        }
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalTo(ownedCharCollectionView)
        }
        allCharLabel.snp.makeConstraints { make in
            make.top.equalTo(ownedCharCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        allCharCollectionView.snp.makeConstraints { make in
            make.top.equalTo(allCharLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(superViewHeight * 0.5)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: false)
    }
    
    // MARK: - Compositional Layout 생성
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let padding: CGFloat = 8
        let cardSize: CGFloat = (UIScreen.main.bounds.width - padding * 5) / 4

        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(cardSize), heightDimension: .absolute(cardSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(cardSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item, item])
        group.interItemSpacing = .fixed(padding)

        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 0)

        return UICollectionViewCompositionalLayout(section: section)
    }
}


extension CharacterSettingsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            // 보유 캐릭터 변경
            print("보유 캐릭터 변경, 인덱스: \(indexPath.row)")
            self.showUpdateAlert(currentValue: indexPath.row)
        } else if collectionView.tag == 1 {
            // 전체 캐릭터 구매
            print("캐릭터 구매, 인덱스: \(indexPath.row)")
            self.showPurchaseAlert(currentValue: indexPath.row)
        }
    }
    
    private func showPurchaseAlert(currentValue: Int) {
        let alert = UIAlertController(title: "캐릭터를 구매하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "구매", style: .default, handler: {_ in
            print("선택된 전체 캐릭터의 인덱스는 \(currentValue)입니다.")
            self.purchaseCharacter(currentValue) { success in
                if success {
                    print("캐릭터 구매에 성공했습니다")
                    self.ownedCharCollectionView.reloadData()
                } else {
                    print("캐릭터 구매에 실패했습니다")
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func showUpdateAlert(currentValue: Int) {
        let alert = UIAlertController(title: "캐릭터를 변경하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "변경", style: .default, handler: {_ in
            print("선택된 보유 캐릭터의 인덱스는 \(currentValue)입니다.")
            self.updateCharacter(currentValue) { success in
                if success {
                    print("캐릭터 변경에 성공했습니다")
                    self.ownedCharCollectionView.reloadData()
                } else {
                    print("캐릭터 변경에 실패했습니다")
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            emptyStateLabel.isHidden = ownedChar.count > 0
            return ownedChar.count
        } else if collectionView.tag == 1 {
            return Constants.CharacterList.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeoulCollectionViewCell", for: indexPath) as? SeoulCollectionViewCell else {
            return UICollectionViewCell()
        }

        if collectionView.tag == 0 {
            let characterID = ownedChar[indexPath.row]
                if let character = findCharacter(by: characterID) {
                    cell.image.image = UIImage(named: character.image)
                    cell.configure(showNameLabel: false,showBorder: false)
                }
        } else if collectionView.tag == 1 {
            cell.image.image = UIImage(named: Constants.CharacterList[indexPath.row].image)
            cell.configure(showNameLabel: false,showBorder: false)
        }

        return cell
    }
    
    private func findCharacter(by id: Int) -> CharacterModel? {
        return Constants.CharacterList.first { $0.id == id }
    }
}
