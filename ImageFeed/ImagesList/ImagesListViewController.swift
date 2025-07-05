import UIKit

final class ImagesListViewController: UIViewController {
    
    // MARK: - Constants
    private enum ImagesListConstants {
        static let numberOfPhotos = 20
        static let rowHeight: CGFloat = 200
        static let tableViewContentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        static let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        static let isLikedModulo = 2
    }
    
    // MARK: - Properties
    private let photosName = (.zero..<ImagesListConstants.numberOfPhotos).map(String.init)
    
    // MARK: - Outlet
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
        
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        
        view.backgroundColor = UIColor.ypBlack
        view.addSubview(tableView)
    }
    
    // MARK: - Date Formatter
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: -
    private func setupConstraints() {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    
    // MARK: - Navigation
        private func showSingleImage(_ image: UIImage?) {
            let vc = SingleImageViewController()
            vc.image = image
            navigationController?.pushViewController(vc, animated: true)
        }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = UIImage(named: photosName[indexPath.row])
        showSingleImage(image)
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
        return photosName.count
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
