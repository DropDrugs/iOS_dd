// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

let superViewHeight = UIScreen.main.bounds.height
let superViewWidth = UIScreen.main.bounds.width

class OnboardingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let pages: [OnboardingPage] = [
        OnboardingPage(title: "사용기한이 지난 약,\n어디에 버리시나요?", description: "2018년 건강보험심사평가원 조사에 따르면, 응답자의 절반 이상이 폐의약품을 쓰레기통, 하수구, 변기 등에 버리고 있으며, 약국, 보건소, 주민센터의 수거함에 배출한다는 응답은 8%에 불과했습니다. 폐의약품 처리 방법을 모른다는 응답자는 무려 74.1%에 달했습니다.", imageName: "OB1"),
        OnboardingPage(title: "쓰레기통이나 변기에\n버리면 왜 안 되나요?", description: "국립환경과학원의 조사에 따르면, 우리나라 하천에서는 소염진통제, 항생제 성분이 검출되고 있으며, 이로 인해 기형 물고기와 항생제 내성을 가진 슈퍼 박테리아가 발견됐습니다. 무심코 버린 폐의약품이 수질과 생태계를 오염시키고 있는 것입니다.", imageName: "OB2"),
        OnboardingPage(title: "폐의약품은 이렇게 버리세요", description: "알약: 약만 따로 모아 배출합니다.\n가루약: 포장지 그대로 배출합니다.\n물약 및 시럽: 밀봉한 용기에 모아 배출합니다.\n연고, 안약, 흡입제 등: 특수 용기는 그대로 배출합니다.", imageName: "OB3"),
        OnboardingPage(title: "어디에 버려야 하나요?", description: "폐의약품은 보건소나 주민센터의 수거함에 직접 배출할 수 있으며, 2024년부터는 우체통을 통해서도 손쉽게 배출할 수 있습니다. 가까운 배출 장소는 드롭드락 앱에서 확인해 보세요!", imageName: "OB4")
    ]
    
    private var collectionView: UICollectionView!
    private var pageControl = UIPageControl()
    
    private let skipBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPageControl()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = view.bounds.size
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "OnboardingCell")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-superViewHeight * 0.02)
                make.centerX.equalToSuperview()
            }
        
        skipBtn.setTitle("skip", for: .normal)
        skipBtn.setTitleColor(.lightGray, for: .normal)
        skipBtn.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        view.addSubview(skipBtn)
        skipBtn.snp.makeConstraints { make in
                make.centerY.equalTo(pageControl.snp.centerY)
                make.leading.equalToSuperview().offset(superViewWidth * 0.05)
            }
    }
    
    @objc func pageControlTapped(_ sender: UIPageControl) {
        let page = sender.currentPage
        let indexPath = IndexPath(item: page, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func skipTapped() {
        let OnboardingVC2 = OnboardingVC2()
        OnboardingVC2.modalPresentationStyle = .fullScreen
        present(OnboardingVC2, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as? OnboardingCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: pages[indexPath.item])
        return cell
    }
    
    // MARK: - UIScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = pageIndex
    }
}

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let textOverlayView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with page: OnboardingPage) {
        titleLabel.text = page.title
        descriptionLabel.text = page.description
        imageView.image = UIImage(named: page.imageName)
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .black
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        textOverlayView.layer.cornerRadius = 10
        contentView.addSubview(textOverlayView)
        textOverlayView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        titleLabel.textColor = Constants.Colors.pink ?? UIColor.systemPink
        titleLabel.font = UIFont.ptdSemiBoldFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        textOverlayView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(textOverlayView.snp.top).offset(superViewHeight * 0.04)
            make.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.ptdRegularFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        textOverlayView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(superViewHeight * 0.04)
            make.leading.trailing.equalToSuperview().inset(superViewWidth * 0.1)
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}
