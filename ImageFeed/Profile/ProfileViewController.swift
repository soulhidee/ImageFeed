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
        setupConstraints()
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
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            handleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            handleLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: handleLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor)
        ])
    }
    
    // MARK: - UI Configuration
    private func setupProfileImageView() {
        profileImage.image = UIImage(named: "mockProfileImage")
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 35
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
        nameLabel.text = MockData.name
        nameLabel.textColor = UIColor(named: "YPWhite")
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.numberOfLines = .zero
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
    }
    
    private func setupHandleLabel() {
        handleLabel.text = MockData.handle
        handleLabel.textColor = UIColor(named: "YPGray")
        handleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        nameLabel.numberOfLines = .zero
        handleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(handleLabel)
    }
    
    private func setupStatusLabel() {
        statusLabel.text = MockData.status
        statusLabel.textColor = UIColor(named: "YPWhite")
        statusLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        nameLabel.numberOfLines = .zero
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
    }
    
    // MARK: - Actions
    @objc private func logoutButtonTapped() {
        //logout logic
    }
    
    // MARK: - Mock
    private enum MockData {
        static let name = "Екатерина Новикова"
        static let handle = "@ekaterina_nov"
        static let status = "Hello, world"
    }
}
