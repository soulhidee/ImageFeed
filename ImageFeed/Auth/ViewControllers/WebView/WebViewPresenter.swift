import Foundation

//    private func updateProgress() {
//        progressView.progress = Float(webView.estimatedProgress)
//        progressView.isHidden = fabs(webView.estimatedProgress - WebViewConstants.fullProgressValue) <= WebViewConstants.progressEpsilon
//    }

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
        
        static let fullProgressValue: Float = 1.0
        static let progressEpsilon: Float = 0.0001
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
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
        
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - PresenterConstants.fullProgressValue) <= PresenterConstants.progressEpsilon
       }
}
