import Foundation

final class ProfileService {
    
    private enum ProfileServiceConstants {
        static let userProfileURL = "https://api.unsplash.com/me"
        static let headerAuthorization = "Authorization"
        static let headerBearer = "Bearer "
    }
    
    // MARK: - Private Properties
    private let token: String
    private var task: URLSessionTask?
    private var lastProfile: Profile?
    
    // MARK: - Initialization
    init(token: String) {
        self.token = token
    }
    
    // MARK: - Nested Types
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
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String
        
        init(result: ProfileService.ProfileResult) {
            self.username = result.username
            let first = result.firstName ?? ""
            let last = result.lastName ?? ""
            self.name = "\(first) \(last)".trimmingCharacters(in: .whitespaces)
            self.loginName = "@\(result.username)"
            self.bio = result.bio ?? ""
        }
    }
    
    // MARK: - Request Creation
    func makeProfileRequest() -> URLRequest? {
        guard let url = URL(string: ProfileServiceConstants.userProfileURL) else {
            print("❌ Ошибка: неверный URL для запроса профиля")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(ProfileServiceConstants.headerBearer + token, forHTTPHeaderField: ProfileServiceConstants.headerAuthorization)
        return request
    }
    
    // MARK: - Fetch Profile
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        if let lastProfile = lastProfile {
            completion(.success(lastProfile))
            return
        }
        
        task?.cancel()
        
        guard let request = makeProfileRequest() else {
            print("❌ Ошибка: не удалось сформировать запрос профиля")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let newTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Ошибка сети при загрузке профиля: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("❌ Ошибка: получены пустые данные при загрузке профиля")
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let profileResult = try decoder.decode(ProfileResult.self, from: data)
                let profile = Profile(result: profileResult)
                self.lastProfile = profile
                completion(.success(profile))
            } catch {
                print("❌ Ошибка декодирования профиля: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task = newTask
        newTask.resume()
    }
    
}
