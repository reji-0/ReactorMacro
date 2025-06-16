
# KasaMacro 가이드

## 소개
KasaMacro는 ReactorKit을 더욱 편리하게 사용할 수 있도록 도와주는 Swift 매크로 모듈입니다. 반복적인 코드 작성을 줄이고, 일관된 패턴을 유지할 수 있도록 도와줍니다.

## 주요 기능

### 1. 상태 관리 매크로

#### 단일 상태 매크로
```swift
@LoadingState    // isLoading: Bool = false
@RefreshState    // isRefreshing: Bool = false
@ErrorState      // @Pulse var error: Error?
```

#### 복합 상태 매크로
```swift
@CompositionState([.loading, .refresh, .error])
```

### 2. 액션 관리 매크로

#### 단일 액션 매크로
```swift
@RefreshAction     // case refresh
@InitializeAction  // case initialize
```

#### 복합 액션 매크로
```swift
@CompositionAction([.refresh, .initialize])
```

### 3. 뮤테이션 관리 매크로

#### 단일 뮤테이션 매크로
```swift
@LoadingMutation    // case setIsLoading(Bool)
@RefreshMutation    // case setIsRefreshing(Bool)
@ErrorMutation      // case setError(Error)
```

#### 복합 뮤테이션 매크로
```swift
@CompositionMutation([.loading, .refresh, .error])
```

### 4. 통합 지원 매크로

#### 단일 기능 지원
```swift
@LoadingSupport    // @LoadingState + @LoadingMutation
@RefreshSupport    // @RefreshState + @RefreshMutation
@ErrorSupport      // @ErrorState + @ErrorMutation
```

#### 복합 기능 지원
```swift
@CompositionSupport([.loading, .refresh, .error])
```

### 5. 리듀스 함수 생성
```swift
@GenerateReduce([.loading, .refresh, .error])
```

## 사용 예시

```swift
@GenerateReduce([.error, .loading, .refresh])
@CompositionAction([.initialize, .refresh])
@CompositionSupport([.error, .loading, .refresh])
class ExampleReactor: Reactor {
    enum Action {
        // @CompositionAction에 의해 자동으로 추가됨
        // case initialize
        // case refresh
    }

    enum Mutation {
        case setIsLoadingMore(Bool)
        case setItemList([Int])
        case setHasMore(Bool)
        // @CompositionSupport에 의해 자동으로 추가됨
        // case setIsLoading(Bool)
        // case setIsRefreshing(Bool)
        // case setError(Error)
    }
    
    struct State {
        var isLoadingMore: Bool = false
        var itemList: [Int] = []
        var hasMore: Bool = false
        // @CompositionSupport에 의해 자동으로 추가됨
        // var isLoading: Bool = false
        // var isRefreshing: Bool = false
        // @Pulse var error: Error?
    }
}
```

## 주의사항

1. 모든 매크로는 `Reactor`를 상속받는 클래스에서만 사용할 수 있습니다.
2. `State`는 반드시 `struct`로 선언해야 합니다.
3. `Action`과 `Mutation`은 반드시 `enum`으로 선언해야 합니다.
4. `@GenerateReduce` 매크로는 코드로 작성된 `State` 속성들만 자동으로 처리합니다. 매크로로 생성된 `State` 값은 파라미터로 명시해야 합니다.

## 에러 처리

매크로 사용 시 다음과 같은 에러가 발생할 수 있습니다:

- `notInheritingReactor`: Reactor를 상속받지 않은 클래스에 매크로 적용
- `notStruct`: State가 struct가 아닌 경우
- `notEnum`: Action이나 Mutation이 enum이 아닌 경우
- `invalidNameForState`: State의 이름이 "State"가 아닌 경우
- `invalidNameForAction`: Action의 이름이 "Action"이 아닌 경우
- `invalidNameForMutation`: Mutation의 이름이 "Mutation"이 아닌 경우
