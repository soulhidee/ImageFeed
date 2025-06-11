import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private var task: URLSessionTask?
    private var lastCode: String?
    private init() { }
    
    struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
        }
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        if lastCode == code {
            return
        }
        lastCode = code
        
        
        let request: URLRequest
        do {
            request = try makeOAuthTokenRequest(code: code)
        } catch {
            completion(.failure(error))
            return
        }
        
        task?.cancel()
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard
                    let data = data,
                    let response = try? JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                else {
                    completion(.failure(RequestError.decodingError))
                    return
                }
                
                completion(.success(response.accessToken))
            }
        }
        task?.resume()
    }
    
    func makeOAuthTokenRequest(code: String) throws -> URLRequest {
        guard !code.isEmpty else {
            throw RequestError.invalidCode
        }
        
        guard let url = URL(string: WebViewConstants.tokenURLString) else {
            throw RequestError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30.0
        
        let bodyParameters = [
            "client_id": Constants.accessKey,
            "client_secret": Constants.secretKey,
            "redirect_uri": Constants.redirectURI,
            "code": code,
            "grant_type": "authorization_code"
        ]
        
        var components = URLComponents()
        components.queryItems = bodyParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let bodyString = components.query,
              let bodyData = bodyString.data(using: .utf8) else {
            throw RequestError.invalidBodyEncoding
        }
        
        request.httpBody = bodyData
        
        return request
    }
    
}
