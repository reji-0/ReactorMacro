import Foundation
import ReactorMacro


@GenerateReduce([.error, .loading, .refresh])
@CompositionAction([.initialize, .refresh])
@CompositionSupport([.error, .loading, .refresh])
class ExampleReactor: Reactor  {
    enum Action {
    }

    enum Mutation{
        case setIsLoadingMore(Bool)
        case setItemList([Int])
        case setHasMore(Bool)
    }
    
    struct State {
        var isLoadingMore: Bool = false // 페이징 상태
        var itemList: [Int] = []        // 공지사항 아이템
        var hasMore: Bool = false       // 페이징 가능, 불가능 상태
    }
    
    func mutate(action: Action)  {
        switch action {
        case .initialize, .refresh:
            break
        }
    }
}


let reactor = ExampleReactor()
var state = ExampleReactor.State()

state = reactor.reduce(state: state, mutation: .setItemList([1, 2, 3]))
state = reactor.reduce(state: state, mutation: .setIsLoading(true))
state = reactor.reduce(state: state, mutation: .setIsRefreshing(true))

print(state.itemList, state.isLoading, state.isRefreshing, state.error as Any)
