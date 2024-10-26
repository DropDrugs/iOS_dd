// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

let superViewHeight = UIScreen.main.bounds.height
let superViewWidth = UIScreen.main.bounds.width

class OnboardingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let pages: [OnboardingPage] = [
        OnboardingPage(title: "마약성분 의약품이 악용돼요", description: "마약성분을 포함한 의약품이 무분별하게 폐기될 경우, 마약류 약물이 유통되거나 악용될 수 있어요.", imageName: "placeholder1"),
        OnboardingPage(title: "다제내성균이 확산돼요", description: "다제내성균은 여러 종류의 항생제에 내성이 있는 세균을 말해요. 치료할 수 있는 항생제가 적어 감염질환 치료가 어려운데, 잘못된 의약품 폐기로 다제내성균 출현이 유도될 수 있어요.", imageName: "placeholder2"),
        OnboardingPage(title: "수질 오염이 심각해요", description: "의약품을 제대로 폐기하지 않고 땅에 매립하거나 하수구에 버리게 되면 항생물질 등의 약품 성분이 토양과 지하수, 하천에 유입되면서 수질을 오염시켜요.", imageName: "placeholder3"),
        OnboardingPage(title: "수질 오염이 심각해요", description: "의약품을 제대로 폐기하지 않고 땅에 매립하거나 하수구에 버리게 되면 항생물질 등의 약품 성분이 토양과 지하수, 하천에 유입되면서 수질을 오염시켜요.", imageName: "placeholder3")
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
        
        titleLabel.textColor = UIColor(named: "pink")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        textOverlayView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(textOverlayView.snp.top).offset(superViewHeight * 0.05)
            make.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        textOverlayView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(superViewHeight * 0.05)
            make.leading.trailing.equalToSuperview().inset(superViewWidth * 0.1)
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}
