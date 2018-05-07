import UIKit



class ComplementalInformationRootView: UIView {
    @IBOutlet weak var organizationNameTextField: UITextField!
    @IBOutlet weak var identityTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var consentTextTextField: UITextField!
    @IBOutlet weak var readQRCodeButton: UIButton!


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadFromXib()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromXib()
    }


    private func loadFromXib() {
        guard let view = R.nib.complementalInformationRootView.firstView(owner: self) else {
            return
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        FilledLayout.apply(subview: view, into: self)
        self.layoutIfNeeded()
    }
}
