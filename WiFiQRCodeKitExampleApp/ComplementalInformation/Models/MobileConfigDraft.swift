import WiFiQRCodeKit



struct PartialMobileConfig: Equatable {
    let organization: WiFiQRCodeKit.MobileConfig.OrganizationName
    let identifier: WiFiQRCodeKit.MobileConfig.PayloadIdentifier
    let displayName: WiFiQRCodeKit.MobileConfig.DisplayName
    let description: String
    let consentText: WiFiQRCodeKit.MobileConfig.ConsentText


    static func validate(draft: Draft) -> ValidationResult {
        return .success(content: PartialMobileConfig(
            organization: .init(organizationName: draft.organization.isEmpty
                ? "Example, Inc."
                : draft.organization
            ),
            identifier: .init(identifier: draft.identifier.isEmpty
                ? "com.example.WiFiSettings"
                : draft.identifier
            ),
            displayName: .init(displayName: draft.displayName.isEmpty
                ? "Wi-Fi Settings for Example, Inc."
                : draft.displayName
            ),
            description: draft.description.isEmpty
                ? "Joining the Wi-Fi network managed by Example, Inc."
                : draft.description,
            consentText: .init(consentTextsForEachLanguages: [
                .default: draft.consentText.isEmpty
                    ? "Would you join the Wi-Fi network managed by Example, Inc.?"
                    : draft.consentText,
            ])
        ))
    }


    struct Draft: Equatable {
        let organization: String
        let identifier: String
        let displayName: String
        let description: String
        let consentText: String


        static let initial = Draft(
            organization: "",
            identifier: "",
            displayName: "",
            description: "",
            consentText: ""
        )
    }


    typealias ValidationResult = WiFiQRCodeKitExampleApp.ValidationResult<PartialMobileConfig, FailureReason>


    typealias FailureReason = Never
}