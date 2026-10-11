import ReactorKit
import ReactorMacro
import RxSwift

/// ReactorMacro로 작성한 Reactor. 동작은 `BeforeNoticeReactor`와 같습니다.
@GenerateReduce([.loading, .refresh, .error])
@CompositionAction([.initialize, .refresh])
@CompositionSupport([.loading, .refresh, .error])
final class AfterNoticeReactor: Reactor {
    enum Action {
        case loadMore
    }
    
    enum Mutation {
        case setItemList([Notice])
        case setPage(Int)
        case setHasMore(Bool)
        case setIsLoadingMore(Bool)
    }
    
    struct State {
        var itemList: [Notice] = []
        var page: Int = 0
        var hasMore: Bool = false
        var isLoadingMore: Bool = false
    }
    
    let initialState = State()
    private let service: NoticeService
    
    init(service: NoticeService) {
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initialize:
            return .concat(
                .just(.setIsLoading(true)),
                fetchNotices(page: 1),
                .just(.setIsLoading(false))
            )
            
        case .refresh:
            return .concat(
                .just(.setIsRefreshing(true)),
                fetchNotices(page: 1),
                .just(.setIsRefreshing(false))
            )
            
        case .loadMore:
            guard currentState.hasMore, !currentState.isLoadingMore else { return .empty() }
            return .concat(
                .just(.setIsLoadingMore(true)),
                fetchNotices(page: currentState.page + 1),
                .just(.setIsLoadingMore(false))
            )
        }
    }
    
    private func fetchNotices(page: Int) -> Observable<Mutation> {
        let previous = page == 1 ? [] : currentState.itemList
        
        return service.fetchNotices(page: page)
            .flatMap { result -> Observable<Mutation> in
                .of(
                    .setItemList(previous + result.items),
                    .setPage(page),
                    .setHasMore(result.hasMore)
                )
            }
            .catch { .just(.setError($0)) }
    }
}
