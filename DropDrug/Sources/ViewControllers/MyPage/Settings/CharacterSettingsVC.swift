// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import Moya

class CharacterSettingsVC: UIViewController {
    //TODO: 캐릭터 불러오기 api 연결
    let MemberProvider = MoyaProvider<MemberAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    
    var ownedCharCount : Int = 0
    
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  캐릭터 설정")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    public lazy var scrollView: UIScrollView = {
        let s = UIScrollView()
        s.showsVerticalScrollIndicator = false
        s.showsHorizontalScrollIndicator = false
        return s
    }()
    
    public lazy var contentView: UIView = {
        let v = UIView()
        return v
    }()
    private let ownedCharLabel = SubLabelView()
    private let allCharLabel = SubLabelView()
    
    private lazy var ownedCharCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let itemsPerRow: CGFloat = 4
        let totalSpacing = (screenWidth / (itemsPerRow * 2 - 1)) * 0.6
        let itemWidth = (screenWidth - totalSpacing * 3) / 4
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = totalSpacing * 0.5
        layout.minimumLineSpacing = totalSpacing * 0.3
        layout.sectionInset = UIEdgeInsets(top: 0, left: totalSpacing * 0.3, bottom: 0, right: totalSpacing * 0.5)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        
        fetchMemberInfo { success in
            if success {
                self.ownedCharCollectionView.reloadData()
            } else {
                print("Failed to update profile")
            }
        }
    }
    
    func setupUI() {
        ownedCharLabel.text = "보유 캐릭터"
        allCharLabel.text = "전체 캐릭터"
        [scrollView].forEach {
            view.addSubview($0)
        }
        scrollView.addSubview(contentView)
        [ownedCharLabel, ownedCharCollectionView, emptyStateLabel, allCharLabel, allCharCollectionView].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView) // 스크롤뷰의 모든 가장자리에 맞춰 배치
            make.width.equalTo(scrollView) // 가로 스크롤을 방지, 스크롤뷰와 같은 너비로 설정
        }
        
        ownedCharLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        ownedCharCollectionView.snp.makeConstraints { make in
            make.top.equalTo(ownedCharLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(80)
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
            make.top.equalTo(allCharLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(850)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: false)
    }
}


extension CharacterSettingsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            //TODO: 캐릭터 변경
            print("캐릭터 변경")
        }
        else if collectionView.tag == 1 {
            //TODO: 캐릭터 구매
            print("캐릭터 구매")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            emptyStateLabel.isHidden = ownedCharCount > 0
            return ownedCharCount
        } else if collectionView.tag == 1 {
            return Constants.AllCharacter.allCharCount
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeoulCollectionViewCell", for: indexPath) as? SeoulCollectionViewCell else {
            return UICollectionViewCell()
        }

        if collectionView == ownedCharCollectionView {
            cell.configure(showNameLabel: false)
        } else if collectionView == allCharCollectionView {
            cell.configure(showNameLabel: false)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            return CGSize(width: 100, height: 100) // 아이템 크기 설정
        }
        else if collectionView.tag == 1 {
            let screenWidth = UIScreen.main.bounds.width
            let itemsPerRow: CGFloat = 4
            let totalSpacing = (screenWidth / (itemsPerRow * 2 - 1))*0.6
            let itemWidth = (screenWidth - totalSpacing * 3)/4
            return CGSize(width: itemWidth, height: itemWidth * 1.25) // 원하는 높이 비율로 설정
        }
        return CGSize()
    }
    
}
