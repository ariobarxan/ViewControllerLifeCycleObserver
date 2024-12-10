import XCTest
@testable import ViewControllerLifeCycleObservers

final class ViewControllerLifeCycleObserversTests: XCTestCase {

    // MARK: - viewWillAppear Event
    func test_viewWillAppearObserverIsAddedAsChild() {
        let sut = UIViewController()

        sut.onViewWillAppear {}

        XCTAssertEqual(sut.children.count, 1 )
    }

    func test_viewWillAppearObserverViewIsAddedAsSubview() {
        let sut = UIViewController()

        sut.onViewWillAppear {}

        let observer = sut.children.first
        XCTAssertEqual(observer?.view.superview, sut.view)
    }


    func test_viewWillAppearObserverViewIsInvisible() {
        let sut = UIViewController()

        sut.onViewWillAppear {}

        let observer = sut.children.first
        XCTAssertEqual(observer?.view.isHidden, true)
    }

    func test_viewWillAppearObserverViewControllerFiresCallback() {
        let sut = UIViewController()

        var callCount = 0
        sut.onViewWillAppear {
            callCount += 1
        }
        
        let observer = sut.children.first
        XCTAssertEqual(callCount, 0)

        observer?.viewWillAppear(false)
        XCTAssertEqual(callCount, 1)

        observer?.viewWillAppear(false)
        XCTAssertEqual(callCount, 2)
    }

    func test_viewWillAppearObserverIsRemovable() {
        let sut = UIViewController()

        sut.onViewWillAppear (run: {}).remove()

        XCTAssertEqual(sut.children.count, 0)
    }

    func test_viewWillAppearObserverViewIsRemovable() {
        let sut = UIViewController()

        sut.onViewWillAppear (run: {}).remove()

        XCTAssertEqual(sut.view.subviews.count, 0)
    }

    // MARK: - loadView Event
    func test_loadViewObserverIsAddedAsChild() {
        let sut = UIViewController()

        sut.onLoadView(run: {})

        XCTAssertEqual(sut.children.count, 1)
    }

    func test_loadViewObserverViewIsAddedAsSubview() {
        let sut = UIViewController()

        sut.onLoadView {}
        let observer = sut.children.first
        XCTAssertEqual(observer?.view.superview, sut.view)
    }

    func test_loadViewObserverViewIsInvisible() {
        let sut = UIViewController()

        sut.onLoadView {}
        let observer = sut.children.first

        XCTAssertEqual(observer?.view.isHidden, true)
    }

    func test_loadViewObserverCallBackGetsFired() {
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

    func test_loadViewObserverIsRemovable() {
        let sut = UIViewController()

        sut.onViewWillAppear (run: {}).remove()

        XCTAssertEqual(sut.children.count, 0)
    }

    func test_loadViewObserverViewIsRemovable() {
        let sut = UIViewController()

        sut.onViewWillAppear (run: {}).remove()

        XCTAssertEqual(sut.view.subviews.count, 0)
    }
}
