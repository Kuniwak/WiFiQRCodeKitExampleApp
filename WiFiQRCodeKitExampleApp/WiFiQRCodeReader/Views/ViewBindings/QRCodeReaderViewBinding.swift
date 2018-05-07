import UIKit
import RxSwift
import RxCocoa



class QRCodeReaderViewBinding {
    private let modalDissolver: ModalDissolver
    private let model: QRCodeReaderModel
    private let disposeBag = RxSwift.DisposeBag()


    init(observing model: QRCodeReaderModel, dismissingBy modalDissolver: ModalDissolver) {
        self.model = model
        self.modalDissolver = modalDissolver

        self.model.state
            .drive(onNext: { [weak self] state in
                guard let `self` = self else { return }

                self.modalDissolver.dismiss(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
}
