// Copyright © 2024 RT4. All rights reserved

import UIKit

class CircularProgressBar: UIView {
    let startAngle: CGFloat = -.pi / 2  // 12시 방향
    let endAngle: CGFloat = .pi * 3 / 2
    
    private var bgPathSubLevel: UIBezierPath!
    private var subLevelShapeLayer: CAShapeLayer!
    private var subLevelProgressLayer: CAShapeLayer!
    private var progressText: UILabel?
    
    @IBInspectable var showProgressText: Bool = false
    
    // 진행률
    public var innerProgress: CGFloat = 0 {
        didSet {
            updateProgress(to: innerProgress)
        }
    }
    
    // 진행률 색상
    @IBInspectable var innerProgressColor: UIColor = Constants.Colors.skyblue! {
        didSet {
            subLevelProgressLayer.strokeColor = innerProgressColor.cgColor
        }
    }
    
    @IBInspectable var innerThickness: CGFloat = 15.0 {
        didSet {
            subLevelShapeLayer.lineWidth = innerThickness
            subLevelProgressLayer.lineWidth = innerThickness
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        createPaths()
    }
    
    private func setupLayers() {
        createPaths()
        addLayers()
    }
    
    private func createPaths() {
        let x : CGFloat = (superViewWidth * 0.8) / 2
        let y : CGFloat = (superViewWidth * 0.8) / 2
        let center = CGPoint(x: x, y: y)
        
        bgPathSubLevel = UIBezierPath(arcCenter: center, radius: x - 25, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        if showProgressText {
            let labelSize = (x - 50)
            if progressText == nil {
                progressText = UILabel(frame: CGRect(x: 0, y: 0, width: labelSize, height: labelSize))
                progressText?.textAlignment = .center
                progressText?.textColor = Constants.Colors.skyblue!
                progressText?.backgroundColor = .systemBackground
                addSubview(progressText!)
            }
            progressText?.font = UIFont.ptdBoldFont(ofSize: labelSize / 4)
            progressText?.text = "0%"
            progressText?.center = center
        }
    }
    
    private func addLayers() {
        subLevelShapeLayer = createShapeLayer(path: bgPathSubLevel, lineWidth: innerThickness, strokeColor: Constants.Colors.gray200!.cgColor)
        subLevelProgressLayer = createShapeLayer(path: bgPathSubLevel, lineWidth: innerThickness, strokeColor: innerProgressColor.cgColor)
        subLevelProgressLayer.strokeEnd = innerProgress
        
        layer.addSublayer(subLevelShapeLayer)
        layer.addSublayer(subLevelProgressLayer)
    }
    
    private func createShapeLayer(path: UIBezierPath, lineWidth: CGFloat, strokeColor: CGColor) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineCap = .round
        return shapeLayer
    }
    
    public func updateProgress(to value: CGFloat) {
        let clampedValue = min(max(value, 0.0), 1.0) // 0.0 ~ 1.0로 값 제한
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = subLevelProgressLayer.strokeEnd
        animation.toValue = clampedValue
        animation.duration = 0.3
        subLevelProgressLayer.add(animation, forKey: "progress")
        subLevelProgressLayer.strokeEnd = clampedValue
        
        // Update progress text if enabled
        if showProgressText {
            let percentage = Int(clampedValue * 100)
            progressText?.text = "\(percentage)%"
        }
    }
}
