import Foundation
import RxSwift

enum NoticeError: LocalizedError {
    case network
    
    var errorDescription: String? {
        "공지사항을 불러오지 못했습니다."
    }
}

/// 네트워크를 흉내내는 서비스. `shouldFail`을 켜면 다음 요청부터 에러를 내려줍니다.
final class NoticeService {
    var shouldFail = false
    
    private let pageSize = 15
    private let lastPage = 3
    
    func fetchNotices(page: Int) -> Observable<NoticePage> {
        let result: Observable<NoticePage>
        
        if shouldFail {
            result = .error(NoticeError.network)
        } else {
            let start = (page - 1) * pageSize + 1
            let items = (start..<start + pageSize).map { Notice(id: $0, title: "공지사항 \($0)") }
            result = .just(NoticePage(items: items, hasMore: page < lastPage))
        }
        
        return result.delaySubscription(.milliseconds(700), scheduler: MainScheduler.instance)
    }
}
