import UIKit
import RxSwift
import RxCocoa



class ComplementalInformationController {
    private let rootView: ComplementalInformationRootView
    private let model: ComplementalInformationModel
    private let disposeBag = RxSwift.DisposeBag()


    init(observing rootView: ComplementalInformationRootView, notifyingTo model: ComplementalInformationModel) {
        self.rootView = rootView
        self.model = model

        RxCocoa.Driver
            .combineLatest(
                rootView.organizationNameTextField.rx.text.orEmpty.asDriver(),
                rootView.identityTextField.rx.text.orEmpty.asDriver(),
                rootView.displayNameTextField.rx.text.orEmpty.asDriver(),
                rootView.descriptionTextField.rx.text.orEmpty.asDriver(),
                rootView.consentTextTextField.rx.text.orEmpty.asDriver(),
                resultSelector: { (
                    organizationNameText,
                    identifierText,
                    displayNameText,
                    descriptionText,
                    consentTextText
                ) in PartialMobileConfig.Draft(
                        organization: organizationNameText,
                        identifier: identifierText,
                        displayName: displayNameText,
                        description: descriptionText,
                        consentText: consentTextText
                    )
                }
            )
            .drive(onNext: { [weak self] draft in
                guard let `self` = self else { return }

                self.model.validate(draft: draft)
            })
            .disposed(by: self.disposeBag)
    }
}