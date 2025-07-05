import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    // MARK: - Constants
    enum WebViewConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        static let unsplashBaseURLString = "https://unsplash.com"
        static let tokenPath = "/oauth/token"
        static let authorizeNativePath = "/oauth/authorize/native"
        
        static var tokenURLString: String {
            return unsplashBaseURLString + tokenPath
        }
        
        static let fullProgressValue: Double = 1.0
        static let progressEpsilon: Double = 0.0001
        
        static let clientID = "client_id"
        static let redirectURL = "redirect_uri"
        static let responseType = "response_type"
        static let code = "code"
        static let scope = "scope"
    }
    
    // MARK: - Delegate
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - UI Elements
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = UIColor.ypBlack
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    //MARK: - Observers
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        webView.navigationDelegate = self
        setupViews()
        loadAuthView()
        setupConstraints()
        observeWebViewProgress()
    }
    
    // MARK: - KVO
    func observeWebViewProgress() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             }
        )
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        configureView()
        view.addSubview(webView)
        view.addSubview(progressView)
        configureCustomBackButton()
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .zero),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .zero),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: .zero),
            
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .zero),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: .zero),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .zero),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .zero)
        ])
    }
    
    // MARK: - UI Configuration
    private func configureCustomBackButton() {
        let customBackButton = UIBarButtonItem(image: UIImage.navBackButton, style: .plain, target: self, action: #selector(backButtonTapped))
        customBackButton.tintColor = UIColor.ypBlack
        navigationItem.leftBarButtonItem = customBackButton
    }
    
    private func configureView() {
        view.backgroundColor = UIColor.ypWhite
    }
    
    // MARK: - WebView Loading
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            print("❌ Не удалось создать URLComponents из строки: \(WebViewConstants.unsplashAuthorizeURLString)")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: WebViewConstants.clientID, value: Constants.accessKey),
            URLQueryItem(name: WebViewConstants.redirectURL, value: Constants.redirectURI),
            URLQueryItem(name: WebViewConstants.responseType, value: WebViewConstants.code),
            URLQueryItem(name: WebViewConstants.scope, value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("❌ Не удалось получить URL из URLComponents: \(urlComponents)")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - Helpers
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - WebViewConstants.fullProgressValue) <= WebViewConstants.progressEpsilon
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
}

// MARK: - Extension
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == WebViewConstants.authorizeNativePath,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == WebViewConstants.code })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}


