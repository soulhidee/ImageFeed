import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService: ProfileService
    private let profileImageService: ProfileImageServiceProtocol
    private let logoutService: ProfileLogoutService
    
    init(
        profileService: ProfileService = .shared,
        profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared,
        logoutService: ProfileLogoutService = .shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.logoutService = logoutService
    }
    
    func viewDidLoad() {
        guard let profile = profileService.lastProfile else {
            print("❌ Ошибка: профиль не найден")
            return
        }
        
        view?.updateProfileDetails(
            name: profile.name,
            login: profile.loginName,
            bio: profile.bio
        )
        view?.stopShimmerAnimation()
        
        if let urlString = profileImageService.avatarURL,
           let url = URL(string: urlString) {
            view?.updateAvatar(with: url)
        }
    }
    
    func avatarDidChange() {
        if let urlString = profileImageService.avatarURL,
           let url = URL(string: urlString) {
            view?.updateAvatar(with: url)
        }
    }
    
    func didTapLogout() {
        logoutService.logout()
    }
}
