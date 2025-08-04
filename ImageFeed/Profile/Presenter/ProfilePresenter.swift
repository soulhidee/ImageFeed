import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let logoutService = ProfileLogoutService.shared
    
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
