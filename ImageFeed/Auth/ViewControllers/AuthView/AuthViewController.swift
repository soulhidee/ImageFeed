import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    // MARK: - Constants
    private enum AuthConstants {
        static let buttonHeight: CGFloat = 48
        static let buttonCornerRadius: CGFloat = 16
        static let logoBottomSpacing: CGFloat = 204
        static let horizontalPadding: CGFloat = 16
        static let buttonFontSize: CGFloat = 17
        static let signInButtonTitle = "Войти"
        static let errorAlertTitle = "Что-то пошло не так("
        static let errorAlertMesseage = "Не удалось войти в систему"
        static let errorAlertAction = "Ок"
    }
    
    // MARK: - UI Elements
    private lazy var authLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.authScreenLogo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AuthConstants.signInButtonTitle, for: .normal)
        button.backgroundColor = UIColor.ypWhite
        button.layer.cornerRadius = AuthConstants.buttonCornerRadius
        button.setTitleColor(UIColor.ypBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: AuthConstants.buttonFontSize, weight: .bold)
        button.accessibilityIdentifier = "Authenticate"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Delegate
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Services
    private let oauth2Service = OAuth2Service.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        configureView()
        view.addSubview(authLogoImageView)
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            authLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            signInButton.heightAnchor.constraint(equalToConstant: AuthConstants.buttonHeight),
            signInButton.topAnchor.constraint(equalTo: authLogoImageView.bottomAnchor, constant: AuthConstants.logoBottomSpacing),
            signInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: AuthConstants.horizontalPadding),
            signInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -AuthConstants.horizontalPadding)
        ])
    }
    
    // MARK: - UI Configuration
    private func configureView() {
        view.backgroundColor = UIColor.ypBlack
    }
    
    // MARK: - Alerts
    private func showAuthErrorAlert() {
        let alert = UIAlertController(
            title: AuthConstants.errorAlertTitle,
            message: AuthConstants.errorAlertMesseage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: AuthConstants.errorAlertAction, style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func signInButtonTapped() {
        let webVC = WebViewViewController()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        
        webVC.presenter = presenter
        presenter.view = webVC
        
        webVC.delegate = self
        navigationController?.pushViewController(webVC, animated: true)
    }
    
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            UIBlockingProgressHUD.dismiss()
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    print("✅ Успешная авторизация. Токен: \(token)")
                    self.delegate?.didAuthenticate(self)
                    
                    let tabBarController = TabBarController()
                    tabBarController.modalPresentationStyle = .fullScreen
                    self.present(tabBarController, animated: true)
                case .failure(let error):
                    print("❌ Ошибка авторизации: \(error)")
                    self.showAuthErrorAlert()
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        navigationController?.popViewController(animated: true)
    }
}
