import UIKit

class AuthViewController: UIViewController {
    
    private let authLogoImageView = UIImageView()
    private let signInButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    private func setupViews() {
        configureView()
        configureAuthLogoImageView()
        configureSignInButton()
    }
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
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInButton)
    }
}
