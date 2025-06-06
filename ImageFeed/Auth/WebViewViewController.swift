import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    let webView = WKWebView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupViews()
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
    
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
