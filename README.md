# ReactorMacro

[ReactorKit](https://github.com/ReactorKit/ReactorKit)의 `Reactor`를 작성할 때 반복되는 코드를 줄여주는 Swift 매크로 패키지입니다.

로딩 · 새로고침 · 에러처럼 화면마다 똑같이 등장하는 `State` / `Mutation` / `Action` 선언과, 프로퍼티를 그대로 옮겨 적기만 하는 `reduce` 함수를 매크로가 대신 만들어 줍니다.

```swift
import ReactorKit
import ReactorMacro

@GenerateReduce([.loading, .error])

@CompositionAction([.initialize, .refresh])

@CompositionSupport([.loading, .error])

final class NoticeReactor: Reactor {
    enum Action { }

    enum Mutation {
        case setItemList([Notice])
    }

    struct State {
        var itemList: [Notice] = []
    }

    let initialState = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initialize, .refresh:
            return .concat(
                .just(.setIsLoading(true)),
                fetchNotices().map(Mutation.setItemList),
                .just(.setIsLoading(false))
            )
        }
    }
}
```

위 코드는 아래 내용을 직접 작성한 것과 같습니다.

```swift
enum Action {
    case refresh
    case initialize
}

enum Mutation {
    case setItemList([Notice])
    case setIsLoading(Bool)
    case setError(Error)
}

struct State {
    var itemList: [Notice] = []
    var isLoading: Bool = false
    @Pulse var error: Error?
}

func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setItemList(itemList):
        newState.itemList = itemList

    case let .setIsLoading(isLoading):
        newState.isLoading = isLoading

    case let .setError(error):
        newState.error = error
    }

    return newState
}
```

## 요구 사항

- Swift 6.0 이상 (Xcode 16 이상)
- iOS 15 이상 / macOS 10.15 이상
- ReactorKit 3.2.0 이상 — 이 패키지의 의존성으로 함께 설치됩니다.

## 설치

Swift Package Manager로 추가합니다.

```swift
dependencies: [
    .package(url: "https://github.com/reji-0/ReactorMacro.git", branch: "main"),
],
targets: [
    .target(
        name: "MyApp",
        dependencies: [
            .product(name: "ReactorMacro", package: "ReactorMacro"),
        ]
    ),
]
```

Xcode에서는 **File > Add Package Dependencies…** 에 위 URL을 입력합니다. 처음 빌드할 때 매크로를 신뢰할지 묻는 창이 뜨면 **Trust & Enable**을 선택합니다.

생성되는 코드가 `Reactor`, `@Pulse`를 사용하므로 매크로를 쓰는 파일에서는 `import ReactorKit`도 함께 필요합니다.

## 매크로 목록

옵션은 두 종류입니다.

- `StateOptionSet`: `.loading`, `.refresh`, `.error`
- `ActionOptionSet`: `.initialize`, `.refresh`

### Reactor 클래스에 붙이는 매크로

| 매크로 | 하는 일 |
| --- | --- |
| `@CompositionSupport([...])` | 옵션에 해당하는 `State` 프로퍼티와 `Mutation` case를 함께 추가 |
| `@CompositionState([...])` | 옵션에 해당하는 `State` 프로퍼티만 추가 |
| `@CompositionMutation([...])` | 옵션에 해당하는 `Mutation` case만 추가 |
| `@CompositionAction([...])` | 옵션에 해당하는 `Action` case 추가 |
| `@LoadingSupport` / `@RefreshSupport` / `@ErrorSupport` | 한 가지 옵션만 쓰는 `@CompositionSupport` |
| `@GenerateReduce([...])` | `State` 프로퍼티를 읽어 `reduce(state:mutation:)` 생성 |

### State · Mutation · Action에 직접 붙이는 매크로

위 매크로들이 내부에서 사용하는 것으로, 필요하면 직접 붙일 수도 있습니다.

| 옵션 | `struct State` | `enum Mutation` | `enum Action` |
| --- | --- | --- | --- |
| loading | `@LoadingState` → `var isLoading: Bool = false` | `@LoadingMutation` → `case setIsLoading(Bool)` | |
| refresh | `@RefreshState` → `var isRefreshing: Bool = false` | `@RefreshMutation` → `case setIsRefreshing(Bool)` | `@RefreshAction` → `case refresh` |
| error | `@ErrorState` → `@Pulse var error: Error?` | `@ErrorMutation` → `case setError(Error)` | |
| initialize | | | `@InitializeAction` → `case initialize` |

## `@GenerateReduce` 사용 규칙

`@GenerateReduce`는 `State`에 **코드로 적혀 있는** 프로퍼티만 볼 수 있습니다. 그래서 다음 규칙을 지켜야 합니다.

1. **매크로로 추가한 상태는 옵션으로 다시 알려줘야 합니다.** `@CompositionSupport([.loading, .error])`를 썼다면 `@GenerateReduce([.loading, .error])`처럼 같은 옵션을 넘깁니다. 빠뜨리면 `switch`가 모든 case를 처리하지 못해 컴파일 에러가 납니다.
2. **`State` 프로퍼티마다 `set` + 프로퍼티 이름 형태의 `Mutation`이 있어야 합니다.** `var itemList: [Notice]`에는 `case setItemList([Notice])`가 필요합니다.
3. **프로퍼티는 타입을 명시한 `var`로 선언합니다.** `var count = 0`처럼 타입을 생략한 프로퍼티는 `reduce`에 포함되지 않습니다.
4. `reduce`에 다른 로직이 필요하면 `@GenerateReduce`를 빼고 직접 작성합니다.

## 제약 사항

- 클래스에 붙이는 매크로는 선언부에 `Reactor`(또는 `ReactorKit.Reactor`)를 직접 채택한 `class`에만 쓸 수 있습니다. extension에서 채택한 경우는 인식하지 못합니다.
- 타입 이름은 `State`(struct), `Mutation`(enum), `Action`(enum)이어야 하고 Reactor 클래스 안에 선언되어 있어야 합니다.
- `Action`에 직접 작성한 case가 없어도 `enum Action { }` 선언은 있어야 합니다.

조건에 맞지 않으면 컴파일 시 다음 에러가 표시됩니다.

| 에러 메시지 | 원인 |
| --- | --- |
| `can only be applied to classes.` | class가 아닌 곳에 클래스용 매크로를 붙임 |
| `can only be applied to classes that inherit from Reactor.` | `Reactor`를 채택하지 않은 클래스 |
| `can only be applied to structs.` / `structs named 'State'.` | `State`가 struct가 아니거나 이름이 다름 |
| `can only be applied to enums.` / `enums named 'Mutation'.` / `enums named 'Action'.` | enum이 아니거나 이름이 다름 |

## 샘플앱

`Example/`에 같은 화면을 두 가지 방식으로 구현한 iOS 앱이 있습니다. 공지사항 목록 화면(초기 로딩, 당겨서 새로고침, 페이징, 에러 알림)을 **Before** 탭은 매크로 없이, **After** 탭은 ReactorMacro로 작성한 Reactor로 띄웁니다. 동작은 같습니다.

| 파일 | 줄 수 |
| --- | --- |
| [`BeforeNoticeReactor.swift`](Example/ReactorMacroExample/Before/BeforeNoticeReactor.swift) | 107 |
| [`AfterNoticeReactor.swift`](Example/ReactorMacroExample/After/AfterNoticeReactor.swift) | 74 |

`mutate` 로직은 두 파일이 똑같고, After에서는 loading · refresh · error 관련 선언과 `reduce` 함수 전체가 사라집니다. `reduce`는 `State` 프로퍼티 하나당 4줄씩 늘어나므로, 상태가 많은 화면일수록 차이가 커집니다.

`Example/ReactorMacroExample.xcodeproj`를 열어 실행합니다. 프로젝트 파일은 `Example/project.yml`에서 [XcodeGen](https://github.com/yonaskolb/XcodeGen)으로 생성한 것입니다.

## 개발

```bash
swift build
swift test
swift run ReactorMacroClient   # 매크로 동작 확인용 예제
```

| 타깃 | 역할 |
| --- | --- |
| `ReactorMacro` | 매크로 선언. 사용하는 쪽에서 import하는 모듈 |
| `ReactorMacroPlugin` | 매크로 구현 (컴파일러 플러그인) |
| `ReactorMacroShared` | `StateOptionSet`, `ActionOptionSet` |
| `ReactorMacroClient` | 예제 실행 파일 |
| `Example/` | 샘플 iOS 앱 (패키지 타깃 아님) |
