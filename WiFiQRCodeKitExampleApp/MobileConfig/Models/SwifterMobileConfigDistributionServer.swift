import WiFiQRCodeKit
import Swifter



class SwifterMobileConfigDistributionServer: WiFiQRCodeKit.MobileConfig.DistributionServer {
    let distributionURL: URL
    private let server: Swifter.HttpServer
    private let port: UInt16
    private var mobileConfig: (data: Data, mimeType: String)?

    init(listeningOn port: UInt16) {
        let mobileConfigPath = "/WiFi.mobileConfig"

        self.distributionURL = URL(string: "http://127.0.0.1:\(port)\(mobileConfigPath)")!
        self.port = port
        self.server = Swifter.HttpServer()

        self.server[mobileConfigPath] = { [weak self] (_: Swifter.HttpRequest) -> Swifter.HttpResponse in
            guard let `self` = self, let mobileConfig = self.mobileConfig else {
                return .notFound
            }

            let statusCode = 20
            let statusText = "OK"
            let headers = ["Content-Type": mobileConfig.mimeType]

            return .raw(
                statusCode,
                statusText,
                headers,
                { (writer: Swifter.HttpResponseBodyWriter) throws in
                    try writer.write(mobileConfig.data)
                }
            )
        }
    }


    func start() -> WiFiQRCodeKit.MobileConfig.DistributionServerState {
        do {
            try self.server.start(self.port)
            return .successfullyStarted
        }
        catch {
            return .failed(because: "\(error)")
        }
    }


    func update(mobileConfigData: Data, mimeType: String) {
        self.mobileConfig = (data: mobileConfigData, mimeType: mimeType)
    }
}