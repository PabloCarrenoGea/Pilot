import Foundation

protocol Coordinator: AnyObject {
    var identifier: String { get }
    var onFinish: (() -> Void)? { get set }
    func start()
}

extension Coordinator {
    var identifier: String {
        String(describing: self)
    }
}

extension Array where Element == Coordinator {
    mutating func removeCoordinator(_ coordinator: Coordinator) {
        removeAll(where: { $0.identifier == coordinator.identifier})
    }
}
