import Foundation

final class ProfileService {
    struct ProfileResult: Codable {
        let id: String
        let username: String
        let firstName: String?
        let lastName: String?
        let bio: String?
        let email: String?
        let profileImage: ProfileImage?
        
        enum CodingKeys: String, CodingKey {
            case id
            case username
            case firstName = "first_name"
            case lastName = "last_name"
            case bio
            case email
            case profileImage = "profile_image"
        }
    }
    
    struct ProfileImage: Codable {
        let small: String?
        let medium: String?
        let large: String?
    }
}
