// Copyright © 2024 RT4. All rights reserved
import UIKit
import PinLayout

class TestVC: UIViewController {
    
    private let label1: UILabel = {
        let label = UILabel()
        label.text = "Label 1"
        label.textAlignment = .center
        label.font = UIFont.ptdBoldFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    
    private let label2: UILabel = {
        let label = UILabel()
        label.text = "DropDrug"
        label.font = UIFont.roRegularFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "Lightblue")
        
        // 라벨을 뷰에 추가
        view.addSubview(label1)
        view.addSubview(label2)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // label1을 화면 중앙에 배치
        label1.pin
            .center()
            .sizeToFit()  // 텍스트에 맞게 사이즈 조절
        
        // label2를 label1 아래에 배치하고 간격을 추가
        label2.pin
            .below(of: label1)
            .marginTop(16)   // 첫 번째 라벨과의 간격
            .hCenter()       // 수평 중앙 정렬
            .sizeToFit()     // 텍스트에 맞게 사이즈 조절
    }
}
