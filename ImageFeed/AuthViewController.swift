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
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            authLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
}
