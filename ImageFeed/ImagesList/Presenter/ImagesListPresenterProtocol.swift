import Foundation
import UIKit

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    
    var photosCount: Int { get }
    func viewDidLoad()
    func photo(at index: Int) -> Photo
    func sizeForPhoto(at index: Int) -> CGSize
    func configCell(_ cell: ImagesListCell, for index: Int)
    func didSelectImage(at index: Int)
    func didTapLike(at index: Int)
}
