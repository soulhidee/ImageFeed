import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Constants
    private enum SingleImageConstants {
        static let minimumZoomScale: CGFloat = 0.1
        static let maximumZoomScale: CGFloat = 1.25
        static let backButtonSize: CGFloat = 44
        static let backButtonLeading: CGFloat = 8
        static let backButtonTop: CGFloat = 11
        static let shareButtonSize: CGFloat = 50
        static let shareButtonBottom: CGFloat = -17
        static let zeroInset: CGFloat = 0
        static let divider: CGFloat = 2
        
        static let alertTitle = "Ошибка"
        static let alertMessage = "Что-то пошло не так. Попробовать ещё раз?"
        static let cancelTitle = "Не надо"
        static let retryTitle = "Повторить"
    }
    
    // MARK: - Public Properties
    var fullImageURL: URL?
    
    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.minimumZoomScale = SingleImageConstants.minimumZoomScale
        sv.maximumZoomScale = SingleImageConstants.maximumZoomScale
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.delegate = self
        return sv
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("", for: .normal)
        button.setImage(UIImage.backward, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var sharingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(nil, for: .normal)
        button.setImage(UIImage.sharing, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupUI()
        setupConstraints()
        setupActions()
        loadFullImage()
    }
    
    // MARK: - Setup
    private func configureView() {
        view.backgroundColor = UIColor.ypBlack
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(backButton)
        view.addSubview(sharingButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: SingleImageConstants.backButtonLeading),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SingleImageConstants.backButtonTop),
            backButton.widthAnchor.constraint(equalToConstant: SingleImageConstants.backButtonSize),
            backButton.heightAnchor.constraint(equalToConstant: SingleImageConstants.backButtonSize),
            
            sharingButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            sharingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: SingleImageConstants.shareButtonBottom),
            sharingButton.widthAnchor.constraint(equalToConstant: SingleImageConstants.shareButtonSize),
            sharingButton.heightAnchor.constraint(equalToConstant: SingleImageConstants.shareButtonSize)
        ])
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        sharingButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapShareButton() {
        guard let image = imageView.image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    // MARK: - Loading Image with ProgressHUD
    private func loadFullImage() {
        guard let url = fullImageURL else { return }
        
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: SingleImageConstants.alertTitle,
            message: SingleImageConstants.alertMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: SingleImageConstants.cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: SingleImageConstants.retryTitle, style: .default) { [weak self] _ in
            self?.loadFullImage()
        })
        present(alert, animated: true)
    }
    
    // MARK: - Zooming & Centering
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        view.layoutIfNeeded()
        let scrollViewSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = scrollViewSize.width / imageSize.width
        let vScale = scrollViewSize.height / imageSize.height
        let scale = max(scrollView.minimumZoomScale, min(scrollView.maximumZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        imageView.frame = CGRect(origin: .zero, size: CGSize(
            width: imageSize.width * scale,
            height: imageSize.height * scale
        ))
        
        centerImage()
    }
    
    private func centerImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = imageView.frame.size
        
        let horizontalInset = max((scrollViewSize.width - imageViewSize.width) / SingleImageConstants.divider,
                                  SingleImageConstants.zeroInset)
        
        let verticalInset = max((scrollViewSize.height - imageViewSize.height) / SingleImageConstants.divider,
                                SingleImageConstants.zeroInset)
        
        scrollView.contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
    }
    
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        centerImage()
    }
}
