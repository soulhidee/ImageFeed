import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private var task: URLSessionTask?
    private var lastCode: String?
    private init() { }
    

    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {

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
