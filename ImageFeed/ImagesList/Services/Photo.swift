import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

extension Photo {
    init(from photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = Self.dateFormatter.date(from: photoResult.createdAt ?? "")
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.full
        self.isLiked = photoResult.likedByUser
    }
    
    static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
}
