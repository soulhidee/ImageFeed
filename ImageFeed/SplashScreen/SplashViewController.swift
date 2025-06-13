import UIKit

final class SplashViewController: UIViewController {
    private let logoImageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
    }
    
    private func setupViews() {
        configureView()
        configureLogoImageView()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 75),
            logoImageView.heightAnchor.constraint(equalToConstant: 78),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureView() {
        view.backgroundColor = UIColor(named: "YPBlack") ?? .black
    }
    
    private func configureLogoImageView() {
        logoImageView.image = UIImage(named: "LaunchScreenLogo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
    }
}
