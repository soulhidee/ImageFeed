import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    // MARK: - Constants
    private enum ImagesListConstants {
        static let numberOfPhotos = 20
        static let rowHeight: CGFloat = 200
        static let tableViewContentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        static let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        static let tableViewTopInset: CGFloat = 16
        static let prefetchThreshold = 1
        static let russianLocale = Locale(identifier: "ru_RU")
        static let unknownDateString = "Дата неизвестна"
        static let signInButtonTitle = "Войти"
        static let errorAlertTitle = "Что-то пошло не так("
        static let errorAlertMessage = "Не удалось войти в систему"
        static let errorAlertAction = "Ок"
    }
    
    // MARK: - Private Properties
    private var photos: [Photo] = []
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.ypBlack
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = ImagesListConstants.rowHeight
        tableView.contentInset = ImagesListConstants.tableViewContentInset
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        tableView.rowHeight = ImagesListConstants.rowHeight
        tableView.contentInset = ImagesListConstants.tableViewContentInset
        configureTransparentNavigationBar()
        setupObservers()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.ypBlack
        view.addSubview(tableView)
        ImagesListService.shared.fetchPhotosNextPage()
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ImagesListConstants.tableViewTopInset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    // MARK: - Observers
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableViewAnimated),
            name: ImagesListService.didChangeNotification,
            object: nil
        )
    }
    
    @objc func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = ImagesListService.shared.photos.count
        photos = ImagesListService.shared.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: .zero) }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
    
    // MARK: - Date Formatter
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = ImagesListConstants.russianLocale
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Navigation
    private func showSingleImage(with url: URL) {
        let vc = SingleImageViewController()
        vc.fullImageURL = url
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func configureTransparentNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]
    }
    
    // MARK - Alert
    private func showAuthErrorAlert() {
        let alert = UIAlertController(
            title: ImagesListConstants.errorAlertTitle,
            message: ImagesListConstants.errorAlertMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: ImagesListConstants.errorAlertAction, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        guard let url = URL(string: photo.largeImageURL) else { return }
        showSingleImage(with: url)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageInsets = ImagesListConstants.imageInsets
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / photo.size.width
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath) {
        if indexPath.row + ImagesListConstants.prefetchThreshold == photos.count {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imageListCell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        imageListCell.startShimmer()
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

// MARK: - Cell Configuration
extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let dateText: String
        if let createdAt = photo.createdAt {
            dateText = dateFormatter.string(from: createdAt)
        } else {
            dateText = ImagesListConstants.unknownDateString
        }
        
        let isLiked = photo.isLiked
        let processor = RoundCornerImageProcessor(cornerRadius: .zero)
        
        if let url = URL(string: photo.thumbImageURL) {
            cell.startShimmer()
            
            cell.cellImageView.kf.indicatorType = .none
            cell.cellImageView.kf.setImage(
                with: url,
                options: [.processor(processor), .forceRefresh, .cacheMemoryOnly]
            ) { _ in
                cell.stopShimmer()
            }
        } else {
            cell.cellImageView.image = nil
            cell.stopShimmer()
        }
        
        cell.configure(with: cell.cellImageView.image, dateText: dateText, isLiked: isLiked)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        ImagesListService.shared.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success:
                self.photos = ImagesListService.shared.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAuthErrorAlert()
            }
        }
    }
    
}
