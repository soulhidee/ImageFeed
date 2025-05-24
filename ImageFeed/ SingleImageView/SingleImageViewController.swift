import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }

    @IBOutlet private weak var backButton: UIButton!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        setupBackButton()
    }

    @IBAction private func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupBackButton() {
        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(named: "Backward"), for: .normal)
    }
}
