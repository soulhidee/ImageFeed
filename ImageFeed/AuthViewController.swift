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
    }
    private func setupConstraints() {
        
    }
    
    private func configureView() {
        view.backgroundColor = UIColor(named: "YPBlack") ?? .black
    }
}
