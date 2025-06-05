import UIKit

class AuthViewController: UIViewController {
    
    
    
    
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
