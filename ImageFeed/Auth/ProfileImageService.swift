import Foundation

final class ProfileImageService {
    
    // MARK: - Constants
    private enum  ProfileImageConstants {
        static let userURL = "https://api.unsplash.com/users/"
        static let headerAuthorization = "Authorization"
        static let bearerPrefix = "Bearer "
    }

    // MARK: - Singleton
    static let shared = ProfileImageService()
    
    // MARK: - Private Properties
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    private init() {}
    
    // MARK: - Nested Types
    private struct UserResult: Codable {
        let profileImage: ProfileImage

        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }
    
    private struct ProfileImage: Codable {
        let small: String?
        let medium: String?
        let large: String?
    }
    
    // MARK: - Request Creation
    private func makeImageRequest(username: String, token: String) -> URLRequest? {
        let urlString = ProfileImageConstants.userURL + username
        guard let url = URL(string: urlString) else {
            print("❌ Ошибка: неверный URL для запроса изображения")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(ProfileImageConstants.bearerPrefix + token, forHTTPHeaderField: ProfileImageConstants.headerAuthorization)
        return request
    }
    
    // MARK: - Fetch Image URL
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        
        guard let token = OAuth2TokenStorage().token else {
            print("❌ Ошибка: токен отсутствует")
            completion(.failure(NetworkError.tokenMissing))
            return
        }
        
        guard let request = makeImageRequest(username: username, token: token) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let newTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("❌ Ошибка сети при загрузке изображения: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("❌ Ошибка: получены пустые данные при загрузке изображения")
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(UserResult.self, from: data)
                if let small = result.profileImage.small {
                    self?.avatarURL = small
                    completion(.success(small))
                } else {
                    print("❌ Ошибка: ссылка на изображение отсутствует")
                    completion(.failure(NetworkError.invalidData))
                }
            } catch {
                print("❌ Ошибка декодирования изображения: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task = newTask
        newTask.resume()
    }
}
