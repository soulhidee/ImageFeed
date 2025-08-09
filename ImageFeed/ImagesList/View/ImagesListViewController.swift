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
    
    // MARK: - Properties
    var presenter: ImagesListPresenterProtocol? = ImagesListPresenter()
    
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
        configureTransparentNavigationBar()
        presenter?.view = self
        presenter?.viewDidLoad()
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
    
    // MARK: - Navigation
    private func configureTransparentNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]
    }
}

// MARK: - ImagesListViewProtocol
extension ImagesListViewController: ImagesListViewProtocol {
    func insertNewRows(from oldCount: Int, to newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func updateTableViewAnimated() {
        tableView.reloadData()
    }
    
    func reloadCell(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showLikeError(message: String) {
        let alert = UIAlertController(
            title: ImagesListConstants.errorAlertTitle,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: ImagesListConstants.errorAlertAction, style: .default))
        present(alert, animated: true)
    }
    
    func showProgressHUD() {
        UIBlockingProgressHUD.show()
    }
    
    func dismissProgressHUD() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func showSingleImage(with url: URL) {
        let vc = SingleImageViewController()
        vc.fullImageURL = url
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectImage(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.sizeForPhoto(at: indexPath.row).height ?? ImagesListConstants.rowHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + ImagesListConstants.prefetchThreshold == presenter?.photosCount ?? 0 {
            presenter?.viewDidLoad()
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photosCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imageListCell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        presenter?.configCell(imageListCell, for: indexPath.row)
        return imageListCell
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.didTapLike(at: indexPath.row)
    }
}
