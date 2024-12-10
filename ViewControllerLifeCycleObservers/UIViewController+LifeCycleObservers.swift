import UIKit

public typealias voidAction = () -> Void

public protocol UIViewControllerLifecycleObserver {
    func remove()
}

public extension UIViewController {
    /// Adds a lifecycle observer to the view controller that executes a callback
    /// whenever `viewWillAppear(_:)` is called on the view controller.
    ///
    /// Use this method to run custom code when the view controller's view is about
    /// to appear. The observer triggers the provided callback during the
    /// `viewWillAppear(_:)` lifecycle event and can be removed if needed.
    /// - Parameter callback: A closure to execute when `viewWillAppear(_:)` is called.
    /// - Returns: A ```UIViewControllerLifecycleObserver``` object that manages the observer.
    ///
    /// Example usage:
    /// ```swift
    /// override func viewDidLoad() {
    ///     super.viewDidLoad()
    ///
    ///     // Attach an observer to run code during `viewWillAppear(_:)`
    ///     let observer = onViewWillAppear {
    ///         print("View is about to appear!")
    ///     }
    ///
    ///     // Optionally store the observer to remove it later
    ///     self.lifecycleObserver = observer
    /// }
    ///
    /// var lifecycleObserver: UIViewControllerLifecycleObserver?
    /// ```
    /// Call `remove()` on this object to detach the observer when no longer needed.
    ///
    ///  > Important: The callback is executed every time `viewWillAppear(_:)` is called. To prevent memory leaks, ensure you remove the observer when it's no longer needed, such as in `deinit` or `viewWillDisappear(_:)`.)
    @discardableResult
    func onViewWillAppear(run callback: @escaping voidAction) -> UIViewControllerLifecycleObserver {
        let observer = ViewControllerLifeCycleObserver(viewWillApearCallBack: callback)
        add(observer)
        return observer
    }

    private func add(_ observer: UIViewController) {
        addChild(observer)
        observer.view.isHidden = true
        view.addSubview(observer.view)
        observer.didMove(toParent: self)
    }
}



private class ViewControllerLifeCycleObserver: UIViewController {
    private var viewWillApearCallBack: voidAction? = nil

   

    convenience init(
        viewWillApearCallBack: voidAction? = nil
    ) {
        self.init()
        self.viewWillApearCallBack = viewWillApearCallBack
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        viewWillApearCallBack?()
    }
}

extension ViewControllerLifeCycleObserver: UIViewControllerLifecycleObserver {
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()

    }
}

public typealias voidAction = () -> Void
