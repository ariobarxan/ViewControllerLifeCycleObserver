import UIKit

public protocol UIViewControllerLifecycleObserver {
    func remove()
}

public extension UIViewController {
    @discardableResult
    func onViewWillAppear(run callback: @escaping () -> Void) -> UIViewControllerLifecycleObserver {
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
    private var viewWillApearCallBack: () -> Void = {}

    convenience init(viewWillApearCallBack: @escaping () -> Void) {
        self.init()
        self.viewWillApearCallBack = viewWillApearCallBack
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        viewWillApearCallBack()
    }
}

extension ViewControllerLifeCycleObserver: UIViewControllerLifecycleObserver {
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()

    }
}

