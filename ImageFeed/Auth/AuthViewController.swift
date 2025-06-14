import UIKit

final class AuthViewController: UIViewController {
    // MARK: - Constants
    private enum AuthConstants {
        static let buttonHeight: CGFloat = 48
        static let buttonCornerRadius: CGFloat = 16
        static let logoBottomSpacing: CGFloat = 204
        static let horizontalPadding: CGFloat = 16
        static let buttonFontSize: CGFloat = 17
    }
    
    // MARK: - UI Elements
    private let authLogoImageView = UIImageView()
    private let signInButton = UIButton()
    
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
        configureAuthLogoImageView()
        configureSignInButton()
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
    
    private func configureAuthLogoImageView() {
        authLogoImageView.image = UIImage.authScreenLogo
        authLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authLogoImageView)
    }
    
    private func configureSignInButton() {
        signInButton.setTitle("Войти", for: .normal)
        signInButton.backgroundColor = UIColor.ypWhite
        signInButton.layer.cornerRadius = AuthConstants.buttonCornerRadius
        signInButton.setTitleColor(UIColor.ypBlack, for: .normal)
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: AuthConstants.buttonFontSize, weight: .bold)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInButton)
    }
    
    @objc private func signInButtonTapped() {
        let webVC = WebViewViewController()
        webVC.delegate = self
        navigationController?.pushViewController(webVC, animated: true)
    }
    
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    print("✅ Успешная авторизация. Токен: \(token)")
                    self.delegate?.didAuthenticate(self)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
                    tabBarController.modalPresentationStyle = .fullScreen
                    self.present(tabBarController, animated: true)
                case .failure(let error):
                    print("❌ Ошибка авторизации: \(error)")
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        navigationController?.popViewController(animated: true)
    }
    
}
