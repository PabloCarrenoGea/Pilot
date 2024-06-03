import Foundation

protocol RetrieveLicensesUseCase {
    func execute(onSuccess: (PilotLicensesDTO) -> Void)
}

struct DefaultRetrieveLicensesUseCase: RetrieveLicensesUseCase {
    func execute(onSuccess: (PilotLicensesDTO) -> Void) {
        guard let path = Bundle.main.path(forResource: "pilot-licenses", ofType: "json") else { return }
        let URL = URL(filePath: path)
        guard let data = try? Data(contentsOf: URL),
        let licenses = try? JSONDecoder().decode(PilotLicensesDTO.self, from: data)
        else { return }
        onSuccess(licenses)
    }
}
