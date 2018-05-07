import UIKit
import WiFiQRCodeKit



class ComplementalInformationViewController: UIViewController {
    private let dependency: Dependency
    private var wiFiQRCodeModalPresenter: WiFiQRCodeReaderModalPresenter?
    private var mobileConfigInstallerViewBinding: MobileConfigInstallerViewBinding?
    private var complementalInformationViewBinding: ComplementalInformationViewBinding?
    private var complementalInformationController: ComplementalInformationController?

    typealias Dependency = (
        complementalInformationModel: ComplementalInformationModel,
        qrCodeReaderModel: QRCodeReaderModel,
        mobileConfigModel: MobileConfigModel,
        installer: WiFiQRCodeKit.MobileConfig.Installer
    )

    
    init(dependency: Dependency) {
        self.dependency = dependency

        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }


    override func loadView() {
        let rootView = ComplementalInformationRootView()
        self.view = rootView

        self.complementalInformationViewBinding = ComplementalInformationViewBinding(
            observing: self.dependency.complementalInformationModel,
            handling: rootView
        )

        self.complementalInformationController = ComplementalInformationController(
            observing: rootView,
            notifyingTo: self.dependency.complementalInformationModel
        )

        self.wiFiQRCodeModalPresenter = WiFiQRCodeReaderModalPresenter(
            observing: rootView,
            presentingBy: ViewControllerModalPresenter(on: self),
            dependency: self.dependency.qrCodeReaderModel
        )

        self.mobileConfigInstallerViewBinding = MobileConfigInstallerViewBinding(
            observing: self.dependency.mobileConfigModel,
            installingBy: self.dependency.installer
        )
    }
}
