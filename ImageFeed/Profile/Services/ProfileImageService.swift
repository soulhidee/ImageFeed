import Foundation

final class ProfileImageService {
    
    // MARK: - Constants
    private enum  ProfileImageConstants {
        static let userURL = "https://api.unsplash.com/users/"
        static let headerAuthorization = "Authorization"
        static let bearerPrefix = "Bearer "
    }
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
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
            let error = NetworkError.tokenMissing
            print("[ProfileImageService fetchProfileImageURL]: TokenMissingError - токен отсутствует")
            completion(.failure(error))
            return
        }
        
        guard let request = makeImageRequest(username: username, token: token) else {
            print("[ProfileImageService fetchProfileImageURL]: InvalidRequestError - неверный запрос, username: \(username)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let userResult):
                if let imageURL = userResult.profileImage.large ?? userResult.profileImage.medium ?? userResult.profileImage.small {
                    self.avatarURL = imageURL
                    completion(.success(imageURL))
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": imageURL]
                    )
                } else {
                    let error = NetworkError.invalidData
                    print("[ProfileImageService fetchProfileImageURL]: InvalidDataError - ссылка на изображение отсутствует, username: \(username)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("[ProfileImageService fetchProfileImageURL]: Failure - \(error.localizedDescription), username: \(username), URL: \(request.url?.absoluteString ?? "nil")")
                completion(.failure(error))
            }
            self.task = nil
        }
        
        task?.resume()
    }
    
    func reset() {
        avatarURL = nil
        task?.cancel()
        task = nil
    }
}
