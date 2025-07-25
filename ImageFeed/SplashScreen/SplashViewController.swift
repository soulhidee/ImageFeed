import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Constants
    private enum SplashConstants {
        static let logoWidth: CGFloat = 75
        static let logoHeight: CGFloat = 78
    }
    
    // MARK: - Private Properties
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    // MARK: - UI Elements
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.launchScreenLogo
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
        view.addSubview(logoImageView)
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
    
    // MARK: - Authorization
    private func checkAuthorization() {
        guard let token = storage.token else {
            showAuthController()
            return
        }
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                guard let self else { return }
                
                switch result {
                case .success(let profile):
                    self.switchToTabBarController()
                    ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                case .failure:
                    self.showAuthController()
                }
            }
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
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        let tabBarController = TabBarController()
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

