import UIKit

final class SingleImageViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Public Properties
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        imageView.image = image
        setupBackButton()
    }
    
    // MARK: - Actions
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    private func setupBackButton() {
        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(named: "Backward"), for: .normal)
    }
}
