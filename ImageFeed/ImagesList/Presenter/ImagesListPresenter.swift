import Kingfisher
import UIKit

final class ImagesListPresenter: @preconcurrency ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewProtocol?
    private var imagesListService: ImagesListServiceProtocol
    var photos: [Photo] = []
    
    var photosCount: Int {
        photos.count
    }
    
    init(imagesListService: ImagesListServiceProtocol = ImagesListService.shared) {
            self.imagesListService = imagesListService
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(didReceivePhotosUpdate),
                name: ImagesListService.didChangeNotification,
                object: nil
            )
        }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func photo(at index: Int) -> Photo {
        photos[index]
    }
    
    func sizeForPhoto(at index: Int) -> CGSize {
        let photo = photos[index]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = UIScreen.main.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / photo.size.width
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return CGSize(width: imageViewWidth, height: cellHeight)
    }
    
    @MainActor func configCell(_ cell: ImagesListCell, for index: Int) {
        let photo = photos[index]
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let dateText = photo.createdAt != nil ? dateFormatter.string(from: photo.createdAt!) : "Дата неизвестна"
        
        // Устанавливаем дату и состояние лайка
        cell.configure(with: cell.cellImageView.image, dateText: dateText, isLiked: photo.isLiked)
        
        // Загружаем изображение только если его еще нет
        if cell.cellImageView.image == nil, let url = URL(string: photo.thumbImageURL) {
            cell.startShimmer()
            let processor = RoundCornerImageProcessor(cornerRadius: 0)
            cell.cellImageView.kf.indicatorType = .none
            cell.cellImageView.kf.setImage(
                with: url,
                options: [.processor(processor), .forceRefresh, .cacheMemoryOnly]
            ) { _ in
                cell.stopShimmer()
            }
        }
    }
    
    func didSelectImage(at index: Int) {
        let photo = photos[index]
        if let url = URL(string: photo.largeImageURL) {
            view?.showSingleImage(with: url)
        }
    }
    
    func didTapLike(at index: Int) {
        let photo = photos[index]
        view?.showProgressHUD()
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                self.view?.reloadCell(at: IndexPath(row: index, section: 0))
                self.view?.dismissProgressHUD()
            case .failure(let error):
                self.view?.dismissProgressHUD()
                self.view?.showLikeError(message: "Не удалось изменить статус лайка: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func didReceivePhotosUpdate() {
        let oldCount = photos.count
        photos = imagesListService.photos
        let newCount = photos.count
        
        if oldCount != newCount {
            view?.insertNewRows(from: oldCount, to: newCount)
        }
    }
}
