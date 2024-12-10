import XCTest
@testable import ViewControllerLifeCycleObservers

final class ViewControllerLifeCycleObserversTests: XCTestCase {

    // MARK: - viewWillAppear Event
    func test_viewWillAppearObserverIsAddedAsChild() {
        assertObserverIsAddedAsChild{ sut in
            sut.onViewWillAppear {}
        }
    }

    func test_viewWillAppearObserverViewIsAddedAsSubview() {
        assertObserverViewIsAddedAsSubView { sut in
            sut.onViewWillAppear {}
        }
    }

    func test_viewWillAppearObserverViewIsInvisible() {
        assertObserverViewViewIsInvisible{ sut in
            sut.onViewWillAppear {}
        }
    }

    func test_viewWillAppearObserverViewControllerFiresCallback() {
        assertObserver(
            firesCallback: { $0.onViewWillAppear(run:) },
            when: { $0.viewWillAppear(false)})
    }

    func test_viewWillAppearObserverIsRemovable() {
        assertObserverIsRemovable{ sut in
            sut.onViewWillAppear {}
        }
    }

    func test_viewWillAppearObserverViewIsRemovable() {
        assertObserverIsRemovable{ sut in
            sut.onViewWillAppear (run: {})
        }
    }

    // MARK: - loadView Event
    func test_loadViewObserverIsAddedAsChild() {
        assertObserverIsAddedAsChild{ sut in
            sut.onLoadView{}
        }
    }

    func test_loadViewObserverViewIsAddedAsSubview() {
        assertObserverViewIsAddedAsSubView { sut in
            sut.onLoadView {}
        }
    }

    func test_loadViewObserverViewIsInvisible() {
        assertObserverViewViewIsInvisible{ sut in
            sut.onLoadView {}
        }
    }

    func test_loadViewObserverCallBackGetsFired() {
        assertObserverCallbackDuringInitialization(
            firesCallback: { $0.onLoadView(run:) },
            when: { $0.loadView()})
    }

    func test_loadViewObserverIsRemovable() {
        assertObserverIsRemovable{ sut in
            sut.onLoadView {}
        }
    }

    func test_loadViewObserverViewIsRemovable() {
        assertObserverIsRemovable{ sut in
            sut.onLoadView {}
        }
    }

    // MARK: - viewDidLoad Event
    func test_viewDidLoadObserverIsAddedAsChild() {
        assertObserverIsAddedAsChild { sut in
            sut.onViewDidLoad {}
        }
    }

    func test_viewDidLoadObserverViewIsAddedAsSubview() {
        assertObserverViewIsAddedAsSubView { sut in
            sut.onViewDidLoad {}
        }
    }

    func test_viewDodLoadObserverViewIsInvisible() {
        assertObserverViewViewIsInvisible { sut in
            sut.onViewDidLoad {}
        }
    }

    func test_viewDidLoadObserverCallbackGetsFired() {
        assertObserverCallbackDuringInitialization(
            firesCallback: { $0.onViewDidLoad(run:) },
            when: { $0.viewDidLoad()})
    }

    func test_viewDidLoadObserverIsRemovable() {
        assertObserverIsRemovable{ sut in
            sut.onViewDidLoad {}
        }
    }

    func test_viewDidLoadObserverViewIsRemovable() {
        assertObserverViewIsRemovable{ sut in
            sut.onViewDidLoad {}
        }
    }

    // MARK: - Helpers

    func assertObserverIsAddedAsChild(on action: @escaping (UIViewController) -> Void, file: StaticString = #file, line: UInt = #line) {
        let sut = UIViewController()
        action(sut)

        XCTAssertEqual(sut.children.count, 1, file: file, line: line)
    }

    func assertObserverViewIsAddedAsSubView(on action: @escaping (UIViewController) -> Void, file: StaticString = #file, line: UInt = #line) {
        let sut = UIViewController()
        action(sut)
        let observer = sut.children.first

        XCTAssertEqual(observer?.view.superview, sut.view, file: file, line: line)
    }

    func assertObserverViewViewIsInvisible(on action: @escaping (UIViewController) -> Void, file: StaticString = #file, line: UInt = #line) {
        let sut = UIViewController()
        action(sut)
        let observer = sut.children.first

        XCTAssertEqual(observer?.view.isHidden, true, file: file, line: line)
    }

    func assertObserverIsRemovable(on action: @escaping (UIViewController) -> UIViewControllerLifecycleObserver, file: StaticString = #file, line: UInt = #line) {
        let sut = UIViewController()
        action(sut).remove()

        XCTAssertEqual(sut.children.count, 0, file: file, line: line)
    }

    func assertObserverViewIsRemovable(on action: @escaping (UIViewController) -> UIViewControllerLifecycleObserver, file: StaticString = #file, line: UInt = #line) {
        let sut = UIViewController()
        action(sut).remove()

        XCTAssertEqual(sut.view.subviews.count, 0)
    }

    func assertObserver(
        firesCallback callback: (UIViewController) -> ((@escaping () -> Void) -> UIViewControllerLifecycleObserver),
        when action: @escaping (UIViewController) -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
            let sut = UIViewController()

            var callCount = 0
            _ = callback(sut)({ callCount += 1 })

            let observer = sut.children.first!
            XCTAssertEqual(callCount, 0, file: file, line: line)

            action(observer)
            XCTAssertEqual(callCount, 1, file: file, line: line)

            action(observer)
            XCTAssertEqual(callCount, 2, file: file, line: line)
        }

    func assertObserverCallbackDuringInitialization(
        firesCallback callback: (UIViewController) -> ((@escaping () -> Void) -> UIViewControllerLifecycleObserver),
        when action: @escaping (UIViewController) -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let sut = UIViewController()

        var callCount = 0
        sut.onLoadView {
            callCount += 1
        }

        let observer = sut.children.first
        XCTAssertEqual(callCount, 1)

        observer?.loadView()
        XCTAssertEqual(callCount, 2)

        observer?.loadView()
        XCTAssertEqual(callCount, 3)
    }
}
