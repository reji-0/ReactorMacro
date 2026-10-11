import UIKit
import RxSwift
import RxRelay

/// Before / After 화면이 함께 쓰는 UI.
/// Reactor와의 연결(`bind(reactor:)`)만 하위 클래스에서 작성합니다.
class NoticeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Reactor로 보낼 이벤트
    
    let initializeTrigger = PublishRelay<Void>()
    let refreshTrigger = PublishRelay<Void>()
    let loadMoreTrigger = PublishRelay<Void>()
    
    var disposeBag = DisposeBag()
    
    private let service: NoticeService
    private var itemList: [Notice] = []
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let refreshControl = UIRefreshControl()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let loadMoreIndicator = UIActivityIndicatorView(style: .medium)
    
    init(service: NoticeService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.refreshControl = refreshControl
        loadMoreIndicator.frame.size.height = 44
        tableView.tableFooterView = loadMoreIndicator
        view.addSubview(tableView)
        
        loadingIndicator.center = view.center
        loadingIndicator.autoresizingMask = [
            .flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin
        ]
        view.addSubview(loadingIndicator)
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        updateFailureButton()
        
        initializeTrigger.accept(())
    }
    
    // MARK: Reactor의 상태를 화면에 반영
    
    func render(itemList: [Notice]) {
        self.itemList = itemList
        tableView.reloadData()
    }
    
    func render(isLoading: Bool) {
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
    
    func render(isRefreshing: Bool) {
        if !isRefreshing { refreshControl.endRefreshing() }
    }
    
    func render(isLoadingMore: Bool) {
        isLoadingMore ? loadMoreIndicator.startAnimating() : loadMoreIndicator.stopAnimating()
    }
    
    func render(error: Error) {
        let alert = UIAlertController(title: "오류", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: Private
    
    @objc private func didPullToRefresh() {
        refreshTrigger.accept(())
    }
    
    @objc private func didTapFailureButton() {
        service.shouldFail.toggle()
        updateFailureButton()
    }
    
    private func updateFailureButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: service.shouldFail ? "오류 발생 ON" : "오류 발생 OFF",
            style: .plain,
            target: self,
            action: #selector(didTapFailureButton)
        )
    }
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = itemList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == itemList.count - 1 {
            loadMoreTrigger.accept(())
        }
    }
}
