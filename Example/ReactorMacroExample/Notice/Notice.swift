import Foundation

struct Notice: Equatable {
    let id: Int
    let title: String
}

struct NoticePage {
    let items: [Notice]
    let hasMore: Bool
}
