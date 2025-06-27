import UIKit

final class OAuth2Service: OAuth2ServiceProtocol {
    //MARK: - Constants
    private enum OAuth2Constants {
        static let tokenEndpoint = "https://unsplash.com/oauth/token"
        static let contentType = "application/x-www-form-urlencoded"
        static let grantType = "authorization_code"
    }
    
    // MARK: - Singleton Instance
    static let shared = OAuth2Service()
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Private Properties
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private let jsonDecoder = JSONDecoder()
    
    // MARK: - Public Methods
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(NetworkError.invalidRequest))
            print("⛔️ Повторный запрос с тем же кодом или код уже использован, выходим.")
            return
        }

        task?.cancel()
        print("🔄 Отменён предыдущий запрос (если был)")

        lastCode = code
        
        guard let request = makeAuthTokenRequest(code: code) else {
            print("❌ Ошибка: не удалось создать URLRequest.")
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        
        task = session.data(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let decodedBody = try self.jsonDecoder.decode(OAuthTokenResponseBody.self, from: data)
                    let token = decodedBody.accessToken
                    OAuth2TokenStorage().token = token
                    completion(.success(token))
                } catch {
                    print("❌ Ошибка декодирования токена: \(error)")
                    completion(.failure(error))
                }
                
            case .failure(let error):
                switch error {
                case NetworkError.httpStatusCode(let code):
                    print("❌ HTTP ошибка со статусом: \(code)")
                case NetworkError.urlRequestError(let err):
                    print("❌ Ошибка запроса: \(err)")
                case NetworkError.urlSessionError:
                    print("❌ Неизвестная ошибка сессии")
                default:
                    print("❌ Другая ошибка: \(error)")
                }
                completion(.failure(error))
            }
            
            self.task = nil
        }
        
        task?.resume()
    }
    
    // MARK: - Private Methods
    private func makeAuthTokenRequest(code: String) -> URLRequest? {
        guard let url = URL(string: OAuth2Constants.tokenEndpoint) else {
            print("❌ Ошибка: невалидный URL.")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        let parameters = [
            "client_id": Constants.accessKey,
            "client_secret": Constants.secretKey,
            "redirect_uri": Constants.redirectURI,
            "code": code,
            "grant_type": OAuth2Constants.grantType
        ]
        
        request.httpBody = parameters
            .map { "\($0)=\($1)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        request.setValue(OAuth2Constants.contentType, forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
