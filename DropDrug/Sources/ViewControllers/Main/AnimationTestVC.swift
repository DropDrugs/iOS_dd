// Copyright © 2024 RT4. All rights reserved

import UIKit
import Lottie
 
class AnimationTestVC: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.white
        
        let animationView: LottieAnimationView = .init(name: "TestAni")
        animationView.backgroundColor = .clear
        self.view.addSubview(animationView)
        
        animationView.frame = self.view.bounds
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        animationView.loopMode = .repeat(5)
        animationView.animationSpeed = 0.5
    }
}
