import UIKit
import RxCocoa


protocol ModalDissolver {
    var completion: RxCocoa.Signal<Void> { get }

    func dismiss(animated: Bool)
}


class ViewControllerModalDissolver: ModalDissolver {
    private weak var viewController: UIViewController?
    private let completionRelay: RxCocoa.PublishRelay<Void>
    let completion: RxCocoa.Signal<Void>


    init(willDismiss viewController: UIViewController) {
        self.viewController = viewController

        let completionRelay = RxCocoa.PublishRelay<Void>()
        self.completionRelay = completionRelay
        self.completion = completionRelay.asSignal()
    }


    func dismiss(animated: Bool) {
        self.viewController?.dismiss(animated: animated, completion: { [weak self] in
            guard let `self` = self else { return }

            self.completionRelay.accept(())
        })
    }
}
