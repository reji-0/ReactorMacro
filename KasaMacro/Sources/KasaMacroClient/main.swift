import Foundation
import KasaMacro


@GenerateReduce([.error, .loading, .refresh])
@CompositionAction([.initialize, .refresh])
@CompositionMutation([.error, .loading, .refresh])
@CompositionState([.error, .loading, .refresh])
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
        default:
            break
        }
    }
}


let reactor = ExampleReactor()
let state = ExampleReactor.State()

print(Date())
print(state.error)

