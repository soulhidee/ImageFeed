import Foundation

final class ProfileService {
    
    private enum ProfileServiceConstants {
        static let userProfileURL = "https://api.unsplash.com/me"
        static let headerAuthorization = "Authorization"
        static let headerBearer = "Bearer "
    }
    
    // MARK: - Singleton
    static let shared = ProfileService()
    
    // MARK: - Private Properties
    private var task: URLSessionTask?
    private(set) var lastProfile: Profile?
    
    private init() {}
    
    // MARK: - Nested Types
    struct ProfileResult: Codable {
        let id: String
        let username: String
        let firstName: String?
        let lastName: String?
        let bio: String?
        let email: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case username
            case firstName = "first_name"
            case lastName = "last_name"
            case bio
            case email
        }
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
    func makeProfileRequest(with token: String) -> URLRequest? {
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
        
        guard let request = makeProfileRequest(with: token) else {
            print("❌ Ошибка: не удалось сформировать запрос профиля")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
                let profile = Profile(result: profileResult)
                self.lastProfile = profile
                completion(.success(profile))
            case .failure(let error):
                print("❌ Ошибка при загрузке профиля: \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.task = nil
        }
        task?.resume()
    }
}
