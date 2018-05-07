import RxSwift
import RxCocoa
import WiFiQRCodeKit



protocol QRCodeReaderModel {
    var state: RxCocoa.Driver<QRCodeReaderModelState> { get }


    func update(qrCodeContent: String)
    func cancel()
}



enum QRCodeReaderModelState: Equatable {
    case waiting
    case success(wiFiQRCode: WiFiQRCode)
    case failed(because: FailureReason)


    enum FailureReason: Equatable {
        case canceled
        case invalidQRCode(WiFiQRCodeKit.ParsingFailureReason)
    }
}



class DefaultQRCodeReaderModel: QRCodeReaderModel {
    private let stateRelay: RxCocoa.BehaviorRelay<QRCodeReaderModelState>
    let state: RxCocoa.Driver<QRCodeReaderModelState>


    init(startingWith initialState: QRCodeReaderModelState) {
        let stateRelay = RxCocoa.BehaviorRelay<QRCodeReaderModelState>(value: initialState)
        self.stateRelay = stateRelay
        self.state = stateRelay.asDriver()
    }


    func update(qrCodeContent: String) {
        switch WiFiQRCodeKit.parse(text: qrCodeContent) {
        case .success(let wiFiQRCode):
            self.stateRelay.accept(.success(wiFiQRCode: wiFiQRCode))
        case .failed(because: let reason):
            self.stateRelay.accept(.failed(because: .invalidQRCode(reason)))
        }
    }


    func cancel() {
        self.stateRelay.accept(.failed(because: .canceled))
    }
}