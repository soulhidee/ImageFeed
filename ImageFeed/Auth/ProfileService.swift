import Foundation

final class ProfileService {
    
    private let token: String
    private var task: URLSessionTask?
    private var lastProfile: Profile?
    
    init(token: String) {
        self.token = token
    }
    
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
    
    func makeProfileRequest() -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        if let lastProfile = lastProfile {
            completion(.success(lastProfile))
            return
        }
        
        task?.cancel()
        
        
        guard let request = makeProfileRequest() else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let profileResult = try decoder.decode(ProfileResult.self, from: data)
                    let profile = Profile(result: profileResult)
                    completion(.success(profile))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        task = newTask
        task.resume()
    }
    
    
    
    
    
    
    
    
    
}
