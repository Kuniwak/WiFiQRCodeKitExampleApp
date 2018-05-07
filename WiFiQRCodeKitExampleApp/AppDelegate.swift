import UIKit
import WiFiQRCodeKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    private let installer = WiFiQRCodeKit.MobileConfig.Installer(
        distributingBy: SwifterMobileConfigDistributionServer(listeningOn: 8989)
    )


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = application.keyWindow ?? {
            let newWindow = UIWindow()
            newWindow.makeKeyAndVisible()
            return newWindow
        }()

        // NOTE: Avoid collecting by ARC.
        self.window = window

        let complementalInformationModel = DefaultComplementalInformationModel(startingWith: .initial)
        let qrCodeReaderModel = DefaultQRCodeReaderModel(startingWith: .waiting)

        window.rootViewController = ComplementalInformationViewController(
            dependency: (
                complementalInformationModel: complementalInformationModel,
                qrCodeReaderModel: qrCodeReaderModel,
                mobileConfigModel: DefaultMobileConfigModel(
                    startingWith: .blank,
                    observing: (
                        complementalInformationModel: complementalInformationModel,
                        qrCodeReaderModel: qrCodeReaderModel
                    )
                ),
                installer: self.installer
            )
        )

        return true
    }


    func applicationDidEnterBackground(_ application: UIApplication) {
        self.installer.keepDistributionServerForBackground(for: application)
    }
}