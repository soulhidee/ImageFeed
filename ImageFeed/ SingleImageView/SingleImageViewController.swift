import UIKit

final class SingleImageViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Public Properties
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var sharingButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setupUI()
        
        if let image {
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - Actions
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let activityView = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityView, animated: true)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        setupBackButton()
        setupSharingButton()
        configureZoomScale()
    }
    
    private func setupBackButton() {
        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(named: "Backward"), for: .normal)
    }
    
    private func setupSharingButton() {
        sharingButton.setTitle("", for: .normal)
        sharingButton.setImage(UIImage(named: "Sharing"), for: .normal)
    }
    
    private func configureZoomScale() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        view.layoutIfNeeded()
        
        // Вычисляем масштаб
        let scrollViewSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = scrollViewSize.width / imageSize.width
        let vScale = scrollViewSize.height / imageSize.height
        let scale = max(scrollView.minimumZoomScale, min(scrollView.maximumZoomScale, min(hScale, vScale)))

        // Устанавливаем начальный масштаб
        scrollView.setZoomScale(scale, animated: false)
        
        // Устанавливаем frame imageView
        imageView.frame = CGRect(origin: .zero, size: CGSize(
            width: imageSize.width * scale,
            height: imageSize.height * scale
        ))

        // Центрируем
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
