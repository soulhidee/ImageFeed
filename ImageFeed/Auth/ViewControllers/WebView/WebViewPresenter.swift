import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - Constants
    enum PresenterConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        static let unsplashBaseURLString = "https://unsplash.com"
        static let tokenPath = "/oauth/token"
        
        static var tokenURLString: String {
            return unsplashBaseURLString + tokenPath
        }
        static let clientID = "client_id"
        static let redirectURL = "redirect_uri"
        static let responseType = "response_type"
        static let scope = "scope"
        static let code = "code"
    }
    
    // MARK: - Protocol
    weak var view: WebViewViewControllerProtocol?

    func viewDidLoad() {
        guard var urlComponents = URLComponents(string: PresenterConstants.unsplashAuthorizeURLString) else {
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: PresenterConstants.clientID, value: Constants.accessKey),
            URLQueryItem(name: PresenterConstants.redirectURL, value: Constants.redirectURI),
            URLQueryItem(name: PresenterConstants.responseType, value: PresenterConstants.code),
            URLQueryItem(name: PresenterConstants.scope, value: Constants.accessScope)
        ]

        guard let url = urlComponents.url else {
            return
        }

        let request = URLRequest(url: url)
        view?.load(request: request)
    }
}
