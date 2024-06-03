import Foundation

protocol FetchStoredUserWithAirecraftsUseCase {
    func execute(onSuccess: (ConfirmationOutput) -> Void, onError: (Error?) -> Void)
}

struct ConfirmationOutput {
    let name: String
    let license: String
    let aircrafts: [String]
}

struct DefaultFetchStoredUserWithAirecraftsUseCase: FetchStoredUserWithAirecraftsUseCase {
    func execute(onSuccess: (ConfirmationOutput) -> Void, onError: (Error?) -> Void) {
        guard let data = UserDefaults.standard.data(forKey: "persistedUser") else {
            onError(nil)
            return
        }
        do {
            let persistedUser = try JSONDecoder().decode(PersistedUser.self, from: data)
            guard let path = Bundle.main.path(forResource: "pilot-licenses", ofType: "json") else { return }
            let URL = URL(filePath: path)
            guard let data = try? Data(contentsOf: URL),
                  let licenses = try? JSONDecoder().decode(PilotLicensesDTO.self, from: data) else {
                onError(nil)
                return
            }
            guard let license = licenses.pilotLicenses.first(where: { $0.type == persistedUser.license}) else {
                onError(nil)
                return
            }
            onSuccess(ConfirmationOutput(name: persistedUser.name, license: persistedUser.license, aircrafts: license.aircrafts))
        } catch {
            onError(error)
        }
    }
}
