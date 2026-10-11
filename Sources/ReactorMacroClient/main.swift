import Foundation
import ReactorKit
import ReactorMacro
import RxSwift


@GenerateReduce([.error, .loading, .refresh])
@CompositionAction([.initialize, .refresh])
@CompositionSupport([.error, .loading, .refresh])
final class ExampleReactor: Reactor {
    enum Action {
    }

    enum Mutation {
        case setIsLoadingMore(Bool)
        case setItemList([Int])
        case setHasMore(Bool)
    }
    
    struct State {
        var isLoadingMore: Bool = false // 페이징 상태
        var itemList: [Int] = []        // 공지사항 아이템
        var hasMore: Bool = false       // 페이징 가능, 불가능 상태
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initialize:
            return .concat(
                .just(.setIsLoading(true)),
                .just(.setItemList([1, 2, 3])),
                .just(.setIsLoading(false))
            )
            
        case .refresh:
            return .concat(
                .just(.setIsRefreshing(true)),
                .just(.setItemList([4, 5, 6])),
                .just(.setIsRefreshing(false))
            )
        }
    }
}


let reactor = ExampleReactor()
let disposable = reactor.state.subscribe(onNext: { state in
    print(state.itemList, state.isLoading, state.isRefreshing, state.error as Any)
})

reactor.action.onNext(.initialize)
reactor.action.onNext(.refresh)
disposable.dispose()
