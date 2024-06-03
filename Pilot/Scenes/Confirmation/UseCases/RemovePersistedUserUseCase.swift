import Foundation

protocol RemovePersistedUserUseCase {
    func execute(onSuccess: () -> Void)
}

struct DefaultRemovePersistedUserUseCase: RemovePersistedUserUseCase {
    func execute(onSuccess: () -> Void) {
        UserDefaults.standard.removeObject(forKey: "persistedUser")
        onSuccess()
    }
}
