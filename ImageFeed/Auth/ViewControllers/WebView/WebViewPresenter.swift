import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {

    // MARK: - Constants
    enum PresenterConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        static let unsplashBaseURLString = "https://unsplash.com"
        static let tokenPath = "/oauth/token"
        static let authorizeNativePath = "/oauth/authorize/native"
        
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
    
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }

    
    // MARK: - Protocol
    weak var view: WebViewViewControllerProtocol?

    func viewDidLoad() {
        guard let request = authHelper.authRequest() else { return }
        
        view?.load(request: request)
        didUpdateProgressValue(.zero)
    }
    
    
    // MARK: - Progress Logic
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
        
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - PresenterConstants.fullProgressValue) <= PresenterConstants.progressEpsilon
       }
    
    // MARK: - Code Extraction
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
