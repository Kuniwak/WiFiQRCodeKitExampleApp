import RxSwift
import RxCocoa



protocol ComplementalInformationModel {
    var state: RxCocoa.Driver<ComplementalInformationModelState> { get }

    func validate(draft: PartialMobileConfig.Draft)
}


typealias ComplementalInformationModelState = PartialMobileConfig.ValidationResult



class DefaultComplementalInformationModel: ComplementalInformationModel {
    private let stateRelay: RxCocoa.BehaviorRelay<ComplementalInformationModelState>
    let state: RxCocoa.Driver<ComplementalInformationModelState>


    init(startingWith initialDraft: PartialMobileConfig.Draft) {
        let stateRelay = RxCocoa.BehaviorRelay(value: PartialMobileConfig.validate(draft: initialDraft))
        self.stateRelay = stateRelay
        self.state = stateRelay.asDriver()
    }


    func validate(draft: PartialMobileConfig.Draft) {
        self.stateRelay.accept(
            PartialMobileConfig.validate(draft: draft)
        )
    }
}