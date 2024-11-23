// Copyright © 2024 RT4. All rights reserved

import UIKit

class PlaceDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = placeDetailView
    }
    
    public lazy var placeDetailView: PlaceDetailView = {
        let v = PlaceDetailView()
        return v
    }()
}
