import UIKit

final class OAuth2Service: OAuth2ServiceProtocol {
    //MARK: - Constants
    private enum OAuth2Constants {
        static let tokenEndpoint = "https://unsplash.com/oauth/token"
        static let contentType = "application/x-www-form-urlencoded"
        static let grantType = "authorization_code"
        static let forHTTPHeaderField = "Content-Type"
        
        enum Keys {
            static let clientID = "client_id"
            static let clientSecret = "client_secret"
            static let redirectURI = "redirect_uri"
            static let code = "code"
            static let grantType = "grant_type"
        }
    }
    
    // MARK: - Singleton Instance
    static let shared = OAuth2Service()
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Private Properties
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    // MARK: - Public Methods
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            print("[OAuth2Service fetchAuthToken]: InvalidRequestError - повторный запрос с тем же кодом: \(code)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        print("[OAuth2Service fetchAuthToken]: Previous task cancelled")
        
        lastCode = code
        
        guard let request = makeAuthTokenRequest(code: code) else {
            print("[OAuth2Service fetchAuthToken]: InvalidRequestError - не удалось создать URLRequest для кода: \(code)")
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        
        task = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            
            guard self.lastCode == code else {
                print("[OAuth2Service fetchAuthToken]: Игнорируем ответ от устаревшего запроса с кодом: \(code)")
                return
            }
            
            switch result {
            case .success(let decodedBody):
                let token = decodedBody.accessToken
                OAuth2TokenStorage().token = token
                completion(.success(token))
            case .failure(let error):
                print("[OAuth2Service fetchAuthToken]: Failure - \(error.localizedDescription), code: \(code), URL: \(request.url?.absoluteString ?? "nil")")
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
            OAuth2Constants.Keys.clientID: Constants.accessKey,
            OAuth2Constants.Keys.clientSecret: Constants.secretKey,
            OAuth2Constants.Keys.redirectURI: Constants.redirectURI,
            OAuth2Constants.Keys.code: code,
            OAuth2Constants.Keys.grantType: OAuth2Constants.grantType
        ]
        
        request.httpBody = parameters
            .map { "\($0)=\($1)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        request.setValue(OAuth2Constants.contentType, forHTTPHeaderField: OAuth2Constants.forHTTPHeaderField)
        
        return request
    }
}
