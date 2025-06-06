import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    let webView = WKWebView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
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
    private func configureView() {
        view.backgroundColor = UIColor(named: "YPWhite") ?? .white
    }
    
    private func configureWebView() {
        webView.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
    }
    
    
}
