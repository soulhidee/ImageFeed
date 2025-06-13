import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Constants
    private enum SplashConstants {
        static let logoWidth: CGFloat = 75
        static let logoHeight: CGFloat = 78
    }
    
    private let storage = OAuth2TokenStorage()
    
    // MARK: - UI Elements
    private let logoImageView = UIImageView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        configureView()
        configureLogoImageView()
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: SplashConstants.logoWidth),
            logoImageView.heightAnchor.constraint(equalToConstant: SplashConstants.logoHeight),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - UI Configuration
    private func configureView() {
        view.backgroundColor = UIColor(named: "YPBlack") ?? .black
    }
    
    private func configureLogoImageView() {
        logoImageView.image = UIImage(named: "LaunchScreenLogo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
    }
    
    private func checkAuthorization() {
        if let _ = storage.token {
            //switchToTabBarController()
        } else {
            //showAuthController()
        }
    }
    
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        }
    }
}
