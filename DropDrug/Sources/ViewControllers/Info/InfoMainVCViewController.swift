// Copyright © 2024 RT4. All rights reserved

import UIKit
import PinLayout

class InfoMainVCViewController: UIViewController {
    
    private let logoLabelView = LogoLabelView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(logoLabelView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logoLabelView.pin
            .top(view.pin.safeArea.top)
            .horizontally(0)
            .sizeToFit()
    }
}
