import RxSwift
import RxCocoa
import WiFiQRCodeKit



protocol MobileConfigModel {
    var state: RxCocoa.Driver<MobileConfigModelState> { get }
}



enum MobileConfigModelState {
    case blank
    case failed(because: FailureReason)
    case ready(mobileConfig: WiFiQRCodeKit.MobileConfig, partialMobileConfig: PartialMobileConfig)


    enum FailureReason {
        case partialMobileConfigProblem(PartialMobileConfig.FailureReason)
        case qrCodeReaderProblem(QRCodeReaderModelState.FailureReason)
    }
}



class DefaultMobileConfigModel: MobileConfigModel {
    typealias Dependency = (
        complementalInformationModel: ComplementalInformationModel,
        qrCodeReaderModel: QRCodeReaderModel
    )
    private let dependency: Dependency
    private let stateRelay: RxCocoa.BehaviorRelay<MobileConfigModelState>
    let state: RxCocoa.Driver<MobileConfigModelState>
    private let disposeBag = RxSwift.DisposeBag()


    init(
        startingWith initialState: MobileConfigModelState,
        observing dependency: Dependency
    ) {
        let stateRelay = RxCocoa.BehaviorRelay(value: initialState)
        self.stateRelay = stateRelay
        self.state = stateRelay.asDriver()
        self.dependency = dependency

        RxCocoa.Driver
            .combineLatest(
                self.dependency.complementalInformationModel.state,
                self.dependency.qrCodeReaderModel.state,
                resultSelector: { ($0, $1) }
            )
            .drive(onNext: { [weak self] (states: (ComplementalInformationModelState, QRCodeReaderModelState)) in
                guard let `self` = self else { return }

                switch states {
                case (.success(content: let partialMobileConfig), .success(wiFiQRCode: let wiFiQRCode)):
                    self.update(
                        by: partialMobileConfig,
                        by: wiFiQRCode
                    )

                case (.failed(because: let reason), _):
                    self.fail(because: .partialMobileConfigProblem(reason))

                case (_, .failed(because: let reason)):
                    self.fail(because: .qrCodeReaderProblem(reason))

                case (_, .waiting):
                    // Do nothing.
                    return
                }
            })
            .disposed(by: self.disposeBag)
    }


    fileprivate func update(by partialMobileConfig: PartialMobileConfig, by wiFiQRCode: WiFiQRCode) {
        let mobileConfig = WiFiQRCodeKit.MobileConfig.from(
            wiFiQRCode: wiFiQRCode,
            organization: partialMobileConfig.organization,
            identifier: partialMobileConfig.identifier,
            description: partialMobileConfig.description,
            displayName: partialMobileConfig.displayName,
            consentText: partialMobileConfig.consentText
        )

        self.stateRelay.accept(.ready(
            mobileConfig: mobileConfig,
            partialMobileConfig: partialMobileConfig
        ))
    }


    fileprivate func fail(because reason: MobileConfigModelState.FailureReason) {
        self.stateRelay.accept(.failed(because: reason))
    }
}