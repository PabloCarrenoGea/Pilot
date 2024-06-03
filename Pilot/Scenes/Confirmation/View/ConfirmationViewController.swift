import UIKit
import Combine

// MARK: - ViewController

final class ConfirmationViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var licenseLabel: UILabel!
    @IBOutlet private weak var aircraftsLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    private let viewModel: ConfirmationViewModel
    private var subscriptions = Set<AnyCancellable>()
    private var aircrafts: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    init(dependencies: ConfirmationDependencies) {
        viewModel = dependencies.resolve()
        super.init(nibName: "ConfirmationViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
        viewModel.viewDidLoad()
    }
}

// MARK: - Private Methods

private extension ConfirmationViewController {
    func setupViews() {
        title = "Welcome"
        navigationItem.hidesBackButton = true
        aircraftsLabel.text = "Allowed aircrafts"
        setupTableView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Bind
    
    func bind() {
        viewModel.state
            .sink { [weak self] state in
                switch state {
                case .storedLoaded(let output):
                    self?.nameLabel.text = output.name
                    self?.licenseLabel.text = output.license
                    self?.aircrafts = output.aircrafts
                }
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - IBActions

    @IBAction func didTapLogout(_ sender: UIButton) {
        viewModel.didTapLogout()
    }
}

// MARK: - Table delegates

extension ConfirmationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        aircrafts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let dequeue = tableView.dequeueReusableCell(withIdentifier: "CellReuse") {
            cell = dequeue
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CellReuse")
        }
        cell.textLabel?.text = aircrafts[indexPath.item]
        return cell
    }
}
