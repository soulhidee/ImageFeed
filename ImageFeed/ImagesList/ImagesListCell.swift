import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - Constants
    enum ImagesListCellConstants {
        static let reuseIdentifier = "ImagesListCell"
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var cellImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    // MARK: - Properties
    static let reuseIdentifier = ImagesListCellConstants.reuseIdentifier
    
    // MARK: - Configuration
    func configure(with image: UIImage?, dateText: String, isLiked: Bool) {
        cellImageView.image = image
        dateLabel.text = dateText

        let likeImage = isLiked ? UIImage.likeActive : UIImage.likeNoActive
        likeButton.setImage(likeImage, for: .normal)
        likeButton.isSelected = isLiked
    }
}
