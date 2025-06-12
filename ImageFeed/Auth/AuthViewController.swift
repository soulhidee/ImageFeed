import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - UI Elements
    private let authLogoImageView = UIImageView()
    private let signInButton = UIButton()
    
    
    // MARK: - Services
    private let oauth2Service = OAuth2Service.shared

    
    // MARK: - Delegate
    weak var delegate: AuthViewControllerDelegate?
    
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
            
            signInButton.heightAnchor.constraint(equalToConstant: 48),
            signInButton.topAnchor.constraint(equalTo: authLogoImageView.bottomAnchor, constant: 204),
            signInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            signInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - UI Configuration
    private func configureView() {
        view.backgroundColor = UIColor(named: "YPBlack") ?? .black
    }
    
    private func configureAuthLogoImageView() {
        authLogoImageView.image = UIImage(named: "auth_screen_logo")
        authLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authLogoImageView)
    }
    
    private func configureSignInButton() {
        signInButton.setTitle("Войти", for: .normal)
        signInButton.backgroundColor = UIColor(named: "YPWhite") ?? .white
        signInButton.layer.cornerRadius = 16
        signInButton.setTitleColor(UIColor(named: "YPBlack"), for: .normal)
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
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
       
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        navigationController?.popViewController(animated: true)
    }
    
}
