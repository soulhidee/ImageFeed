import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Constants
    private enum SplashConstants {
        static let logoWidth: CGFloat = 75
        static let logoHeight: CGFloat = 78
    }
    
    // MARK: - Private Properties
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
        checkAuthorization()
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
        view.backgroundColor = UIColor.ypBlack
    }
    
    private func configureLogoImageView() {
        logoImageView.image = UIImage.launchScreenLogo
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
    }
    
    // MARK: - Authorization
    private func checkAuthorization() {
        if let _ = storage.token {
            switchToTabBarController()
        } else {
            showAuthController()
        }
    }
    
    // MARK: - Navigation
    private func showAuthController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            return
        }
        
        guard let window = windowScene.windows.first else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true) { [weak self] in
            self?.switchToTabBarController()
        }
    }
}

