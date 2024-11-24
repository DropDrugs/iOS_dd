// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class SelectDrugTypeVC : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public var userPickedImageURL : URL?
    
    private var collectionView: UICollectionView!
    // TODO : 이미지 에셋 추가
    let categories = [
        ("알약", "OB1"),
        ("물약", "OB1"),
        ("처방약", "OB1"),
        ("가루약", "OB1"),
        ("연고", "OB1"),
        ("기타", "OB1")
    ]
    
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  종류 선택")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(KindCollectionViewCell.self, forCellWithReuseIdentifier: "KindCell")
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Compositional Layout 생성
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        // 패딩과 카드 크기 설정
        let padding: CGFloat = superViewWidth * 0.05
        let cardSize: CGFloat = superViewWidth * 0.425

        // 아이템 크기 설정 (카드의 절대 너비와 높이로 설정)
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(cardSize), heightDimension: .absolute(cardSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 그룹에 포함된 아이템 간격을 padding으로 설정
        item.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: 0, bottom: 0, trailing: 0)

        // 그룹 설정 (한 줄에 두 개의 아이템)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(cardSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = .fixed(padding) // 그룹 내 간격을 일정하게 설정

        // 섹션 설정
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: 0)
        
        // 레이아웃 생성 및 반환
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KindCell", for: indexPath) as? KindCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let (name, backgroundImg) = categories[indexPath.item]
        cell.configure(backgroundImg: backgroundImg, name: name)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Alert 창 띄우기
        let alert = UIAlertController(title: "실천 사진 인증", message: "실시간 사진 인증을 하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel) { [weak self] _ in
            self?.moveToMainScreen()
        })
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.presentCamera()
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    private func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("카메라를 사용할 수 없습니다.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            // PNG 데이터로 변환
            if let pngData = image.pngData() {
                // 비동기로 파일 저장
                saveToDocuments(data: pngData) { [weak self] savedImageURL in
                    guard let self = self, let url = savedImageURL else {
                        print("이미지 저장 실패")
                        return
                    }
                    print("PNG 파일 저장 완료: \(url)")
                    
                    // 저장 완료 후 새로운 뷰 컨트롤러 띄우기
                    self.showNewViewController(with: url)
                }
            } else {
                print("PNG로 변환 실패")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func saveToDocuments(data: Data, completion: @escaping (URL?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { // 백그라운드 스레드에서 실행
            let fileManager = FileManager.default
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            guard let documentsURL = urls.first else {
                DispatchQueue.main.async {
                    completion(nil) // 실패 시 nil 반환
                }
                return
            }
            
            let fileURL = documentsURL.appendingPathComponent("captured_image.png")
            do {
                try data.write(to: fileURL)
                print("파일이 저장되었습니다: \(fileURL)")
                DispatchQueue.main.async {
                    completion(fileURL) // 성공 시 URL 반환
                }
            } catch {
                print("파일 저장 실패: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil) // 실패 시 nil 반환
                }
            }
        }
    }
    
    private func showNewViewController(with imageURL: URL) {
        let loadingVC = ImageDisplayVC()
        loadingVC.imageURL = imageURL
        loadingVC.modalPresentationStyle = .fullScreen
        present(loadingVC, animated: true)
    }
    
    // MARK: Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func moveToMainScreen() {
        navigationController?.popViewController(animated: true)
    }
    
}
