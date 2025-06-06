import UIKit
import WebKit

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}




final class WebViewViewController: UIViewController {
    let webView = WKWebView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupViews()
        loadAuthView()
        setupConstraints()
    }
    
    private func setupViews() {
        configureCustomBackButton()
        configureWebView()
        configureView()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .zero),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: .zero),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .zero),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .zero)
        ])
    }
    
    private func  configureCustomBackButton() {
        let customBackButton = UIBarButtonItem(image: UIImage(named: "nav_back_button"), style: .plain, target: self, action: #selector(backButtonTapped))
        customBackButton.tintColor = UIColor(named: "YPBlack")
        navigationItem.leftBarButtonItem = customBackButton
    }
    
    private func configureView() {
        view.backgroundColor = UIColor(named: "YPWhite") ?? .white
    }
    
    private func configureWebView() {
        webView.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
    }
    
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
