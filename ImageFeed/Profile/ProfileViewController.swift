import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor(named: "YPBlack")
        setupProfileImageView()
        setupLogoutButton()
        setupNameLabel()
        setupHandleLabel()
        setupStatusLabel()
    }
    
    private func setupProfileImageView() {
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.masksToBounds = true
        profileImage.image = UIImage(named: "mockProfileImage")
    }
    
    private func setupLogoutButton() {
        logoutButton.setTitle("", for: .normal)
        logoutButton.setImage(UIImage(named: "Exit"), for: .normal)
    }
    
    private func setupNameLabel() {
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YPWhite")
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
    }
    
    private func setupHandleLabel() {
        handleLabel.text = "@ekaterina_nov"
        handleLabel.textColor = UIColor(named: "YPGray")
        handleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private func setupStatusLabel() {
        statusLabel.text = "Hello, world"
        statusLabel.textColor = UIColor(named: "YPWhite")
        statusLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    // MARK: - Actions
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
    }
    
}
