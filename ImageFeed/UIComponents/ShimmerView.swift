import UIKit

final class ShimmerView: UIView {
    private let gradientLayer = CAGradientLayer()

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
    }

    private func setupGradient() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 0.5).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 0.5).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 0.5).cgColor
        ]
        gradientLayer.locations = [0, 0.1, 0.3]
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.masksToBounds = true

        layer.addSublayer(gradientLayer)
    }

    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }

    func stopAnimating() {
        gradientLayer.removeAnimation(forKey: "shimmerAnimation")
    }
}
