import UIKit
import QRCodeReader
import RxSwift
import RxCocoa



class WiFiQRCodeReaderModalPresenter {
    private let rootView: ComplementalInformationRootView
    private let modalPresenter: ModalPresenter
    private let disposeBag = RxSwift.DisposeBag()
    private let dependency: WiFiQRCodeReaderViewController.Dependency


    init(
        observing rootView: ComplementalInformationRootView,
        presentingBy modalPresenter: ModalPresenter,
        dependency: WiFiQRCodeReaderViewController.Dependency
    ) {
        self.rootView = rootView
        self.modalPresenter = modalPresenter
        self.dependency = dependency

        self.rootView.readQRCodeButton.rx.tap
            .asSignal()
            .emit(onNext: { [weak self] _ in
                guard let `self` = self else { return }

                self.modalPresenter.present(
                    viewController: WiFiQRCodeReaderViewController(dependency: self.dependency),
                    animated: true
                )
            })
            .disposed(by: self.disposeBag)
    }
}
