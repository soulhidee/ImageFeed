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
    
    private lazy var profileImageShimmer = ShimmerView()
    private lazy var nameLabelShimmer = ShimmerView()
    private lazy var handleLabelShimmer = ShimmerView()
    private lazy var statusLabelShimmer = ShimmerView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        loadProfileIfAvailable()
        addProfileImageObserver()
        updateAvatar()
        profileImageShimmer.startAnimating()
        nameLabelShimmer.startAnimating()
        handleLabelShimmer.startAnimating()
        statusLabelShimmer.startAnimating()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = UIColor.ypBlack
        
        view.addSubview(profileImage)
        view.addSubview(logoutButton)
        view.addSubview(nameLabel)
        view.addSubview(handleLabel)
        view.addSubview(statusLabel)
        
        view.addSubview(profileImageShimmer)
        view.addSubview(nameLabelShimmer)
        view.addSubview(handleLabelShimmer)
        view.addSubview(statusLabelShimmer)
        
        profileImageShimmer.setCornerRadius(ProfileConstants.profileImageCornerRadius)
        nameLabelShimmer.setCornerRadius(9)
        handleLabelShimmer.setCornerRadius(9)
        statusLabelShimmer.setCornerRadius(9)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: ProfileConstants.profileImageSize),
            profileImage.heightAnchor.constraint(equalToConstant: ProfileConstants.profileImageSize),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ProfileConstants.profileImageTopInset),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ProfileConstants.profileImageLeadingInset),
            
            profileImageShimmer.widthAnchor.constraint(equalTo: profileImage.widthAnchor),
            profileImageShimmer.heightAnchor.constraint(equalTo: profileImage.heightAnchor),
            profileImageShimmer.topAnchor.constraint(equalTo: profileImage.topAnchor),
            profileImageShimmer.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            logoutButton.widthAnchor.constraint(equalToConstant: ProfileConstants.logoutButtonSize),
            logoutButton.heightAnchor.constraint(equalToConstant: ProfileConstants.logoutButtonSize),
            logoutButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: ProfileConstants.logoutButtonTrailingInset),
            
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: ProfileConstants.nameLabelTopSpacing),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            nameLabelShimmer.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameLabelShimmer.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameLabelShimmer.widthAnchor.constraint(equalTo: nameLabel.widthAnchor),
            nameLabelShimmer.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            
            handleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: ProfileConstants.handleLabelTopSpacing),
            handleLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            handleLabelShimmer.topAnchor.constraint(equalTo: handleLabel.topAnchor),
            handleLabelShimmer.leadingAnchor.constraint(equalTo: handleLabel.leadingAnchor),
            handleLabelShimmer.widthAnchor.constraint(equalTo: handleLabel.widthAnchor),
            handleLabelShimmer.heightAnchor.constraint(equalTo: handleLabel.heightAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: handleLabel.bottomAnchor, constant: ProfileConstants.statusLabelTopSpacing),
            statusLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            statusLabelShimmer.topAnchor.constraint(equalTo: statusLabel.topAnchor),
            statusLabelShimmer.leadingAnchor.constraint(equalTo: statusLabel.leadingAnchor),
            statusLabelShimmer.widthAnchor.constraint(equalTo: statusLabel.widthAnchor),
            statusLabelShimmer.heightAnchor.constraint(equalTo: statusLabel.heightAnchor),
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
        self.profileImageShimmer.stopAnimating()
        self.profileImageShimmer.isHidden = true
        
        self.nameLabelShimmer.stopAnimating()
        self.nameLabelShimmer.isHidden = true
        
        self.handleLabelShimmer.stopAnimating()
        self.handleLabelShimmer.isHidden = true
        
        self.statusLabelShimmer.stopAnimating()
        self.statusLabelShimmer.isHidden = true
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
        static let name = "Loading..."
        static let handle = "@loading"
        static let status = "Please wait..."
    }
    
}
