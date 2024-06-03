import Foundation

protocol CheckStoredUserUseCase {
    func execute(onSuccess: (NavigationType) -> Void)
}

enum NavigationType {
    case registration, confirmation
}

struct DefaultCheckStoredUserUseCase: CheckStoredUserUseCase {
    func execute(onSuccess: (NavigationType) -> Void) {
        guard let _ = UserDefaults.standard.data(forKey: "persistedUser") else {
            onSuccess(.registration)
            return
        }
        onSuccess(.confirmation)
    }
}
