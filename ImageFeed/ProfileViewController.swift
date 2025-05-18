import UIKit

final class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "YPBlack")
        setupProfileImageView()
        setupExitButton()
        setupNameLabel()
        setupHandleLabel()
        setupStatusLabel()
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
    }
    
    private func setupProfileImageView() {
        
    }
    

    private func setupExitButton() { }
    
    private func setupNameLabel() { }
    
    private func setupHandleLabel() { }
    
    private func setupStatusLabel() { }
}
