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
        setupLogoutButton()
        setupNameLabel()
        setupHandleLabel()
        setupStatusLabel()
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
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
    
    
    private func setupStatusLabel() { }
}
