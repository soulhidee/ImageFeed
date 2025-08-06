import UIKit
import WebKit

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    
    // MARK: - Constants
    enum WebViewConstants {
        static let code = "code"
    }
    
    // MARK: - Delegate
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - Presenter
    var presenter: WebViewPresenterProtocol?
    
    // MARK: - UI Elements
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .white
        webView.accessibilityIdentifier = "UnsplashWebView"
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
        presenter?.viewDidLoad()
        setupConstraints()
        observeWebViewProgress()
    }
    
    // MARK: - KVO
    func observeWebViewProgress() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
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
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    // MARK: - Helpers
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
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
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}


