import UIKit
import RxSwift
import RxCocoa



class ComplementalInformationViewBinding {
    private let complementalInformationModel: ComplementalInformationModel
    private let rootView: ComplementalInformationRootView
    private let disposeBag = RxSwift.DisposeBag()


    init(observing complementalInformationModel: ComplementalInformationModel, handling rootView: ComplementalInformationRootView) {
        self.complementalInformationModel = complementalInformationModel
        self.rootView = rootView

        self.complementalInformationModel.state
            .drive(onNext: { [weak self] validationResult in
                guard let `self` = self else { return }

                self.rootView.readQRCodeButton.isEnabled = validationResult.isValid
            })
            .disposed(by: self.disposeBag)
    }
}
