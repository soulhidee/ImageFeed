import UIKit

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
    }
    
    // MARK: - Public Properties
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.minimumZoomScale = SingleImageConstants.minimumZoomScale
        sv.maximumZoomScale = SingleImageConstants.maximumZoomScale
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("", for: .normal)
        button.setImage(UIImage.backward, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let sharingButton: UIButton = {
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
        updateImageIfNeeded()
    }
    
    // MARK: - Lifecycle Helpers
    private func configureView() {
        scrollView.delegate = self
        view.backgroundColor = UIColor.ypBlack
    }

    private func updateImageIfNeeded() {
        guard let image else { return }
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(backButton)
        view.addSubview(sharingButton)
    }
    
    // MARK: - Constraints
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
        
        let horizontalInset = max((scrollViewSize.width - imageViewSize.width) / 2, 0)
        let verticalInset = max((scrollViewSize.height - imageViewSize.height) / 2, 0)
        
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
