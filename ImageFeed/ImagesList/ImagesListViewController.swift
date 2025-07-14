import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    // MARK: - Constants
    private enum ImagesListConstants {
        static let numberOfPhotos = 20
        static let rowHeight: CGFloat = 200
        static let tableViewContentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        static let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        static let isLikedModulo = 2
        static let tableViewTopInset: CGFloat = 16
    }
    
    // MARK: - Private Properties
    private let imagesListService = ImagesListService()
    var photos: [Photo] = []
    
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
           let newCount = imagesListService.photos.count
           photos = imagesListService.photos
           if oldCount != newCount {
               tableView.performBatchUpdates {
                   let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                   tableView.insertRows(at: indexPaths, with: .automatic)
               }
           }
       }
    
    // MARK: - Date Formatter
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Navigation
    private func showSingleImage(_ image: UIImage?) {
        let vc = SingleImageViewController()
        vc.image = image
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
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        guard let url = URL(string: photo.largeImageURL) else { return }
        
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    self.showSingleImage(value.image)
                }
            case .failure(let error):
                print("Error loading full image: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return .zero
        }
        
        let imageInsets = ImagesListConstants.imageInsets
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        
        guard imageWidth != .zero else {
            return .zero
        }
        
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.selectionStyle = .none
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        // Тут будет код
    }
}

// MARK: - Cell Configuration
extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let image = UIImage(named: photosName[indexPath.row])
        let dateText = dateFormatter.string(from: Date())
        let isLiked = indexPath.row % ImagesListConstants.isLikedModulo == .zero
        
        cell.configure(with: image, dateText: dateText, isLiked: isLiked)
    }
}
