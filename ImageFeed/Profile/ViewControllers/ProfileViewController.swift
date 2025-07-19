import UIKit
import Kingfisher

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
    
    var profile: ProfileService.Profile?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - UI Elements
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage.exit, for: .normal)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mockProfileImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = ProfileConstants.profileImageCornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = dataMock.name
        label.textColor = UIColor.ypWhite
        label.font = UIFont.systemFont(ofSize: ProfileConstants.nameLabelFontSize, weight: .bold)
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var handleLabel: UILabel = {
        let label = UILabel()
        label.text = dataMock.handle
        label.textColor = UIColor.ypGray
        label.font = UIFont.systemFont(ofSize: ProfileConstants.handleStatusLabelFontSize, weight: .regular)
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = dataMock.status
        label.textColor = UIColor.ypWhite
        label.font = UIFont.systemFont(ofSize: ProfileConstants.handleStatusLabelFontSize, weight: .regular)
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        loadProfileIfAvailable()
        addProfileImageObserver()
        updateAvatar()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = UIColor.ypBlack
        view.addSubview(profileImage)
        view.addSubview(logoutButton)
        view.addSubview(nameLabel)
        view.addSubview(handleLabel)
        view.addSubview(statusLabel)
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
    
    // MARK: - Load Profile
    private func loadProfileIfAvailable() {
        if let profile = ProfileService.shared.lastProfile {
            updateProfileLabels(with: profile)
        }
    }
    
    // MARK: - Update UI
    private func updateProfileLabels(with profile: ProfileService.Profile) {
        nameLabel.text = profile.name
        handleLabel.text = profile.loginName
        statusLabel.text = profile.bio
    }
    
    // MARK: - Profile Image Observer
    private func addProfileImageObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
    // MARK: - Update Avatar
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        profileImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "defaultProfileImage"),
            options: [
                .cacheOriginalImage
            ]
        )
    }
    
    // MARK: - Actions
    @objc private func logoutButtonTapped() {
        ProfileLogoutService.shared.logout()
    }
    
    // MARK: - Mock Data
    private enum dataMock {
        static let name = ""
        static let handle = ""
        static let status = ""
    }
}
