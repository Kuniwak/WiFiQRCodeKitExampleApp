import UIKit
import class QRCodeReader.QRCodeReaderViewController
import struct QRCodeReader.QRCodeReaderResult



class QRCodeReaderController {
    private let model: QRCodeReaderModel


    init(observing qrCodeReaderViewController: QRCodeReader.QRCodeReaderViewController, notifyingTo model: QRCodeReaderModel) {
        self.model = model

        qrCodeReaderViewController.completionBlock = { [weak self] result in
            guard let `self` = self else { return }

            if let result = result {
                self.model.update(qrCodeContent: result.value)
            }
            else {
                self.model.cancel()
            }
        }
    }
}