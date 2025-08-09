@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    var stopShimmerAnimationCalled = false
    
    func updateProfileDetails(name: String, login: String, bio: String) {
        updateProfileDetailsCalled = true
    }
    
    func updateAvatar(with url: URL) {
        updateAvatarCalled = true
    }
    
    func stopShimmerAnimation() {
        stopShimmerAnimationCalled = true
    }
}
