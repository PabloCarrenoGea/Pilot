import Foundation

protocol PersistUserUseCase {
    func execute(data: PersistedUser, onSuccess: () -> Void, onError: (Error) -> Void)
}

struct DefaultPersistUserUseCase: PersistUserUseCase {
    func execute(data: PersistedUser, onSuccess: () -> Void, onError: (Error) -> Void) {
        do {
            let data = try JSONEncoder().encode(data)
            UserDefaults.standard.set(data, forKey: "persistedUser")
            onSuccess()
        } catch {
            onError(error)
        }
    }
}
