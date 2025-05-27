import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - UI Elements
    private let logoutButton = UIButton()
    private let profileImage = UIImageView()
    private let nameLabel = UILabel()
    private let handleLabel = UILabel()
    private let statusLabel = UILabel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = UIColor(named: "YPBlack")
        setupProfileImageView()
        setupLogoutButton()
        setupNameLabel()
        setupHandleLabel()
        setupStatusLabel()
    }

    // MARK: - Setup UI Elements
    private func setupProfileImageView() {
        profileImage.image = UIImage(named: "mockProfileImage")
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.masksToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
    }
    
    private func setupLogoutButton() {
        logoutButton.setTitle("", for: .normal)
        logoutButton.setImage(UIImage(named: "Exit"), for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
    }
    
    private func setupNameLabel() {
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YPWhite")
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
    }
    
    private func setupHandleLabel() {
        handleLabel.text = "@ekaterina_nov"
        handleLabel.textColor = UIColor(named: "YPGray")
        handleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        handleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(handleLabel)
    }
    
    private func setupStatusLabel() {
        statusLabel.text = "Hello, world"
        statusLabel.textColor = UIColor(named: "YPWhite")
        statusLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
    }
    
    

    // MARK: - Actions
    @objc private func logoutButtonTapped() {
        //logout logic
    }
}
