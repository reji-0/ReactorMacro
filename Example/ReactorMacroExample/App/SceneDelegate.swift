import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        /// 같은 화면을 두 가지 방식의 Reactor로 띄웁니다. 동작은 완전히 같습니다.
        let beforeService = NoticeService()
        let before = BeforeNoticeViewController(service: beforeService)
        before.reactor = BeforeNoticeReactor(service: beforeService)
        before.title = "Before"
        before.tabBarItem = UITabBarItem(title: "Before", image: UIImage(systemName: "pencil"), tag: 0)
        
        let afterService = NoticeService()
        let after = AfterNoticeViewController(service: afterService)
        after.reactor = AfterNoticeReactor(service: afterService)
        after.title = "After"
        after.tabBarItem = UITabBarItem(title: "After", image: UIImage(systemName: "wand.and.stars"), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: before),
            UINavigationController(rootViewController: after),
        ]
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
}
