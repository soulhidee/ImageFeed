import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Constants
    private enum ProfileConstants {
        static let profileImageSize: CGFloat = 70
        static let profileImageCornerRadius: CGFloat = profileImageSize / 2
        static let profileImageTopInset: CGFloat = 32
        static let profileImageLeadingInset: CGFloat = 16
        
        static let logoutButtonSize: CGFloat = 44
        static let logoutButtonTrailingInset: CGFloat = -16
        
        static let nameLabelTopSpacing: CGFloat = 8
        static let handleLabelTopSpacing: CGFloat = 8
        static let statusLabelTopSpacing: CGFloat = 8
        
        static let nameLabelFontSize: CGFloat = 23
        static let handleStatusLabelFontSize: CGFloat = 13
    }
    
    private let profileService = ProfileService(token: OAuth2TokenStorage().token ?? "")
    
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
        fetchProfile()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = UIColor.ypBlack
        setupProfileImageView()
        setupLogoutButton()
        setupNameLabel()
        setupHandleLabel()
        setupStatusLabel()
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: ProfileConstants.profileImageSize),
            profileImage.heightAnchor.constraint(equalToConstant: ProfileConstants.profileImageSize),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ProfileConstants.profileImageTopInset),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ProfileConstants.profileImageLeadingInset),
            
            logoutButton.widthAnchor.constraint(equalToConstant: ProfileConstants.logoutButtonSize),
            logoutButton.heightAnchor.constraint(equalToConstant: ProfileConstants.logoutButtonSize),
            logoutButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: ProfileConstants.logoutButtonTrailingInset),
            
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: ProfileConstants.nameLabelTopSpacing),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            handleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: ProfileConstants.handleLabelTopSpacing),
            handleLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: handleLabel.bottomAnchor, constant: ProfileConstants.statusLabelTopSpacing),
            statusLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor)
        ])
    }
    
    // MARK: - UI Configuration
    private func setupProfileImageView() {
        profileImage.image = UIImage(named: "mockProfileImage")
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = ProfileConstants.profileImageCornerRadius
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
    }
    
    private func setupLogoutButton() {
        logoutButton.setTitle("", for: .normal)
        logoutButton.setImage(UIImage.exit, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
    }
    
    private func setupNameLabel() {
        nameLabel.text = dataMock.name
        nameLabel.textColor = UIColor.ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: ProfileConstants.nameLabelFontSize, weight: .bold)
        nameLabel.numberOfLines = .zero
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
    }
    
    private func setupHandleLabel() {
        handleLabel.text = dataMock.handle
        handleLabel.textColor = UIColor.ypGray
        handleLabel.font = UIFont.systemFont(ofSize: ProfileConstants.handleStatusLabelFontSize, weight: .regular)
        handleLabel.numberOfLines = .zero
        handleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(handleLabel)
    }
    
    private func setupStatusLabel() {
        statusLabel.text = dataMock.status
        statusLabel.textColor = UIColor.ypWhite
        statusLabel.font = UIFont.systemFont(ofSize: ProfileConstants.handleStatusLabelFontSize, weight: .regular)
        statusLabel.numberOfLines = .zero
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
    }
    
    private func fetchProfile() {
        guard let token = OAuth2TokenStorage().token else {
            print("❌ Нет токена — нельзя загрузить профиль")
            return
        }
        
        profileService.fetchProfile(token) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.updateProfileLabels(with: profile)
                case .failure(let error):
                    print("❌ Ошибка загрузки профиля: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func updateProfileLabels(with profile: ProfileService.Profile) {
        nameLabel.text = profile.name
        handleLabel.text = profile.loginName
        statusLabel.text = profile.bio
    }
    
    
    
    // MARK: - Actions
    @objc private func logoutButtonTapped() {
        
    }
    
    // MARK: - Mock
    private enum dataMock {
        static let name = ""
        static let handle = ""
        static let status = ""
    }
}
