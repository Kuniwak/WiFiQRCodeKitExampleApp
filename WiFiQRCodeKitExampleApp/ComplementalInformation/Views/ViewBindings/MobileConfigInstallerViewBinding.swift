import RxSwift
import RxCocoa
import WiFiQRCodeKit



class MobileConfigInstallerViewBinding {
    private let model: MobileConfigModel
    private let installer: WiFiQRCodeKit.MobileConfig.Installer
    private let disposeBag = RxSwift.DisposeBag()


    init(
        observing model: MobileConfigModel,
        installingBy installer: WiFiQRCodeKit.MobileConfig.Installer
    ) {
        self.model = model
        self.installer = installer

        self.model.state
            .drive(onNext: { [weak self] state in
                guard let `self` = self else { return }

                switch state {
                case .blank, .failed:
                    return

                case .ready(mobileConfig: let mobileConfig, partialMobileConfig: _):
                    switch self.installer.install(mobileConfig: mobileConfig) {
                    case .confirming:
                        return
                    case .failed(because: let reason):
                        dump(reason)
                    }
                }
            })
            .disposed(by: self.disposeBag)
    }
}
