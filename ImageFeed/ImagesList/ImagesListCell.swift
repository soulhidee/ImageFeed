import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Constants
    enum ImagesListCellConstants {
        static let reuseIdentifier = "ImagesListCell"
        static let imageViewCornerRadius: CGFloat = 16
        static let labelFont: CGFloat = 13
        
        static let imageTopInset: CGFloat = 4
        static let imageBottomInset: CGFloat = -8
        static let imageLeadingInset: CGFloat = 16
        static let imageTrailingInset: CGFloat = -16
        
        static let likeButtonSize: CGFloat = 44
        
        static let dateLabelLeadingInset: CGFloat = 8
        static let dateLabelBottomInset: CGFloat = -8
        static let spacingBetweenLabelAndButton: CGFloat = -8
    }
    
    // MARK: - Delegate
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - Reuse Identifier
    static let reuseIdentifier = ImagesListCellConstants.reuseIdentifier
    
    
    // MARK: - UI Elements
    lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = ImagesListCellConstants.imageViewCornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.ypWhite
        label.font = .systemFont(ofSize: ImagesListCellConstants.labelFont)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.likeActive, for: .normal)
        button.setTitle(nil, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var shimmerView = ShimmerView()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.ypBlack
        backgroundColor = UIColor.ypBlack
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.kf.cancelDownloadTask()
        cellImageView.image = nil
        
        dateLabel.text = nil
        likeButton.isSelected = false
        likeButton.setImage(UIImage.likeNoActive, for: .normal)
        
        stopShimmer()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        contentView.addSubview(cellImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
        cellImageView.addSubview(shimmerView)
    }
    
    // MARK: - Constaints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ImagesListCellConstants.imageTopInset),
            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: ImagesListCellConstants.imageBottomInset),
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ImagesListCellConstants.imageLeadingInset),
            cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: ImagesListCellConstants.imageTrailingInset),
            
            shimmerView.topAnchor.constraint(equalTo: cellImageView.topAnchor),
            shimmerView.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor),
            shimmerView.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor),
            shimmerView.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
            
            likeButton.widthAnchor.constraint(equalToConstant: ImagesListCellConstants.likeButtonSize),
            likeButton.heightAnchor.constraint(equalToConstant: ImagesListCellConstants.likeButtonSize),
            likeButton.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: cellImageView.topAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor, constant: ImagesListCellConstants.dateLabelLeadingInset),
            dateLabel.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: ImagesListCellConstants.dateLabelBottomInset),
            dateLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: ImagesListCellConstants.spacingBetweenLabelAndButton)
        ])
    }
    
    // MARK: - Configuration
    func configure(with image: UIImage?, dateText: String, isLiked: Bool) {
        cellImageView.image = image
        dateLabel.text = dateText
        
        setIsLiked(isLiked)
    }
    
    // MARK: -
    func setIsLiked(_ isLiked: Bool) {
        let image = isLiked ? UIImage.likeActive : UIImage.likeNoActive
        likeButton.setImage(image, for: .normal)
        likeButton.isSelected = isLiked
    }
    
    func startShimmer() {
        shimmerView.isHidden = false
        shimmerView.startAnimating()
    }
    
    func stopShimmer() {
        shimmerView.stopAnimating()
        shimmerView.isHidden = true
    }
    
    // MARK: - Action
    @objc private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}
