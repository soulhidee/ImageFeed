import UIKit

final class ShimmerView: UIView {
    private let gradientLayer = CAGradientLayer()
    private var animationLayers: Set<CALayer> = Set()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.masksToBounds = true
    }
    
    private func setupGradient() {
        gradientLayer.frame = bounds
        gradientLayer.locations = [0, 0.1, 0.3]
        gradientLayer.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = bounds.height / 2
        layer.addSublayer(gradientLayer)
        animationLayers.insert(gradientLayer)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    func startAnimating() {
        print("Starting shimmer animation for \(self)")
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradientLayer.add(gradientChangeAnimation, forKey: "locationsChange")
    }
    
    func stopAnimating() {
        print("Stopping shimmer animation for \(self)")
        animationLayers.forEach { $0.removeAllAnimations() }
        animationLayers.removeAll()
    }
    
    func setCornerRadius(_ radius: CGFloat) {
            layer.cornerRadius = radius
        }
}
