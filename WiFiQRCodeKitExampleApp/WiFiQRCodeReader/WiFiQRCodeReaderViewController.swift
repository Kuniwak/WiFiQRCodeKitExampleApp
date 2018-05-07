import Dispatch
import UIKit
import QRCodeReader



class WiFiQRCodeReaderViewController: UIViewController {
    typealias Dependency = QRCodeReaderModel

    private let dependency: Dependency
    private var controller: QRCodeReaderController?
    private var viewBinding: QRCodeReaderViewBinding?


    init(dependency: Dependency) {
        self.dependency = dependency

        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder aDecoder: NSCoder) {
        return nil
    }


    override func loadView() {
        let rootView = UIView()
        rootView.backgroundColor = .clear
        self.view = rootView
    }


    override func viewDidLoad() {
        let qrCodeReaderBuilder = QRCodeReaderViewControllerBuilder()
        qrCodeReaderBuilder.reader = QRCodeReader(
            metadataObjectTypes: [.qr],
            captureDevicePosition: .back
        )

        let qrCodeReaderViewController = QRCodeReaderViewController(builder: qrCodeReaderBuilder)
        let modalDissolver = ViewControllerModalDissolver(willDismiss: self)

        self.viewBinding = QRCodeReaderViewBinding(
            observing: self.dependency,
            dismissingBy: modalDissolver
        )

        self.controller = QRCodeReaderController(
            observing: qrCodeReaderViewController,
            notifyingTo: self.dependency
        )

        DispatchQueue.main.async {
            self.present(qrCodeReaderViewController, animated: false)
        }
    }
}
