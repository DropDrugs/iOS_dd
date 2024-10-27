// Copyright © 2024 RT4. All rights reserved

import UIKit

class HomeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addComponenets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var iconBackground: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "Lightblue")
        return v
    }()
    
    public lazy var appTitle: UILabel = {
        let l = UILabel()
        l.text = "DropDrug"
        l.font = UIFont.ro
        return l
    }()
    
    private func addComponenets() {
    }

}
