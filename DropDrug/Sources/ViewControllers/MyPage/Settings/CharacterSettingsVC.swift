// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya
import SwiftyToaster

class CharacterSettingsVC: UIViewController {
    let MemberProvider = MoyaProvider<MemberAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    
    var ownedChar : [Int] = [0]
    var selectedChar : Int = 0
    
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
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SeoulCollectionViewCell.self, forCellWithReuseIdentifier: "SeoulCollectionViewCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.tag = 0
        return collectionView
    }()
    
    private lazy var allCharCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SeoulCollectionViewCell.self, forCellWithReuseIdentifier: "SeoulCollectionViewCell")
        collectionView.tag = 1
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationController?.navigationBar.isTranslucent = false
        
        let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground() // 불투명한 배경 설정
            appearance.backgroundColor = .systemBackground       // 원하는 배경색 설정
            appearance.shadowImage = UIImage()         // 구분선 이미지 제거
            appearance.shadowColor = nil
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        setupUI()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateChars()
        updateCollectionViewHeight()
    }

    func setupUI() {
        ownedCharLabel.text = "보유 캐릭터"
        allCharLabel.text = "전체 캐릭터"
        [contentView].forEach {
            view.addSubview($0)
        }
        [ownedCharLabel, ownedCharCollectionView, allCharLabel, allCharCollectionView].forEach {
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
        allCharLabel.snp.makeConstraints { make in
            make.top.equalTo(ownedCharCollectionView.snp.bottom)
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
    
    private func updateChars() {
        fetchMemberInfo { success in
            if success {
                self.updateCollectionViewHeight()
                self.ownedCharCollectionView.reloadData()
            } else {
                
            }
        }
    }
    private func showPurchaseAlert(currentValue: Int) {
        let alert = UIAlertController(title: "해당 캐릭터를 구매하시겠습니까?", message: "\(Constants.CharacterList[currentValue].name)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "구매", style: .default, handler: {_ in
            print("선택된 전체 캐릭터의 인덱스는 \(currentValue)입니다.")
            self.purchaseCharacter(currentValue) { success in
                if success {
                    self.showCustomAlert(title: "구매 성공", message: "캐릭터를 성공적으로 구매했어요!")
                    self.updateChars()
                } else {
                    self.showCustomAlert(title: "구매 실패", message: "캐릭터 구매에 실패했어요. 다시 시도해 주세요.")
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
                    self.showCustomAlert(title: "변경 성공", message: "캐릭터가 성공적으로 변경되었어요.")
                    self.updateChars()
                } else {
                    self.showCustomAlert(title: "변경 실패", message: "캐릭터 변경에 실패했어요. 다시 시도해 주세요.")
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showCustomAlert(title: String, message: String) {
        let customAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        customAlert.addAction(confirmAction)
        customAlert.view.tintColor = Constants.Colors.skyblue
        present(customAlert, animated: true, completion: nil)
    }
    
    private func showOwnedCharacterAlert(characterID: Int) {
        guard let character = findCharacter(by: characterID) else { return }
        showCustomAlert(title: "구매 불가", message: "\(character.name)를 이미 보유하고 있어요.")
    }
    
    // MARK: - Compositional Layout 생성
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let padding: CGFloat = 8
        let cardSize: CGFloat = (UIScreen.main.bounds.width - padding * 5) / 4

        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(cardSize), heightDimension: .absolute(cardSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(cardSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item, item])
        group.interItemSpacing = .fixed(padding)

        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 0)

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func updateCollectionViewHeight() {
        contentView.layoutIfNeeded()
        let maxHeight = (contentView.frame.height / 2) - 20
        let itemHeight: CGFloat = (UIScreen.main.bounds.width - (8 * 5)) / 4
        let rows = (ownedChar.count + 3) / 4
        let sectionHeight = CGFloat(rows) * (itemHeight + 8)
        let calculatedHeight = min(sectionHeight, maxHeight)

        ownedCharCollectionView.snp.updateConstraints { make in
            make.height.equalTo(calculatedHeight)
        }
    }
}


extension CharacterSettingsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            self.showUpdateAlert(currentValue: ownedChar[indexPath.row])
        } else if collectionView.tag == 1 {
            let selectedCharacterID = Constants.CharacterList[indexPath.row].id
            if ownedChar.contains(selectedCharacterID) {
                self.showOwnedCharacterAlert(characterID: selectedCharacterID)
            } else {
                self.showPurchaseAlert(currentValue: selectedCharacterID)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
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

        if collectionView.tag == 0 { // 보유 캐릭터 목록
            let characterID = ownedChar[indexPath.row]
            if let character = findCharacter(by: characterID) {
                cell.image.image = UIImage(named: character.image)
                let isSelected = characterID == selectedChar
                cell.configure(showNameLabel: false, showBorder: isSelected, borderColor: isSelected ? Constants.Colors.red : nil)
            }
        } else if collectionView.tag == 1 { // 전체 캐릭터 목록
            cell.image.image = UIImage(named: Constants.CharacterList[indexPath.row].image)
            cell.configure(showNameLabel: false, showBorder: false, borderColor: nil)
        }

        return cell
    }
    
    private func findCharacter(by id: Int) -> CharacterModel? {
        return Constants.CharacterList.first { $0.id == id }
    }
}
