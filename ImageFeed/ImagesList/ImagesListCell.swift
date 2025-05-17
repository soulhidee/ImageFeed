import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet private weak var cellImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private var likeButton: UIButton!
    
    static let reuseIdentifier = "ImagesListCell"
    
    
    
    func configure(with image: UIImage?, dateText: String, isLiked: Bool) {
           cellImageView.image = image
           dateLabel.text = dateText

           let likeImage = isLiked ? UIImage(named: "LikeActive") : UIImage(named: "LikeNoActive")
           likeButton.setImage(likeImage, for: .normal)
           likeButton.isSelected = isLiked
       }
}

