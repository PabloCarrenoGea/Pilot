struct PilotLicensesDTO: Codable {
    var pilotLicenses: [PilotLicense]

    enum CodingKeys: String, CodingKey {
        case pilotLicenses = "pilot-licenses"
    }

    struct PilotLicense: Codable {
        var type: String
        var aircrafts: [String]
    }
}

struct PersistedUser: Codable {
    let name: String
    let license: String
}
se
