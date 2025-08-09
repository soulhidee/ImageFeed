import Foundation

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    
    func updateProfileDetails(name: String, login: String, bio: String)
    func updateAvatar(with url: URL)
    func stopShimmerAnimation()
}
