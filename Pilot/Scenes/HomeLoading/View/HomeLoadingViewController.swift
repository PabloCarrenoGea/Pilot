import UIKit

// MARK: - ViewController

final class HomeLoadingViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: HomeLoadingViewModel

    init(dependencies: HomeLoadingDependencies) {
        viewModel = dependencies.resolve()
        super.init(nibName: "HomeLoadingViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
}
