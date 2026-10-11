import ReactorKit
import RxSwift

/// 매크로 없이 작성한 Reactor.
final class BeforeNoticeReactor: Reactor {
    enum Action {
        case initialize
        case refresh
        case loadMore
    }
    
    enum Mutation {
        case setItemList([Notice])
        case setPage(Int)
        case setHasMore(Bool)
        case setIsLoadingMore(Bool)
        case setIsLoading(Bool)
        case setIsRefreshing(Bool)
        case setError(Error)
    }
    
    struct State {
        var itemList: [Notice] = []
        var page: Int = 0
        var hasMore: Bool = false
        var isLoadingMore: Bool = false
        var isLoading: Bool = false
        var isRefreshing: Bool = false
        @Pulse var error: Error?
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
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setItemList(itemList):
            newState.itemList = itemList
            
        case let .setPage(page):
            newState.page = page
            
        case let .setHasMore(hasMore):
            newState.hasMore = hasMore
            
        case let .setIsLoadingMore(isLoadingMore):
            newState.isLoadingMore = isLoadingMore
            
        case let .setIsLoading(isLoading):
            newState.isLoading = isLoading
            
        case let .setIsRefreshing(isRefreshing):
            newState.isRefreshing = isRefreshing
            
        case let .setError(error):
            newState.error = error
        }
        
        return newState
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
