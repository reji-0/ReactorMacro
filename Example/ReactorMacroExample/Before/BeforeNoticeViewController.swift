import ReactorKit
import RxCocoa
import RxSwift

final class BeforeNoticeViewController: NoticeListViewController, View {
    func bind(reactor: BeforeNoticeReactor) {
        // Action
        initializeTrigger
            .map { Reactor.Action.initialize }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        refreshTrigger
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        loadMoreTrigger
            .map { Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map(\.itemList)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in self?.render(itemList: $0) })
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isLoading)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in self?.render(isLoading: $0) })
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isRefreshing)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in self?.render(isRefreshing: $0) })
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isLoadingMore)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in self?.render(isLoadingMore: $0) })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] in self?.render(error: $0) })
            .disposed(by: disposeBag)
    }
}
