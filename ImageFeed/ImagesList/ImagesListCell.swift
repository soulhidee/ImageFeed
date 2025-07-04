import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - Constants
    enum ImagesListCellConstants {
        static let reuseIdentifier = "ImagesListCell"
    }
    
    // MARK: - Outlets
    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.ypWhite
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.likeActive, for: .normal)
        button.setTitle(nil, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: ImagesListCellConstants.reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
            contentView.addSubview(cellImageView)
            contentView.addSubview(dateLabel)
            contentView.addSubview(likeButton)
        }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // cellImageView constraints
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // likeButton constraints
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: cellImageView.topAnchor),
            
            // dateLabel constraints
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: likeButton.topAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configuration
    func configure(with image: UIImage?, dateText: String, isLiked: Bool) {
        cellImageView.image = image
        dateLabel.text = dateText
        
        let likeImage = isLiked ? UIImage.likeActive : UIImage.likeNoActive
        likeButton.setImage(likeImage, for: .normal)
        likeButton.isSelected = isLiked
    }
}
