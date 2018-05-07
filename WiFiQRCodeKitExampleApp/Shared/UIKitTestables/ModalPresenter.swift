import UIKit



protocol ModalPresenter {
    func present(viewController: UIViewController, animated: Bool)
}



class ViewControllerModalPresenter: ModalPresenter {
    private weak var baseViewController: UIViewController?


    init(on baseViewController: UIViewController) {
        self.baseViewController = baseViewController
    }


    func present(viewController: UIViewController, animated: Bool) {
        self.baseViewController?.present(viewController, animated: animated)
    }
}
