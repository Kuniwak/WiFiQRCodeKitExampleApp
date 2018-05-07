import UIKit



protocol URLOpener {
    func open(url: URL)
}



class ApplicationURLOpener: URLOpener {
    private weak var application: UIApplication?


    init(on application: UIApplication) {
        self.application = application
    }


    func open(url: URL) {
        guard let application = self.application else { return }

        if #available(iOS 10.0, *) {
            application.open(url)
        }
        else {
            application.openURL(url)
        }
    }
}
