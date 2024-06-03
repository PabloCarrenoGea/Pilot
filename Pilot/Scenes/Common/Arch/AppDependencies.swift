import UIKit

struct AppDependencies: RegistrationExternalDependencies,
                        ConfirmationExternalDependencies,
                        HomeLoadingExternalDependencies {

    var navigationController: UINavigationController?

    func resolve() -> UINavigationController? {
        navigationController
    }
}
